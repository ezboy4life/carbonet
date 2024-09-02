import 'package:carbonet/pages/add_refeicao.dart';
import 'package:carbonet/pages/listar_refeicoes.dart';
import 'package:flutter/material.dart';
import 'package:carbonet/widgets/card.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    //required this.cards,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: const Center(
        child: Text(
          "Página Home. Sim não tem nada ainda.",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
