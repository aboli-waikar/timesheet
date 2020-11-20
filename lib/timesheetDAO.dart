import 'DAO.dart';
import 'timesheetModel.dart';

class TimesheetDAO extends DAO<TimeSheetModel> {
  final String date = "Date";
  final String st = "ST";
  final String et = "ET";
  final String wd = "WD";

  @override
  String tableName = "TimeSheetTbl";

  @override
  String pkColumn = "ID";

  @override
  String get colNamesWithDbTypes =>
      "$date TEXT, $st TEXT, $et TEXT, $wd TEXT";
}