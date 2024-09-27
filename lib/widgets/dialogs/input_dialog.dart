import 'package:carbonet/data/models/alimento_ingerido.dart';
import 'package:carbonet/utils/app_colors.dart';
import 'package:carbonet/widgets/buttons/button.dart';
import 'package:carbonet/widgets/dialogs/warning_dialog.dart';
import 'package:carbonet/widgets/input/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DialogEditSelectedFood extends StatefulWidget {
  final AlimentoIngerido selectedFood;

  const DialogEditSelectedFood({
    super.key,
    required this.selectedFood,
  });

  @override
  State<DialogEditSelectedFood> createState() => _DialogEditSelectedFoodState();
}

class _DialogEditSelectedFoodState extends State<DialogEditSelectedFood> {
  final TextEditingController selectedFoodController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Theme(
          data: Theme.of(context).copyWith(
            dialogTheme: const DialogTheme(
              elevation: 0,
            ),
          ),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(
                color: AppColors.fontDimmed,
              ),
            ),
            backgroundColor: Colors.black,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.restaurant_rounded,
                    color: AppColors.fontBright,
                    size: 60,
                  ),
                  const SizedBox(height: 30),
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: "Insira a quantidade de ",
                          style: TextStyle(
                            color: AppColors.fontBright,
                            fontSize: 20,
                          ),
                        ),
                        TextSpan(
                          text: widget.selectedFood.alimentoReferencia.nome,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const TextSpan(
                          text: " em gramas:",
                          style: TextStyle(
                            color: AppColors.fontBright,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  InputField(
                    controller: selectedFoodController,
                    labelText: "Qtd. em gramas",
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Button(
                        label: "Alterar",
                        onPressed: () {
                          if (selectedFoodController.text.isNotEmpty && int.parse(selectedFoodController.text) != 0) {
                            widget.selectedFood.qtdIngerida = double.parse(selectedFoodController.text);
                            Navigator.of(context).pop(widget.selectedFood.qtdIngerida);
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
                        },
                      ),
                      const SizedBox(height: 30),
                      Button(
                        label: "Remover",
                        backgroundColor: Colors.red,
                        onPressed: () {
                          Navigator.of(context).pop("delete");
                        },
                      ),
                    ],
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