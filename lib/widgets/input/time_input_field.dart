import 'package:carbonet/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:carbonet/utils/app_colors.dart';

class TimeInputField extends StatelessWidget {
  final String labelText;
  final TextEditingController timeController;
  final Function(TimeOfDay) onTimeSelected;

  const TimeInputField({
    super.key,
    required this.labelText,
    required this.timeController,
    required this.onTimeSelected,
  });

  void _selectTime(BuildContext context) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (selectedTime != null) {
      String hour = selectedTime.hour.toString().padLeft(2, "0");
      String minutes = selectedTime.minute.toString().padLeft(2, "0");

      timeController.text = "$hour:$minutes";
      onTimeSelected(selectedTime);
    } else {
      infoLog("Seleção de data cancelada.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      controller: timeController,
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
        _selectTime(context);
      },
    );
  }
}
