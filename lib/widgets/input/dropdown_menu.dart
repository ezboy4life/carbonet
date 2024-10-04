import 'package:carbonet/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomDropDownMenu extends StatelessWidget {
  final String? labelText;
  final IconData? iconData;
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
    this.iconData,
    this.controller,
    this.labelColor = AppColors.fontBright,
    this.textColor = Colors.white,
    this.widthFactor = 0.9,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return DropdownMenu(
      controller: controller,
      onSelected: onSelected,
      width: screenWidth * widthFactor,
      leadingIcon: leadingIcon,
      dropdownMenuEntries: dropdownMenuEntries,
      initialSelection: selectedDropdownMenuEntry,
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
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconData != null) Icon(iconData, color: AppColors.fontBright),
          if (iconData != null) const SizedBox(width: 10),
          Text(
            labelText ?? "",
            style: TextStyle(color: labelColor),
          ),
        ],
      ),
    );
  }
}
