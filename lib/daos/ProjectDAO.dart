import 'package:timesheet/daos/DAO.dart';
import 'package:timesheet/models/Project.dart';
import 'package:sqflite/sqflite.dart';

class ProjectDAO extends DAO<Project> {
  final String userId = "UserId";
  final String name = "Name";
  final String company = "Company";
  final String rate = "Rate";

  @override
  String tableName = "ProjectTbl";

  @override
  String pkColumn = "ID";

  @override
  String get colNamesWithDbTypes => "$userId TEXT, $name TEXT, $company TEXT, $rate INT";

  Future<List> getAllForUser(String userId, String sortColumn) async {
    var dbClient = await db;
    var result = await dbClient.query(
      "$tableName",
      where: "$userId",
      whereArgs: [userId],
      orderBy: "$sortColumn DESC",
    );
    var res = result.toList();
    //print(res);
    return res;
  }

  Future<int> getCountForUser(String uId) async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery("SELECT COUNT(*) FROM $tableName where $userId = $uId"));
  }
}
