import 'package:carbonet/utils/app_colors.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Border? border;
  final void Function() onPressed;
  final bool isLabelBold;

  const Button({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = AppColors.defaultAppColor,
    this.border,
    this.isLabelBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // border: Border.all(color: AppColors.defaultAppColor, width: 1.5),
        color: backgroundColor,
        border: border,
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        // color: Colors.black,
      ),
      child: TextButton(
        style: const ButtonStyle(
          splashFactory: NoSplash.splashFactory,
        ),
        onPressed: () {
          FocusScope.of(context).unfocus();
          onPressed();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontWeight: isLabelBold ? FontWeight.bold : FontWeight.normal,
                fontSize: 20,
              ),
            )
          ],
        ),
      ),
    );
  }
}
