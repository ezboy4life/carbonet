import 'package:carbonet/pages/add_meal/foodvisor_vision.dart';
import 'package:carbonet/utils/app_colors.dart';
import 'package:carbonet/widgets/buttons/button.dart';
import 'package:carbonet/widgets/input/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SelectFoodFromApi extends StatefulWidget {
  const SelectFoodFromApi({
    super.key,
  });



  @override
  State<SelectFoodFromApi> createState() => _SelectFoodFromApiState();
}

class _SelectFoodFromApiState extends State<SelectFoodFromApi> {

  //^ TEMP
  List<FoodItem> dropdownItemsVal = <FoodItem> [
    FoodItem(confidence: 1, quantity: 150, foodId: 'id1', foodName: 'comidão 1', gPerServing: 10, calories100g: 100, carbs100g: 10),
    FoodItem(confidence: 1, quantity: 250, foodId: 'id2', foodName: 'comidão 2', gPerServing: 20, calories100g: 200, carbs100g: 20),
    FoodItem(confidence: 1, quantity: 350, foodId: 'id3', foodName: 'comidão 3', gPerServing: 30, calories100g: 300, carbs100g: 30),
  ];
  List<DropdownMenuItem<FoodItem>> dropdownItems = [];

  @override void initState() {
    dropdownItems = dropdownItemsVal.map((foodItem) => DropdownMenuItem(value: foodItem, child: Text(foodItem.foodName))).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            backgroundColor: Colors.black,
            body: Padding(
              padding: EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [

                  Text(
                    "Alterar alimento",
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: "Insira a quantidade de ",
                          style: TextStyle(
                            color: AppColors.fontBright,
                            fontSize: 17,
                          ),
                        ),
                        TextSpan( //^SUBSTITUIR
                          text: '[nomeAlimento]', //filteredSelectedFoods[index].name.toLowerCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const TextSpan(
                          text: " em gramas, ou escolha outro alimento:",
                          style: TextStyle(
                            color: AppColors.fontBright,
                            fontSize: 17,
                          ),
                        ),
                      ]
                    ),
                  ),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      DropdownButton( 
                        //items: widget.dropdownItems,        //^SUBSTITUIR
                        //value: widget.dropdownInitialValue, //^SUBSTITUIR
                        //onChanged: widget.dropdownOnChanged //^SUBSTITUIR
                        items: dropdownItems, 
                        onChanged: (value) {
                          print(value);
                        },
                      ),

                      const SizedBox(width: 12,),
                      Expanded(
                        child: InputField( 
                          maxLength: 4,
                          autofocus: true,
                          labelText: 'Qtd. em gramas',
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          //controller: widget.controller, //^SUBSTITUIR
                        
                          controller: TextEditingController(),
                        ),
                      ),

                    ]
                  ),

                  const SizedBox(height: 32),
                  Button( 
                    label: 'Alterar', 
                    onPressed: () {
                      print("BOTÃO APERTADO");
                      //widget.onPressed(); //^SUBSTITUIR 
                    }
                  ),
                ],
              ),
            )
          );
  }
}