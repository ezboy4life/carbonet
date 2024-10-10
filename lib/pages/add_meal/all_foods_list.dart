import 'package:carbonet/data/models/ingested_food.dart';
import 'package:carbonet/data/models/food_reference.dart';
import 'package:carbonet/pages/add_meal/camera_functionality.dart';
import 'package:carbonet/utils/app_colors.dart';
import 'package:carbonet/utils/logger.dart';
import 'package:carbonet/utils/static_image_holder.dart';
import 'package:carbonet/widgets/dialogs/input_dialog.dart';
import 'package:carbonet/widgets/dialogs/warning_dialog.dart';
import 'package:carbonet/widgets/input/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AllFoodsList extends StatefulWidget {
  final List<FoodReference> filteredFoodReferenceList;
  final List<IngestedFood> selectedFoodList;
  final TextEditingController searchBoxController;
  final Function(String?) updateFilteredList;

  const AllFoodsList({
    super.key,
    required this.filteredFoodReferenceList,
    required this.selectedFoodList,
    required this.searchBoxController,
    required this.updateFilteredList,
  });

  dynamic photoFunction(BuildContext context) async {
    Uint8List? croppedImage = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const BaseCameraScreen(),
      ),
    );
    croppedImage = StaticImageHolder.image; // meio que desnecessário agora, masss... vou deixar aí, só caso algo dê errado se eu tirar.
    //   if (image != null) {
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
  FoodReference? selectedFoodReference;

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
      if (food.idFoodReference == selectedFoodReference?.id) {
        food.gramsIngested += double.parse(gramsController.text);
        Navigator.pop(context);
        return;
      }
    }

    widget.selectedFoodList.add(
      IngestedFood(
        idFoodReference: selectedFoodReference!.id,
        foodReference: selectedFoodReference,
        gramsIngested: double.parse(gramsController.text),
      ),
    );

    gramsController.text = "";
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 32),
        InputField(
          controller: widget.searchBoxController,
          onChanged: widget.updateFilteredList,
          labelText: "Pesquisar",
          iconData: Icons.search_rounded,
          trailingIcon: Icons.camera_alt_outlined,
          onTrailingIconPressed: widget.photoFunction,
        ),
        const SizedBox(height: 32),
        Expanded(
          child: ListView.builder(
            itemCount: widget.filteredFoodReferenceList.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                    title: Text(
                      widget.filteredFoodReferenceList[index].name,
                      style: const TextStyle(color: AppColors.fontBright),
                    ),
                    onTap: () {
                      infoLog('"${widget.filteredFoodReferenceList[index].name}" selecionado!');
                      selectedFoodReference = widget.filteredFoodReferenceList[index];
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
                            onPressed: addFoodToList,
                          );
                        },
                      );
                    },
                  ),
                  if (index < widget.filteredFoodReferenceList.length - 1) const Divider(color: AppColors.fontDimmed),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
