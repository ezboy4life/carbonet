import 'package:flutter/material.dart';

class CustomDropDownMenu extends StatelessWidget {
  final List<DropdownMenuEntry<String>> dropdownMenuEntries;
  final Color textColor;
  final Color labelColor;
  final double widthFactor;

  const CustomDropDownMenu({
    super.key,
    required this.dropdownMenuEntries,
    this.labelColor = Colors.white,
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
      menuStyle: const MenuStyle(
        backgroundColor: MaterialStatePropertyAll(
          Colors.black,
        ),
      ),
      label: Text(
        'Tipo de Refeição',
        style: TextStyle(color: labelColor),
      ),
    );
  }
}
