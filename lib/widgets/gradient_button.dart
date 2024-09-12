import 'package:carbonet/utils/app_colors.dart';
import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final String label;
  final List<Color> buttonColors;
  final void Function()? onPressed;

  const GradientButton({
    super.key,
    required this.label,
    this.buttonColors = const [
      AppColors.defaultDarkAppColor,
      AppColors.defaultAppColor,
    ],
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: ShapeDecoration(
        shape: const StadiumBorder(),
        gradient: LinearGradient(
          colors: buttonColors,
        ),
      ),
      child: TextButton(
        style: const ButtonStyle(
          splashFactory: NoSplash.splashFactory,
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
