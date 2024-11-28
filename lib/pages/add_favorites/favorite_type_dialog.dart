import 'dart:ui';
import 'package:carbonet/data/models/food_reference.dart';
import 'package:carbonet/data/models/meal_type.dart';
import 'package:carbonet/utils/app_colors.dart';
import 'package:carbonet/widgets/buttons/button.dart';
import 'package:flutter/material.dart';

class FavoriteTypeDialog extends StatefulWidget {
  final FoodReference selectedFood;
  final void Function(FoodReference, MealType, bool) setFavorite;
  const FavoriteTypeDialog({
    super.key,
    required this.selectedFood,
    required this.setFavorite,
  });

  @override
  State<FavoriteTypeDialog> createState() => _FavoriteTypeDialogState();
}

class _FavoriteTypeDialogState extends State<FavoriteTypeDialog> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dialogTheme: const DialogTheme(
          elevation: 0,
        ),
      ),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.black,
              boxShadow: const [
                BoxShadow(
                  color: AppColors.fontDark,
                  spreadRadius: 2.5,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Text(
                        widget.selectedFood.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const Divider(color: AppColors.fontDimmed),
                  CheckboxListTile(
                    title: Row(
                      children: [
                        Container(
                          width: 35,
                          height: 35,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                            color: Colors.brown,
                          ),
                          child: const Icon(
                            Icons.coffee_rounded,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 15),
                        const Text(
                          "Café",
                          style: TextStyle(
                            color: AppColors.fontBright,
                          ),
                        ),
                      ],
                    ),
                    checkColor: Colors.white,
                    activeColor: AppColors.defaultAppColor,
                    value: widget.selectedFood.favoriteCoffee,
                    onChanged: (value) {
                      setState(() {
                        widget.setFavorite(widget.selectedFood, MealType.coffee, value ?? false);
                      });
                    },
                  ),
                  const Divider(color: AppColors.fontDimmed),
                  CheckboxListTile(
                    title: Row(
                      children: [
                        Container(
                          width: 35,
                          height: 35,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                            color: Colors.green,
                          ),
                          child: const Icon(
                            Icons.local_restaurant_rounded,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 15),
                        const Text(
                          "Almoço",
                          style: TextStyle(
                            color: AppColors.fontBright,
                          ),
                        ),
                      ],
                    ),
                    checkColor: Colors.white,
                    activeColor: AppColors.defaultAppColor,
                    value: widget.selectedFood.favoriteLunch,
                    onChanged: (value) {
                      setState(() {
                        widget.setFavorite(widget.selectedFood, MealType.lunch, value ?? false);
                      });
                    },
                  ),
                  const Divider(color: AppColors.fontDimmed),
                  CheckboxListTile(
                    title: Row(
                      children: [
                        Container(
                          width: 35,
                          height: 35,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                            color: Colors.orange,
                          ),
                          child: const Icon(
                            Icons.dinner_dining_rounded,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 15),
                        const Text(
                          "Janta",
                          style: TextStyle(
                            color: AppColors.fontBright,
                          ),
                        ),
                      ],
                    ),
                    checkColor: Colors.white,
                    activeColor: AppColors.defaultAppColor,
                    value: widget.selectedFood.favoriteDinner,
                    onChanged: (value) {
                      setState(() {
                        widget.setFavorite(widget.selectedFood, MealType.dinner, value ?? false);
                      });
                    },
                  ),
                  const Divider(color: AppColors.fontDimmed),
                  CheckboxListTile(
                    title: Row(
                      children: [
                        Container(
                          width: 35,
                          height: 35,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                            color: AppColors.defaultAppColor,
                          ),
                          child: const Icon(
                            Icons.lunch_dining_rounded,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 15),
                        const Text(
                          "Lanche",
                          style: TextStyle(
                            color: AppColors.fontBright,
                          ),
                        ),
                      ],
                    ),
                    checkColor: Colors.white,
                    activeColor: AppColors.defaultAppColor,
                    value: widget.selectedFood.favoriteSnack,
                    onChanged: (value) {
                      setState(() {
                        widget.setFavorite(widget.selectedFood, MealType.snack, value ?? false);
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Button(
                    label: "Confirmar",
                    onPressed: () {
                      Navigator.pop(context);
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
