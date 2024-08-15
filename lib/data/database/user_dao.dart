import 'database_helper.dart';
import 'package:carbonet/data/models/user.dart';

class UserDAO {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> insertUser(User user) async {
    final db = await _databaseHelper.database;
    return await db.insert('users', user.toMap());
  }

  Future<List<User>> getAllUsers() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query("users");

    return List.generate(maps.length, (index) {
      return User.fromMap(maps[index]);
    });
  }

  Future<User?> getUser(int id) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      "users",
      where: "id = ?",
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateUser(User user) async {
    final db = await _databaseHelper.database;
    return await db.update(
      "users",
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete(
      "users",
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
