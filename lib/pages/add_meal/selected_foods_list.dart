import 'dart:async';
import 'package:carbonet/data/models/ingested_food.dart';
import 'package:carbonet/utils/app_colors.dart';
import 'package:carbonet/utils/logger.dart';
import 'package:carbonet/widgets/dialogs/confirmation_dialog.dart';
import 'package:carbonet/widgets/dialogs/input_dialog.dart';
import 'package:carbonet/widgets/dialogs/warning_dialog.dart';
import 'package:carbonet/widgets/input/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SelectedFoodsList extends StatefulWidget {
  final List<IngestedFood> selectedFoods;

  const SelectedFoodsList({
    super.key,
    required this.selectedFoods,
  });

  @override
  State<SelectedFoodsList> createState() => _SelectedFoodsListState();
}

class _SelectedFoodsListState extends State<SelectedFoodsList> {
  final TextEditingController alterController = TextEditingController();
  final TextEditingController searchBoxController = TextEditingController();
  List<IngestedFood> filteredSelectedFoods = [];
  IngestedFood? selectedFoodItem;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    filteredSelectedFoods = widget.selectedFoods;
  }

  void updateSelectedFoodItem() {
    if (selectedFoodItem == null) {
      errorLog("Erro ao atualizar quantidade ingerida de um alimento. O alimento é nulo.");
      return;
    }

    if (alterController.text.isNotEmpty && int.parse(alterController.text) != 0) {
      selectedFoodItem?.gramsIngested = double.parse(alterController.text);
      Navigator.of(context).pop(selectedFoodItem?.gramsIngested);
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

  void updateFilteredList(String? value) {
    if (value == null || value.isEmpty) {
      setState(() {
        filteredSelectedFoods = widget.selectedFoods;
      });
    } else {
      setState(() {
        filteredSelectedFoods = widget.selectedFoods.where((element) => element.foodReference.name.toLowerCase().contains(value.toLowerCase())).toList();
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.selectedFoods.isNotEmpty) ...[
          const SizedBox(height: 32),
          InputField(
            controller: searchBoxController,
            labelText: "Pesquisar alimentos selecionados",
            onChanged: updateFilteredListDelay,
            iconData: Icons.search_rounded,
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView.builder(
              itemCount: filteredSelectedFoods.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Dismissible(
                      key: Key(filteredSelectedFoods[index].foodReference.id.toString()),
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
                        IngestedFood foodToBeRemoved = filteredSelectedFoods.elementAt(index);
                        setState(() {
                          filteredSelectedFoods.remove(foodToBeRemoved);
                          widget.selectedFoods.remove(foodToBeRemoved);
                        });
                      },
                      child: ListTile(
                        title: Text(
                          filteredSelectedFoods[index].foodReference.name,
                          style: const TextStyle(color: AppColors.fontBright),
                        ),
                        trailing: Text(
                          "${filteredSelectedFoods[index].gramsIngested.toStringAsFixed(0)}g",
                          style: const TextStyle(
                            color: AppColors.fontBright,
                            fontSize: 15,
                          ),
                        ),
                        onTap: () async {
                          infoLog(filteredSelectedFoods[index].foodReference.name);
                          selectedFoodItem = filteredSelectedFoods[index];
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
                                    text: filteredSelectedFoods[index].foodReference.name.toLowerCase(),
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
                    if (index < filteredSelectedFoods.length - 1) const Divider(color: AppColors.fontDimmed),
                  ],
                );
              },
            ),
          ),
        ] else ...[
          const Expanded(
            child: Center(
              child: Text(
                "Nenhum alimento selecionado",
                style: TextStyle(color: AppColors.fontBright),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
