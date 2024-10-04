// classe que registra os alimentos da refeição.

import 'package:carbonet/data/models/food_reference.dart';

class IngestedFood {
  int id;
  final int idFoodReference;
  int idMeal;
  double gramsIngested;

  FoodReference? _foodReference;

  FoodReference get foodReference {
    _foodReference ??= FoodReference.fromId(idFoodReference);
    return _foodReference!;
  }

  set foodReference(FoodReference foodReference) {
    _foodReference = foodReference;
  }

  // é uma boa, no DAO, não continuar a operação sem ter o idMeal > -1 e a gramsIngested > 0; estourar uma exception e tudo o mais (o próprio id feijoada pq ele é auto incremento)
  IngestedFood({this.id = -1, required this.idFoodReference, this.idMeal = -1, this.gramsIngested = 0, foodReference}) : _foodReference = foodReference;

  Map<String, dynamic> toMap() {
    if (id == -1) {
      return {
        'idAlimentoReferencia': idFoodReference,
        'idRefeicao': idMeal,
        'qtdIngerida': gramsIngested,
      };
    } else {
      return {
        'id': id,
        'idAlimentoReferencia': idFoodReference,
        'idRefeicao': idMeal,
        'qtdIngerida': gramsIngested,
      };
    }
  }

  factory IngestedFood.fromMap(Map<String, dynamic> map) {
    return IngestedFood(
        id: map['id'],
        idFoodReference: map['idAlimentoReferencia'],
        idMeal: map['idRefeicao'],
        gramsIngested: (map['qtdIngerida']) // n precisa de parse que nem no alimento referencia pq no sqlite ele tá salvo como double mesmo
        );
  }
}
