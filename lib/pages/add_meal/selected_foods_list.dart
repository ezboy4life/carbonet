import 'dart:async';
import 'package:carbonet/pages/add_meal/custom_types/food_union_type.dart';
import 'package:carbonet/utils/app_colors.dart';
import 'package:carbonet/utils/logger.dart';
import 'package:carbonet/widgets/dialogs/confirmation_dialog.dart';
import 'package:carbonet/widgets/dialogs/warning_dialog.dart';
import 'package:carbonet/widgets/input/input_field.dart';
import 'package:flutter/material.dart';

class SelectedFoodsList extends StatefulWidget {
  final List<FoodUnionType> selectedFoods;

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
  List<FoodUnionType> filteredSelectedFoods = [];
  FoodUnionType? selectedFoodItem;
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

    // comportamento default: popa com gramas ingeridos, ou com nulo
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
        filteredSelectedFoods = widget.selectedFoods
            .where((element) => (element is IngestedFoodWrapper)
                ? element.value.foodReference.name.toLowerCase().contains(value.toLowerCase())
                : (element as FoodvisorFoodlistWrapper).value.selected.foodName.toLowerCase().contains(value.toLowerCase()))
            .toList();
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
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
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredSelectedFoods.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Dismissible(
                          key: Key(filteredSelectedFoods[index].id.toString()),
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
                            FoodUnionType foodToBeRemoved = filteredSelectedFoods.elementAt(index);
                            setState(() {
                              filteredSelectedFoods.remove(foodToBeRemoved);
                              widget.selectedFoods.remove(foodToBeRemoved);
                            });
                          },
                          child: ListTile(
                            title: Text(
                              filteredSelectedFoods[index].name,
                              style: const TextStyle(color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              maxLines: 1,
                            ),
                            trailing: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[850],
                                borderRadius: const BorderRadius.all(Radius.circular(8)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                child: Text(
                                  "${filteredSelectedFoods[index].gramsIngested.toStringAsFixed(0)}g",
                                  style: const TextStyle(
                                    color: AppColors.fontBright,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                            onTap: () async {
                              // <- aqui muda.
                              // ! Aviso: como agora nós temos mais de um tipo de dado na lista de alimentos selecionados, a coisa funciona um pouco diferente em todo lugar que interage com ela.
                              // * -> Caso você clique numa entrada que é "FoodItem" (foodvisor), você tem a opção de trocar quantidade, escolher entre outros itens que a IA achou pertinentes, ou CONVERTER aquela entrada em algo que já exista no NOSSO db.
                              // * -> Essas entradas "FoodItem" (na real são FoodList mas enfim) SÃO consideradas no total de calorias e carboidratos da refeição (e portanto no cálculo e nos registros), mas os alimentos vindos do foodvisor NÃO são registrados, e aí a refeição fica com "calorias fantasma" se vc olhar com atenção pros mapeamentos de refeição-alimentoIngerido. Mas bem, como nós NÃO vamos mostrar isso, vai ficar assim por enquanto.

                              infoLog(filteredSelectedFoods[index].name);
                              selectedFoodItem = filteredSelectedFoods[index];
                              final result = await selectedFoodItem!.editDialog(context, alterController, updateSelectedFoodItem, filteredSelectedFoods, index);
                              if (result != null) {
                                setState(() {
                                  if (result is IngestedFoodWrapper) {
                                    filteredSelectedFoods[index] = result;
                                  }
                                });
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
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
