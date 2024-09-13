import 'dart:async';
import 'package:carbonet/data/database/alimento_ref_dao.dart';
import 'package:carbonet/data/models/alimento_ingerido.dart';
import 'package:carbonet/data/models/alimento_ref.dart';
import 'package:carbonet/utils/app_colors.dart';
import 'package:carbonet/utils/logger.dart';
import 'package:carbonet/widgets/gradient_button.dart';
import 'package:carbonet/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DialogSelecionarAlimento extends StatefulWidget {
  const DialogSelecionarAlimento({
    super.key,
    required this.searchBoxController,
    required this.alimentosSelecionados,
    required this.setState,
  });

  final Function setState;
  final TextEditingController searchBoxController;
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

  Timer? _debounce;

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

  // Delay de .3 segundos pra que a função não seja chamada literalmente
  // toda vez que o usuário digitar algo
  void updateFilteredListDelay(String? searchTerm) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 300),
      () {
        updateListaFiltrada(searchTerm);
      },
    );
  }

  List<AlimentoRef> listaAlimentoRef = [];
  List<AlimentoRef> listaAlimentoRefFiltrada = [];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: const TabBar(
          dividerColor: AppColors.fontBright,
          indicatorColor: AppColors.defaultAppColor,
          tabs: [
            Tab(
              icon: Icon(
                Icons.restaurant_rounded,
                color: AppColors.fontBright,
              ),
              child: Text(
                "Todos Alimentos",
                style: TextStyle(color: AppColors.fontBright),
              ),
            ),
            Tab(
              icon: Icon(
                Icons.star_rounded,
                color: AppColors.fontBright,
              ),
              child: Text(
                "Favoritos",
                style: TextStyle(color: AppColors.fontBright),
              ),
            ),
            Tab(
              icon: Icon(
                Icons.check_rounded,
                color: AppColors.fontBright,
              ),
              child: Text(
                "Selecionados",
                style: TextStyle(color: AppColors.fontBright),
              ),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            AllFoodsList(
              filteredFoodReferenceList: listaAlimentoRefFiltrada,
              selectedFoodList: widget.alimentosSelecionados,
              searchBoxController: widget.searchBoxController,
              updateFilteredList: updateFilteredListDelay,
            ),
            const Center(
              child: Text(
                "Página de alimentos favoritos.",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const Center(
              child: Text(
                "Página de alimentos selecionados.",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        bottomNavigationBar: GradientButton(
          label: "Registrar Refeição",
          onPressed: () {
            infoLog("Botão de registrar refeição");
          },
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return SingleChildScrollView(
  //     child: Dialog(
  //       child: Padding(
  //         padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: TextField(
  //                 controller: widget.textController,
  //                 onChanged: (value) {
  //                   updateListaFiltrada(value);
  //                 },
  //                 enableSuggestions: true,
  //                 autofillHints: listaAlimentoRefFiltrada
  //                     .map((element) => element.nome)
  //                     .toList(),
  //                 decoration: InputDecoration(
  //                     hintText: "Buscar Alimentos...",
  //                     suffixIcon: widget.textController.text.isNotEmpty
  //                         ? IconButton(
  //                             onPressed: () {
  //                               widget.textController.clear();
  //                               updateListaFiltrada(null);
  //                             },
  //                             icon: const Icon(Icons.close))
  //                         : null),
  //               ),
  //             ),
  //             Container(
  //               width: double.infinity,
  //               child: DefaultTabController(
  //                 length: 2,
  //                 initialIndex: 0,
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     const TabBar(
  //                       tabs: [
  //                         Tab(
  //                           text: "Adicionar Alimentos",
  //                           icon: Icon(Icons.add_circle_outline),
  //                         ),
  //                         Tab(
  //                           text: "Alimentos Adicionados",
  //                           icon: Icon(Icons.restaurant),
  //                         ),
  //                       ],
  //                     ),
  //                     ConstrainedBox(
  //                       constraints: const BoxConstraints(maxHeight: 480),
  //                       child: TabBarView(children: [
  //                         // lista dos alimentos todos em geral + filtrados
  //                         ListView.builder(
  //                           shrinkWrap: true,
  //                           itemCount: listaAlimentoRefFiltrada.length,
  //                           itemBuilder: (context, index) {
  //                             final alimentoRef =
  //                                 listaAlimentoRefFiltrada[index];
  //                             return ListTile(
  //                               title: Text(alimentoRef.nome),
  //                               trailing: TextButton.icon(
  //                                 onPressed: () {
  //                                   showDialog(
  //                                       context: context,
  //                                       builder: (context) {
  //                                         return StatefulBuilder(
  //                                             builder: (context, setState) {
  //                                           return DialogSelecionarQtd(
  //                                               alimentoSelecionado:
  //                                                   alimentoRef,
  //                                               listaAlimentosSelecionados:
  //                                                   widget
  //                                                       .alimentosSelecionados);
  //                                         });
  //                                       }).then((value) {
  //                                     setState(() {});
  //                                   });
  //                                 },
  //                                 label: const Text("Adicionar"),
  //                                 icon: const Icon(Icons.add),
  //                               ),
  //                             );
  //                           },
  //                         ),
  //                         // lista dos alimentos já selecionados
  //                         ListView.builder(
  //                           shrinkWrap: true,
  //                           itemCount: widget.alimentosSelecionados.length,
  //                           itemBuilder: (context, index) {
  //                             final alimento =
  //                                 widget.alimentosSelecionados[index];
  //                             return ListTile(
  //                               title: Text(alimento.alimentoReferencia.nome),
  //                               trailing: Row(
  //                                 mainAxisSize: MainAxisSize.min,
  //                                 children: [
  //                                   Text("${alimento.qtdIngerida}g"),
  //                                   IconButton(
  //                                     onPressed: () {
  //                                       setState(() {
  //                                         widget.alimentosSelecionados
  //                                             .remove(alimento);
  //                                       });
  //                                     },
  //                                     icon: const Icon(Icons.delete),
  //                                   ),
  //                                 ],
  //                               ),
  //                             );
  //                           },
  //                         ),
  //                       ]),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(height: 12),
  //             TextButton.icon(
  //               style: TextButton.styleFrom(
  //                 backgroundColor: AppColors.defaultAppColor,
  //                 foregroundColor: Colors.white,
  //               ),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //               label: Text("Ok"),
  //               icon: Icon(
  //                 Icons.check,
  //                 color: Colors.white,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

class AllFoodsList extends StatelessWidget {
  final List<AlimentoRef> filteredFoodReferenceList;
  final List<AlimentoIngerido> selectedFoodList;
  final TextEditingController searchBoxController;
  final Function(String?) updateFilteredList;

  const AllFoodsList({
    super.key,
    required this.filteredFoodReferenceList,
    required this.selectedFoodList,
    required this.searchBoxController,
    required this.updateFilteredList,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        InputField(
          controller: searchBoxController,
          onChanged: updateFilteredList,
          labelText: "Pesquisar por alimentos",
        ),
        const SizedBox(height: 30),
        Expanded(
          child: ListView.builder(
            // shrinkWrap: true,
            itemCount: filteredFoodReferenceList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  filteredFoodReferenceList[index].nome,
                  style: const TextStyle(color: AppColors.fontBright),
                ),
                onTap: () {
                  infoLog('${filteredFoodReferenceList[index].nome} selected');
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DialogSelecionarQtd(
                        alimentoSelecionado: filteredFoodReferenceList[index],
                        listaAlimentosSelecionados: selectedFoodList,
                      );
                      // return PopupDialog(title: "title", message: "message");
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
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
        child: Theme(
          data: Theme.of(context).copyWith(
            dialogTheme: const DialogTheme(
              elevation: 0,
            ),
          ),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              side: const BorderSide(
                color: AppColors.fontDimmed,
              ),
            ),
            backgroundColor: Colors.black,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.restaurant_rounded,
                    color: AppColors.fontBright,
                    size: 60,
                  ),
                  const SizedBox(height: 30),
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: "Insira a quantidade de ",
                          style: TextStyle(
                            color: AppColors.fontBright,
                            fontSize: 20,
                          ),
                        ),
                        TextSpan(
                          text: widget.alimentoSelecionado.nome,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const TextSpan(
                          text: " em gramas:",
                          style: TextStyle(
                            color: AppColors.fontBright,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  InputField(
                    controller: qtdController,
                    labelText: "Qtd. em gramas",
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 30),
                  GradientButton(
                    label: "Salvar",
                    onPressed: () {
                      if (qtdController.text.isNotEmpty &&
                          qtdController.text != '0') {
                        AlimentoIngerido alimentoIngerido = AlimentoIngerido(
                            alimentoReferencia: widget.alimentoSelecionado,
                            qtdIngerida: double.parse(qtdController.text),
                            idAlimentoReferencia:
                                widget.alimentoSelecionado.id);
                        widget.listaAlimentosSelecionados.add(alimentoIngerido);
                      }
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
