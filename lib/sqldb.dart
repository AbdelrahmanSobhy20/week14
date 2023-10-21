import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDb {
  static Database? _db;
  Future<Database?> get db async {
    if (_db == null) {
      _db = await initialDp();
      return _db;
    } else {
      return _db;
    }
  }

  initialDp() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, "todo.db");
    Database mydb = await openDatabase(path,
        onCreate: _onCreate, version: 6, onUpgrade: _onUpgrade);
    return mydb;
  }

  _onUpgrade(Database db, int oldversion, int newvesion) async {
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE "todo"(
      "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      "notes" TEXT NOT NULL
      )
    ''');
    print("crate table data");
  }

  readData(String sql) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(sql);
    return response;
  }

  insertData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql);
    return response;
  }

  updateData(String sql) async {
    Database? mydb = await db;
    int? response = await mydb?.rawUpdate(sql);
    return response;
  }

  deleteData(String sql) async {
    Database? mydb = await db;
    int? response = await mydb?.rawDelete(sql);
    return response;
  }

  mydeleteDatabase() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, "todo.db");
    await deleteDatabase(path);
  }
}
