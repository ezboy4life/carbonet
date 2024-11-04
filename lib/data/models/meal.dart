import 'package:carbonet/data/models/ingested_food.dart';

class Meal {
  int id;
  int idUser;
  String mealType;
  DateTime date;
  bool isActive;
  int carbTotal;
  int calorieTotal;

  final List<IngestedFood> localListaAlimentosIngeridos = [];

  // é uma boa, no DAO, não continuar a operação sem ter idUser > -1 e a gramsIngested > 0; estourar uma exception e tudo o mais
  Meal({
    this.id = -1,
    required this.idUser,
    required this.date,
    required this.mealType,
    required this.carbTotal,
    required this.calorieTotal,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    if (id == -1) {
      return {
        'idUser': idUser,
        'data': date.toIso8601String(),
        'tipoRefeicao': mealType,
        'totalCarbos': carbTotal,
        'totalCalorias': calorieTotal,
      };
    } else {
      return {
        'id': id,
        'idUser': idUser,
        'data': date.toIso8601String(),
        'tipoRefeicao': mealType,
        'isActive': isActive,
        'totalCarbos': carbTotal,
        'totalCalorias': calorieTotal,
      };
    }
  }

  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      id: map['id'],
      idUser: map['idUser'],
      date: DateTime.parse(map['data']),
      mealType: map['tipoRefeicao'],
      isActive: map['isActive'] == 1 ? true : false,
      carbTotal: map['totalCarbos'],
      calorieTotal: map['totalCalorias'],
    );
  }
}
