import 'package:carbonet/data/database/database_helper.dart';
import 'package:carbonet/data/models/meal.dart';

class RefeicaoDAO {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  /// Não usar essa função diretamente. Para inserir uma refeição com a lista de alimentos, usar p método dao_procedure_coupler.inserirRefeicaoProcedimento().
  Future<int> insertRefeicao(Meal meal) async {
    final db = await _databaseHelper.database;
    return await db.insert('refeicao', meal.toMap());
  }

  Future<List<Meal>> getAllRefeicoes() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('refeicao');

    return List.generate(maps.length, (index) {
      return Meal.fromMap(maps[index]);
    });
  }

  Future<List<Meal>> getRefeicoesByUser(int idUser) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('refeicao', where: 'idUser = ?', whereArgs: [idUser]);

    return List.generate(maps.length, (index) {
      return Meal.fromMap(maps[index]);
    });
  }
}
