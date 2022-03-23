import 'ProjectTable.dart';

class TimesheetTable {
  static const String ProjectId = "ProjectId";
  static const String Date = "Date";
  static const String ST = "ST";
  static const String ET = "ET";
  static const String WD = "WD";
  static const String Hrs = "HRS";

  static const String TableName = "TimeSheetTbl";

  static const String PKColumn = "ID";

  static const String ColNamesWithDbTypes =
      "$ProjectId INT, $Date TEXT, $ST TEXT, $ET TEXT, $WD TEXT, $Hrs INT";

  static const String fk = "FOREIGN KEY(${TimesheetTable.ProjectId}) REFERENCES ${ProjectTable.TableName}(${ProjectTable.PKColumn})";

  static const String CreateTableStatement = "CREATE TABLE $TableName($PKColumn INTEGER PRIMARY KEY, $ColNamesWithDbTypes, $fk)";
}
