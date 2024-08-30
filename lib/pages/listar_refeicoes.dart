import 'package:flutter/material.dart';

class ListarRefeicoes extends StatefulWidget {
  const ListarRefeicoes({super.key});

  @override
  State<ListarRefeicoes> createState() => _ListarRefeicoesState();
}

class _ListarRefeicoesState extends State<ListarRefeicoes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //TODO
          Text("Listar Refeicoes"),
          SizedBox(height: 12),
          
        ],
      ),
    );
  }
}