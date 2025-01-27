import 'package:carbonet/data/database/food_reference_dao.dart';
import 'package:carbonet/data/models/ingested_food.dart';
import 'package:carbonet/pages/add_meal/custom_types/food_search_separate.dart';
import 'package:carbonet/pages/add_meal/custom_types/foodvisor_foodlist.dart';
import 'package:carbonet/pages/add_meal/custom_types/select_food_from_api.dart';
import 'package:carbonet/pages/add_meal/foodvisor_vision.dart';
import 'package:carbonet/utils/app_colors.dart';
import 'package:carbonet/utils/logger.dart';
import 'package:carbonet/widgets/dialogs/food_search_dialog.dart';
import 'package:carbonet/widgets/dialogs/input_dialog.dart';
import 'package:carbonet/widgets/dialogs/mixed_reselect_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

sealed class FoodUnionType {
  get name {
    if (this is IngestedFoodWrapper) {
      return (this as IngestedFoodWrapper).value.foodReference.name;
    } else if (this is FoodvisorFoodlistWrapper) {
      return (this as FoodvisorFoodlistWrapper).value.selected!.foodName;
    }
  }

  get id {
    if (this is IngestedFoodWrapper) {
      return (this as IngestedFoodWrapper).value.id;
    } else if (this is FoodvisorFoodlistWrapper) {
      return (this as FoodvisorFoodlistWrapper).value.selected!.foodId;
    }
  }

  get gramsIngested {
    if (this is IngestedFoodWrapper) {
      return (this as IngestedFoodWrapper).value.gramsIngested;
    } else if (this is FoodvisorFoodlistWrapper) {
      return (this as FoodvisorFoodlistWrapper).value.selected!.quantity;
    }
  }

  set gramsIngested(dynamic value) {
    assert(value is double || value is int, "value must be a number");
    if (this is IngestedFoodWrapper) {
      (this as IngestedFoodWrapper).value.gramsIngested = value;
    } else if (this is FoodvisorFoodlistWrapper) {
      var foodvisorFoodList = (this as FoodvisorFoodlistWrapper).value;
      var updatedSelected = foodvisorFoodList.selected!.copyWith(quantity: value);
      final result = foodvisorFoodList.list.remove(foodvisorFoodList.list.firstWhere((el) => el.foodId == foodvisorFoodList.selected!.foodId)); // Isso não tá funcionando, aparentemente.
      //foodvisorFoodList.list.
      infoLog("Conseguiu remover o alimento da lista? -> $result");
      print(foodvisorFoodList.list);
      print(foodvisorFoodList.selected);
      print(updatedSelected);

      foodvisorFoodList.list.add(updatedSelected);
      foodvisorFoodList.selected = updatedSelected;
    }
  }

  editDialog(BuildContext context, TextEditingController alterController, Function updateSelectedFoodItem, List<FoodUnionType> filteredSelectedFoods, int index) {
    if (this is IngestedFoodWrapper) {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return InputDialog(
            maxLength: 4,
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
                text: filteredSelectedFoods[index].name.toLowerCase(),
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
    } else if (this is FoodvisorFoodlistWrapper) {

      //TODO

      // Erro 1: ao clicar em alterar, ele coloca outra entrada do mesmo alimento na lista, com uma quantidade diferente.
      // Erro 2: cada entrada de alimento tem uma quantidade única, parece. Então, qdo vc muda ele no modal de alterar, ele não tá trocando no input tbm.
      // Erro 3: tem vezes que vc altera o alimento mas ele n altera o nome displayed na lista...??????? explanado: ele atualiza na lista, mas qdo vc clica ele puxa o originalmente selecionado (?)
      // Erro 4: se vc troca na dropdownbutton, mas n altera a qtd em gramas, ele troca fora, mas não no input qdo vc reabre o input.
      var foodvisorFoodList = (this as FoodvisorFoodlistWrapper);
      var dropdownItems = foodvisorFoodList.value.list
        .map((foodItem) => DropdownMenuItem(
          value: foodItem, 
          child: Text(foodItem.foodName)
        )).toList();

      // DropdownItem diferenciado - causa a troca do tipo de variável na lista de alimentos selecionados
      dropdownItems.add(
        const DropdownMenuItem(
          value: null,
          child: Row(
                children: [
                  Icon(Icons.search, color: Colors.white,),
                  SizedBox(width: 8),
                  Flexible(child: Text("Buscar alimento na base de dados", softWrap: true,)),
                ]),
        )
      );
      
      var initialSelect = foodvisorFoodList.value.selected;//list[0];//dropdownItems[0];
      void dropdownOnChanged(newSelected) async {
        if (newSelected is FoodItem) {
          foodvisorFoodList.value.selected = newSelected; // 👈 esse campo (selected) era final; troquei pra não ser, e vejamos se resolve o erro 3.
          alterController.text = newSelected.quantity.toString(); // 👈 deve corrigir o erro 2...
        } else {
          // Tela: buscar alimento na base de dados :D
          var foodList = await FoodReferenceDAO().getAllFoodReference();
          FoodUnionType? result = await Navigator.push(context, 
            MaterialPageRoute(builder: (context) {
              return FoodSearchPageSeparate(
                controller: TextEditingController(), //alterController, 
                title: "Buscar alimento", 
                label: "Nome do alimento", 
                buttonLabel: "Cancelar", 
                foodList: foodList
              );
            },)
          );

          if (result != null) { // Se entrar aqui, o usuário escolheu um alimento (jeito não usual de sair desse dialog; o normal seria sair pelo onPressed do botão)
            Navigator.pop(context, result);
          }
        }
      }
      return showDialog(
        context: context, 
        builder: (BuildContext context) {
          return MixedReselectDialog(
            controller: alterController, 
            title: "Alterar alimento", 
            label: "Qtd. em gramas", 
            buttonLabel: "Alterar", 
            onPressed: updateSelectedFoodItem, 
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            message: const [
              TextSpan(
                text: "Insira a quantidade do alimento em gramas, ou escolha outro alimento:",
                style: TextStyle(
                  color: AppColors.fontBright,
                  fontSize: 17,
                ),
              ),
            ],

            foodvisorFoodList: foodvisorFoodList,
            updateQuantityFunc: foodvisorFoodList.updateQuantity,
            dropdownItems: dropdownItems,
            dropdownInitialValue: initialSelect,
            dropdownOnChanged: dropdownOnChanged,
            );
        }
      );
    }
  }
}

class IngestedFoodWrapper extends FoodUnionType {
  final IngestedFood value;
  IngestedFoodWrapper(this.value);
}

class FoodvisorFoodlistWrapper extends FoodUnionType {
  final FoodVisorFoodlist value;
  FoodvisorFoodlistWrapper(this.value);

  void updateQuantity(double qty) {
    // for (int i = 0; i < value.list.length; i++) {
    //   value.list[i] = value.list[i].copyWith(quantity: qty);
    // }
  }
}