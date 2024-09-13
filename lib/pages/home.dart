import 'package:flutter/material.dart';

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
