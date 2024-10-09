import 'dart:async';
import 'package:carbonet/data/database/food_reference_dao.dart';
import 'package:carbonet/data/models/food_reference.dart';
import 'package:carbonet/data/models/meal_type.dart';
import 'package:carbonet/pages/add_favorites/favorite_type_dialog.dart';
import 'package:carbonet/utils/app_colors.dart';
import 'package:carbonet/widgets/input/input_field.dart';
import 'package:flutter/material.dart';

class AddFavorites extends StatefulWidget {
  const AddFavorites({super.key});

  @override
  State<AddFavorites> createState() => _AddFavoritesState();
}

class _AddFavoritesState extends State<AddFavorites> {
  final List<FoodReference> favoritesCoffee = [];
  final List<FoodReference> favoritesLunch = [];
  final List<FoodReference> favoritesDinner = [];
  final List<FoodReference> favoritesSnack = [];
  final TextEditingController searchBoxController = TextEditingController();
  late List<FoodReference> _foods = [];
  List<FoodReference> _filteredFoods = [];
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _initListAsync();
  }

  void setFavorite(FoodReference food, MealType type, bool value) {
    setState(() {
      switch (type) {
        case MealType.coffee:
          food.favoriteCoffee = value;
          break;
        case MealType.lunch:
          food.favoriteLunch = value;
          break;
        case MealType.dinner:
          food.favoriteDinner = value;
          break;
        case MealType.snack:
          food.favoriteSnack = value;
          break;
      }
    });

    FoodReferenceDAO dao = FoodReferenceDAO();
    dao.updateFavoriteStatus(food);
  }

  _initListAsync() async {
    _foods = await FoodReferenceDAO().getAllFoodReference();
    for (FoodReference food in _foods) {
      food.favoriteCoffee ? favoritesCoffee.add(food) : null;
      food.favoriteLunch ? favoritesLunch.add(food) : null;
      food.favoriteDinner ? favoritesDinner.add(food) : null;
      food.favoriteSnack ? favoritesSnack.add(food) : null;
    }
    setState(() {
      _filteredFoods = _foods;
    });
  }

  void updateFilteredList(String? value) {
    if (value == null || value.isEmpty) {
      _filteredFoods = _foods;
    } else {
      _filteredFoods = _foods.where((element) => element.name.toLowerCase().contains(value.toLowerCase())).toList();
    }
  }

  void updateFilteredListDelay(String? searchTerm) {
    if (_searchDebounce?.isActive ?? false) _searchDebounce!.cancel();
    _searchDebounce = Timer(
      const Duration(milliseconds: 300),
      () {
        setState(() {
          updateFilteredList(searchTerm);
        });
      },
    );
  }

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
              "Fechar",
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
              const Text(
                "Favoritos",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              InputField(
                controller: searchBoxController,
                onChanged: updateFilteredListDelay,
                labelText: "Pesquisar",
                iconData: Icons.search_rounded,
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredFoods.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListTile(
                          title: Row(
                            children: [
                              Text(
                                _filteredFoods[index].name,
                                style: const TextStyle(color: AppColors.fontBright),
                              ),
                              const Spacer(),
                              if (_filteredFoods[index].favoriteCoffee)
                                Container(
                                  width: 15,
                                  height: 15,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.brown,
                                  ),
                                ),
                              if (_filteredFoods[index].favoriteLunch)
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                                  child: Container(
                                    width: 15,
                                    height: 15,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              if (_filteredFoods[index].favoriteDinner)
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                                  child: Container(
                                    width: 15,
                                    height: 15,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ),
                              if (_filteredFoods[index].favoriteSnack)
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                                  child: Container(
                                    width: 15,
                                    height: 15,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.defaultAppColor,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return FavoriteTypeDialog(
                                  setFavorite: setFavorite,
                                  selectedFood: _filteredFoods[index],
                                );
                              },
                            );
                          },
                        ),
                        if (index < _filteredFoods.length - 1) const Divider(color: AppColors.fontDimmed),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
