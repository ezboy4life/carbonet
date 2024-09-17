import 'package:carbonet/data/models/alimento_ingerido.dart';
import 'package:carbonet/pages/selecionar_alimentos.dart';
import 'package:carbonet/utils/app_colors.dart';
import 'package:carbonet/utils/logger.dart';
import 'package:carbonet/utils/validators.dart';
import 'package:carbonet/widgets/date_input_field.dart';
import 'package:carbonet/widgets/dropdown_menu.dart';
import 'package:carbonet/widgets/dropdown_menu_entry.dart';
import 'package:carbonet/widgets/gradient_button.dart';
import 'package:carbonet/widgets/popup_dialog.dart';
import 'package:carbonet/widgets/time_input_field.dart';
import 'package:carbonet/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdicionarRefeicao extends StatefulWidget {
  const AdicionarRefeicao({super.key});

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
  double _currentProgress = 0.0;
  int _currentPageIndex = 0;

  final List<DropdownMenuEntry<String>> _tiposDeRefeicao = [
    CustomDropdownMenuEntry(value: "Café da manhã", label: "Café da manhã"),
    CustomDropdownMenuEntry(value: "Almoço", label: "Almoço"),
    CustomDropdownMenuEntry(value: "Janta", label: "Janta"),
    CustomDropdownMenuEntry(value: "Lanche", label: "Lanche"),
  ];

  double _normalize(int min, int max, int value) {
    return (value - min) / (max - min);
  }

  void _handlePageChanged(int currentPageIndex) {
    _currentProgress = _normalize(0, 1, currentPageIndex);
    setState(() {
      _currentPageIndex = currentPageIndex;
    });
  }

  void _nextPage() {
    FocusScope.of(context).unfocus();
    _pageViewController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  void _previousPage() {
    _selectedMealTypeController.text = "";
    // _glicemiaController.text = "";

    _pageViewController.previousPage(
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
      totalCHO += alimentoIngerido.alimentoReferencia.carbos_por_grama * alimentoIngerido.qtdIngerida;
    }
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LinearProgressIndicator(
                value: _currentProgress,
                minHeight: 5,
                borderRadius: const BorderRadius.all(Radius.circular(100)),
                color: AppColors.defaultAppColor,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      infoLog("Botão de voltar");
                      _previousPage();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Etapa ${_currentPageIndex + 1} de 2",
                        style: const TextStyle(
                          color: AppColors.fontDimmed,
                        ),
                      ),
                      Text(
                        _hintTexts[_currentPageIndex],
                        style: const TextStyle(
                          color: AppColors.fontBright,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Expanded(
                child: PageView(
                  controller: _pageViewController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: _handlePageChanged,
                  children: [
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
                      alimentosSelecionados: alimentosSelecionados,
                      mealDate: selectedMealDate,
                      mealTime: selectedMealTime,
                      selectedMealTypeController: _selectedMealTypeController,
                      glicemiaController: _glicemiaController,
                      setState: setState,
                    )
                  ],
                ),
              ),
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
          dateController: dateController,
          onDateSelected: onDateSelected,
        ),
        const SizedBox(
          height: 30,
        ),
        TimeInputField(
          labelText: "Horário da refeição",
          timeController: timeController,
          onTimeSelected: onTimeSelected,
        ),
        const SizedBox(
          height: 30,
        ),
        CustomDropDownMenu(
          labelText: "Tipo da Refeição",
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

class CommaToDotFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(
      text: newValue.text.replaceAll(',', '.'),
      selection: newValue.selection,
    );
  }
}
