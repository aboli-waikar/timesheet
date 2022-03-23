class ProjectTable {
  static const String UserId = "UserId";
  static const String Name = "Name";
  static const String Company = "Company";
  static const String Rate = "Rate";

  static const String TableName = "ProjectTbl";

  static const String PKColumn = "ID";

  static const String ColNamesWithDbTypes = "$UserId TEXT, $Name TEXT, $Company TEXT, $Rate INT";

  static const String CreateTableStatement = "CREATE TABLE $TableName($PKColumn INTEGER PRIMARY KEY, $ColNamesWithDbTypes)";
}
