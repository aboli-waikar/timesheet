import 'dart:io';
import 'package:timesheet/Domain.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

class DAO<T extends Domain> {
  //Constructor definition, _variables are private to class and not exposed directly.

  static Database _db;
  String _tableName;
  String _pkColumn;
  String _colNamesWithDbTypes;

  //Use getter and setter methods to asscociate with private variables of class.
  String get tableName => _tableName;

  set tableName(String tableName) {
    this._tableName = tableName;
  }

  String get pkColumn => _pkColumn;

  set pkColumn(String pkColumn) {
    this._pkColumn = pkColumn;
  }

  String get colNamesWithDbTypes => _colNamesWithDbTypes;

  set colNamesWithDbTypes(String colNamesWithDbTypes) {
    this._colNamesWithDbTypes = colNamesWithDbTypes;
  }

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
    await db.execute("CREATE TABLE $tableName($pkColumn INTEGER PRIMARY KEY, $colNamesWithDbTypes)");
    print("Table is created");
  }

  /// This method is getItems method.
  Future<List> getAll(String sortColumn) async {
    var dbClient = await db;
    //var result = await dbClient.query("SELECT * FROM $tableName");
    var result = await dbClient.query("$tableName", orderBy:"$sortColumn DESC",);
    print("In DAO.getAll");
    var res = result.toList();
    //print(res);
    return res;

  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery("SELECT COUNT(*) FROM $tableName"));
  }

  Future<Map<String, dynamic>> getById(int id) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableName WHERE id =$id");
    if (result.length == 0) return null;
    return result.first;
  }

  Future<int> insert(T t) async {
    print("inserting: $t");
    var dbClient = await db;
    int res = await dbClient.insert("$tableName", t.mapForDBInsert());
    print(res.toString());
    return res;
  }

  Future<int> update(T t) async {
    var id = t.id;
    print("In DAO.update to update item with id: $id");
    var dbClient = await db;
    return await dbClient.update(tableName, t.mapForDBUpdate(), where: "$pkColumn = ?", whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    print("In DAO Delete");
    var dbClient = await db;
    return await dbClient.delete(tableName, where: "$pkColumn = ?", whereArgs: [id]);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
