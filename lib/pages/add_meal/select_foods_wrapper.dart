import 'package:carbonet/data/database/food_reference_dao.dart';
import 'package:carbonet/data/models/ingested_food.dart';
import 'package:carbonet/data/models/food_reference.dart';
import 'package:carbonet/data/models/meal.dart';
import 'package:carbonet/pages/add_meal/all_foods_list.dart';
import 'package:carbonet/pages/add_meal/favorite_foods_list.dart';
import 'package:carbonet/pages/add_meal/selected_foods_list.dart';
import 'package:carbonet/utils/app_colors.dart';
import 'package:carbonet/utils/dao_procedure_coupler.dart';
import 'package:carbonet/utils/logged_user_access.dart';
import 'package:carbonet/widgets/buttons/button.dart';
import 'package:carbonet/widgets/dialogs/warning_dialog.dart';
import 'package:flutter/material.dart';

class SelectFoodsWrapper extends StatefulWidget {
  final Function setState;
  final TextEditingController searchBoxController;
  final TextEditingController favoritesSearchBoxController;
  final TextEditingController selectedFoodsSearchBoxController;
  final TextEditingController selectedMealTypeController;
  final TextEditingController glicemiaController;
  final List<IngestedFood> selectedFoods;
  final DateTime? mealDate;
  final TimeOfDay? mealTime;
  final Function(Meal) addMealToHistory;

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

            final DateTime dataRefeicao = DateTime(
              widget.mealDate!.year,
              widget.mealDate!.month,
              widget.mealDate!.day,
              widget.mealTime!.hour,
              widget.mealTime!.minute,
            );

            Meal refeicao = Meal(
              idUser: LoggedUserAccess().user!.id!,
              date: dataRefeicao,
              mealType: getMealName(widget.selectedMealTypeController.text)!,
              isActive: true,
            );

            DaoProcedureCoupler.inserirRefeicaoProcedimento(refeicao, widget.selectedFoods).then(
              (value) {
                refeicao.id = value;
                widget.addMealToHistory(refeicao);
                Navigator.pop(context, true);
              },
            );
          },
        ),
      ),
    );
  }
}
