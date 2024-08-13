import 'package:flutter/material.dart';
import "package:carbonet/utils/app_colors.dart";
import 'package:flutter/services.dart';

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    required this.controller,
    required this.labelText,
    this.obscureText = false,
    this.inputFormatters,
    this.maxLength,
  });

  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final List<FilteringTextInputFormatter>? inputFormatters;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      buildCounter:
          (_, {int? currentLength, int? maxLength, bool? isFocused}) => null,
      // esconde a contagem de caracteres quando se tem o maxlenght
      style: const TextStyle(
        color: AppColors.fontBright,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          color: AppColors.fontBright,
        ),
        contentPadding: const EdgeInsets.all(10),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          borderSide: BorderSide(
            color: AppColors.fontDimmed,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          borderSide: BorderSide(
            color: AppColors.fontBright,
            width: 2,
          ),
        ),
      ),
    );
  }
}
