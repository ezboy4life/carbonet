import 'package:carbonet/data/database/food_reference_dao.dart';
import 'package:carbonet/data/models/ingested_food.dart';
import 'package:carbonet/data/models/food_reference.dart';
import 'package:carbonet/data/models/meal.dart';
import 'package:carbonet/pages/add_meal/all_foods_list.dart';
import 'package:carbonet/pages/add_meal/favorite_foods_list.dart';
import 'package:carbonet/pages/add_meal/custom_types/food_union_type.dart';
import 'package:carbonet/pages/add_meal/selected_foods_list.dart';
import 'package:carbonet/utils/app_colors.dart';
import 'package:carbonet/utils/calculator.dart';
import 'package:carbonet/utils/dao_procedure_coupler.dart';
import 'package:carbonet/utils/logged_user_access.dart';
import 'package:carbonet/widgets/buttons/button.dart';
import 'package:carbonet/widgets/dialogs/blood_glucose_dialog.dart';
import 'package:carbonet/widgets/dialogs/warning_dialog.dart';
import 'package:flutter/material.dart';

class SelectFoodsWrapper extends StatefulWidget {
  final Function setState;
  final TextEditingController searchBoxController;
  final TextEditingController favoritesSearchBoxController;
  final TextEditingController selectedFoodsSearchBoxController;
  final TextEditingController selectedMealTypeController;
  final TextEditingController glicemiaController;
  final List<FoodUnionType> selectedFoods;
  final DateTime? mealDate;
  final TimeOfDay? mealTime;
  final Function(Meal) addMealToHistory;
  final Function(Function?) toggleLoadingState;

  const SelectFoodsWrapper({
    super.key,
    required this.searchBoxController,
    required this.favoritesSearchBoxController,
    required this.selectedFoodsSearchBoxController,
    required this.selectedMealTypeController,
    required this.glicemiaController,
    required this.selectedFoods,
    required this.addMealToHistory,
    required this.setState,
    required this.mealDate,
    required this.mealTime,
    required this.toggleLoadingState,
  });

  @override
  State<SelectFoodsWrapper> createState() => _SelectFoodsWrapperState();
}

class _SelectFoodsWrapperState extends State<SelectFoodsWrapper> {
  late List<FoodReference> foodList = [];
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    _initListAsync();
    // });
  }

  _initListAsync() async {
    List<FoodReference> list = await FoodReferenceDAO().getAllFoodReference();
    setState(() {
      foodList = list;
    });
  }

  String? getMealName(String mealType) {
    switch (mealType) {
      case "coffee":
        return "Café da manhã";
      case "lunch":
        return "Almoço";
      case "dinner":
        return "Jantar";
      case "snack":
        return "Lanche";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: foodList.isEmpty ? 0 : 3,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: TabBar(
          dividerColor: AppColors.fontBright,
          indicatorColor: AppColors.defaultAppColor,
          tabs: [
            if (foodList.isNotEmpty) ...[
              const Tab(
                icon: Icon(
                  Icons.restaurant_rounded,
                  color: AppColors.fontBright,
                ),
                child: Text(
                  "Todos Alimentos",
                  style: TextStyle(color: AppColors.fontBright),
                  textAlign: TextAlign.center,
                ),
              ),
              const Tab(
                icon: Icon(
                  Icons.star_rounded,
                  color: AppColors.fontBright,
                ),
                child: Text(
                  "Favoritos",
                  style: TextStyle(color: AppColors.fontBright),
                ),
              ),
              const Tab(
                icon: Icon(
                  Icons.check_rounded,
                  color: AppColors.fontBright,
                ),
                child: Text(
                  "Selecionados",
                  style: TextStyle(color: AppColors.fontBright),
                ),
              ),
            ]
          ],
        ),
        body: TabBarView(
          children: [
            if (foodList.isNotEmpty) ...[
              AllFoodsList(
                foodList: foodList,
                selectedFoodList: widget.selectedFoods,
                toggleLoadingState: widget.toggleLoadingState,
              ),
              FavoriteFoodsList(
                mealType: widget.selectedMealTypeController.value.text,
                foodList: foodList,
                selectedFoodsList: widget.selectedFoods,
              ),
              SelectedFoodsList(
                selectedFoods: widget.selectedFoods,
              ),
            ]
          ],
        ),
        bottomNavigationBar: Button(
          label: "Registrar Refeição",
          onPressed: () {
            if (widget.selectedFoods.isEmpty) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const WarningDialog(
                    title: "Refeição sem alimentos!",
                    message: "Insira pelo menos um alimento para que a refeição possa ser registrada.",
                  );
                },
              );
              return;
            }

            // Registro efetivo da refeição e da glicemia
            // TODO : Implementar o registro da glicemia

            final DateTime dataRefeicao = DateTime(
              widget.mealDate!.year,
              widget.mealDate!.month,
              widget.mealDate!.day,
              widget.mealTime!.hour,
              widget.mealTime!.minute,
            );

            double totalCarbohydrates = 0;
            double totalCalories = 0;

            totalCarbohydrates = Calculator.calulateCarbos(widget.selectedFoods);
            totalCalories = Calculator.calculateCalories(widget.selectedFoods);

            Meal refeicao = Meal(
              idUser: LoggedUserAccess().user!.id!,
              date: dataRefeicao,
              mealType: getMealName(widget.selectedMealTypeController.text)!,
              isActive: true,
              carbTotal: totalCarbohydrates.round(),
              calorieTotal: totalCalories.round(),
            );

            // Eu devo levantar a questão, mas porque raios eu estou armazenando a composição das refeições?
            // Bom, agora, com o FoodItem do FoodVisor, isso não tem mais garantia nenhuma de estar completo.
            final List<IngestedFoodWrapper> tempList = widget.selectedFoods.whereType<IngestedFoodWrapper>().toList();
            final List<IngestedFood> ingestedFoodsPure = tempList.map((ifw) => ifw.value).toList();
            print("lista impura: ${widget.selectedFoods}");
            print("lista pura: ${ingestedFoodsPure}");
            DaoProcedureCoupler.inserirRefeicaoProcedimento(refeicao, ingestedFoodsPure).then(
              (value) async {
                refeicao.id = value;
                widget.addMealToHistory(refeicao);

                double totalCarbs = totalCarbohydrates;
                int totalCalories = refeicao.calorieTotal;
                int minGlucose = LoggedUserAccess().user!.minBloodGlucose;
                int maxGlucose = LoggedUserAccess().user!.maxBloodGlucose;
                int currentBloodSugar = int.parse(widget.glicemiaController.text);
                int insulinRatio = LoggedUserAccess().user!.constanteInsulinica.toInt();
                //TODO aqui vai o cálculo da insulina
                await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      // return AlertDialog(
                      //   title: const Text("Cálculo de insulina"),
                      //   content: Column(
                      //     mainAxisSize: MainAxisSize.min,
                      //     children: [
                      //       Text("Total de carboidratos consumidos: ${totalCarbs.round()}g"),
                      //       Text("Total de calorias consumidas: ${totalCalories.round()} kcal"),
                      //       Text("Glicemia inicial: ${currentBloodSugar} mg/dL"),
                      //       const SizedBox(
                      //         height: 16,
                      //       ),
                      //       Text("Dose de insulina recomendada: ${Calculator.calculateInsulinDosage(totalCarbs, currentBloodSugar, minGlucose, maxGlucose, insulinRatio)} unidades"),
                      //     ],
                      //   ),
                      //   actions: [
                      //     TextButton.icon(
                      //       onPressed: () => Navigator.of(context).pop(),
                      //       label: const Text("Ok"),
                      //       icon: const Icon(Icons.check),
                      //     )
                      //   ],
                      //   actionsAlignment: MainAxisAlignment.center,
                      // );
                      return BloodGlucoseDialog(
                        totalCarbs: totalCarbs.round(),
                        totalKcal: totalCalories.round(),
                        initialBloodGlucose: currentBloodSugar,
                        recommendedInsulinDose: Calculator.calculateInsulinDosage(totalCarbs, currentBloodSugar, minGlucose, maxGlucose, insulinRatio),
                      );
                    });
                print("wah");
                // seria bom tbm exibir a lógica nesse cálculo
                // seria bom, também, salvar essa dose (e qual caso é) no cadastro de glicemia, e permitir caçar essa glicemia no histórico
                // vincular glicemia à refeição = bom tbm
                Navigator.pop(context, true);
              },
            );
          },
        ),
      ),
    );
  }
}
