import 'package:carbonet/data/models/ingested_food.dart';
import 'package:carbonet/pages/add_meal/custom_types/food_union_type.dart';

class Calculator {
  /// Quantidade, em mg/dL, de glicose abaixada por uma unidade de insulina.
  static const mgOfGlucoseOneInsulinUnitLowers = 50;

  static double calculateCalories(List<FoodUnionType> alimentos) {
    double totalCalories = 0;
    for (var ingestedFood in alimentos) {
      if (ingestedFood is IngestedFoodWrapper) {
        totalCalories += 
          ingestedFood.value.foodReference.caloriesPerPortion * 
          (ingestedFood.value.gramsIngested / ingestedFood.value.foodReference.gramsPerPortion);
      } else if (ingestedFood is FoodvisorFoodlistWrapper) {
        totalCalories +=
          ingestedFood.value.selected.calories100g * ingestedFood.value.selected.quantity / 100;
      }
    }
    return totalCalories;
  }

  static double calulateCarbos(List<FoodUnionType> alimentos) {
    double totalCarbohydrates = 0;
    for (var ingestedFood in alimentos) {
      if (ingestedFood is IngestedFoodWrapper) {
        totalCarbohydrates += 
          ingestedFood.value.foodReference.carbsPerPortion * 
          (ingestedFood.value.gramsIngested / ingestedFood.value.foodReference.gramsPerPortion);
      } else if (ingestedFood is FoodvisorFoodlistWrapper) {
        totalCarbohydrates +=
          ingestedFood.value.selected.carbs100g * ingestedFood.value.selected.quantity / 100;
      }
    }
  
    return totalCarbohydrates;
  }

  static int calculateInsulinDosage(double carbs, int currentBloodSugar, int minIdeal, int maxIdeal, int insulinRatio) {
    //int mgOfGlucoseOneInsulinUnitLowers = 50;
    int bloodSugarIncreaseByCarbs = (carbs * (mgOfGlucoseOneInsulinUnitLowers / insulinRatio))
        .round(); // 50 mg glicose são cobertos por uma dose de insulina, que cobre 15g (por exemplo); logo, p/ saber quantos mg de glicose vem de cada g de CHO, dividimos a subida da glicose pela razão insulina-cho.
    print("bloodSugarIncreaseByCarbs: $bloodSugarIncreaseByCarbs");
    int expectedBloodSugar = currentBloodSugar + bloodSugarIncreaseByCarbs;
    print("expectedBloodSugar: $expectedBloodSugar");

    if (expectedBloodSugar < minIdeal) {
      print("expectedBloodSugar < minIdeal");
      return 0; // açúcar no sangue ainda abaixo do ideal
    } else if (expectedBloodSugar > maxIdeal) {
      print("expectedBloodSugar > maxIdeal");
      double correction = (expectedBloodSugar - maxIdeal) / mgOfGlucoseOneInsulinUnitLowers;
      print("correction = (expectedBloodSugar - maxIdeal) / mgOfGlucoseOneInsulinUnitLowers:\n $correction = ($expectedBloodSugar - $maxIdeal) / $mgOfGlucoseOneInsulinUnitLowers");
      print("correction: $correction");
      double correctionFraction = correction - correction.truncate();
      print("correctionFraction: $correctionFraction");
      int finalCorrection = 0;
      if (correctionFraction > 0) {
        finalCorrection = correction.truncate() + 1;
      } else {
        finalCorrection = correction.truncate();
      }

      print("finalCorrection: $finalCorrection");
      return finalCorrection;
      //TODO: isso implica num requerimento: o intervalo ideal precisa ter ao menos 50mg de glicose (qtd de glicose que 1unid insulina abaixa) entre os dois pontos.
    } else {
      print("minIdeal <= expectedBloodSugar <= maxIdeal");
      double correction = (expectedBloodSugar - minIdeal) / mgOfGlucoseOneInsulinUnitLowers;
      print("correction: $correction");
      double correctionFraction = correction - correction.round();
      print("correctionFraction: $correctionFraction");
      int finalCorrection = correction.round();
      print("finalCorrection: $finalCorrection");

      int expectedGlucoseDeviationInMg = (mgOfGlucoseOneInsulinUnitLowers * correctionFraction).round();

      print("expectedGlucoseDeviationInMg: $expectedGlucoseDeviationInMg");

      int bloodSugarWithDeviation = currentBloodSugar + expectedGlucoseDeviationInMg;

      print("bloodSugarWithDeviation: $bloodSugarWithDeviation");

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
