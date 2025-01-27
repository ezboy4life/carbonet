import 'package:carbonet/data/models/meal.dart';
import 'package:carbonet/pages/add_meal/custom_types/food_union_type.dart';
import 'package:carbonet/pages/add_meal/meal_info.dart';
import 'package:carbonet/pages/add_meal/select_foods_wrapper.dart';
import 'package:carbonet/utils/app_colors.dart';
import 'package:carbonet/utils/calculator.dart';
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
  final List<FoodUnionType> selectedFoods = [];
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

  /// Usado na somente na exibição
  double bloodGlucose = 0.0;

  /// Usado na somente na exibição
  double totalCarbohydrates = 0.0;
  double totalCalories = 0.0;

  // Usado p/ exibir feedback visual quando houver chamadas à API do Foodvisor
  bool isLoading = false;

  final List<DropdownMenuEntry<String>> _mealTypes = [
    CustomDropdownMenuEntry(value: "coffee", label: "Café da manhã"),
    CustomDropdownMenuEntry(value: "lunch", label: "Almoço"),
    CustomDropdownMenuEntry(value: "dinner", label: "Janta"),
    CustomDropdownMenuEntry(value: "snack", label: "Lanche"),
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

  void toggleLoadingState(Function? callback) {
    setState(() {
      isLoading = !isLoading;
    });
    callback?.call();
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
    totalCarbohydrates += Calculator.calulateCarbos(selectedFoods);
    totalCalories = 0;
    totalCalories += Calculator.calculateCalories(selectedFoods);
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
              style: TextStyle(
                color: AppColors.defaultBrightAppColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: Stack(
        children: [
          Center(
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
                    toggleLoadingState: toggleLoadingState,
                  )
                ],
              ),
            ),
          ),

          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
        ]
      ),
    );
  }
}
