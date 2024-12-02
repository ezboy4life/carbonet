import 'dart:ui';
import 'package:carbonet/utils/app_colors.dart';
import 'package:carbonet/widgets/buttons/button.dart';
import 'package:flutter/material.dart';

class BloodGlucoseDialog extends StatelessWidget {
  final int totalCarbs;
  final int totalKcal;
  final int initialBloodGlucose;
  final int recommendedInsulinDose;

  const BloodGlucoseDialog({
    super.key,
    required this.totalCarbs,
    required this.totalKcal,
    required this.initialBloodGlucose,
    required this.recommendedInsulinDose,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dialogTheme: const DialogTheme(
          elevation: 0,
        ),
      ),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.black,
              boxShadow: const [
                BoxShadow(
                  color: AppColors.fontDark,
                  spreadRadius: 2.5,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Cálculo de Insulina",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    "Carboidratos consumidos:",
                                    style: TextStyle(
                                      color: AppColors.fontBright,
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[850],
                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                    child: Text(
                                      "${totalCarbs}g",
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(color: AppColors.fontDimmed),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    "Calorias consumidas:",
                                    style: TextStyle(
                                      color: AppColors.fontBright,
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[850],
                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                    child: Text(
                                      "$totalKcal kcal",
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(color: AppColors.fontDimmed),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    "Glicemia inicial:",
                                    style: TextStyle(
                                      color: AppColors.fontBright,
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[850],
                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                    child: Text(
                                      "$initialBloodGlucose mg/dL",
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(color: AppColors.fontDimmed),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    "Dose recomendada:",
                                    style: TextStyle(
                                      color: AppColors.fontBright,
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue[800],
                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                    child: Text(
                                      "$recommendedInsulinDose ${recommendedInsulinDose == 1 ? 'unidade' : 'unidades'}",
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Button(
                    label: "OK",
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
