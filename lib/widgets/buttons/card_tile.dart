import 'package:flutter/material.dart';

class CardTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? iconBackgroundColor;

  const CardTile({
    super.key,
    required this.title,
    required this.icon,
    this.iconBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // contentPadding: const EdgeInsets.all(0),
      leading: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: iconBackgroundColor ?? Colors.grey[700],
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey[700]),
    );
  }
}
