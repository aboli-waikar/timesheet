import 'dart:io';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timesheet/daos/ProjectTable.dart';
import 'package:timesheet/daos/TimesheetTable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const FlutterSecureStorage secureStorage = FlutterSecureStorage();

class DbCreator {
  static Database _db;
  List<String> _createTableStatements;


  DbCreator() {
    _createTableStatements = [ProjectTable.CreateTableStatement, TimesheetTable.CreateTableStatement];
  }

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

  Future<Database> initDb() async {
    print("DBCreator - _initializing db");

    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "notodo_db.db");
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  void _onCreate(Database db, int version) async {
    // await db.execute("CREATE TABLE $tableName($pkColumn INTEGER PRIMARY KEY, $colNamesWithDbTypes)");
    _createTableStatements.forEach((statement) async {
      print(statement);
      await db.execute(statement);
    });
    print("Tables are created");
    var storedUIDToken = await secureStorage.read(key: 'uid');
    //var insertProjectMap = {ProjectTable.UserId: storedUIDToken, ProjectTable.Name: 'Default', ProjectTable.Company: 'Default', ProjectTable.Rate: 10};
    var insertProjectMap = {'UserId': storedUIDToken, 'Name': 'Default', 'Company': 'Default', 'Rate': 10};
    //var savedProjectId = await db.insert(ProjectTable.TableName, insertProjectMap);
    int savedProjectId = await db.rawInsert("INSERT INTO ProjectTbl (UserId, Name, Company, Rate) VALUES ('$storedUIDToken', 'Default', 'Default', 10 )");
    print("Project created: $savedProjectId");
  }
}
