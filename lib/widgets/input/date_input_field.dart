import 'package:carbonet/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:carbonet/utils/app_colors.dart';

class DateInputField extends StatelessWidget {
  final String labelText;
  final TextEditingController dateController;
  final Function(DateTime) onDateSelected;

  const DateInputField({
    super.key,
    required this.labelText,
    required this.dateController,
    required this.onDateSelected,
  });

  void _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      String day = selectedDate.day.toString().padLeft(2, "0");
      String month = selectedDate.month.toString().padLeft(2, "0");
      String year = selectedDate.year.toString();

      dateController.text = "$day/$month/$year";
      onDateSelected(selectedDate);
    } else {
      infoLog("Seleção de data cancelada.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      controller: dateController,
      style: const TextStyle(
        color: Colors.white,
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
      onTap: () {
        _selectDate(context);
      },
    );
  }
}
