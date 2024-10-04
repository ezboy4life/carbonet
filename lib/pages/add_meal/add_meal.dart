import 'package:carbonet/data/models/alimento_ingerido.dart';
import 'package:carbonet/data/models/meal.dart';
import 'package:carbonet/pages/add_meal/meal_info.dart';
import 'package:carbonet/pages/add_meal/select_foods_wrapper.dart';
import 'package:carbonet/utils/app_colors.dart';
import 'package:carbonet/widgets/cosmetic/dropdown_menu_entry.dart';
import 'package:carbonet/widgets/pager.dart';
import 'package:flutter/material.dart';

class AddMeal extends StatefulWidget {
  final Function(Meal) addMealToHistory;
  const AddMeal({
    super.key,
    required this.addMealToHistory,
  });

  @override
  State<AddMeal> createState() => _AddMealState();
}

class _AddMealState extends State<AddMeal> {
  final List<AlimentoIngerido> selectedFoods = [];
  final TextEditingController allFoodsController = TextEditingController();
  final TextEditingController favoriteFoodsController = TextEditingController();
  final TextEditingController selectedFoodsController = TextEditingController();
  final TextEditingController mealTypeController = TextEditingController();
  final TextEditingController bloodGlucoseController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController selectedMealTypeController = TextEditingController();
  DateTime selectedMealDate = DateTime.now();
  TimeOfDay selectedMealTime = TimeOfDay.now();

  final List<String> _hintTexts = [
    "Preencha os dados",
    "Selecione os alimentos",
  ];
  final PageController _pageViewController = PageController();
  double bloodGlucose = 0.0;
  double totalCarbohydrates = 0.0;

  final List<DropdownMenuEntry<String>> _mealTypes = [
    CustomDropdownMenuEntry(value: "Café da manhã", label: "Café da manhã"),
    CustomDropdownMenuEntry(value: "Almoço", label: "Almoço"),
    CustomDropdownMenuEntry(value: "Janta", label: "Janta"),
    CustomDropdownMenuEntry(value: "Lanche", label: "Lanche"),
  ];

  void _nextPage() {
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
      dateController.text = "$day/$month/${date.year}";
    });
  }

  void _handleTimeSelected(TimeOfDay time) {
    setState(() {
      selectedMealTime = time;
      String hour = time.hour.toString().padLeft(2, "0");
      String minutes = time.minute.toString().padLeft(2, "0");
      timeController.text = "$hour:$minutes";
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
    totalCarbohydrates = 0;
    for (var ingestedFood in selectedFoods) {
      totalCarbohydrates += ingestedFood.alimentoReferencia.carbosPorGrama * ingestedFood.qtdIngerida;
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
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "Cancelar",
              style: TextStyle(color: AppColors.defaultAppColor),
            ),
          ),
          const SizedBox(
            width: 10,
          )
        ],
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
                glicemiaController: bloodGlucoseController,
                dateController: dateController,
                timeController: timeController,
                selectedMealTypeController: selectedMealTypeController,
                tiposDeRefeicao: _mealTypes,
              ),
              SelectFoodsWrapper(
                searchBoxController: allFoodsController,
                favoritesSearchBoxController: favoriteFoodsController,
                selectedFoodsSearchBoxController: selectedFoodsController,
                selectedMealTypeController: selectedMealTypeController,
                glicemiaController: bloodGlucoseController,
                selectedFoods: selectedFoods,
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
