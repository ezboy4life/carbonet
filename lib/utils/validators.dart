import 'package:carbonet/data/models/user.dart';
import 'package:carbonet/data/repository/user_repository.dart';
import 'package:carbonet/utils/calculator.dart';
import 'package:carbonet/utils/logger.dart';
import 'package:flutter/material.dart';

class Validators {
  static bool isValidEmail(String email) {
    // Não sei se esse regex é decente mas pelos testes que fiz tá pegando
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  static bool isValidPassword(String password) {
    return password.length >= 10;
  }

  /// WARN: deprecated
  static bool isValidHeight(double height) {
    return height < 3;
  }

  static Future<bool> checkEmailAlreadyRegistered(String email) async {
    UserRepository userRepository = UserRepository();
    User? user = await userRepository.fetchUserFromEmail(email);
    if (user != null) {
      return true;
    }
    return false;
  }

  static bool isAgeValid(DateTime? birthDate) {
    if (birthDate == null) {
      infoLog("Data não selecionada!");
      return false;
    }

    final currentDate = DateTime.now();
    var age = currentDate.year - birthDate.year;
    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month &&
            currentDate.day < birthDate.day)) {
      age--;
    }
    return age >= 18 && age < 122; // 122 = pessoa mais velha do mundo
  }

  /// WARN: deprecated
  static bool isValidWeight(String weightString) {
    if (weightString.isEmpty) {
      return false;
    }

    double weight = double.parse(weightString);
    return weight > 0 && weight < 595; // pessoa mais pesada do mundo
  }

  static bool isDateValid(DateTime? birthDate) {
    if (birthDate == null) {
      infoLog("Data não selecionada!");
      return false;
    }

    final currentDate = DateTime.now();
    var age = currentDate.year - birthDate.year;
    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month &&
            currentDate.day < birthDate.day)) {
      age--;
    }
    return age >= 18 && age < 122; // 122 = pessoa mais velha do mundo
  }

  static bool isTimeValid(TimeOfDay? time) {
    return time != null;
  }

  static bool isValidMinBloodGlucose(int min, int max) {
    return min >= 70 && min < 180 && min <= max - Calculator.mgOfGlucoseOneInsulinUnitLowers;
  }


  static bool isValidMaxBloodGlucose(int min, int max) {
    return max > 70 && max <= 180 && max >= min + Calculator.mgOfGlucoseOneInsulinUnitLowers;
  }

  static bool isValidIdealBloodGlucoseInterval(int min, int max) {
    return max - min >= Calculator.mgOfGlucoseOneInsulinUnitLowers;
  }
}
