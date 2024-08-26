import 'package:carbonet/data/database/database_helper.dart';
import 'package:carbonet/data/models/alimento_ingerido.dart';

class AlimentoIngeridoDAO {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  /// Não usar essa função diretamente. Para inserir uma refeição com a lista de alimentos, usar p método dao_procedure_coupler.inserirRefeicaoProcedimento().
  Future<int> insertAlimentoIngerido(AlimentoIngerido alimentoIngerido) async {
    final db = await _databaseHelper.database;
    return await db.insert('alimento_ingerido', alimentoIngerido.toMap());
  }

  Future<List<AlimentoIngerido>> getAlimentoIngeridoByRefeicao (int idRefeicao) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('alimento_ingerido', where: 'idRefeicao = ?', whereArgs: [idRefeicao]);
    return List.generate(maps.length, (index) {
      return AlimentoIngerido.fromMap(maps[index]);
    });
  }
}