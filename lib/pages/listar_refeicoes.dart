import 'package:carbonet/data/database/refeicao_dao.dart';
import 'package:carbonet/data/models/alimento_ingerido.dart';
import 'package:carbonet/data/models/refeicao.dart';
import 'package:carbonet/utils/app_colors.dart';
import 'package:carbonet/utils/dao_procedure_coupler.dart';
import 'package:carbonet/utils/logged_user_access.dart';
import 'package:carbonet/widgets/input/input_field.dart';
import 'package:flutter/material.dart';

class ListarRefeicoes extends StatefulWidget {
  final List<Refeicao> historicoRefeicoes;
  const ListarRefeicoes({
    super.key,
    required this.historicoRefeicoes,
  });

  @override
  State<ListarRefeicoes> createState() => _ListarRefeicoesState();
}

class _ListarRefeicoesState extends State<ListarRefeicoes> {
  final TextEditingController searchBoxController = TextEditingController();
  final Future<List<Refeicao>> _futureRefeicoes = RefeicaoDAO().getRefeicoesByUser(LoggedUserAccess().user!.id!);
  final Map<int, bool> _isExpanded = {};
  bool hasReceivedMealList = false;

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
              future: _futureRefeicoes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (!hasReceivedMealList) {
                    snapshot.data?.forEach((refeicao) {
                      widget.historicoRefeicoes.add(refeicao);
                    });
                    hasReceivedMealList = true;
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: widget.historicoRefeicoes.length,
                      itemBuilder: (context, index) {
                        return Theme(
                          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                          child: Column(
                            children: [
                              ExpansionTile(
                                iconColor: AppColors.fontBright,
                                collapsedIconColor: AppColors.fontBright,
                                title: Row(
                                  children: [
                                    Text(
                                      widget.historicoRefeicoes[index].tipoRefeicao,
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    const Spacer(),
                                    Text(
                                      //  - ${listaRefeicoes[index].data.day.toString().padLeft(2, "0")}/${listaRefeicoes[index].data.month.toString().padLeft(2, "0")}/${listaRefeicoes[index].data.year}"
                                      "${widget.historicoRefeicoes[index].data.hour.toString().padLeft(2, '0')}:${widget.historicoRefeicoes[index].data.minute.toString().padLeft(2, '0')}",
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                onExpansionChanged: (expanded) {
                                  setState(() {
                                    _isExpanded[index] = expanded;
                                  });
                                },
                                children: [
                                  if (_isExpanded[index] == true)
                                    FutureBuilder(
                                      future: DaoProcedureCoupler.getAlimentoIngeridoByRefeicaoFullData(widget.historicoRefeicoes[index].id),
                                      builder: (context, innerSnapshot) {
                                        if (innerSnapshot.connectionState == ConnectionState.done) {
                                          if (innerSnapshot.hasData && innerSnapshot.data != null) {
                                            List<Widget> widgets = [];
                                            List<AlimentoIngerido> alimentosIngeridos = innerSnapshot.data!;

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
                                                              alimentosIngeridos[index].alimentoReferencia.nome,
                                                              style: const TextStyle(
                                                                color: AppColors.fontBright,
                                                              ),
                                                            ),
                                                            const Spacer(),
                                                            Text(
                                                              "${alimentosIngeridos[index].qtdIngerida} g",
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
                              if (index < widget.historicoRefeicoes.length - 1) const Divider(color: Colors.white),
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
