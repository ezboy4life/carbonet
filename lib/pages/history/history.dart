import 'package:carbonet/data/database/refeicao_dao.dart';
import 'package:carbonet/data/models/ingested_food.dart';
import 'package:carbonet/data/models/meal.dart';
import 'package:carbonet/utils/app_colors.dart';
import 'package:carbonet/utils/dao_procedure_coupler.dart';
import 'package:carbonet/utils/logged_user_access.dart';
import 'package:carbonet/utils/logger.dart';
import 'package:carbonet/widgets/dialogs/confirmation_dialog.dart';
import 'package:carbonet/widgets/input/input_field.dart';
import 'package:flutter/material.dart';

class History extends StatefulWidget {
  final List<Meal> mealHistory;
  const History({
    super.key,
    required this.mealHistory,
  });

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final TextEditingController searchBoxController = TextEditingController();
  final Future<List<Meal>> _getMealsFuture = RefeicaoDAO().getRefeicoesByUser(LoggedUserAccess().user!.id!);
  final Map<int, bool> _isExpanded = {};
  bool hasReceivedMealList = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            InputField(
              controller: searchBoxController,
              labelText: "Pesquisar",
              iconData: Icons.search_rounded,
            ),
            const SizedBox(height: 30),
            FutureBuilder(
              future: _getMealsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (!hasReceivedMealList) {
                    snapshot.data?.forEach((refeicao) {
                      widget.mealHistory.add(refeicao);
                    });
                    hasReceivedMealList = true;
                    infoLog("widget.mealHistory setado!");
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: widget.mealHistory.length,
                      itemBuilder: (context, index) {
                        return Theme(
                          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                          child: Column(
                            children: [
                              Dismissible(
                                key: Key(widget.mealHistory[index].id.toString()),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 20),
                                  child: const Icon(Icons.delete, color: Colors.white),
                                ),
                                confirmDismiss: (direction) async {
                                  return await showDialog<bool>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const ConfirmationDialog(
                                        title: "Confirmar exclusão",
                                        message: "Você tem certeza que deseja excluir essa refeição?",
                                        confirmButtonLabel: "Excluir",
                                        confirmButtonColor: Colors.red,
                                      );
                                    },
                                  );
                                },
                                onDismissed: (direction) {
                                  setState(() {
                                    widget.mealHistory.removeAt(index);
                                  });
                                  infoLog("Removido item em $index");
                                  //TODO: remover do banco tbm (?)
                                },
                                child: ExpansionTile(
                                  iconColor: AppColors.fontBright,
                                  collapsedIconColor: AppColors.fontBright,
                                  title: Row(
                                    children: [
                                      Text(
                                        widget.mealHistory[index].mealType,
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                      const Spacer(),
                                      Text(
                                        //  - ${listaRefeicoes[index].data.day.toString().padLeft(2, "0")}/${listaRefeicoes[index].data.month.toString().padLeft(2, "0")}/${listaRefeicoes[index].data.year}"
                                        "${widget.mealHistory[index].date.hour.toString().padLeft(2, '0')}:${widget.mealHistory[index].date.minute.toString().padLeft(2, '0')}",
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  onExpansionChanged: (expanded) {
                                    if (!expanded) {
                                      Future.delayed(const Duration(milliseconds: 300), () {
                                        setState(() {
                                          _isExpanded[index] = expanded;
                                        });
                                      });
                                      return;
                                    }
                                    setState(() {
                                      _isExpanded[index] = expanded;
                                    });
                                  },
                                  children: [
                                    if (_isExpanded[index] == true)
                                      FutureBuilder(
                                        future: DaoProcedureCoupler.getAlimentoIngeridoByRefeicaoFullData(widget.mealHistory[index].id),
                                        builder: (context, innerSnapshot) {
                                          if (innerSnapshot.connectionState == ConnectionState.done) {
                                            if (innerSnapshot.hasData && innerSnapshot.data != null) {
                                              List<Widget> widgets = [];
                                              List<IngestedFood> alimentosIngeridos = innerSnapshot.data!;

                                              for (var index = 0; index < alimentosIngeridos.length; index++) {
                                                widgets.add(
                                                  Padding(
                                                    padding: const EdgeInsets.fromLTRB(25.0, 0, 0, 0),
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                alimentosIngeridos[index].foodReference.name,
                                                                style: const TextStyle(
                                                                  color: AppColors.fontBright,
                                                                ),
                                                              ),
                                                              const Spacer(),
                                                              Text(
                                                                "${alimentosIngeridos[index].gramsIngested} g",
                                                                style: const TextStyle(
                                                                  color: AppColors.fontBright,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        if (index < alimentosIngeridos.length - 1) const Divider(color: AppColors.fontBright),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }
                                              return Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: widgets,
                                              );
                                            }
                                          }
                                          return const CircularProgressIndicator();
                                        },
                                      ),
                                  ],
                                ),
                              ),
                              if (index < widget.mealHistory.length - 1) const Divider(color: Colors.white),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }
                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}
