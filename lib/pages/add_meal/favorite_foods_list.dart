import 'dart:async';
import 'package:carbonet/data/models/ingested_food.dart';
import 'package:carbonet/data/models/food_reference.dart';
import 'package:carbonet/pages/add_meal/custom_types/food_union_type.dart';
import 'package:carbonet/utils/app_colors.dart';
import 'package:carbonet/utils/logger.dart';
import 'package:carbonet/widgets/dialogs/input_dialog.dart';
import 'package:carbonet/widgets/dialogs/warning_dialog.dart';
import 'package:carbonet/widgets/input/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FavoriteFoodsList extends StatefulWidget {
  final String mealType;
  final List<FoodReference> foodList;
  final List<FoodUnionType> selectedFoodsList;
  // final TextEditingController searchBoxController;

  const FavoriteFoodsList({
    super.key,
    required this.mealType,
    required this.foodList,
    required this.selectedFoodsList,
    // required this.searchBoxController,
  });

  @override
  State<FavoriteFoodsList> createState() => _FavoriteFoodsListState();
}

class _FavoriteFoodsListState extends State<FavoriteFoodsList> {
  final TextEditingController favoritesSearchBoxController = TextEditingController();
  final TextEditingController gramsController = TextEditingController();
  final List<FoodReference> favorites = [];
  List<FoodReference> filteredFavorites = [];
  FoodReference? selectedFavorite;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _extrairFavoritos();
  }

  void updateFilteredList(String? value) {
    if (value == null || value.isEmpty) {
      setState(() {
        filteredFavorites = favorites;
      });
    } else {
      setState(() {
        filteredFavorites = favorites.where((element) => element.name.toLowerCase().contains(value.toLowerCase())).toList();
      });
    }
  }

  void updateFilteredListDelay(String? searchTerm) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 300),
      () {
        updateFilteredList(searchTerm);
      },
    );
  }

  void _adicionarFavorito() {
    if (selectedFavorite == null) {
      errorLog("Erro ao adicionar favorito");
      return;
    }

    if (gramsController.text.isEmpty || double.parse(gramsController.text) == 0) {
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

    for (final alimento in widget.selectedFoodsList) {
      if (alimento.id.toString() == selectedFavorite?.id.toString()) {
        alimento.gramsIngested += double.parse(gramsController.text);
        Navigator.pop(context);
        return;
      }
    }

    widget.selectedFoodsList.add(
      IngestedFoodWrapper(
        IngestedFood(
          idFoodReference: selectedFavorite!.id,
          foodReference: selectedFavorite,
          gramsIngested: double.parse(gramsController.text),
        ),
      ),
    );
    gramsController.text = "";
    Navigator.pop(context);
  }

  void _extrairFavoritos() {
    favorites.clear();
    for (FoodReference alimento in widget.foodList) {
      if (_isFavorito(alimento, widget.mealType)) {
        favorites.add(alimento);
      }
    }
    setState(() {
      filteredFavorites = favorites;
    });
  }

  bool _isFavorito(FoodReference alimento, String mealType) {
    switch (mealType) {
      case "coffee":
        return alimento.favoriteCoffee;
      case "lunch":
        return alimento.favoriteLunch;
      case "dinner":
        return alimento.favoriteDinner;
      case "snack":
        return alimento.favoriteSnack;
      default:
        return false;
    }
  }

  String? getMealName(String mealType) {
    switch (mealType) {
      case "coffee":
        return "café da manhã";
      case "lunch":
        return "almoço";
      case "dinner":
        return "jantar";
      case "snack":
        return "lanche";
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        if (favorites.isNotEmpty) ...[
          const SizedBox(height: 32),
          InputField(
            controller: favoritesSearchBoxController,
            onChanged: updateFilteredListDelay,
            labelText: "Pesquisar favoritos",
            iconData: Icons.search_rounded,
          ),
          const SizedBox(height: 32),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: filteredFavorites.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text(
                          filteredFavorites[index].name,
                          style: const TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          infoLog('"${filteredFavorites[index].name}" selecionado!');
                          selectedFavorite = filteredFavorites[index];
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return InputDialog(
                                controller: gramsController,
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
                                    text: filteredFavorites[index].name.toLowerCase(),
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
                      ),
                      if (index < filteredFavorites.length - 1) const Divider(color: AppColors.fontDimmed),
                    ],
                  );
                }),
          )
        ] else ...[
          Expanded(
            child: Center(
              child: Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: "Nenhum favorito para a categoria ",
                      style: TextStyle(color: AppColors.fontBright),
                    ),
                    TextSpan(
                      text: getMealName(widget.mealType),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
                // style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ]),
    );
  }
}
