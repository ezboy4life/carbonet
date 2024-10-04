import 'package:carbonet/data/models/alimento_ingerido.dart';
import 'package:carbonet/utils/app_colors.dart';
import 'package:carbonet/utils/logger.dart';
import 'package:carbonet/widgets/dialogs/confirmation_dialog.dart';
import 'package:carbonet/widgets/dialogs/input_dialog.dart';
import 'package:carbonet/widgets/dialogs/warning_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SelectedFoodsList extends StatefulWidget {
  final List<AlimentoIngerido> selectedFoods;

  const SelectedFoodsList({
    super.key,
    required this.selectedFoods,
  });

  @override
  State<SelectedFoodsList> createState() => _SelectedFoodsListState();
}

class _SelectedFoodsListState extends State<SelectedFoodsList> {
  final TextEditingController alterController = TextEditingController();
  AlimentoIngerido? selectedFoodItem;

  void updateSelectedFoodItem() {
    if (selectedFoodItem == null) {
      errorLog("Erro ao atualizar quantidade ingerida de um alimento. O alimento é nulo.");
      return;
    }

    if (alterController.text.isNotEmpty && int.parse(alterController.text) != 0) {
      selectedFoodItem?.qtdIngerida = double.parse(alterController.text);
      Navigator.of(context).pop(selectedFoodItem?.qtdIngerida);
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        Expanded(
          child: ListView.builder(
            itemCount: widget.selectedFoods.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Dismissible(
                    key: Key(widget.selectedFoods[index].alimentoReferencia.id.toString()),
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
                      setState(() {
                        widget.selectedFoods.removeAt(index);
                      });
                    },
                    child: ListTile(
                      title: Text(
                        widget.selectedFoods[index].alimentoReferencia.nome,
                        style: const TextStyle(color: AppColors.fontBright),
                      ),
                      trailing: Text(
                        "${widget.selectedFoods[index].qtdIngerida.toStringAsFixed(0)}g",
                        style: const TextStyle(
                          color: AppColors.fontBright,
                          fontSize: 15,
                        ),
                      ),
                      onTap: () async {
                        infoLog(widget.selectedFoods[index].alimentoReferencia.nome);
                        selectedFoodItem = widget.selectedFoods[index];
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
                                  text: widget.selectedFoods[index].alimentoReferencia.nome.toLowerCase(),
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
                  if (index < widget.selectedFoods.length - 1) const Divider(color: AppColors.fontDimmed),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
