import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

Map<int, String> _scripts = {
  1: '''CREATE TABLE imc (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          peso REAL,
          altura REAL
        );'''
};

class SQLiteDataBase {
  static Database? db;

  Future<Database> getDatabase() async {
    if (db == null) {
      return await initLocalStorageSqlite();
    }
    return db!;
  }

  Future<Database> initLocalStorageSqlite() async {
    var db = await openDatabase(
      p.join(await getDatabasesPath(), 'database.db'),
      version: _scripts.length,
      onCreate: (Database db, int version) async {
        for (var i = 1; i <= _scripts.length; i++) {
          await db.execute(_scripts[i]!);
        }
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        for (var i = oldVersion + 1; i <= _scripts.length; i++) {
          await db.execute(_scripts[i]!);
        }
      },
    );
    return db;
  }
}
