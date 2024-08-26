import 'package:carbonet/data/database/database_helper.dart';
import 'package:carbonet/data/models/glicemia.dart';

class GlicemiaDAO {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> insertGlicemia(Glicemia glicemia) async {
    final db = await _databaseHelper.database;
    return await db.insert('glicemia', glicemia.toMap());
  }

  Future<List<Glicemia>> getAllGlicemiaByUser(int idUser) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('glicemia', where: 'idUser = ?', whereArgs: [idUser]);
    
    return List.generate(maps.length, (index) {
      return Glicemia.fromMap(maps[index]);
    });
  }
}