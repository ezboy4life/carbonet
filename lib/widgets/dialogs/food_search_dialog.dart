import 'dart:async';
import 'dart:ui';
import 'package:carbonet/data/models/food_reference.dart';
import 'package:carbonet/data/models/ingested_food.dart';
import 'package:carbonet/pages/add_meal/custom_types/food_union_type.dart';
import 'package:carbonet/utils/app_colors.dart';
import 'package:carbonet/utils/logger.dart';
import 'package:carbonet/widgets/buttons/button.dart';
import 'package:carbonet/widgets/dialogs/input_dialog.dart';
import 'package:carbonet/widgets/dialogs/warning_dialog.dart';
import 'package:carbonet/widgets/input/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FoodSearchDialog extends StatefulWidget {
  final TextEditingController controller;
  final String title;
  final String label;
  final String buttonLabel;
  final List<TextSpan>? message;

  final IconData? icon;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;

  final List<FoodReference> foodList;

  /// Um dialog que tem um TextField, permitindo o usuário digitar um valor nele
  const FoodSearchDialog({
    super.key,
    required this.controller,
    required this.title,
    required this.label,
    required this.buttonLabel,
    required this.foodList,
    this.message,
    this.icon,
    this.inputFormatters,
    this.keyboardType,
  });

  @override
  State<FoodSearchDialog> createState() => _FoodSearchDialogState();
}

class _FoodSearchDialogState extends State<FoodSearchDialog> {
  final TextEditingController gramsController = TextEditingController();
  final TextEditingController searchBoxController = TextEditingController();
  List<FoodReference> filteredFoodList = [];
  FoodReference? selectedFoodReference;
  FoodUnionType? newIngestedFood;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    setState(() {
      filteredFoodList = widget.foodList;
    });
  }

  void updateFilteredList(String? value) {
    if (value == null || value.isEmpty) {
      setState(() {
        filteredFoodList = widget.foodList;
      });
    } else {
      setState(() {
        filteredFoodList = widget.foodList.where((element) => element.name.toLowerCase().contains(value.toLowerCase())).toList();
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

  void getQtyAndReturnNewFood() {
    if (selectedFoodReference == null) {
      errorLog("Alimento selecionado é nulo.");
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

    var newIngestedFood = IngestedFoodWrapper(
      IngestedFood(
        idFoodReference: selectedFoodReference!.id,
        foodReference: selectedFoodReference,
        gramsIngested: double.parse(gramsController.text),
      ),
    );

    gramsController.text = "";
    Navigator.pop(context, newIngestedFood);
  }

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
            width: MediaQuery.sizeOf(context).width * 0.8,
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
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null) Icon(widget.icon, color: Colors.white, size: 100),
                  if (widget.icon != null) const SizedBox(height: 16),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  if (widget.message != null) const SizedBox(height: 16),
                  if (widget.message != null) Text.rich(TextSpan(children: widget.message)),
                  const SizedBox(height: 32),
                  Expanded(
                    child: InputField(
                      controller: widget.controller,
                      labelText: widget.label,
                      inputFormatters: widget.inputFormatters,
                      keyboardType: widget.keyboardType,
                      autofocus: true,
                      onChanged: updateFilteredListDelay,
                    ),
                  ),
                  Container(
                    height: 60, 
                    padding: const EdgeInsets.all(8),
                    child: ListView.builder(
                      itemCount: filteredFoodList.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              title: Text(
                                filteredFoodList[index].name,
                                style: const TextStyle(color: AppColors.fontBright),
                              ),
                              onTap: () {
                                infoLog('"${filteredFoodList[index].name}" selecionado!');
                                selectedFoodReference = filteredFoodList[index];
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
                                          text: selectedFoodReference?.name.toLowerCase() ?? "ERRO!",
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
                                      onPressed: getQtyAndReturnNewFood,
                                    );
                                  },
                                );
                              },
                            ),
                            if (index < filteredFoodList.length - 1) const Divider(color: AppColors.fontDimmed),
                          ],
                        );
                      },
                    ),

                  ),
                  const SizedBox(height: 32),
                  Button(
                    label: widget.buttonLabel,
                    onPressed: () {
                      Navigator.pop(context, newIngestedFood);
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
