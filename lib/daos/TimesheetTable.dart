class TimesheetTable {
  static const String ProjectId = "ProjectId";
  static const String Date = "Date";
  static const String ST = "ST";
  static const String ET = "ET";
  static const String WD = "WD";
  static const String Hrs = "HRS";
  static const String Project = "PR";

  static const String TableName = "TimeSheetTbl";

  static const String PKColumn = "ID";

  static const String ColNamesWithDbTypes =
      "$ProjectId INT, $Date TEXT, $ST TEXT, $ET TEXT, $WD TEXT, $Hrs INT, $Project PR";

  static const String CreateTableStatement = "CREATE TABLE $TableName($PKColumn INTEGER PRIMARY KEY, $ColNamesWithDbTypes)";
}
