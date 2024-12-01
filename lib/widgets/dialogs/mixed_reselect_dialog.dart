import 'dart:ui';
import 'package:carbonet/pages/add_meal/foodvisor_vision.dart';
import 'package:carbonet/utils/app_colors.dart';
import 'package:carbonet/widgets/buttons/button.dart';
import 'package:carbonet/widgets/input/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MixedReselectDialog extends StatefulWidget {
  final TextEditingController controller;
  final String title;
  final String label;
  final String buttonLabel;
  final List<TextSpan>? message;
  final Function onPressed;

  // Dropdown
  final ValueChanged<dynamic>? dropdownOnChanged;
  final List<DropdownMenuItem> dropdownItems;
  final dynamic dropdownInitialValue;

  final Function updateQuantityFunc;

  final IconData? icon;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;

  /// Um dialog que tem um TextField, permitindo o usuário digitar um valor nele
  const MixedReselectDialog({
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
    
    this.dropdownOnChanged, 
    required this.dropdownItems, 
    this.dropdownInitialValue,

    required this.updateQuantityFunc,
  });

  @override
  State<MixedReselectDialog> createState() => _MixedReselectDialogState();
}

class _MixedReselectDialogState extends State<MixedReselectDialog> {

  void updateQuantityOnFoodItem(String? str) {
    widget.updateQuantityFunc((str == null || str.isEmpty) ? 0.0 : double.parse(str));
  }

  @override
  void initState() {
    widget.controller.text = (widget.dropdownItems[0].value as FoodItem).quantity.toString();
    super.initState();
  }

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
            width: MediaQuery.sizeOf(context).width * 0.8,
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
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
                  if (widget.message != null) Text.rich(TextSpan(children: widget.message), textAlign: TextAlign.center,),
                  const SizedBox(height: 32),
                  DropdownButton(
                    isExpanded: true,
                    items: widget.dropdownItems, 
                    value: widget.dropdownInitialValue,
                    onChanged: widget.dropdownOnChanged
                  ),
                  const SizedBox(height: 12),
                  InputField(
                    maxLength: 4,
                    controller: widget.controller,
                    labelText: widget.label,
                    inputFormatters: widget.inputFormatters,
                    keyboardType: widget.keyboardType,
                    autofocus: true,
                    onChanged: updateQuantityOnFoodItem,
                  ),
                  const SizedBox(height: 12),
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
