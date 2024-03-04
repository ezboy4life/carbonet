import 'package:flutter/material.dart';
import 'package:carbonet/utils/logger.dart';

class BottomIconButton extends StatelessWidget {
  const BottomIconButton({
    super.key,
    required this.icon,
  });

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: IconButton(
        padding: EdgeInsets.zero,
        focusColor: Colors.red,
        iconSize: 48.0,
        icon: Icon(
          icon,
          color: Colors.white,
        ),
        onPressed: () => {
          infoLog("IconButton test.")
        },
      )
    );
  }
}
