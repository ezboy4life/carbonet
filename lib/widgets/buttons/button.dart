import 'package:carbonet/utils/app_colors.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final void Function()? onPressed;

  const Button({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = AppColors.defaultAppColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: const StadiumBorder(),
        color: backgroundColor,
      ),
      child: TextButton(
        style: const ButtonStyle(
          splashFactory: NoSplash.splashFactory,
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            )
          ],
        ),
      ),
    );
  }
}
