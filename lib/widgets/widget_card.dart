import 'package:flutter/material.dart';

class CardButton extends StatelessWidget {
  const CardButton({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    // this.trailing,
  });
  // Um Widget que é mostrado antes do
  final Widget? leading;
  final Text? title;
  final Text? subtitle;
  // final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3.0,
      
      borderRadius: BorderRadius.circular(8.0),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        visualDensity: const VisualDensity(horizontal: 0, vertical: 0),
        leading: Container(
          color: const Color(0xFF0B6FF4),
          height: 100,
          child: const Icon(
            Icons.dining,
            color: Colors.white,
            size: 56,
            
          ),
        ),
        title: const Text('Refeição'),
        subtitle: const Text('Cadastrar refeição'),
        trailing: Transform.flip(
          flipX: true,
          child: const Icon(
            Icons.arrow_back_ios_sharp,
            color: Color(0xFF0B6FF4),
          ),
        ),
        // tileColor: Colors.red,
      ),
    );
  }
}
