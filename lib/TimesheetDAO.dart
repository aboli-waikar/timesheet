import 'DAO.dart';
import 'TimesheetModel.dart';

class TimesheetDAO extends DAO<TimeSheetModel> {
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
  String get colNamesWithDbTypes =>
      "$date TEXT, $st TEXT, $et TEXT, $wd TEXT, $hrs INT, $project PR";
}