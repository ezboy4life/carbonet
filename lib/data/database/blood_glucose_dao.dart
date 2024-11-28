import 'package:carbonet/data/database/database_helper.dart';
import 'package:carbonet/data/models/blood_glucose.dart';

class BloodGlucoseDAO {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> insertBloodGlucose(BloodGlucose bloodGlucose) async {
    final db = await _databaseHelper.database;
    return await db.insert('glicemia', bloodGlucose.toMap());
  }

  Future<List<BloodGlucose>> getAllBloodGlucoseUser(int idUser) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('glicemia', where: 'idUser = ?', whereArgs: [idUser]);

    return List.generate(maps.length, (index) {
      return BloodGlucose.fromMap(maps[index]);
    });
  }
}
