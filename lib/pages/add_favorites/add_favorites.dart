import 'dart:async';
import 'package:carbonet/data/database/food_reference_dao.dart';
import 'package:carbonet/data/models/food_reference.dart';
import 'package:carbonet/utils/app_colors.dart';
import 'package:carbonet/utils/logger.dart';
import 'package:carbonet/widgets/input/input_field.dart';
import 'package:flutter/material.dart';

enum MealTypeEnum { cafe, almoco, jantar, lanche }

class AddFavorites extends StatefulWidget {
  const AddFavorites({super.key});

  @override
  State<AddFavorites> createState() => _AddFavoritesState();
}

class _AddFavoritesState extends State<AddFavorites> {
  final Future<List<FoodReference>> _foodsFuture = FoodReferenceDAO().getAllFoodReference();
  final List<FoodReference> _foods = [];
  bool hasResolvedFoodsFuture = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "Cancelar",
              style: TextStyle(
                color: AppColors.defaultAppColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              FutureBuilder(
                future: _foodsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        // return const Text(snapshot.data?[index].);
                        // TODO: Fazer isso aqui
                      },
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AddFavoritesOld extends StatefulWidget {
  const AddFavoritesOld({super.key});

  @override
  State<AddFavoritesOld> createState() => _AddFavoritesOldState();
}

class _AddFavoritesOldState extends State<AddFavoritesOld> {
  final Future<List<FoodReference>> _alimentos = FoodReferenceDAO().getAllFoodReference();

  final List<FoodReference> favoritosCafe = [];
  final List<FoodReference> favoritosAlmoco = [];
  final List<FoodReference> favoritosJantar = [];
  final List<FoodReference> favoritosLanche = [];
  late List<FoodReference> listaBase;

  Future<void> separarFavoritos() async {
    listaBase = await _alimentos;
    for (FoodReference alimento in listaBase) {
      alimento.favoriteCoffee ? favoritosCafe.add(alimento) : null;
      alimento.favoriteLunch ? favoritosAlmoco.add(alimento) : null;
      alimento.favoriteDinner ? favoritosJantar.add(alimento) : null;
      alimento.favoriteSnack ? favoritosLanche.add(alimento) : null;
    }
  }

  ({List<FoodReference> favoriteCoffee, List<FoodReference> favoriteLunch, List<FoodReference> favoriteDinner, List<FoodReference> favoriteSnack, List<FoodReference> listaBase}) getListas() {
    return (favoriteCoffee: favoritosCafe, favoriteLunch: favoritosAlmoco, favoriteDinner: favoritosJantar, favoriteSnack: favoritosLanche, listaBase: listaBase);
  }

  void _toggleFavorito(FoodReference alimento, MealTypeEnum refeicao, List<FoodReference> listaFav) async {
    if (listaFav.contains(alimento)) {
      listaFav.remove(alimento);
    } else {
      listaFav.add(alimento);
    }

    switch (refeicao) {
      case MealTypeEnum.cafe:
        alimento.favoriteCoffee = !alimento.favoriteCoffee;
        break;
      case MealTypeEnum.almoco:
        alimento.favoriteLunch = !alimento.favoriteLunch;
        break;
      case MealTypeEnum.jantar:
        alimento.favoriteDinner = !alimento.favoriteDinner;
        break;
      case MealTypeEnum.lanche:
        alimento.favoriteSnack = !alimento.favoriteSnack;
        break;
    }

    FoodReferenceDAO dao = FoodReferenceDAO();
    dao.updateFavoriteStatus(alimento);

    return;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: const TabBar(
          dividerColor: AppColors.fontBright,
          indicatorColor: AppColors.defaultAppColor,
          tabs: [
            Tab(
              icon: Icon(
                Icons.breakfast_dining,
                color: AppColors.fontBright,
              ),
              child: Text(
                "Café",
                style: TextStyle(color: AppColors.fontBright),
              ),
            ),
            Tab(
              icon: Icon(
                Icons.lunch_dining,
                color: AppColors.fontBright,
              ),
              child: Text(
                "Almoço",
                style: TextStyle(color: AppColors.fontBright),
              ),
            ),
            Tab(
              icon: Icon(
                Icons.dinner_dining,
                color: AppColors.fontBright,
              ),
              child: Text(
                "Jantar",
                style: TextStyle(color: AppColors.fontBright),
              ),
            ),
            Tab(
              icon: Icon(
                Icons.bakery_dining,
                color: AppColors.fontBright,
              ),
              child: Text(
                "Lanche",
                style: TextStyle(color: AppColors.fontBright),
              ),
            ),
          ],
        ),
        body: FutureBuilder(
          future: separarFavoritos(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return TabBarView(
                children: [
                  ListaFavoritosRefeicao(
                    favoritos: favoritosCafe,
                    refeicao: MealTypeEnum.cafe,
                    toggleFavorito: _toggleFavorito,
                    getListas: getListas,
                  ),
                  ListaFavoritosRefeicao(
                    favoritos: favoritosAlmoco,
                    refeicao: MealTypeEnum.almoco,
                    toggleFavorito: _toggleFavorito,
                    getListas: getListas,
                  ),
                  ListaFavoritosRefeicao(
                    favoritos: favoritosJantar,
                    refeicao: MealTypeEnum.jantar,
                    toggleFavorito: _toggleFavorito,
                    getListas: getListas,
                  ),
                  ListaFavoritosRefeicao(
                    favoritos: favoritosLanche,
                    refeicao: MealTypeEnum.lanche,
                    toggleFavorito: _toggleFavorito,
                    getListas: getListas,
                  ),
                ],
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}

class ListaFavoritosRefeicao extends StatefulWidget {
  const ListaFavoritosRefeicao({super.key, required this.favoritos, required this.refeicao, required this.toggleFavorito, required this.getListas});

  final List<FoodReference> favoritos;
  final MealTypeEnum refeicao;
  final Function toggleFavorito;
  final Function getListas;

  @override
  State<ListaFavoritosRefeicao> createState() => _ListaFavoritosRefeicaoState();
}

class _ListaFavoritosRefeicaoState extends State<ListaFavoritosRefeicao> {
  Future<void> showAdicionarModal() async {
    await showModalBottomSheet(
      backgroundColor: Colors.grey[900],
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return AdicionarFavModal(getListas: widget.getListas);
      },
    );
    if (mounted) {
      setState(() {});
    }
  }

  String getRefeicaoName(MealTypeEnum refeicao) {
    switch (refeicao) {
      case MealTypeEnum.cafe:
        return "Café";
      case MealTypeEnum.almoco:
        return "Almoço";
      case MealTypeEnum.jantar:
        return "Jantar";
      case MealTypeEnum.lanche:
        return "Lanche";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(children: [
            Text("Favoritos - ${getRefeicaoName(widget.refeicao)}", style: const TextStyle(color: AppColors.fontBright, fontSize: 18, fontWeight: FontWeight.bold)),
            const Spacer(),
            TextButton.icon(
                onPressed: () {
                  if (mounted) {
                    setState(() {
                      showAdicionarModal();
                    });
                  }
                },
                icon: const Icon(
                  Icons.add,
                  color: AppColors.fontBright,
                ),
                label: const Text(
                  "Adicionar",
                  style: TextStyle(color: AppColors.fontBright),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: const RoundedRectangleBorder(
                    side: BorderSide(color: AppColors.fontBright),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                )),
          ]),
        ),
        ListView.builder(
            shrinkWrap: true,
            itemCount: widget.favoritos.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  widget.favoritos[index].name,
                  style: const TextStyle(color: AppColors.fontBright),
                ),
                trailing: IconButton(
                    onPressed: () {
                      widget.toggleFavorito(widget.favoritos[index], widget.refeicao, widget.favoritos);
                      setState(() {});
                    },
                    icon: const Icon(Icons.remove_circle_outline, color: Colors.red)),
              );
            }),
      ]),
    );
  }
}

class AdicionarFavModal extends StatefulWidget {
  AdicionarFavModal({super.key, required this.getListas});

  final Function getListas;
  final TextEditingController searchBoxController = TextEditingController();

  @override
  State<AdicionarFavModal> createState() => _AdicionarFavModalState();
}

class _AdicionarFavModalState extends State<AdicionarFavModal> {
  late List<FoodReference> _listaBase, listaFoodReferenceFiltrada; //_favCafe, _favAlmoco, _favJanta, _favLanche
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    var (:favoriteCoffee, :favoriteLunch, :favoriteDinner, :favoriteSnack, :listaBase) = widget.getListas();

    _listaBase = listaBase;
    listaFoodReferenceFiltrada = _listaBase;
  }

  void _updateListaFiltrada(String? value) {
    if (value == null || value.isEmpty) {
      setState(() {
        listaFoodReferenceFiltrada = _listaBase;
      });
    } else {
      setState(() {
        listaFoodReferenceFiltrada = _listaBase.where((element) => element.name.toLowerCase().contains(value.toLowerCase())).toList();
      });
    }
  }

  void updateFilteredList(String? searchTerm) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 300),
      () {
        _updateListaFiltrada(searchTerm);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                "Editar Favoritos",
                style: TextStyle(
                  color: AppColors.fontBright,
                  fontSize: 20,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: AppColors.fontBright),
              ),
            ],
          ),
          const SizedBox(height: 30),
          InputField(
            controller: widget.searchBoxController,
            onChanged: updateFilteredList,
            labelText: "Pesquisar por alimentos",
          ),
          const SizedBox(height: 30),
          Expanded(
            child: ListView.builder(
              itemCount: listaFoodReferenceFiltrada.length,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text(
                        listaFoodReferenceFiltrada[index].name,
                        style: const TextStyle(color: AppColors.fontBright),
                      ),
                      onTap: () {
                        infoLog('"${listaFoodReferenceFiltrada[index].name}" selecionado!');
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DialogModificarFavorito(
                              alimentoSelecionado: listaFoodReferenceFiltrada[index],
                              getListas: widget.getListas,
                            );
                          },
                        );
                        setState(() {});
                      },
                    ),
                    if (index < listaFoodReferenceFiltrada.length - 1) const Divider(color: AppColors.fontDimmed),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DialogModificarFavorito extends StatefulWidget {
  const DialogModificarFavorito({super.key, required this.alimentoSelecionado, required this.getListas});

  final FoodReference alimentoSelecionado;
  final Function getListas;

  @override
  State<DialogModificarFavorito> createState() => _DialogModificarFavoritoState();
}

class _DialogModificarFavoritoState extends State<DialogModificarFavorito> {
  late List<FoodReference> _favCafe, _favAlmoco, _favJanta, _favLanche;
  late List<bool> _selectedRefeicoes;
  final List<Icon> icons = const [
    Icon(Icons.breakfast_dining),
    Icon(Icons.lunch_dining),
    Icon(Icons.dinner_dining),
    Icon(Icons.bakery_dining),
  ];

  @override
  void initState() {
    super.initState();
    var (:favoriteCoffee, :favoriteLunch, :favoriteDinner, :favoriteSnack, :listaBase) = widget.getListas();

    _favCafe = favoriteCoffee;
    _favAlmoco = favoriteLunch;
    _favJanta = favoriteDinner;
    _favLanche = favoriteSnack;

    _selectedRefeicoes = [widget.alimentoSelecionado.favoriteCoffee, widget.alimentoSelecionado.favoriteLunch, widget.alimentoSelecionado.favoriteDinner, widget.alimentoSelecionado.favoriteSnack];
  }

  void updateFavorito(FoodReference alimento, MealTypeEnum refeicao) {
    List<FoodReference> listaFav;

    switch (refeicao) {
      case MealTypeEnum.cafe:
        listaFav = _favCafe;
        alimento.favoriteCoffee = !alimento.favoriteCoffee;
        break;
      case MealTypeEnum.almoco:
        listaFav = _favAlmoco;
        alimento.favoriteLunch = !alimento.favoriteLunch;
        break;
      case MealTypeEnum.jantar:
        listaFav = _favJanta;
        alimento.favoriteDinner = !alimento.favoriteDinner;
        break;
      case MealTypeEnum.lanche:
        listaFav = _favLanche;
        alimento.favoriteSnack = !alimento.favoriteSnack;
        break;
    }

    if (listaFav.contains(alimento)) {
      listaFav.remove(alimento);
    } else {
      listaFav.add(alimento);
    }

    FoodReferenceDAO dao = FoodReferenceDAO();
    dao.updateFavoriteStatus(alimento);

    return;
  }

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
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 60,
                  ),
                  const SizedBox(height: 30),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Editar favorito: ${widget.alimentoSelecionado.name}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ToggleButtons(
                    direction: Axis.horizontal,
                    onPressed: (int index) {
                      setState(() {
                        // All buttons are selectable.
                        _selectedRefeicoes[index] = !_selectedRefeicoes[index];
                        updateFavorito(widget.alimentoSelecionado, MealTypeEnum.values[index]);
                      });
                    },
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    selectedBorderColor: Colors.blue[700],
                    selectedColor: Colors.white,
                    fillColor: Colors.blue[200],
                    color: Colors.blue[400],
                    isSelected: _selectedRefeicoes,
                    children: icons,
                  ),
                  const SizedBox(height: 30),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                      side: const BorderSide(color: AppColors.fontBright),
                      borderRadius: BorderRadius.circular(24.0),
                    )),
                    child: const Text("Ok", style: TextStyle(color: AppColors.fontBright)),
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
