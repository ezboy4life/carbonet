import 'package:carbonet/data/models/meal.dart';
import 'package:carbonet/utils/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WeeklyCalorieChart extends StatefulWidget {
  final List<Meal> mealList;

  const WeeklyCalorieChart({
    super.key,
    required this.mealList,
  });

  @override
  State<WeeklyCalorieChart> createState() => _WeeklyCalorieChartState();
}

class _WeeklyCalorieChartState extends State<WeeklyCalorieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Consumo Calórico Semanal",
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                  ),
                ),
                Text(
                  "Média de calorias por refeição",
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  maxLines: 2,
                  style: TextStyle(
                    color: AppColors.fontBright,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AspectRatio(
              aspectRatio: 3 / 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
                child: BarChart(
                  getBarChartData(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartData getBarChartData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (_) => Colors.blueGrey,
          // tooltipHorizontalAlignment: FLHorizontalAlignment.right,
          // tooltipMargin: 0,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            String weekDay;
            switch (group.x) {
              case 0:
                weekDay = 'Segunda';
                break;
              case 1:
                weekDay = 'Terça';
                break;
              case 2:
                weekDay = 'Quarta';
                break;
              case 3:
                weekDay = 'Quinta';
                break;
              case 4:
                weekDay = 'Sexta';
                break;
              case 5:
                weekDay = 'Sábado';
                break;
              case 6:
                weekDay = 'Domingo';
                break;
              default:
                throw Error();
            }
            return BarTooltipItem(
              '$weekDay\n',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: (rod.toY - 1).toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions || barTouchResponse == null || barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }

            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      gridData: const FlGridData(show: false),
      barGroups: showingGroups(),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('S', style: style);
        break;
      case 1:
        text = const Text('T', style: style);
        break;
      case 2:
        text = const Text('Q', style: style);
        break;
      case 3:
        text = const Text('Q', style: style);
        break;
      case 4:
        text = const Text('S', style: style);
        break;
      case 5:
        text = const Text('S', style: style);
        break;
      case 6:
        text = const Text('D', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color? barColor,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    barColor = Colors.white;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: isTouched ? AppColors.defaultAppColor : barColor,
          width: width,
          borderSide: isTouched ? const BorderSide(color: AppColors.defaultBrightAppColor) : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: getWeeklyTotals(widget.mealList).isEmpty ? 5 : getWeeklyTotals(widget.mealList).values.reduce((a, b) => a > b ? a : b) + 5,
            color: Colors.grey[800],
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
        Map<int, double> meals = getWeeklyTotals(widget.mealList);

        switch (i + 1) {
          case 1:
            return makeGroupData(0, meals[i + 1] == null ? 0 : meals[i + 1]!, isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(1, meals[i + 1] == null ? 0 : meals[i + 1]!, isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(2, meals[i + 1] == null ? 0 : meals[i + 1]!, isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(3, meals[i + 1] == null ? 0 : meals[i + 1]!, isTouched: i == touchedIndex);
          case 5:
            return makeGroupData(4, meals[i + 1] == null ? 0 : meals[i + 1]!, isTouched: i == touchedIndex);
          case 6:
            return makeGroupData(5, meals[i + 1] == null ? 0 : meals[i + 1]!, isTouched: i == touchedIndex);
          case 7:
            return makeGroupData(6, meals[i + 1] == null ? 0 : meals[i + 1]!, isTouched: i == touchedIndex);
          default:
            return throw Error();
        }
      });

  Map<int, double> getWeeklyTotals(List<Meal> meals) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    final thisWeekObjects = meals.where((obj) {
      return obj.date.isAfter(startOfWeek.subtract(const Duration(days: 1))) && obj.date.isBefore(endOfWeek.add(const Duration(days: 1)));
    }).toList();

    final Map<int, double> totals = {};
    for (var obj in thisWeekObjects) {
      final day = obj.date.weekday;
      totals[day] = (totals[day] ?? 0) + obj.calorieTotal.toDouble();
    }

    return totals;
  }
}
