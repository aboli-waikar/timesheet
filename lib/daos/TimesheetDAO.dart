import 'package:timesheet/daos/DAO.dart';
import 'package:timesheet/daos/ProjectTable.dart';
import 'package:timesheet/daos/TimesheetTable.dart';
import '../models/Timesheet.dart';
import 'package:sqflite/sqflite.dart';

class TimesheetDAO extends DAO<TimeSheet> {
  @override
  String tableName = TimesheetTable.TableName;
  String tableName1 = 'TimeSheetTbl a, ProjectTbl b';

  @override
  String pkColumn = TimesheetTable.PKColumn;

  @override
  String get colNamesWithDbTypes => TimesheetTable.ColNamesWithDbTypes;

  Future<List> getTimeSheetsForAProject(
      int projectId, String sortColumn) async {
    var dbClient = await db;
    var result = await dbClient.query("${TimesheetTable.TableName}",
        where: "${TimesheetTable.ProjectId} = projectID"
        //whereArgs: [projectId],
        //orderBy: "$sortColumn DESC",
        );
    var res = result.toList();
    //print(res);
    return res;
  }

  Future<int> getCountForProject(String pId) async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery(
        "SELECT COUNT(*) FROM $tableName where ${TimesheetTable.ProjectId} = $pId"));
  }

  Future<List<Map<String, Object>>> getTimeSheetAndProjectName() async {
    var dbClient = await db;
    // var res = await dbClient.query(
    //     "$tableName1 where a.ProjectId = b.ID");
    var sql = "SELECT a.ID, a.ProjectID, a.Date, a.ST, a.ET, a.WD, a.HRS, b.ID as prID, b.UserId, b.Name, b.Company, b.Rate FROM TimeSheetTbl a, ProjectTbl b WHERE a.ProjectId = b.ID";
    var res = await dbClient.rawQuery(sql);
    return res;
  }
}
