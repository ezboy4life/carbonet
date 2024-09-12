import 'package:carbonet/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomDropdownMenuEntry<T> extends DropdownMenuEntry<T> {
  @override
  final ButtonStyle? style;

  CustomDropdownMenuEntry({
    required super.value,
    required super.label,
    this.style = const ButtonStyle(
      foregroundColor: MaterialStatePropertyAll(AppColors.fontBright),
    ),
  });
}
