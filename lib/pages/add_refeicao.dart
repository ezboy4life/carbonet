import 'package:carbonet/data/models/alimento_ingerido.dart';
import 'package:carbonet/data/models/refeicao.dart';
import 'package:carbonet/pages/selecionar_alimentos.dart';
import 'package:carbonet/utils/validators.dart';
import 'package:carbonet/widgets/input/date_input_field.dart';
import 'package:carbonet/widgets/input/dropdown_menu.dart';
import 'package:carbonet/widgets/cosmetic/dropdown_menu_entry.dart';
import 'package:carbonet/widgets/buttons/gradient_button.dart';
import 'package:carbonet/widgets/pager.dart';
import 'package:carbonet/widgets/dialogs/popup_dialog.dart';
import 'package:carbonet/widgets/input/time_input_field.dart';
import 'package:carbonet/widgets/input/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdicionarRefeicao extends StatefulWidget {
  final Function(Refeicao) addMealToHistory;
  const AdicionarRefeicao({
    super.key,
    required this.addMealToHistory,
  });

  @override
  State<AdicionarRefeicao> createState() => _AdicionarRefeicaoState();
}

class _AdicionarRefeicaoState extends State<AdicionarRefeicao> {
  final List<AlimentoIngerido> alimentosSelecionados = [];
  final TextEditingController selecionarAlimentosController = TextEditingController();
  final TextEditingController favoritosAlimentosController = TextEditingController();
  final TextEditingController selecionadosAlimentosController = TextEditingController();
  final TextEditingController tipoRefeicaoController = TextEditingController();
  final TextEditingController _glicemiaController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _selectedMealTypeController = TextEditingController();
  DateTime selectedMealDate = DateTime.now();
  TimeOfDay selectedMealTime = TimeOfDay.now();

  final List<String> _hintTexts = [
    "Preencha os dados",
    "Selecione os alimentos",
  ];
  final PageController _pageViewController = PageController();
  double glicemia = 0.0;
  double totalCHO = 0.0;

  final List<DropdownMenuEntry<String>> _tiposDeRefeicao = [
    CustomDropdownMenuEntry(value: "Café da manhã", label: "Café da manhã"),
    CustomDropdownMenuEntry(value: "Almoço", label: "Almoço"),
    CustomDropdownMenuEntry(value: "Janta", label: "Janta"),
    CustomDropdownMenuEntry(value: "Lanche", label: "Lanche"),
  ];

  void _nextPage() {
    FocusScope.of(context).unfocus();
    _pageViewController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  void _handleDateSelected(DateTime date) {
    setState(() {
      selectedMealDate = date;
      String day = date.day.toString().padLeft(2, "0");
      String month = date.month.toString().padLeft(2, "0");
      _dateController.text = "$day/$month/${date.year}";
    });
  }

  void _handleTimeSelected(TimeOfDay time) {
    setState(() {
      selectedMealTime = time;
      String hour = time.hour.toString().padLeft(2, "0");
      String minutes = time.minute.toString().padLeft(2, "0");
      _timeController.text = "$hour:$minutes";
    });
  }

  DateTime? _getSelectedDate() {
    return selectedMealDate;
  }

  TimeOfDay? _getSelectedTime() {
    return selectedMealTime;
  }

  @override
  void initState() {
    super.initState();
    _handleDateSelected(DateTime.now());
    _handleTimeSelected(TimeOfDay.now());
  }

  @override
  void setState(VoidCallback fn) {
    totalCHO = 0;
    for (var alimentoIngerido in alimentosSelecionados) {
      totalCHO += alimentoIngerido.alimentoReferencia.carbosPorGrama * alimentoIngerido.qtdIngerida;
    }
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close_rounded,
            size: 35,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Pager(
            pageViewController: _pageViewController,
            hintTexts: _hintTexts,
            heightFactor: 0.75,
            pages: [
              MealInfo(
                nextPage: _nextPage,
                onDateSelected: _handleDateSelected,
                onTimeSelected: _handleTimeSelected,
                getSelectedDate: _getSelectedDate,
                getSelectedTime: _getSelectedTime,
                glicemiaController: _glicemiaController,
                dateController: _dateController,
                timeController: _timeController,
                selectedMealTypeController: _selectedMealTypeController,
                tiposDeRefeicao: _tiposDeRefeicao,
              ),
              SelectFoods(
                searchBoxController: selecionarAlimentosController,
                favoritesSearchBoxController: favoritosAlimentosController,
                selectedFoodsSearchBoxController: selecionadosAlimentosController,
                selectedMealTypeController: _selectedMealTypeController,
                glicemiaController: _glicemiaController,
                alimentosSelecionados: alimentosSelecionados,
                addMealToHistory: widget.addMealToHistory,
                setState: setState,
                mealDate: selectedMealDate,
                mealTime: selectedMealTime,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MealInfo extends StatelessWidget {
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

  void _handleSelectedMealType(Object? object) {
    if (object == null) {
      return;
    }
    selectedMealTypeController.text = object.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        DateInputField(
          labelText: "Data da refeição",
          iconData: Icons.calendar_month_rounded,
          dateController: dateController,
          onDateSelected: onDateSelected,
        ),
        const SizedBox(
          height: 30,
        ),
        TimeInputField(
          labelText: "Horário da refeição",
          iconData: Icons.watch_later_rounded,
          timeController: timeController,
          onTimeSelected: onTimeSelected,
        ),
        const SizedBox(
          height: 30,
        ),
        CustomDropDownMenu(
          labelText: "Tipo da Refeição",
          iconData: Icons.restaurant_menu_rounded,
          dropdownMenuEntries: tiposDeRefeicao,
          selectedDropdownMenuEntry: CustomDropdownMenuEntry(
            value: selectedMealTypeController.text,
            label: selectedMealTypeController.text,
          ),
          onSelected: _handleSelectedMealType,
        ),
        const SizedBox(
          height: 30,
        ),
        InputField(
          controller: glicemiaController,
          labelText: "Glicemia",
          iconData: Icons.local_hospital_rounded,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          keyboardType: const TextInputType.numberWithOptions(decimal: false),
          maxLength: 20,
        ),
        const Spacer(),
        GradientButton(
          label: "Avançar",
          onPressed: () {
            // Validação da data
            DateTime? date = getSelectedDate();

            if (date == null) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const PopupDialog(
                    title: "Data inválida!",
                    message: "Por gentileza, defina uma data válida.",
                  );
                },
              );
              return;
            }

            // Validação do horário
            TimeOfDay? time = getSelectedTime();
            if (!Validators.isTimeValid(time)) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const PopupDialog(
                    title: "Horário inválido!",
                    message: "Por gentileza, defina um horário válido.",
                  );
                },
              );
              return;
            }

            // Validação da Glicemia
            if (glicemiaController.text.isEmpty || int.parse(glicemiaController.text) == 0) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const PopupDialog(
                    title: "Glicemia inválida!",
                    message: "Por gentileza, defina um valor válido.",
                  );
                },
              );
              return;
            }

            // Validação do tipo da refeição
            if (selectedMealTypeController.text.isEmpty) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const PopupDialog(
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

            nextPage();
          },
        )
      ],
    );
  }
}
