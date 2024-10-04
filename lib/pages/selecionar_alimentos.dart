import 'dart:async';
import 'package:carbonet/data/database/alimento_ref_dao.dart';
import 'package:carbonet/data/models/alimento_ingerido.dart';
import 'package:carbonet/data/models/alimento_ref.dart';
import 'package:carbonet/data/models/refeicao.dart';
import 'package:carbonet/pages/camera_functionality.dart';
import 'package:carbonet/utils/app_colors.dart';
import 'package:carbonet/utils/dao_procedure_coupler.dart';
import 'package:carbonet/utils/logged_user_access.dart';
import 'package:carbonet/utils/logger.dart';
import 'package:carbonet/utils/static_image_holder.dart';
import 'package:carbonet/widgets/buttons/button.dart';
import 'package:carbonet/widgets/dialogs/confirmation_dialog.dart';
import 'package:carbonet/widgets/input/input_field.dart';
import 'package:carbonet/widgets/dialogs/warning_dialog.dart';
import 'package:carbonet/widgets/dialogs/input_dialog.dart';
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
  final Function(Refeicao) addMealToHistory;

  const SelectFoods({
    super.key,
    required this.searchBoxController,
    required this.favoritesSearchBoxController,
    required this.selectedFoodsSearchBoxController,
    required this.selectedMealTypeController,
    required this.glicemiaController,
    required this.alimentosSelecionados,
    required this.addMealToHistory,
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
            FavoriteFoodsList(
              tipoRefeicao: widget.selectedMealTypeController.text,
              listaAlimentosRef: listaAlimentoRef,
              listaAlimentosSelecionados: widget.alimentosSelecionados,
            ),
            SelectedFoodsList(
              selectedFoods: widget.alimentosSelecionados,
            ),
          ],
        ),
        bottomNavigationBar: Button(
          label: "Registrar Refeição",
          onPressed: () {
            if (widget.alimentosSelecionados.isEmpty) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const WarningDialog(
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
                refeicao.id = value;
                widget.addMealToHistory(refeicao);
                Navigator.pop(context, true);
              },
            );
          },
        ),
      ),
    );
  }
}

class AllFoodsList extends StatefulWidget {
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

  dynamic photoFunction(BuildContext context) async {
    Uint8List? croppedImage = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const BaseCameraScreen(),
      ),
    );
    croppedImage = StaticImageHolder.image; // meio que desnecessário agora, masss... vou deixar aí, só caso algo dê errado se eu tirar.
    //   if (image != null) {
    // Aqui espera-se receber a imagem cortada, e é aqui que a gente vai contatar a API e registrar os alimentos que ela nos devolver.
    // Com a lista de resultados, a gente coloca o usuário na tab de alimentos selecionados, e sucesso na vida e na morte.
    //TODO: lembrete de deixar editar o alimento tocando nele na lista de alimentos selecionado depois.
    //TODO: implementação api e transição de tela
    //TODO: lembrete que eu preciso manter os dados de calorias nas tabelas
    //TODO: lembrete que eu preciso fazer essa tela mostrar o valor total de calorias e carbos depois
    //TODO: lembrete que ao final, o cálculo de insulina tem que ser exibido.
    //TODO: lembrete de implementar o cadastro de glicemia separado.
    //   }
  }

  @override
  State<AllFoodsList> createState() => _AllFoodsListState();
}

class _AllFoodsListState extends State<AllFoodsList> {
  final TextEditingController qtdController = TextEditingController();
  AlimentoRef? selectedFoodRef;

  void addFoodToList() {
    if (selectedFoodRef == null) {
      errorLog("Refeição selecionada é nula.");
      return;
    }

    if (qtdController.text.isEmpty || double.parse(qtdController.text) == 0) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const WarningDialog(
            title: "Quantidade inválida!",
            message: "Insira uma quantidade (em gramas) válida.",
          );
        },
      );
      return;
    }

    for (final alimento in widget.selectedFoodList) {
      if (alimento.idAlimentoReferencia == selectedFoodRef?.id) {
        alimento.qtdIngerida += double.parse(qtdController.text);
        Navigator.pop(context);
        return;
      }
    }

    widget.selectedFoodList.add(
      AlimentoIngerido(
        idAlimentoReferencia: selectedFoodRef!.id,
        alimentoReferencia: selectedFoodRef,
        qtdIngerida: double.parse(qtdController.text),
      ),
    );

    qtdController.text = "";
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        InputField(
          controller: widget.searchBoxController,
          onChanged: widget.updateFilteredList,
          labelText: "Pesquisar",
          iconData: Icons.search_rounded,
          trailingIcon: Icons.camera_alt_outlined,
          onTrailingIconPressed: photoFunction,
        ),
        const SizedBox(height: 30),
        Expanded(
          child: ListView.builder(
            itemCount: widget.filteredFoodReferenceList.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                    title: Text(
                      widget.filteredFoodReferenceList[index].nome,
                      style: const TextStyle(color: AppColors.fontBright),
                    ),
                    onTap: () {
                      infoLog('"${widget.filteredFoodReferenceList[index].nome}" selecionado!');
                      selectedFoodRef = widget.filteredFoodReferenceList[index];
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return InputDialog(
                            controller: qtdController,
                            title: "Adicionar alimento",
                            message: [
                              const TextSpan(
                                text: "Insira a quantidade de ",
                                style: TextStyle(
                                  color: AppColors.fontBright,
                                  fontSize: 17,
                                ),
                              ),
                              TextSpan(
                                text: selectedFoodRef?.nome.toLowerCase() ?? "ERRO!",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const TextSpan(
                                text: " em gramas:",
                                style: TextStyle(
                                  color: AppColors.fontBright,
                                  fontSize: 17,
                                ),
                              ),
                            ],
                            label: "Qtd em gramas",
                            buttonLabel: "Adicionar",
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            onPressed: addFoodToList,
                          );
                        },
                      );
                    },
                  ),
                  if (index < widget.filteredFoodReferenceList.length - 1) const Divider(color: AppColors.fontDimmed),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class FavoriteFoodsList extends StatefulWidget {
  const FavoriteFoodsList({
    super.key,
    required this.tipoRefeicao,
    required this.listaAlimentosRef,
    required this.listaAlimentosSelecionados,
  });

  final String tipoRefeicao;
  final List<AlimentoRef> listaAlimentosRef;
  final List<AlimentoIngerido> listaAlimentosSelecionados;

  @override
  State<FavoriteFoodsList> createState() => _FavoriteFoodsListState();
}

class _FavoriteFoodsListState extends State<FavoriteFoodsList> {
  final List<AlimentoRef> favoritos = [];
  final TextEditingController favoritosController = TextEditingController();
  AlimentoRef? selectedFavorite;

  void _adicionarFavorito() {
    if (selectedFavorite == null) {
      errorLog("Erro ao adicionar favorito");
      return;
    }

    if (favoritosController.text.isEmpty || double.parse(favoritosController.text) == 0) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const WarningDialog(
            title: "Quantidade inválida!",
            message: "Insira uma quantidade (em gramas) válida.",
          );
        },
      );
      return;
    }

    for (final alimento in widget.listaAlimentosSelecionados) {
      if (alimento.idAlimentoReferencia == selectedFavorite?.id) {
        alimento.qtdIngerida += double.parse(favoritosController.text);
        Navigator.pop(context);
        return;
      }
    }

    widget.listaAlimentosSelecionados.add(
      AlimentoIngerido(
        idAlimentoReferencia: selectedFavorite!.id,
        alimentoReferencia: selectedFavorite,
        qtdIngerida: double.parse(favoritosController.text),
      ),
    );
    favoritosController.text = "";
    Navigator.pop(context);
  }

  void _extrairFavoritos() {
    favoritos.clear(); //?

    for (AlimentoRef alimento in widget.listaAlimentosRef) {
      if (_isFavorito(alimento, widget.tipoRefeicao)) {
        favoritos.add(alimento);
      }
    }
  }

  bool _isFavorito(AlimentoRef alimento, String tipoRefeicao) {
    switch (tipoRefeicao) {
      case "Café da manhã":
        return alimento.favCafe;
      case "Almoço":
        return alimento.favAlmoco;
      case "Janta":
        return alimento.favJanta;
      case "Lanche":
        return alimento.favLanche;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    _extrairFavoritos();

    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text("Favoritos - ${widget.tipoRefeicao}", style: const TextStyle(color: AppColors.fontBright, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      ListView.builder(
          shrinkWrap: true,
          itemCount: favoritos.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                favoritos[index].nome,
                style: const TextStyle(color: AppColors.fontBright),
              ),
              trailing: IconButton(
                  onPressed: () {
                    infoLog('"${favoritos[index].nome}" selecionado!');
                    selectedFavorite = favoritos[index];
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return InputDialog(
                          controller: favoritosController,
                          title: "Adicionar alimento",
                          message: [
                            const TextSpan(
                              text: "Insira a quantidade de ",
                              style: TextStyle(
                                color: AppColors.fontBright,
                                fontSize: 17,
                              ),
                            ),
                            TextSpan(
                              text: favoritos[index].nome.toLowerCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const TextSpan(
                              text: " em gramas:",
                              style: TextStyle(
                                color: AppColors.fontBright,
                                fontSize: 17,
                              ),
                            ),
                          ],
                          label: "Qtd em gramas",
                          buttonLabel: "Adicionar",
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          onPressed: _adicionarFavorito,
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.add, color: Colors.blueAccent)),
            );
          }),
    ]);
  }
}

class SelectedFoodsList extends StatefulWidget {
  final List<AlimentoIngerido> selectedFoods;

  const SelectedFoodsList({
    super.key,
    required this.selectedFoods,
  });

  @override
  State<SelectedFoodsList> createState() => _SelectedFoodsListState();
}

class _SelectedFoodsListState extends State<SelectedFoodsList> {
  final TextEditingController alterController = TextEditingController();
  AlimentoIngerido? selectedFoodItem;

  void updateSelectedFoodItem() {
    if (selectedFoodItem == null) {
      errorLog("Erro ao atualizar quantidade ingerida de um alimento. O alimento é nulo.");
      return;
    }

    if (alterController.text.isNotEmpty && int.parse(alterController.text) != 0) {
      selectedFoodItem?.qtdIngerida = double.parse(alterController.text);
      Navigator.of(context).pop(selectedFoodItem?.qtdIngerida);
      selectedFoodItem = null;
      alterController.text = "";
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const WarningDialog(
            title: "Quantidade inválida!",
            message: "Insira uma quantidade (em gramas) válida.",
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        Expanded(
          child: ListView.builder(
            itemCount: widget.selectedFoods.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Dismissible(
                    key: Key(widget.selectedFoods[index].alimentoReferencia.id.toString()),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    confirmDismiss: (direction) async {
                      return await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return const ConfirmationDialog(
                            title: "Confirmar exclusão",
                            message: "Você tem certeza que deseja excluir esse alimento?",
                            confirmButtonLabel: "Excluir",
                            confirmButtonColor: Colors.red,
                          );
                        },
                      );
                    },
                    onDismissed: (direction) {
                      setState(() {
                        widget.selectedFoods.removeAt(index);
                      });
                    },
                    child: ListTile(
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
                        selectedFoodItem = widget.selectedFoods[index];
                        final result = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return InputDialog(
                              controller: alterController,
                              title: "Alterar alimento",
                              label: "Qtd. em gramas",
                              buttonLabel: "Alterar",
                              onPressed: updateSelectedFoodItem,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              message: [
                                const TextSpan(
                                  text: "Insira a quantidade de ",
                                  style: TextStyle(
                                    color: AppColors.fontBright,
                                    fontSize: 17,
                                  ),
                                ),
                                TextSpan(
                                  text: widget.selectedFoods[index].alimentoReferencia.nome.toLowerCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const TextSpan(
                                  text: " em gramas:",
                                  style: TextStyle(
                                    color: AppColors.fontBright,
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                        if (result != null) {
                          setState(() {});
                        }
                      },
                    ),
                  ),
                  if (index < widget.selectedFoods.length - 1) const Divider(color: AppColors.fontDimmed),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
