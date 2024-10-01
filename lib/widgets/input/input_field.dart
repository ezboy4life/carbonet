import 'package:flutter/material.dart';
import "package:carbonet/utils/app_colors.dart";
import 'package:flutter/services.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData? iconData;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final TextInputType? keyboardType;
  final bool autofocus;
  final Function(String)? onChanged;
  final IconData? trailingIcon;
  final Function(BuildContext)? onTrailingIconPressed;

  const InputField({
    super.key,
    required this.controller,
    required this.labelText,
    this.iconData,
    this.obscureText = false,
    this.inputFormatters,
    this.maxLength,
    this.keyboardType,
    this.autofocus = false,
    this.onChanged,
    this.trailingIcon,
    this.onTrailingIconPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      keyboardType: keyboardType,
      autofocus: autofocus,
      onChanged: onChanged,
      buildCounter: (_, {int? currentLength, int? maxLength, bool? isFocused}) => null,
      // esconde a contagem de caracteres quando se tem o maxlenght
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (iconData != null) Icon(iconData, color: AppColors.fontBright),
            if (iconData != null) const SizedBox(width: 10),
            Text(labelText),
          ],
        ),
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
            width: 1,
          ),
        ),
        suffixIcon: trailingIcon != null
            ? IconButton(
                onPressed: onTrailingIconPressed != null ? (() => onTrailingIconPressed!(context)) : null,
                icon: Icon(trailingIcon, color: AppColors.fontBright),
              )
            : null,
      ),
    );
  }
}
