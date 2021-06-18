import 'package:timesheet/daos/DAO.dart';
import 'package:timesheet/daos/ProjectTable.dart';
import 'package:timesheet/daos/TimesheetTable.dart';
import '../models/Timesheet.dart';
import 'package:sqflite/sqflite.dart';

class TimesheetDAO extends DAO<TimeSheet> {
  @override
  String tableName = TimesheetTable.TableName;

  @override
  String pkColumn = TimesheetTable.PKColumn;

  @override
  String get colNamesWithDbTypes => TimesheetTable.ColNamesWithDbTypes;

  Future<List> getAllForProject(int projectId, String sortColumn) async {
    var dbClient = await db;
    var result = await dbClient.query(
      "${TimesheetTable.TableName}",
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
    return Sqflite.firstIntValue(
        await dbClient.rawQuery("SELECT COUNT(*) FROM $tableName where ${TimesheetTable.ProjectId} = $pId"));
  }
}
