import 'package:timesheet/daos/DAO.dart';
import 'package:timesheet/models/Project.dart';

class ProjectDAO extends DAO<Project> {
  final String name = "Name";
  final String company = "Company";
  final String rate = "Rate";

  @override
  String tableName = "ProjectTbl";

  @override
  String pkColumn = "ID";

  @override
  String get colNamesWithDbTypes => "$name TEXT, $company TEXT, $rate INT";
}
