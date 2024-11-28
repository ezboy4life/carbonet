import 'package:carbonet/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomDropdownMenuEntry<T> extends DropdownMenuEntry<T> {
  CustomDropdownMenuEntry({
    required super.value,
    required super.label,
    super.style = const ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(AppColors.fontBright),
    ),
    // this.style = customStyle,
  });
}
