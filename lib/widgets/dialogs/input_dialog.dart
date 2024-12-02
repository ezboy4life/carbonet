import 'dart:ui';
import 'package:carbonet/utils/app_colors.dart';
import 'package:carbonet/widgets/buttons/button.dart';
import 'package:carbonet/widgets/input/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputDialog extends StatefulWidget {
  final TextEditingController controller;
  final String title;
  final String label;
  final String buttonLabel;
  final List<TextSpan>? message;
  final Function onPressed;
  final bool obscureText;
  final int? maxLength;

  final IconData? icon;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;

  /// Um dialog que tem um TextField, permitindo o usuário digitar um valor nele
  const InputDialog({
    super.key,
    required this.controller,
    required this.title,
    required this.label,
    required this.buttonLabel,
    required this.onPressed,
    this.message,
    this.icon,
    this.inputFormatters,
    this.keyboardType,
    this.obscureText = false,
    this.maxLength,
  });

  @override
  State<InputDialog> createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dialogTheme: const DialogTheme(
          elevation: 0,
        ),
      ),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.black,
              boxShadow: const [
                BoxShadow(
                  color: AppColors.fontDark,
                  spreadRadius: 2.5,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null) Icon(widget.icon, color: Colors.white, size: 100),
                  if (widget.icon != null) const SizedBox(height: 16),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  if (widget.message != null) const SizedBox(height: 16),
                  if (widget.message != null) Text.rich(TextSpan(children: widget.message)),
                  const SizedBox(height: 32),
                  InputField(
                    maxLength: widget.maxLength,
                    obscureText: widget.obscureText,
                    controller: widget.controller,
                    labelText: widget.label,
                    inputFormatters: widget.inputFormatters,
                    keyboardType: widget.keyboardType,
                    autofocus: true,
                  ),
                  const SizedBox(height: 32),
                  Button(
                    label: widget.buttonLabel,
                    onPressed: () {
                      widget.onPressed();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
