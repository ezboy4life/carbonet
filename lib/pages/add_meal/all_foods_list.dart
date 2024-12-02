import 'dart:async';

import 'package:carbonet/data/models/ingested_food.dart';
import 'package:carbonet/data/models/food_reference.dart';
import 'package:carbonet/pages/add_meal/camera_functionality.dart';
import 'package:carbonet/pages/add_meal/custom_types/food_union_type.dart';
import 'package:carbonet/pages/add_meal/custom_types/foodvisor_foodlist.dart';
import 'package:carbonet/pages/add_meal/foodvisor_vision.dart';
import 'package:carbonet/utils/app_colors.dart';
import 'package:carbonet/utils/logger.dart';
import 'package:carbonet/utils/static_image_holder.dart';
import 'package:carbonet/widgets/dialogs/input_dialog.dart';
import 'package:carbonet/widgets/dialogs/warning_dialog.dart';
import 'package:carbonet/widgets/input/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AllFoodsList extends StatefulWidget {
  final List<FoodReference> foodList;
  final List<FoodUnionType> selectedFoodList;

  const AllFoodsList({
    super.key,
    required this.foodList,
    required this.selectedFoodList,
  });

  dynamic photoFunction(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const BaseCameraScreen(),
      ),
    );
    Uint8List? croppedImage = StaticImageHolder.image;
    if (StaticImageHolder.image != null) {
      AnalysisResults? results = await FoodvisorVision().analyseImage(StaticImageHolder.image!);
      if (results != null) {
        for (AnalysisItem item in results.items) {
          selectedFoodList.add(FoodvisorFoodlistWrapper(FoodVisorFoodlist(list: item.foods)));
        }

        //todo loading e colocar o usuário na tab certa
      }
      // exibir loading
      // enviar e receber a resposta da api
      // colocar os alimentos na lista de selecionados
      // colocar o usuário na tab de selecionados
    }
    // Aqui espera-se receber a imagem cortada, e é aqui que a gente vai contatar a API e registrar os alimentos que ela nos devolver.
    // Com a lista de resultados, a gente coloca o usuário na tab de alimentos selecionados, e sucesso na vida e na morte.
    //TODO: lembrete de deixar editar o alimento tocando nele na lista de alimentos selecionado depois.
    //TODO: implementação api e transição de tela
    //TODO: lembrete que eu preciso manter os dados de calorias nas tabelas
    //TODO: lembrete que eu preciso fazer essa tela mostrar o valor total de calorias e carbos depois
    //TODO: lembrete que ao final, o cálculo de insulina tem que ser exibido.
    //TODO: lembrete de implementar o cadastro de glicemia separado.
    //   }
  }

  @override
  State<AllFoodsList> createState() => _AllFoodsListState();
}

class _AllFoodsListState extends State<AllFoodsList> {
  final TextEditingController gramsController = TextEditingController();
  final TextEditingController searchBoxController = TextEditingController();
  List<FoodReference> filteredFoodList = [];
  FoodReference? selectedFoodReference;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    setState(() {
      filteredFoodList = widget.foodList;
    });
  }

  void addFoodToList() {
    if (selectedFoodReference == null) {
      errorLog("Refeição selecionada é nula.");
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

    for (final food in widget.selectedFoodList) {
      if (food.name == selectedFoodReference?.name) {
        food.gramsIngested += double.parse(gramsController.text);
        Navigator.pop(context);
        return;
      }
    }

    widget.selectedFoodList.add(
      IngestedFoodWrapper(
        IngestedFood(
          idFoodReference: selectedFoodReference!.id,
          foodReference: selectedFoodReference,
          gramsIngested: double.parse(gramsController.text),
        ),
      ),
    );

    gramsController.text = "";
    Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const SizedBox(height: 32),
          InputField(
            controller: searchBoxController,
            onChanged: updateFilteredListDelay,
            labelText: "Pesquisar",
            iconData: Icons.search_rounded,
            trailingIcon: Icons.camera_alt_outlined,
            onTrailingIconPressed: widget.photoFunction,
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
                                maxLength: 4,
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
                                onPressed: addFoodToList,
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
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
