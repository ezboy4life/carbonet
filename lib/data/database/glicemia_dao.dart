import 'package:carbonet/data/database/database_helper.dart';
import 'package:carbonet/data/models/blood_glucose.dart';

class GlicemiaDAO {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> insertGlicemia(BloodGlucose glicemia) async {
    final db = await _databaseHelper.database;
    return await db.insert('glicemia', glicemia.toMap());
  }

  Future<List<BloodGlucose>> getAllGlicemiaByUser(int idUser) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('glicemia', where: 'idUser = ?', whereArgs: [idUser]);

    return List.generate(maps.length, (index) {
      return BloodGlucose.fromMap(maps[index]);
    });
  }
}
