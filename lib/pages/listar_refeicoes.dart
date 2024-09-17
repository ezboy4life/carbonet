import 'package:carbonet/data/database/refeicao_dao.dart';
import 'package:carbonet/data/models/refeicao.dart';
import 'package:carbonet/utils/app_colors.dart';
import 'package:carbonet/utils/dao_procedure_coupler.dart';
import 'package:carbonet/utils/logged_user_access.dart';
import 'package:flutter/material.dart';

class ListarRefeicoes extends StatefulWidget {
  ListarRefeicoes({super.key});
  List<bool> _isOpen = [];
  bool _isOpenHasBeenInit = false;

  @override
  State<ListarRefeicoes> createState() => _ListarRefeicoesState();
}

class _ListarRefeicoesState extends State<ListarRefeicoes> {
  late Future<List<Refeicao>> _futureRefeicoes;

  @override
  void initState() {
    _futureRefeicoes = RefeicaoDAO().getRefeicoesByUser(LoggedUserAccess().user!.id!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.defaultAppColor,
        ),
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: _futureRefeicoes,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (widget._isOpenHasBeenInit == false) {
                  widget._isOpen = List.generate(snapshot.data!.length, (i) => false);
                  widget._isOpenHasBeenInit = true;
                }

                return ExpansionPanelList(
                  children: List.generate(snapshot.data!.length, (i) {
                    return ExpansionPanel(
                      canTapOnHeader: true,
                      headerBuilder: (context, isOpen) {
                        return ListTile(
                          title: Text("${snapshot.data![i].tipoRefeicao} - ${snapshot.data![i].data.toString()}"),
                        );
                      },
                      body: ListTile(
                        //TODO: melhorar esse futuro enfiado direto no futurebuilder
                        //title: Text("a fazer; não sei como gerar uma lista de conteúdo dinâmica sem usar futuro direto no futureBuilder aqui"),
                        title: FutureBuilder(
                            future: DaoProcedureCoupler.getAlimentoIngeridoByRefeicaoFullData(snapshot.data![i].id),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                return Column(
                                  children: snapshot.data!.map((e) => Text("${e.alimentoReferencia.nome} - ${e.qtdIngerida}g")).toList(),
                                );
                              } else {
                                return const CircularProgressIndicator();
                              }
                            }),
                      ),
                      isExpanded: widget._isOpen[i],
                    );
                  }),
                  expansionCallback: (i, isOpen) {
                    setState(() {
                      widget._isOpen[i] = isOpen;
                    });
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ));
  }
}
