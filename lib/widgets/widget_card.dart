import 'package:flutter/material.dart';

class CardButton extends StatelessWidget {
  const CardButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.fork_left),
    );
  }
}
