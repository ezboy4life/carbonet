import 'package:carbonet/data/database/database_helper.dart';
import 'package:carbonet/data/models/refeicao.dart';

class RefeicaoDAO {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  /// Não usar essa função diretamente. Para inserir uma refeição com a lista de alimentos, usar p método dao_procedure_coupler.inserirRefeicaoProcedimento().
  Future<int> insertRefeicao(Refeicao refeicao) async {
    final db = await _databaseHelper.database;
    return await db.insert('refeicao', refeicao.toMap());
  }

  Future<List<Refeicao>> getAllRefeicoes() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('refeicao');

    return List.generate(maps.length, (index) {
      return Refeicao.fromMap(maps[index]);
    });
  }
  
  Future<List<Refeicao>> getRefeicoesByUser(int idUser) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('refeicao', where: 'idUser = ?', whereArgs: [idUser]);

    return List.generate(maps.length, (index) {
      return Refeicao.fromMap(maps[index]);
    });
  }
}