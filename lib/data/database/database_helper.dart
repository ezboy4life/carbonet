import 'package:carbonet/utils/logger.dart';
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
    infoLog("⚠ Fechando banco de dados");
    final db = await database;
    db.close();
    _database = null;
    infoLog("⚠ Banco de dados fechado");
  }

  // 👀
  Future<void> recreateDatabase() async {
    final db = await database;
    var batch = db.batch();

    infoLog("⚠ Removendo banco de dados existente");
    batch.execute("DROP TABLE IF EXISTS users");
    batch.execute("DROP TABLE IF EXISTS glicemia");
    batch.execute("DROP TABLE IF EXISTS alimento_referencia");
    batch.execute("DROP TABLE IF EXISTS refeicao");
    batch.execute("DROP TABLE IF EXISTS alimento_ingerido");

    await batch.commit(noResult: true);
    infoLog("⚠ Tabelas removidas");


    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'carbonet.db');
    await databaseFactory.deleteDatabase(path);
    infoLog("⚠ Arquivo removido");
    
    await closeDatabase();

    await _initDatabase();
    infoLog("⚠ Banco de dados recriado");
  }
}
