import 'dart:io';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DbCreator {
  static Database _db;
  List<String> _createTableStatements;

  DbCreator(this._createTableStatements);

  List<String> get createTableStatements => _createTableStatements;

  Future<Database> get db async {
    if (_db != null) {
      print("_db instance is not null");
      return _db;
    }

    print("_db instance is null");
    _db = await initDb();
    return _db;
  }

  initDb() async {
    print("_initializing db");

    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "notodo_db.db");
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  void _onCreate(Database db, int version) async {
    // await db.execute("CREATE TABLE $tableName($pkColumn INTEGER PRIMARY KEY, $colNamesWithDbTypes)");
    _createTableStatements.forEach((statement) async {
      await db.execute(statement);
    });
    print("Tables are created");
  }
}
