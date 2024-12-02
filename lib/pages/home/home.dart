import 'package:carbonet/data/models/meal.dart';
import 'package:carbonet/pages/home/weekly_calorie_chart.dart';
import 'package:carbonet/utils/app_colors.dart';
import 'package:carbonet/widgets/buttons/card_tile.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final List<Meal> mealList;
  final Function(int) onItemTapped;

  const HomePage({
    super.key,
    required this.mealList,
    required this.onItemTapped,
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
        padding: const EdgeInsets.all(32.0),
        child: ListView(
          children: [
            const Text(
              "Dashboard",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  CardTile(
                    title: "Registrar Refeição",
                    icon: Icons.dinner_dining_rounded,
                    iconBackgroundColor: AppColors.defaultAppColor,
                    onTap: () {
                      setState(() {
                        widget.onItemTapped(2);
                      });
                    },
                  ),
                  Divider(thickness: .5, color: Colors.grey[700], indent: 65),
                  CardTile(
                    title: "Favoritos",
                    icon: Icons.star_rounded,
                    iconBackgroundColor: AppColors.defaultAppColor,
                    onTap: () {
                      setState(() {
                        widget.onItemTapped(1);
                      });
                    },
                  ),
                  Divider(thickness: .5, color: Colors.grey[700], indent: 65),
                  CardTile(
                    title: "Histórico",
                    icon: Icons.history,
                    iconBackgroundColor: AppColors.defaultAppColor,
                    onTap: () {
                      setState(() {
                        widget.onItemTapped(3);
                      });
                    },
                  ),
                  Divider(thickness: .5, color: Colors.grey[700], indent: 65),
                  CardTile(
                    title: "Seu Perfil",
                    icon: Icons.person_rounded,
                    iconBackgroundColor: AppColors.defaultAppColor,
                    onTap: () {
                      setState(() {
                        widget.onItemTapped(4);
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
