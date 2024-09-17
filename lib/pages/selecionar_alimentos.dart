import 'dart:async';
import 'package:carbonet/data/database/alimento_ref_dao.dart';
import 'package:carbonet/data/models/alimento_ingerido.dart';
import 'package:carbonet/data/models/alimento_ref.dart';
import 'package:carbonet/data/models/refeicao.dart';
import 'package:carbonet/utils/app_colors.dart';
import 'package:carbonet/utils/dao_procedure_coupler.dart';
import 'package:carbonet/utils/logged_user_access.dart';
import 'package:carbonet/utils/logger.dart';
import 'package:carbonet/widgets/gradient_button.dart';
import 'package:carbonet/widgets/input_field.dart';
import 'package:carbonet/widgets/popup_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SelectFoods extends StatefulWidget {
  final Function setState;
  final TextEditingController searchBoxController;
  final TextEditingController favoritesSearchBoxController;
  final TextEditingController selectedFoodsSearchBoxController;
  final TextEditingController selectedMealTypeController;
  final TextEditingController glicemiaController;

  final List<AlimentoIngerido> alimentosSelecionados;
  final DateTime? mealDate;
  final TimeOfDay? mealTime;

  const SelectFoods({
    super.key,
    required this.searchBoxController,
    required this.favoritesSearchBoxController,
    required this.selectedFoodsSearchBoxController,
    required this.selectedMealTypeController,
    required this.glicemiaController,
    required this.alimentosSelecionados,
    required this.setState,
    required this.mealDate,
    required this.mealTime,
  });

  @override
  State<SelectFoods> createState() => _SelectFoodsState();
}

class _SelectFoodsState extends State<SelectFoods> {
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
        listaAlimentoRefFiltrada = listaAlimentoRef.where((element) => element.nome.toLowerCase().contains(value.toLowerCase())).toList();
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
            SelectedFoodsList(
              selectedFoods: widget.alimentosSelecionados,
            ),
          ],
        ),
        bottomNavigationBar: GradientButton(
          label: "Registrar Refeição",
          onPressed: () {
            // debugLog("Data selecionada: ${widget.mealDate?.day}/${widget.mealDate?.month}/${widget.mealDate?.year}");
            // debugLog("Horário selecionado: ${widget.mealTime?.hour}:${widget.mealTime?.minute}");
            // debugLog("Glicemia: ${widget.glicemiaController.text}");
            // debugLog("Tipo da refeição: ${widget.selectedMealTypeController.text}");
            // if (widget.alimentosSelecionados.isEmpty) {
            //   errorLog("Nenhum alimento selecionado!");
            //   return;
            // }
            // for (final alimento in widget.alimentosSelecionados) {
            //   infoLog("${alimento.alimentoReferencia.nome} - ${alimento.qtdIngerida}");
            // }

            if (widget.alimentosSelecionados.isEmpty) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const PopupDialog(
                    title: "Refeição sem alimentos!",
                    message: "Insira pelo menos um alimento para que a refeição possa ser registrada.",
                  );
                },
              );
              return;
            }

            final DateTime dataRefeicao = DateTime(
              widget.mealDate!.year,
              widget.mealDate!.month,
              widget.mealDate!.day,
              widget.mealTime!.hour,
              widget.mealTime!.minute,
            );

            Refeicao refeicao = Refeicao(
              idUser: LoggedUserAccess().user!.id!,
              data: dataRefeicao,
              tipoRefeicao: widget.selectedMealTypeController.text,
              isActive: true,
            );

            DaoProcedureCoupler.inserirRefeicaoProcedimento(refeicao, widget.alimentosSelecionados).then(
              (value) {
                Navigator.pop(context, true);
              },
            );
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
  //                                           return DialogAdicionarAlimento(
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
                      return DialogAdicionarAlimento(
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

class FavoriteFoodsList extends StatelessWidget {
  const FavoriteFoodsList({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implementar a listagem dos favoritos
    throw UnimplementedError();
  }
}

class SelectedFoodsList extends StatefulWidget {
  final List<AlimentoIngerido> selectedFoods;

  const SelectedFoodsList({super.key, required this.selectedFoods});

  @override
  State<SelectedFoodsList> createState() => _SelectedFoodsListState();
}

class _SelectedFoodsListState extends State<SelectedFoodsList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        Expanded(
          child: ListView.builder(
            itemCount: widget.selectedFoods.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  widget.selectedFoods[index].alimentoReferencia.nome,
                  style: const TextStyle(color: AppColors.fontBright),
                ),
                trailing: Text(
                  "${widget.selectedFoods[index].qtdIngerida.toStringAsFixed(0)}g",
                  style: const TextStyle(
                    color: AppColors.fontBright,
                    fontSize: 15,
                  ),
                ),
                onTap: () async {
                  infoLog(widget.selectedFoods[index].alimentoReferencia.nome);
                  final result = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DialogEditSelectedFood(
                        selectedFood: widget.selectedFoods[index],
                      );
                    },
                  );

                  if (result == "delete") {
                    setState(() {
                      widget.selectedFoods.removeAt(index);
                    });
                  } else if (result != null) {
                    setState(() {});
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class DialogAdicionarAlimento extends StatefulWidget {
  const DialogAdicionarAlimento({
    super.key,
    required this.alimentoSelecionado,
    required this.listaAlimentosSelecionados,
  });

  final AlimentoRef alimentoSelecionado;
  final List<AlimentoIngerido> listaAlimentosSelecionados;

  @override
  State<DialogAdicionarAlimento> createState() => _DialogAdicionarAlimentoState();
}

class _DialogAdicionarAlimentoState extends State<DialogAdicionarAlimento> {
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
                    label: "Adicionar",
                    onPressed: () {
                      if (qtdController.text.isEmpty || double.parse(qtdController.text) == 0) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const PopupDialog(
                              title: "Quantidade inválida!",
                              message: "Insira uma quantidade (em gramas) válida.",
                            );
                          },
                        );
                        return;
                      }

                      for (final alimento in widget.listaAlimentosSelecionados) {
                        if (alimento.idAlimentoReferencia == widget.alimentoSelecionado.id) {
                          alimento.qtdIngerida += double.parse(qtdController.text);
                          Navigator.pop(context);
                          return;
                        }
                      }

                      widget.listaAlimentosSelecionados.add(
                        AlimentoIngerido(
                          idAlimentoReferencia: widget.alimentoSelecionado.id,
                          alimentoReferencia: widget.alimentoSelecionado,
                          qtdIngerida: double.parse(qtdController.text),
                        ),
                      );
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DialogEditSelectedFood extends StatefulWidget {
  AlimentoIngerido selectedFood;

  DialogEditSelectedFood({
    super.key,
    required this.selectedFood,
  });

  @override
  State<DialogEditSelectedFood> createState() => _DialogEditSelectedFoodState();
}

class _DialogEditSelectedFoodState extends State<DialogEditSelectedFood> {
  final TextEditingController selectedFoodController = TextEditingController();

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
              borderRadius: BorderRadius.circular(20),
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
                          text: widget.selectedFood.alimentoReferencia.nome,
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
                    controller: selectedFoodController,
                    labelText: "Qtd. em gramas",
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 30),
                  GradientButton(
                    label: "Alterar",
                    onPressed: () {
                      if (selectedFoodController.text.isNotEmpty && int.parse(selectedFoodController.text) != 0) {
                        widget.selectedFood.qtdIngerida = double.parse(selectedFoodController.text);
                        Navigator.of(context).pop(widget.selectedFood.qtdIngerida);
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const PopupDialog(
                              title: "Quantidade inválida!",
                              message: "Insira uma quantidade (em gramas) válida.",
                            );
                          },
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 30),
                  GradientButton(
                    label: "Remover",
                    buttonColors: const [
                      Colors.red,
                      Colors.redAccent,
                    ],
                    onPressed: () {
                      Navigator.of(context).pop("delete");
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
