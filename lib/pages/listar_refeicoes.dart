import 'package:carbonet/data/database/alimento_ingerido_dao.dart';
import 'package:carbonet/data/database/refeicao_dao.dart';
import 'package:carbonet/data/models/refeicao.dart';
import 'package:carbonet/utils/app_colors.dart';
import 'package:carbonet/utils/logged_user_access.dart';
import 'package:flutter/material.dart';

class ListarRefeicoes extends StatefulWidget {
  const ListarRefeicoes({super.key});

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

    List<bool> _isOpen;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.defaultAppColor,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: _futureRefeicoes, 
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
        
              // TODO MUITO IRRITANTE 💢💢💢
              // o treco não abre pq qdo eu clico no trem de expandir, ele POR ALGUMA RAZÃO MISTERIOSA trigga o rebuild a árvore toda (ou pelo menos partindo do nó que tem esse future builder; consequência: ele re-gera essa lista _isOpen, e fecha TODOS os trequinhos de novo. filho da puta. flutter pq CARALHOS vc tá rebuildando esse povo todo????) alternativa: usar o expansionPanelList.radio, que em tese só deixa ter um mano aberto a cada tempo então essa lógica em tese tá embutida nele. vou dormir e ver oq resolvo.
              _isOpen = List.generate(snapshot.data!.length, (i) => false);
              print('on creation:');
              for (int i = 0; i < _isOpen.length; i++) {
                print("_isOpen[$i]: ${_isOpen[i]}");
              }
        
              return ExpansionPanelList(
                children: List.generate(snapshot.data!.length, (i) {
                  return ExpansionPanel(
                    headerBuilder: (context, isOpen) {
                      return ListTile(
                        title: Text("${snapshot.data![i].tipoRefeicao} - ${snapshot.data![i].data.toString()}"),
                      );
                    },
                    body: ListTile(
                      //TODO: melhorar esse futuro enfiado direto no futurebuilder
                      //title: Text("a fazer; não sei como gerar uma lista de conteúdo dinâmica sem usar futuro direto no futureBuilder aqui"),
                      title: FutureBuilder(
                        future: AlimentoIngeridoDAO().getAlimentoIngeridoByRefeicao(snapshot.data![i].id), 
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            return Column(
                              children: snapshot.data!.map(
                                  (e) => Text("${e.alimentoReferencia.nome} - ${e.qtdIngerida}g")
                                ).toList(),
                            );
                            //Text(snapshot.data!.toString());
                          } else {
                            return const CircularProgressIndicator();
                          }
                        }),
                    ),
                    isExpanded: _isOpen[i],
                  );
                }),
                expansionCallback: (i, isOpen) {
                  setState(() {
                    print("isOpen[$i]: $isOpen");
                    _isOpen[i] = !isOpen;
                  });
                },
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      )
    );
  }
}