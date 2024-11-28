import 'dart:async';
import 'package:carbonet/data/database/food_reference_dao.dart';
import 'package:carbonet/data/models/food_reference.dart';
import 'package:carbonet/data/models/meal_type.dart';
import 'package:carbonet/pages/add_favorites/favorite_type_dialog.dart';
import 'package:carbonet/utils/app_colors.dart';
import 'package:carbonet/widgets/cosmetic/dropdown_menu_entry.dart';
import 'package:carbonet/widgets/input/dropdown_menu.dart';
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
  final List<DropdownMenuEntry<String>> _mealTypes = [
    CustomDropdownMenuEntry(value: "null", label: "Sem filtro"),
    CustomDropdownMenuEntry(value: "coffee", label: "Café da manhã"),
    CustomDropdownMenuEntry(value: "lunch", label: "Almoço"),
    CustomDropdownMenuEntry(value: "dinner", label: "Janta"),
    CustomDropdownMenuEntry(value: "snack", label: "Lanche"),
  ];
  late List<FoodReference> _foods = [];
  List<FoodReference> _filteredFoods = [];
  Timer? _searchDebounce;
  bool isFilterEnabled = false;
  String selectedFilterSearch = "null";

  @override
  void initState() {
    super.initState();
    _initListAsync();
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

  void _handleSelectedMealType(Object? value) {
    setState(() {
      switch (value) {
        case "null":
          _filteredFoods = _foods;
          selectedFilterSearch = "null";
          break;
        case "coffee":
          _filteredFoods = favoritesCoffee;
          selectedFilterSearch = "coffee";
          break;
        case "lunch":
          _filteredFoods = favoritesLunch;
          selectedFilterSearch = "lunch";
          break;
        case "dinner":
          _filteredFoods = favoritesDinner;
          selectedFilterSearch = "dinner";
          break;
        case "snack":
          _filteredFoods = favoritesSnack;
          selectedFilterSearch = "snack";
          break;
        default:
          throw Exception("! Seleção do DropDownMenu não implementada");
      }
    });
  }

  void toggleFilterField(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      if (isFilterEnabled) {
        _filteredFoods = _foods;
      }
      isFilterEnabled = !isFilterEnabled;
    });
  }

  void setFavorite(FoodReference food, MealType type, bool value) {
    List<FoodReference> localFoodList;

    setState(() {
      switch (type) {
        case MealType.coffee:
          food.favoriteCoffee = value;
          localFoodList = favoritesCoffee;
          // favoritesCoffee.add(food);
          break;
        case MealType.lunch:
          food.favoriteLunch = value;
          localFoodList = favoritesLunch;
          // favoritesLunch.add(food);
          break;
        case MealType.dinner:
          food.favoriteDinner = value;
          localFoodList = favoritesDinner;
          // favoritesDinner.add(food);
          break;
        case MealType.snack:
          food.favoriteSnack = value;
          localFoodList = favoritesSnack;
          // favoritesSnack.add(food);
          break;
      }

      if (value) {
        localFoodList.add(food);
      } else {
        localFoodList.remove(food);
      }
    });

    FoodReferenceDAO dao = FoodReferenceDAO();
    dao.updateFavoriteStatus(food);
  }

  void updateFilteredList(String? value) {
    List<FoodReference> localFoodList;

    switch (selectedFilterSearch) {
      case "null":
        localFoodList = _foods;
        break;
      case "coffee":
        localFoodList = favoritesCoffee;
        break;
      case "lunch":
        localFoodList = favoritesLunch;
        break;
      case "dinner":
        localFoodList = favoritesDinner;
        break;
      case "snack":
        localFoodList = favoritesSnack;
        break;
      default:
        localFoodList = [];
    }
    if (value == null || value.isEmpty) {
      _filteredFoods = localFoodList;
    } else {
      _filteredFoods = localFoodList.where((element) => element.name.toLowerCase().contains(value.toLowerCase())).toList();
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
                trailingIcon: Icons.filter_list_rounded,
                onTrailingIconPressed: toggleFilterField,
              ),
              const SizedBox(height: 15),
              if (isFilterEnabled) ...[
                CustomDropDownMenu(
                  labelText: "Tipo da Refeição",
                  iconData: Icons.restaurant_menu_rounded,
                  dropdownMenuEntries: _mealTypes,
                  selectedDropdownMenuEntry: _mealTypes[0],
                  onSelected: _handleSelectedMealType,
                ),
                const SizedBox(height: 15),
              ],
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _filteredFoods.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              title: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      _filteredFoods[index].name,
                                      style: const TextStyle(color: Colors.white),
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                      maxLines: 1,
                                    ),
                                  ),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
