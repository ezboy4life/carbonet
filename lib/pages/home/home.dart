import 'package:carbonet/data/models/meal.dart';
import 'package:carbonet/pages/home/weekly_calorie_chart.dart';
import 'package:carbonet/utils/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final List<Meal> mealList;

  const HomePage({
    super.key,
    required this.mealList,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool hasFinishedDelay = false;
  @override
  void initState() {
    super.initState();
    /* Gambiarra pra atualizar os gráficos :3 */
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        hasFinishedDelay = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            if (widget.mealList.isEmpty) ...[
              if (hasFinishedDelay) ...[
                const Expanded(
                  child: Center(
                    child: Text(
                      "Nenhum dado encontrado para gerar os gráficos.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ] else ...[
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.defaultAppColor,
                    ),
                  ),
                ),
              ]
            ] else ...[
              WeeklyCalorieChart(mealList: widget.mealList)
            ],
          ],
        ),
      ),
    );
  }
}
