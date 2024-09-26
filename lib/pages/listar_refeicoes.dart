import 'package:carbonet/data/database/refeicao_dao.dart';
import 'package:carbonet/data/models/refeicao.dart';
import 'package:carbonet/utils/app_colors.dart';
import 'package:carbonet/utils/dao_procedure_coupler.dart';
import 'package:carbonet/utils/logged_user_access.dart';
import 'package:carbonet/widgets/input/input_field.dart';
import 'package:flutter/material.dart';

class ListarRefeicoes extends StatefulWidget {
  const ListarRefeicoes({super.key});

  @override
  State<ListarRefeicoes> createState() => _ListarRefeicoesState();
}

class _ListarRefeicoesState extends State<ListarRefeicoes> {
  final TextEditingController searchBoxController = TextEditingController();
  final Future<List<Refeicao>> _futureRefeicoes = RefeicaoDAO().getRefeicoesByUser(LoggedUserAccess().user!.id!);

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
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        List<Refeicao> listaRefeicoes = snapshot.data!;
                        // if (listaRefeicoes == null) return const Text("Erro!");
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
                                      listaRefeicoes[index].tipoRefeicao,
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    const Spacer(),
                                    Text(
                                      //  - ${listaRefeicoes[index].data.day.toString().padLeft(2, "0")}/${listaRefeicoes[index].data.month.toString().padLeft(2, "0")}/${listaRefeicoes[index].data.year}"
                                      "${listaRefeicoes[index].data.hour}:${listaRefeicoes[index].data.minute}",
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                children: [
                                  FutureBuilder(
                                    future: DaoProcedureCoupler.getAlimentoIngeridoByRefeicaoFullData(snapshot.data![index].id),
                                    builder: (context, innerSnapshot) {
                                      if (innerSnapshot.connectionState == ConnectionState.done) {
                                        if (innerSnapshot.hasData && innerSnapshot.data != null) {
                                          List<Widget> widgets = [];

                                          for (var index = 0; index < innerSnapshot.data!.length; index++) {
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
                                                            innerSnapshot.data![index].alimentoReferencia.nome,
                                                            style: const TextStyle(
                                                              color: AppColors.fontBright,
                                                            ),
                                                          ),
                                                          const Spacer(),
                                                          Text(
                                                            "${innerSnapshot.data![index].qtdIngerida} g",
                                                            style: const TextStyle(
                                                              color: AppColors.fontBright,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    if (index < innerSnapshot.data!.length - 1) const Divider(color: AppColors.fontBright),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }

                                          // var widgets = innerSnapshot.data!.map((refeicaoDetails) {
                                          //   return Padding(
                                          //     padding: const EdgeInsets.fromLTRB(25.0, 0, 0, 0),
                                          //     child: Column(
                                          //       children: [
                                          //         Padding(
                                          //           padding: const EdgeInsets.all(8.0),
                                          //           child: Row(
                                          //             children: [
                                          //               Text(
                                          //                 refeicaoDetails.alimentoReferencia.nome,
                                          //                 style: const TextStyle(
                                          //                   color: AppColors.fontBright,
                                          //                 ),
                                          //               ),
                                          //               const Spacer(),
                                          //               Text(
                                          //                 "${refeicaoDetails.qtdIngerida} g",
                                          //                 style: const TextStyle(
                                          //                   color: AppColors.fontBright,
                                          //                 ),
                                          //               ),
                                          //             ],
                                          //           ),
                                          //         ),
                                          //         const Divider(color: AppColors.fontBright),
                                          //       ],
                                          //     ),
                                          //   );
                                          // }).toList();

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

                                // children: listaRefeicoes.map((refeicao) {
                                //   return ListTile(
                                //     title: Text(item),
                                //   );
                                // }).toList(),
                              ),
                              if (index < snapshot.data!.length - 1) const Divider(color: Colors.white),
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
