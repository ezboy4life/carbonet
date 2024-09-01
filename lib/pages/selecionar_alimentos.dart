import 'package:carbonet/data/database/alimento_ref_dao.dart';
import 'package:carbonet/data/models/alimento_ingerido.dart';
import 'package:carbonet/data/models/alimento_ref.dart';
import 'package:carbonet/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DialogSelecionarAlimento extends StatefulWidget {
  DialogSelecionarAlimento({
    super.key,
    required this.textController,
    required this.alimentosSelecionados,
    required this.setState,
  });

  final Function setState;
  final TextEditingController textController;
  final List<AlimentoIngerido> alimentosSelecionados;

  @override
  State<DialogSelecionarAlimento> createState() =>
      _DialogSelecionarAlimentoState();
}

class _DialogSelecionarAlimentoState extends State<DialogSelecionarAlimento> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initListAsync();
    });
  }

  _initListAsync() async {
    listaAlimentoRef = await AlimentoRefDAO().getAllAlimentoRef();
    setState(() {
      listaAlimentoRefFiltrada = listaAlimentoRef;
    });
  }

  void updateListaFiltrada(String? value) {
    if (value == null || value.isEmpty) {
      setState(() {
        listaAlimentoRefFiltrada = listaAlimentoRef;
      });
    } else {
      setState(() {
        listaAlimentoRefFiltrada = listaAlimentoRef
            .where((element) =>
                element.nome.toLowerCase().contains(value.toLowerCase()))
            .toList();
      });
    }
  }

  List<AlimentoRef> listaAlimentoRef = [];
  List<AlimentoRef> listaAlimentoRefFiltrada = [];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Dialog(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: widget.textController,
                  onChanged: (value) {
                    updateListaFiltrada(value);
                  },
                  enableSuggestions: true,
                  autofillHints: listaAlimentoRefFiltrada
                      .map((element) => element.nome)
                      .toList(),
                  decoration: InputDecoration(
                      hintText: "Buscar Alimentos...",
                      suffixIcon: widget.textController.text.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                widget.textController.clear();
                                updateListaFiltrada(null);
                              },
                              icon: const Icon(Icons.close))
                          : null),
                ),
              ),
              Container(
                width: double.infinity,
                child: DefaultTabController(
                  length: 2,
                  initialIndex: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const TabBar(
                        tabs: [
                          Tab(
                            text: "Adicionar Alimentos",
                            icon: Icon(Icons.add_circle_outline),
                          ),
                          Tab(
                            text: "Alimentos Adicionados",
                            icon: Icon(Icons.restaurant),
                          ),
                        ],
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 480),
                        child: TabBarView(children: [
                          // lista dos alimentos todos em geral + filtrados
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: listaAlimentoRefFiltrada.length,
                            itemBuilder: (context, index) {
                              final alimentoRef =
                                  listaAlimentoRefFiltrada[index];
                              return ListTile(
                                title: Text(alimentoRef.nome),
                                trailing: TextButton.icon(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return StatefulBuilder(
                                              builder: (context, setState) {
                                            return DialogSelecionarQtd(
                                                alimentoSelecionado:
                                                    alimentoRef,
                                                listaAlimentosSelecionados:
                                                    widget
                                                        .alimentosSelecionados);
                                          });
                                        }).then((value) {
                                      setState(() {});
                                    });
                                  },
                                  label: const Text("Adicionar"),
                                  icon: const Icon(Icons.add),
                                ),
                              );
                            },
                          ),
                          // lista dos alimentos já selecionados
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: widget.alimentosSelecionados.length,
                            itemBuilder: (context, index) {
                              final alimento =
                                  widget.alimentosSelecionados[index];
                              return ListTile(
                                title: Text(alimento.alimentoReferencia.nome),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("${alimento.qtdIngerida}g"),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          widget.alimentosSelecionados
                                              .remove(alimento);
                                        });
                                      },
                                      icon: const Icon(Icons.delete),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.defaultAppColor,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                label: Text("Ok"),
                icon: Icon(
                  Icons.check,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DialogSelecionarQtd extends StatefulWidget {
  const DialogSelecionarQtd({
    super.key,
    required this.alimentoSelecionado,
    required this.listaAlimentosSelecionados,
  });

  final AlimentoRef alimentoSelecionado;
  final List<AlimentoIngerido> listaAlimentosSelecionados;

  @override
  State<DialogSelecionarQtd> createState() => _DialogSelecionarQtdState();
}

class _DialogSelecionarQtdState extends State<DialogSelecionarQtd> {
  final TextEditingController qtdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                    "Insira a quantidade de ${widget.alimentoSelecionado.nome} em gramas"),
                const SizedBox(height: 12),
                TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: qtdController,
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.defaultAppColor,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (qtdController.text.isNotEmpty &&
                        qtdController.text != '0') {
                      AlimentoIngerido alimentoIngerido = AlimentoIngerido(
                          alimentoReferencia: widget.alimentoSelecionado,
                          qtdIngerida: double.parse(qtdController.text),
                          idAlimentoReferencia: widget.alimentoSelecionado.id);
                      widget.listaAlimentosSelecionados.add(alimentoIngerido);
                    }
                    Navigator.of(context).pop();
                  },
                  label: Text("Salvar"),
                  icon: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
