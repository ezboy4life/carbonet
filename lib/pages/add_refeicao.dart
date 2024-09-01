// Nota: A página está inteirinha sem estilos.
// Isso é intencional, por enquanto a prioridade é fazer funcionar.
// Reposta a nota: IUPIII! :3

import 'package:carbonet/data/models/alimento_ingerido.dart';
import 'package:carbonet/data/models/refeicao.dart';
import 'package:carbonet/pages/selecionar_alimentos.dart';
import 'package:carbonet/utils/app_colors.dart';
import 'package:carbonet/utils/dao_procedure_coupler.dart';
import 'package:carbonet/utils/logged_user_access.dart';
import 'package:flutter/material.dart';

class AdicionarRefeicao extends StatefulWidget {
  AdicionarRefeicao({super.key});

  final List<AlimentoIngerido> alimentosSelecionados = [];
  final TextEditingController tipoRefeicaoController = TextEditingController();
  double glicemia = 0;
  double totalCHO = 0;

  @override
  State<AdicionarRefeicao> createState() => _AdicionarRefeicaoState();
}

class _AdicionarRefeicaoState extends State<AdicionarRefeicao> {
  @override
  void setState(VoidCallback fn) {
    widget.totalCHO = 0;
    for (var alimentoIngerido in widget.alimentosSelecionados) {
      widget.totalCHO += alimentoIngerido.alimentoReferencia.carbos_por_grama *
          alimentoIngerido.qtdIngerida;
    }
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const Text("Tipo de Refeição"),
          const SizedBox(height: 12),
          DropdownMenu_TiposRefeicao(
            tipoRefeicaoController: widget.tipoRefeicaoController,
          ),
          const SizedBox(height: 12),
          const Text("Alimentos"),
          const SizedBox(height: 12),
          TextButton_BuscarAlimentos(
            alimentosSelecionados: widget.alimentosSelecionados,
            setPageState: setState,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Expanded(
              child: ListView_AlimentosSelecionados(
                alimentosSelecionados: widget.alimentosSelecionados,
              ),
            ),
          ),
          const Spacer(),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Glicemia: ${widget.glicemia} mg/dL"),
              const SizedBox(width: 12),
              Text("Carboidratos: ${widget.totalCHO} gramas"),
            ],
          ),
          const SizedBox(height: 12),
          TextButton_CadastrarRefeicao(
            alimentosSelecionados: widget.alimentosSelecionados,
            glicemia: widget.glicemia,
            totalCHO: widget.totalCHO,
            tipoRefeicao: widget.tipoRefeicaoController.text,
          ),
          const SizedBox(height: 12),
        ],
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
class DropdownMenu_TiposRefeicao extends StatefulWidget {
  const DropdownMenu_TiposRefeicao({
    super.key,
    required this.tipoRefeicaoController,
  });
  final TextEditingController tipoRefeicaoController;
  final List<String> dropdownMenuEntries = const [
    'Café',
    'Almoço',
    'Janta',
    'Lanche'
  ];

  @override
  State<DropdownMenu_TiposRefeicao> createState() =>
      _DropdownMenu_TiposRefeicaoState();
}

class _DropdownMenu_TiposRefeicaoState
    extends State<DropdownMenu_TiposRefeicao> {
  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      width: 250,
      initialSelection: widget.dropdownMenuEntries[0],
      controller: widget.tipoRefeicaoController,
      requestFocusOnTap: false,
      label: const Text('Tipo de Refeição'),
      onSelected: (String? tipoSelecionado) {
        setState(() {});
      },
      dropdownMenuEntries: widget.dropdownMenuEntries
          .map<DropdownMenuEntry<String>>((String tipoRefeicao) {
        return DropdownMenuEntry<String>(
          value: tipoRefeicao,
          label: tipoRefeicao,
          style: MenuItemButton.styleFrom(),
        );
      }).toList(),
    );
  }
}
