import 'package:carbonet/widgets/input/date_input_field.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({
    super.key,
    //required this.cards,
  });

  DateTime filterDateStart = DateTime.now().subtract(const Duration(days: 7));
  DateTime filterDateEnd = DateTime.now();

  final TextEditingController dateStartController = TextEditingController();
  final TextEditingController dateEndController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                DateInputField(
                  labelText: "Filtro: dia inicial", 
                  dateController: dateStartController, 
                  onDateSelected: (p0) {
                    filterDateStart = p0;
                  },
                ),
                const SizedBox(width: 16),
                DateInputField(
                  labelText: "Filtro: dia final", 
                  dateController: dateStartController, 
                  onDateSelected: (p0) {
                    filterDateEnd = p0;
                  },
                )
              ],
            ),
            const SizedBox(height: 16),
            LineChart(
              LineChartData(
                
              ),
              duration: const Duration(milliseconds: 150),
              curve: Curves.bounceInOut,
            ),
          ],
        ),
      ),
    );
  }
}
