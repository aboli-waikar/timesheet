import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';


class DbCreator {

  static Database _db;

  List<String> _createTableStatements;

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
  }
}