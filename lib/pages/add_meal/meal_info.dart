import 'package:carbonet/utils/logger.dart';
import 'package:carbonet/utils/validators.dart';
import 'package:carbonet/widgets/buttons/button.dart';
import 'package:carbonet/widgets/cosmetic/dropdown_menu_entry.dart';
import 'package:carbonet/widgets/dialogs/warning_dialog.dart';
import 'package:carbonet/widgets/input/date_input_field.dart';
import 'package:carbonet/widgets/input/dropdown_menu.dart';
import 'package:carbonet/widgets/input/input_field.dart';
import 'package:carbonet/widgets/input/time_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MealInfo extends StatefulWidget {
  final VoidCallback nextPage;
  final Function(DateTime) onDateSelected;
  final Function(TimeOfDay) onTimeSelected;
  final Function getSelectedDate;
  final Function getSelectedTime;
  final TextEditingController glicemiaController;
  final TextEditingController dateController;
  final TextEditingController timeController;
  final TextEditingController selectedMealTypeController;
  final List<DropdownMenuEntry<String>> tiposDeRefeicao;

  const MealInfo({
    super.key,
    required this.nextPage,
    required this.onDateSelected,
    required this.onTimeSelected,
    required this.getSelectedDate,
    required this.getSelectedTime,
    required this.glicemiaController,
    required this.dateController,
    required this.timeController,
    required this.selectedMealTypeController,
    required this.tiposDeRefeicao,
  });

  @override
  State<MealInfo> createState() => _MealInfoState();
}

class _MealInfoState extends State<MealInfo> {
  bool isFirstTime = true;

  DropdownMenuEntry<String>? initialDropdown;

  void _handleSelectedMealType(Object? object) {
    if (object == null) {
      return;
    }
    widget.selectedMealTypeController.text = object.toString();
  }

  void _firstTimeResponsiveSelection() {
    if (isFirstTime) {
      int hora = DateTime.now().hour;
      print("Hora: $hora 🍌");
      if (hora >= 4 && hora < 11) {
        initialDropdown = widget.tiposDeRefeicao[0];
      } else if (hora >= 11 && hora < 17) {
        initialDropdown = widget.tiposDeRefeicao[1];
      } else if (hora >= 17) {
        initialDropdown = widget.tiposDeRefeicao[2];
      } else {
        initialDropdown = widget.tiposDeRefeicao[3];
      }
      isFirstTime = false;
    } else {
      initialDropdown = CustomDropdownMenuEntry(
        value: widget.selectedMealTypeController.text,
        label: widget.selectedMealTypeController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _firstTimeResponsiveSelection();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        DateInputField(
          labelText: "Data da refeição",
          iconData: Icons.calendar_month_rounded,
          dateController: widget.dateController,
          onDateSelected: widget.onDateSelected,
        ),
        const SizedBox(
          height: 30,
        ),
        GestureDetector(
          onTap: () => infoLog("message"),
          child: TimeInputField(
            labelText: "Horário da refeição",
            iconData: Icons.watch_later_rounded,
            timeController: widget.timeController,
            onTimeSelected: widget.onTimeSelected,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        CustomDropDownMenu(
          labelText: "Tipo da Refeição",
          iconData: Icons.restaurant_menu_rounded,
          dropdownMenuEntries: widget.tiposDeRefeicao,
          selectedDropdownMenuEntry: initialDropdown,
          onSelected: _handleSelectedMealType,
        ),
        const SizedBox(
          height: 30,
        ),
        InputField(
          controller: widget.glicemiaController,
          labelText: "Glicemia",
          iconData: Icons.local_hospital_rounded,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          keyboardType: const TextInputType.numberWithOptions(decimal: false),
          maxLength: 20,
        ),
        const Spacer(),
        Button(
          label: "Avançar",
          onPressed: () {
            // Validação da data
            DateTime? date = widget.getSelectedDate();

            if (date == null) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const WarningDialog(
                    title: "Data inválida!",
                    message: "Por gentileza, defina uma data válida.",
                  );
                },
              );
              return;
            }

            // Validação do horário
            TimeOfDay? time = widget.getSelectedTime();
            if (!Validators.isTimeValid(time)) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const WarningDialog(
                    title: "Horário inválido!",
                    message: "Por gentileza, defina um horário válido.",
                  );
                },
              );
              return;
            }

            // Validação da Glicemia
            if (widget.glicemiaController.text.isEmpty || int.parse(widget.glicemiaController.text) == 0) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const WarningDialog(
                    title: "Glicemia inválida!",
                    message: "Por gentileza, defina um valor válido.",
                  );
                },
              );
              return;
            }

            // Validação do tipo da refeição
            if (widget.selectedMealTypeController.text.isEmpty) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const WarningDialog(
                    title: "Tipo de refeição inválido!",
                    message: "Por gentileza, selecione valor válido.",
                  );
                },
              );
              return;
            }

            date = DateTime(
              date.year,
              date.month,
              date.day,
              time!.hour,
              time.minute,
            );

            widget.nextPage();
          },
        )
      ],
    );
  }
}
