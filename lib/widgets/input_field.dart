import 'package:flutter/material.dart';
import 'package:carbonet/assets/app_colors.dart';

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.obscureText,
  });

  final TextEditingController controller;
  final String labelText;
  final bool obscureText;

  //TODO: Fazer o padding ficar igual no Figma

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(
        color: AppColors.brightGrey,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          color: AppColors.brightGrey,
        ),
        contentPadding: const EdgeInsets.all(10),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(50.0),
          ),
          borderSide: BorderSide(
            color: AppColors.dimmedGray,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(50.0),
          ),
          borderSide: BorderSide(
            color: AppColors.brightGrey,
            width: 2,
          ),
        ),
      ),
    );
  }
}
