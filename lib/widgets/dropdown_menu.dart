import 'package:carbonet/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomDropDownMenu extends StatelessWidget {
  final String? labelText;
  final List<DropdownMenuEntry<String>> dropdownMenuEntries;
  final DropdownMenuEntry<String>? selectedDropdownMenuEntry;
  final TextEditingController? controller;
  final Function(Object?) onSelected;
  final Color textColor;
  final Color labelColor;
  final double widthFactor;
  final Widget? leadingIcon;

  const CustomDropDownMenu({
    super.key,
    required this.dropdownMenuEntries,
    required this.onSelected,
    this.selectedDropdownMenuEntry,
    this.labelText,
    this.controller,
    this.labelColor = AppColors.fontBright,
    this.textColor = Colors.white,
    this.widthFactor = 0.9,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    // double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return DropdownMenu(
      controller: controller,
      onSelected: onSelected,
      width: screenWidth * widthFactor,
      leadingIcon: leadingIcon,
      dropdownMenuEntries: dropdownMenuEntries,
      initialSelection: selectedDropdownMenuEntry,
      requestFocusOnTap: false,
      textStyle: TextStyle(
        color: textColor,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.fontDimmed,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
      menuStyle: const MenuStyle(
        backgroundColor: MaterialStatePropertyAll(
          Colors.black,
        ),
      ),
      label: Text(
        labelText ?? "",
        style: TextStyle(color: labelColor),
      ),
    );
  }
}
