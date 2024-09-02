// Nota: A página está inteirinha sem estilos.
// Isso é intencional, por enquanto a prioridade é fazer funcionar.
// Reposta a nota: IUPIII! :3

import 'package:carbonet/data/models/alimento_ingerido.dart';
import 'package:carbonet/data/models/refeicao.dart';
import 'package:carbonet/pages/selecionar_alimentos.dart';
import 'package:carbonet/utils/app_colors.dart';
import 'package:carbonet/utils/dao_procedure_coupler.dart';
import 'package:carbonet/utils/logged_user_access.dart';
import 'package:carbonet/widgets/dropdown_menu.dart';
import 'package:carbonet/widgets/dropdown_menu_entry.dart';
import 'package:flutter/material.dart';

class AdicionarRefeicao extends StatefulWidget {
  const AdicionarRefeicao({super.key});

  @override
  State<AdicionarRefeicao> createState() => _AdicionarRefeicaoState();
}

class _AdicionarRefeicaoState extends State<AdicionarRefeicao> {
  final List<AlimentoIngerido> alimentosSelecionados = [];
  final TextEditingController tipoRefeicaoController = TextEditingController();
  double glicemia = 0;
  double totalCHO = 0;

  final List<DropdownMenuEntry<String>> tiposDeRefeicao = [
    CustomDropdownMenuEntry(value: "Café da manhã", label: "Café da manhã"),
    CustomDropdownMenuEntry(value: "Almoço", label: "Almoço"),
    CustomDropdownMenuEntry(value: "Janta", label: "Janta"),
    CustomDropdownMenuEntry(value: "Lanche", label: "Lanche"),
  ];

  @override
  void setState(VoidCallback fn) {
    totalCHO = 0;
    for (var alimentoIngerido in alimentosSelecionados) {
      totalCHO += alimentoIngerido.alimentoReferencia.carbos_por_grama *
          alimentoIngerido.qtdIngerida;
    }
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomDropDownMenu(
              dropdownMenuEntries: tiposDeRefeicao,
            ),
            const Text(
              "Alimentos",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            TextButton_BuscarAlimentos(
              alimentosSelecionados: alimentosSelecionados,
              setPageState: setState,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Expanded(
                child: ListView_AlimentosSelecionados(
                  alimentosSelecionados: alimentosSelecionados,
                ),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Glicemia: ${glicemia} mg/dL",
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Carboidratos: ${totalCHO} gramas",
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            TextButton_CadastrarRefeicao(
              alimentosSelecionados: alimentosSelecionados,
              glicemia: glicemia,
              totalCHO: totalCHO,
              tipoRefeicao: tipoRefeicaoController.text,
            ),
          ],
        ),
      ),
    );
  }
}

/// O botão responsável pelos eventos de cadastrar uma refeição.
///
/// Entenda-se por isso: criar o objeto refeição, colocar a lista de alimentos selecionados dentro dele, chamar o sequenciador que invoca os DAOs responsáveis por cadastrar a refeição (e, em seguida, os alimentos ingeridos) e, ao final, devolver você para a tela inicial com uma notificação snackbar de sucesso.
class TextButton_CadastrarRefeicao extends StatelessWidget {
  const TextButton_CadastrarRefeicao({
    super.key,
    required this.alimentosSelecionados,
    required this.glicemia,
    required this.totalCHO,
    required this.tipoRefeicao,
  });

  final List<AlimentoIngerido> alimentosSelecionados;
  final double glicemia;
  final double totalCHO;
  final String tipoRefeicao;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      label: const Text("Concluir"),
      icon: const Icon(Icons.check, color: Colors.white),
      onPressed: () {
        if (tipoRefeicao.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Selecione o tipo de refeição."),
            ),
          );
          return;
        } else {
          Refeicao refeicao = Refeicao(
            idUser: LoggedUserAccess().user!.id!,
            data: DateTime
                .now(), // TODO mudar <- tem que ter um campo pra selecionar data aqui tipo o que tem na tela de cadastro :)
            tipoRefeicao: tipoRefeicao,
            isActive: true,
          );

          DaoProcedureCoupler.inserirRefeicaoProcedimento(
                  refeicao, alimentosSelecionados)
              .then(
            (value) {
              //TODO
              //se sucesso, devolver o valor pra tela home e mostrar uma snackbar de sucesso;
              Navigator.pop(context, true);
              //se falha, mostrar uma snackbar de erro e ficar nessa página, para o usuário poder tentar de novo.
            },
          );
        }
      },
      style: TextButton.styleFrom(
        backgroundColor: AppColors.defaultGreen,
        foregroundColor: Colors.white,
      ),
    );
  }
}

/// A lista de alimentos selecionados.
///
/// Não tem muito mais o que dizer, é só a lista dos alimentos selecionados com as quantidades (alimentoIngerido)
class ListView_AlimentosSelecionados extends StatelessWidget {
  const ListView_AlimentosSelecionados({
    super.key,
    required this.alimentosSelecionados,
  });
  final List<AlimentoIngerido> alimentosSelecionados;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: alimentosSelecionados.length,
      itemBuilder: (context, index) {
        final alimento = alimentosSelecionados[index];
        return ListTile(
          title: Text(alimento.alimentoReferencia.nome),
          trailing: Text("${alimento.qtdIngerida}g"),
        );
      },
    );
  }
}

/// O botão responsável por abrir a página de busca de alimentos.
///
/// Quase certeza que aqui a gente precisa passar a lista de alimentos selecionados, pra ela ser alterada por referência.
class TextButton_BuscarAlimentos extends StatelessWidget {
  const TextButton_BuscarAlimentos({
    super.key,
    required this.alimentosSelecionados,
    required this.setPageState,
  });
  final List<AlimentoIngerido> alimentosSelecionados;
  final Function setPageState;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
        icon: const Icon(
          Icons.search,
          color: Colors.white,
        ),
        label: const Text('Buscar...'),
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => SelecionarAlimentos(alimentosSelecionados: alimentosSelecionados)));
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  final TextEditingController textController =
                      TextEditingController();
                  return DialogSelecionarAlimento(
                    textController: textController,
                    alimentosSelecionados: alimentosSelecionados,
                    setState: setState,
                  );
                },
              );
            },
          ).then(
            (value) {
              setPageState(() {});
            },
          );
        },
        style: TextButton.styleFrom(
          backgroundColor: AppColors.defaultAppColor,
          foregroundColor: Colors.white,
        ));
  }
}

/// Dropdown contendo os tipos de refeição: 'Café', 'Almoço', 'Janta', e 'Lanche'.
///
/// É meio estranho configurar dropdowns em flutter, então ele foi o motivo de eu extrair todos esses widgets com comportamentos particulares.
// class DropdownMenu_TiposRefeicao extends StatefulWidget {
//   const DropdownMenu_TiposRefeicao({
//     super.key,
//     required this.tipoRefeicaoController,
//   });

//   final TextEditingController tipoRefeicaoController;
//   final List<String> dropdownMenuEntries = const [
//     'Café',
//     'Almoço',
//     'Janta',
//     'Lanche'
//   ];

//   @override
//   State<DropdownMenu_TiposRefeicao> createState() =>
//       _DropdownMenu_TiposRefeicaoState();
// }

// class _DropdownMenu_TiposRefeicaoState
//     extends State<DropdownMenu_TiposRefeicao> {
//   @override
//   Widget build(BuildContext context) {
//     return DropdownMenu<String>(
//       width: 250,
//       initialSelection: dropdownMenuEntries[0],
//       controller: tipoRefeicaoController,
//       requestFocusOnTap: false,
//       label: const Text('Tipo de Refeição'),
//       onSelected: (String? tipoSelecionado) {
//         setState(() {});
//       },
//       dropdownMenuEntries: dropdownMenuEntries
//           .map<DropdownMenuEntry<String>>((String tipoRefeicao) {
//         return DropdownMenuEntry<String>(
//           value: tipoRefeicao,
//           label: tipoRefeicao,
//           style: MenuItemButton.styleFrom(),
//         );
//       }).toList(),
//     );
//   }
// }
