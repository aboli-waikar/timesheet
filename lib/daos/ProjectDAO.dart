import 'package:timesheet/daos/DAO.dart';
import 'package:timesheet/daos/ProjectTable.dart';
import 'package:timesheet/models/Project.dart';
import 'package:sqflite/sqflite.dart';

class ProjectDAO extends DAO<Project> {
  @override
  String tableName = ProjectTable.TableName;

  @override
  String pkColumn = ProjectTable.PKColumn;

  @override
  String get colNamesWithDbTypes => ProjectTable.ColNamesWithDbTypes;

  Future<List> getAllForUser(String userId, String sortColumn) async {
    var dbClient = await db;
    var result = await dbClient.query(
      "$tableName",
      where: "${ProjectTable.UserId}",
      whereArgs: [userId],
      orderBy: "$sortColumn DESC",
    );
    var res = result.toList();
    //print(res);
    return res;
  }

  Future<int> getCountForUser(String uId) async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery("SELECT COUNT(*) FROM $tableName where ${ProjectTable.UserId} = $uId"));
  }
}
