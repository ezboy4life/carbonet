import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'carbonet.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        final String schemaSQL =
            await rootBundle.loadString("assets/schema.sql");

        final List<String> sqlStatements = schemaSQL.split(";");
        for (String statement in sqlStatements) {
          if (statement.trim().isNotEmpty) {
            await db.execute(statement);
          }
        }
        //await db.execute(schemaSQL); // <- executa uma instrução só
      },
    );
  }

  Future<void> closeDatabase() async {
    final db = await database;
    db.close();
  }

  // 👀
  Future<void> recreateDatabase() async {
    await closeDatabase();

    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'carbonet.db');
    await databaseFactory.deleteDatabase(path);

    await database;
  }
}
