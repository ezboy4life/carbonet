import 'package:carbonet/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomDropDownMenu extends StatelessWidget {
  final String? labelText;
  final List<DropdownMenuEntry<String>> dropdownMenuEntries;
  final Color textColor;
  final Color labelColor;
  final double widthFactor;

  const CustomDropDownMenu({
    super.key,
    this.labelText,
    required this.dropdownMenuEntries,
    this.labelColor = AppColors.fontBright,
    this.textColor = Colors.white,
    this.widthFactor = 0.9,
  });

  @override
  Widget build(BuildContext context) {
    // double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return DropdownMenu(
      width: screenWidth * widthFactor,
      dropdownMenuEntries: dropdownMenuEntries,
      initialSelection: dropdownMenuEntries[0],
      requestFocusOnTap: false,
      textStyle: TextStyle(
        color: textColor,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.fontDimmed,
            strokeAlign: 10,
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
