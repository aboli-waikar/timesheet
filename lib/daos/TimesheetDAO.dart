import 'package:timesheet/daos/DAO.dart';
import '../models/Timesheet.dart';
import 'package:sqflite/sqflite.dart';

class TimesheetDAO extends DAO<TimeSheet> {
  final String projectId = "ProjectId";
  final String date = "Date";
  final String st = "ST";
  final String et = "ET";
  final String wd = "WD";
  final String hrs = "HRS";
  final String project = "PR";

  @override
  String tableName = "TimeSheetTbl";

  @override
  String pkColumn = "ID";

  @override
  String get colNamesWithDbTypes => "$projectId INT, $date TEXT, $st TEXT, $et TEXT, $wd TEXT, $hrs INT, $project PR";

  Future<List> getAllForProject(String projectId, String sortColumn) async {
    var dbClient = await db;
    var result = await dbClient.query(
      "$tableName",
      where: "$projectId",
      whereArgs: [projectId],
      orderBy: "$sortColumn DESC",
    );
    var res = result.toList();
    //print(res);
    return res;
  }

  Future<int> getCountForProject(String pId) async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery("SELECT COUNT(*) FROM $tableName where $projectId = $pId"));
  }
}
