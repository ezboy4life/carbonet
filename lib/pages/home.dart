import 'package:carbonet/pages/add_refeicao.dart';
import 'package:carbonet/pages/listar_refeicoes.dart';
import 'package:flutter/material.dart';
import 'package:carbonet/widgets/card.dart';

class HomePage extends StatelessWidget {
  HomePage({
    super.key,
    //required this.cards,
  });

  List<CardButton> cards = [];

  @override
  Widget build(BuildContext context) {

    cards = [
      // btn de add refeição
      CardButton(
        icon: Icons.dining,
        title: 'Refeição',
        subtitle: 'Cadastrar Refeição',
        onTap: () {
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) {
                return AdicionarRefeicao();
              },
            )
          ).then( // aqui ele recebe um retorno do adicionar refeição, e exibe uma snackbar informando o user que deu bom.
            (value) {  
              if (!context.mounted) return;

              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Text("Refeição adicionada com sucesso!"),
                    behavior: SnackBarBehavior.floating,
                    showCloseIcon: true,
                  )
                );
            },
          );
        },
      ),
      // btn que leva pra tela de que exibe as refeições daora cadastradas :D
      CardButton(
        icon: Icons.library_books_outlined,
        title: 'Histórico',
        subtitle: 'Listar Refeições Cadastradas',
        onTap: () {
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) {
                return ListarRefeicoes();
              },),  
          );
        },
      ),
    ];

    return Center(
      child: ListView.separated(
        padding: const EdgeInsets.all(10.0),
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: cards.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) => cards[index],
      ),
    );
  }
}
