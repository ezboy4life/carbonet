import 'package:carbonet/data/models/alimento_ingerido.dart';
import 'package:carbonet/data/models/alimento_ref.dart';
import 'package:carbonet/utils/app_colors.dart';
import 'package:carbonet/utils/logger.dart';
import 'package:carbonet/widgets/dialogs/input_dialog.dart';
import 'package:carbonet/widgets/dialogs/warning_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FavoriteFoodsList extends StatefulWidget {
  const FavoriteFoodsList({
    super.key,
    required this.tipoRefeicao,
    required this.listaAlimentosRef,
    required this.listaAlimentosSelecionados,
  });

  final String tipoRefeicao;
  final List<AlimentoRef> listaAlimentosRef;
  final List<AlimentoIngerido> listaAlimentosSelecionados;

  @override
  State<FavoriteFoodsList> createState() => _FavoriteFoodsListState();
}

class _FavoriteFoodsListState extends State<FavoriteFoodsList> {
  final List<AlimentoRef> favoritos = [];
  final TextEditingController favoritosController = TextEditingController();
  AlimentoRef? selectedFavorite;

  void _adicionarFavorito() {
    if (selectedFavorite == null) {
      errorLog("Erro ao adicionar favorito");
      return;
    }

    if (favoritosController.text.isEmpty || double.parse(favoritosController.text) == 0) {
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

    for (final alimento in widget.listaAlimentosSelecionados) {
      if (alimento.idAlimentoReferencia == selectedFavorite?.id) {
        alimento.qtdIngerida += double.parse(favoritosController.text);
        Navigator.pop(context);
        return;
      }
    }

    widget.listaAlimentosSelecionados.add(
      AlimentoIngerido(
        idAlimentoReferencia: selectedFavorite!.id,
        alimentoReferencia: selectedFavorite,
        qtdIngerida: double.parse(favoritosController.text),
      ),
    );
    favoritosController.text = "";
    Navigator.pop(context);
  }

  void _extrairFavoritos() {
    favoritos.clear(); //?

    for (AlimentoRef alimento in widget.listaAlimentosRef) {
      if (_isFavorito(alimento, widget.tipoRefeicao)) {
        favoritos.add(alimento);
      }
    }
  }

  bool _isFavorito(AlimentoRef alimento, String tipoRefeicao) {
    switch (tipoRefeicao) {
      case "Café da manhã":
        return alimento.favCafe;
      case "Almoço":
        return alimento.favAlmoco;
      case "Janta":
        return alimento.favJanta;
      case "Lanche":
        return alimento.favLanche;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    _extrairFavoritos();

    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text("Favoritos - ${widget.tipoRefeicao}", style: const TextStyle(color: AppColors.fontBright, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      ListView.builder(
          shrinkWrap: true,
          itemCount: favoritos.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                favoritos[index].nome,
                style: const TextStyle(color: AppColors.fontBright),
              ),
              trailing: IconButton(
                  onPressed: () {
                    infoLog('"${favoritos[index].nome}" selecionado!');
                    selectedFavorite = favoritos[index];
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return InputDialog(
                          controller: favoritosController,
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
                              text: favoritos[index].nome.toLowerCase(),
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
                          onPressed: _adicionarFavorito,
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.add, color: Colors.blueAccent)),
            );
          }),
    ]);
  }
}
