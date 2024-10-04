import 'package:carbonet/data/models/ingested_food.dart';

class Calculator {
  static double calculateCalories(List<IngestedFood> alimentos) {
    throw UnimplementedError();
    // TODO: colocar o cálculo de calorias
  }

  static double calulateCarbos(List<IngestedFood> alimentos) {
    double total = 0;
    for (var alimento in alimentos) {
      total += (alimento.gramsIngested * alimento.foodReference.carbsPerPortion) / alimento.foodReference.gramsPerPortion;
    }
    return total;
  }

  static int calculateInsulinDosage(double carbs, int currentBloodSugar, int minIdeal, int maxIdeal, int insulinRatio) {
    int mgOfGlucoseOneInsulinUnitLowers = 50;
    int bloodSugarIncreaseByCarbs = (carbs * (mgOfGlucoseOneInsulinUnitLowers / insulinRatio))
        .round(); // 50 mg glicose são cobertos por uma dose de insulina, que cobre 15g (por exemplo); logo, p/ saber quantos mg de glicose vem de cada g de CHO, dividimos a subida da glicose pela razão insulina-cho.

    int expectedBloodSugar = currentBloodSugar + bloodSugarIncreaseByCarbs;

    if (expectedBloodSugar < minIdeal) {
      return 0; // açúcar no sangue ainda abaixo do ideal
    } else if (expectedBloodSugar > maxIdeal) {
      double correction = (expectedBloodSugar - maxIdeal) / insulinRatio;
      double correctionFraction = correction - correction.truncate();
      int finalCorrection = 0;
      if (correctionFraction > 0) {
        finalCorrection = correction.truncate() + 1;
      } else {
        finalCorrection = correction.truncate();
      }
      return finalCorrection;
      //TODO: isso implica num requerimento: o intervalo ideal precisa ter ao menos 50mg de glicose (qtd de glicose que 1unid insulina abaixa) entre os dois pontos.
    } else {
      // minIdeal <= expectedBloodSugar <= maxIdeal
      double correction = carbs / insulinRatio;
      double correctionFraction = correction - correction.round();
      int finalCorrection = correction.round();

      int expectedGlucoseDeviationInMg = (mgOfGlucoseOneInsulinUnitLowers * correctionFraction).round();

      int bloodSugarWithDeviation = currentBloodSugar + expectedGlucoseDeviationInMg;

      if (bloodSugarWithDeviation < minIdeal) {
        finalCorrection = finalCorrection - 1;
        return finalCorrection;
      } else if (bloodSugarWithDeviation > maxIdeal) {
        finalCorrection = finalCorrection + 1;
        return finalCorrection;
      } else {
        return finalCorrection;
      }
    }
  }
}
