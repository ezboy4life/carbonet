import 'package:carbonet/data/database/meal_dao.dart';
import 'package:carbonet/data/models/ingested_food.dart';
import 'package:carbonet/data/models/meal.dart';
import 'package:carbonet/utils/app_colors.dart';
import 'package:carbonet/utils/dao_procedure_coupler.dart';
import 'package:carbonet/utils/logged_user_access.dart';
import 'package:carbonet/utils/logger.dart';
import 'package:carbonet/widgets/dialogs/confirmation_dialog.dart';
import 'package:carbonet/widgets/input/date_input_field.dart';
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
  final TextEditingController dateController = TextEditingController();

  final Future<List<Meal>> _getMealsFuture = MealDAO().getMealsByUser(LoggedUserAccess().user!.id!);
  final Map<int, bool> _isExpanded = {};
  bool hasReceivedMealList = false;

  @override
  void initState() {
    super.initState();
  }

  Widget getMealTypeIcon(String name) {
    IconData icon = Icons.error;
    Color color = Colors.red;

    switch (name) {
      case "Café da manhã":
        icon = Icons.coffee_rounded;
        color = Colors.brown;
        break;
      case "Almoço":
        icon = Icons.local_restaurant_rounded;
        color = Colors.green;
        break;
      case "Jantar":
        icon = Icons.dinner_dining_rounded;
        color = Colors.orange;
        break;
      case "Lanche":
        icon = Icons.lunch_dining_rounded;
        color = Colors.blue;
        break;
    }

    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(8.0),
        ),
        color: color,
      ),
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }

  void onDateSelected(DateTime date) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DateInputField(
              labelText: "Filtrar por dia",
              dateController: dateController,
              onDateSelected: onDateSelected,
              iconData: Icons.calendar_month_rounded,
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
                    widget.mealHistory.sort((a, b) => b.date.compareTo(a.date)); // Organiza por datas
                    hasReceivedMealList = true;
                  }
                  return Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.mealHistory.length,
                          itemBuilder: (context, index) {
                            DateTime mealDate = widget.mealHistory[index].date;

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
                                        var mealToRemove = widget.mealHistory.removeAt(index);
                                        DaoProcedureCoupler.removerRefeicaoProcedimento(mealToRemove);
                                      });
                                      infoLog("Removido item em $index");
                                      infoLog("Refeição removida do armazenamento local");
                                    },
                                    child: Theme(
                                      data: ThemeData(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        dividerColor: Colors.transparent,
                                      ),
                                      child: ExpansionTile(
                                        iconColor: AppColors.fontBright,
                                        collapsedIconColor: AppColors.fontBright,
                                        title: Row(
                                          children: [
                                            Row(
                                              children: [
                                                getMealTypeIcon(widget.mealHistory[index].mealType),
                                                const SizedBox(width: 15),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      widget.mealHistory[index].mealType,
                                                      style: const TextStyle(color: Colors.white),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          decoration: BoxDecoration(
                                                            color: Colors.grey[850],
                                                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                                            child: Text(
                                                              "${widget.mealHistory[index].calorieTotal} kcal",
                                                              style: const TextStyle(color: AppColors.fontBright),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(width: 10),
                                                        Container(
                                                          decoration: BoxDecoration(
                                                            color: Colors.grey[850],
                                                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                                            child: Text(
                                                              "${widget.mealHistory[index].carbTotal}g CHO",
                                                              style: const TextStyle(color: AppColors.fontBright),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const Spacer(),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "${mealDate.day.toString()}/${mealDate.month.toString()}/${(mealDate.year % 100).toString().padLeft(2, '0')}",
                                                  style: const TextStyle(color: Colors.white),
                                                ),
                                                // Container(
                                                //   decoration: BoxDecoration(
                                                //     color: Colors.grey[850],
                                                //     borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                //   ),
                                                //   child: Padding(
                                                //     padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                                //     child: Text(
                                                //       "${mealDate.hour.toString().padLeft(2, '0')}:${mealDate.minute.toString().padLeft(2, '0')}",
                                                //       style: const TextStyle(color: AppColors.fontBright),
                                                //     ),
                                                //   ),
                                                // ),
                                                Text(
                                                  "${mealDate.hour.toString().padLeft(2, '0')}:${mealDate.minute.toString().padLeft(2, '0')}",
                                                  style: const TextStyle(color: AppColors.fontBright),
                                                ),
                                              ],
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
                                                          padding: const EdgeInsets.fromLTRB(65, 0, 25, 0),
                                                          child: Column(
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                        overflow: TextOverflow.ellipsis,
                                                                        softWrap: false,
                                                                        maxLines: 1,
                                                                        alimentosIngeridos[index].foodReference.name,
                                                                        style: const TextStyle(
                                                                          color: AppColors.fontBright,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 25,
                                                                    ),
                                                                    // Container(
                                                                    //   decoration: BoxDecoration(
                                                                    //     color: Colors.blueGrey[00],
                                                                    //     borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                                    //   ),
                                                                    //   child: Padding(
                                                                    //     padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                                                    //     child: Text(
                                                                    //       "${alimentosIngeridos[index].gramsIngested} g",
                                                                    //       style: const TextStyle(color: AppColors.fontBright),
                                                                    //     ),
                                                                    //   ),
                                                                    // ),

                                                                    Text(
                                                                      "${alimentosIngeridos[index].gramsIngested} g",
                                                                      style: const TextStyle(
                                                                        color: AppColors.fontBright,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              if (index < alimentosIngeridos.length - 1) const Divider(color: AppColors.fontDimmed),
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
                                  ),
                                  if (index < widget.mealHistory.length - 1)
                                    const Divider(
                                      color: AppColors.fontBright,
                                      indent: 65,
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
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
