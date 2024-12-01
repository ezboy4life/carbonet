import 'dart:async';

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

class FoodSearchPageSeparate extends StatefulWidget {
  const FoodSearchPageSeparate({
    super.key,
    required this.controller,
    required this.title,
    required this.label,
    required this.buttonLabel,
    required this.foodList,
    this.icon,
    this.inputFormatters,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String title;
  final String label;
  final String buttonLabel;

  final IconData? icon;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;

  final List<FoodReference> foodList;

  @override
  State<FoodSearchPageSeparate> createState() => _FoodSearchPageSeparateState();
}

class _FoodSearchPageSeparateState extends State<FoodSearchPageSeparate> {

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
    infoLog("[getQtyAndReturnNewFood] called");
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

    newIngestedFood = IngestedFoodWrapper(
      IngestedFood(
        idFoodReference: selectedFoodReference!.id,
        foodReference: selectedFoodReference,
        gramsIngested: double.parse(gramsController.text),
      ),
    );

    infoLog("[getQtyAndReturnNewFood] newIngestedFood defined :D");
    gramsController.text = "";
    Navigator.pop(context, newIngestedFood);
    Navigator.pop(context, newIngestedFood);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            backgroundColor: Colors.black,
            body: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [

                  const Text(
                    "Buscar alimento",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  const Text.rich(
                    TextSpan(
                      text: "Insira o nome do alimento que deseja buscar: ",
                      style: TextStyle(
                        color: AppColors.fontBright,
                        fontSize: 17,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32,),
                  InputField( 
                    controller: widget.controller,
                    labelText: widget.label,
                    inputFormatters: widget.inputFormatters,
                    keyboardType: widget.keyboardType,
                    autofocus: true,
                    onChanged: updateFilteredListDelay,
                  ),

                  // & Trecho que eu roubei do visual novo do luigi :3
                  const SizedBox(height: 32),
                  Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: (filteredFoodList.isEmpty) 
                        ? const Center(child: Text("Nenhum alimento encontrado.", style: TextStyle(color: Colors.white),)) 
                        : ListView.builder(
                        shrinkWrap: true,
                        itemCount: filteredFoodList.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              ListTile(
                                title: Text(
                                  filteredFoodList[index].name,
                                  style: const TextStyle(color: Colors.white),
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  maxLines: 1,
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
                  ),

                  // Botão de voltar
                  const SizedBox(height: 32),
                  Button(
                    label: widget.buttonLabel,
                    backgroundColor: AppColors.error,
                    onPressed: () {
                      Navigator.pop(context, null);
                    },
                  ),
                ],
              ),
            )
          );
  }
}