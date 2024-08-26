// Nota: A página está inteirinha sem estilos.
// Isso é intencional, por enquanto a prioridade é fazer funcionar.

import 'package:carbonet/data/models/alimento_ingerido.dart';
import 'package:carbonet/pages/selecionar_alimentos.dart';
import 'package:flutter/material.dart';

class AdicionarRefeicao extends StatefulWidget {
  AdicionarRefeicao({super.key});

  final List<AlimentoIngerido> alimentosSelecionados = [];
  final TextEditingController tipoRefeicaoController = TextEditingController();

  @override
  State<AdicionarRefeicao> createState() => _AdicionarRefeicaoState();
}

class _AdicionarRefeicaoState extends State<AdicionarRefeicao> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text("Tipo de Refeição"),
          DropdownMenu_TiposRefeicao(
            tipoRefeicaoController: widget.tipoRefeicaoController,),
          Text("Alimentos"),
          TextButton_BuscarAlimentos(
            alimentosSelecionados: widget.alimentosSelecionados,
            setPageState: setState,
          ),
          Expanded(
            child: ListView_AlimentosSelecionados(
              alimentosSelecionados: widget.alimentosSelecionados,
            ),
          ),
          Spacer(),
          TextButton_CadastrarRefeicao()
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
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      label: const Text("Concluir"),
      icon: const Icon(Icons.check),
      onPressed: () {
        //TODO: cadastro da refeição; aqui eu dependo do DAO que eu ainda não fiz 😇
      },
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
          trailing: Text("${alimento.qtdIngerida}"),
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
      icon: const Icon(Icons.search),
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
                final TextEditingController textController = TextEditingController();
                return DialogSelecionarAlimento(textController: textController, alimentosSelecionados: alimentosSelecionados, setState: setState,);
            },);
          },
        ).then((value) {
          setPageState(() {});  
        },);
      },
    );
  }
}

/// Dropdown contendo os tipos de refeição: 'Café', 'Almoço', 'Janta', e 'Lanche'.
///
/// É meio estranho configurar dropdowns em flutter, então ele foi o motivo de eu extrair todos esses widgets com comportamentos particulares.
class DropdownMenu_TiposRefeicao extends StatefulWidget {
  DropdownMenu_TiposRefeicao({
    super.key,
    required this.tipoRefeicaoController,
  });
  final TextEditingController tipoRefeicaoController;
  final List<String> dropdownMenuEntries = const ['Café', 'Almoço', 'Janta', 'Lanche'];
  String tipoSelecionado = "";

  @override
  State<DropdownMenu_TiposRefeicao> createState() => _DropdownMenu_TiposRefeicaoState();
}

class _DropdownMenu_TiposRefeicaoState extends State<DropdownMenu_TiposRefeicao> {
  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      controller: widget.tipoRefeicaoController,
      requestFocusOnTap: true,
      label: const Text('Tipo de Refeição'),
      onSelected: (String? tipoSelecionado) {
        setState(() {
          tipoSelecionado = tipoSelecionado ?? "";
        });
      },
      dropdownMenuEntries: widget.dropdownMenuEntries.map<DropdownMenuEntry<String>>(
        (String tipoRefeicao) {
          return DropdownMenuEntry<String>(
            value: tipoRefeicao,
            label: tipoRefeicao,
            style: MenuItemButton.styleFrom(),
          );
        }
      ).toList(),
    );
  }
}

