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

  Future<User?> getUserFromId(int id) async {
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

  Future<User?> getUserFromLogin(String email, String password) async {
    final String passwordHash = User.hashPassword(password);

    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      "users",
      where: "email = ? and senha = ?",
      whereArgs: [email, passwordHash],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<User?> getUserFromEmail(String email) async {
    // TODO: Alterar query só pra ver se o cadastro existe, e não retornar o user
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      "users",
      where: "email = ?",
      whereArgs: [email],
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

  Future<int> updateUserBirthDate(User user) async {
    final db = await _databaseHelper.database;

    return await db.update(
      'users',
      {'dataNascimento': user.birthDate.toIso8601String()},
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> updateUserEmail(User user) async {
    final db = await _databaseHelper.database;

    return await db.update(
      'users',
      {'email': user.email},
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> updateUserPassword(User user) async {
    final db = await _databaseHelper.database;

    return await db.update(
      'users',
      {'senha': user.passwordHash},
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> updateUserInsulin(User user) async {
    final db = await _databaseHelper.database;

    return await db.update(
      'users',
      {'constInsulinica': user.constanteInsulinica},
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> updateUserName(User user) async {
    final db = await _databaseHelper.database;

    return await db.update(
      'users',
      {'nome': user.name},
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> updateUserSurname(User user) async {
    final db = await _databaseHelper.database;

    return await db.update(
      'users',
      {'sobrenome': user.surname},
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> updateUserMaxBloodGlucose(User user) async {
    final db = await _databaseHelper.database;

    return await db.update(
      'users',
      {'glicemiaMaxima': user.maxBloodGlucose},
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> updateUserMinBloodGlucose(User user) async {
    final db = await _databaseHelper.database;

    return await db.update(
      'users',
      {'glicemiaMinima': user.maxBloodGlucose},
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
