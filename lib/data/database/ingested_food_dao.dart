import 'package:carbonet/data/database/database_helper.dart';
import 'package:carbonet/data/models/ingested_food.dart';

class IngestedFoodDAO {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  /// Não usar essa função diretamente. Para inserir uma refeição com a lista de alimentos, usar p método dao_procedure_coupler.inserirRefeicaoProcedimento().
  Future<int> insertIngestedFood(IngestedFood ingestedFood) async {
    final db = await _databaseHelper.database;
    return await db.insert('alimento_ingerido', ingestedFood.toMap());
  }

  Future<List<IngestedFood>> getIngestedFoodByMealId(int mealId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('alimento_ingerido', where: 'idRefeicao = ?', whereArgs: [mealId]);
    return List.generate(maps.length, (index) {
      return IngestedFood.fromMap(maps[index]);
    });
  }
}
