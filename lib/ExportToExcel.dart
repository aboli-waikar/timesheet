import 'package:timesheet/TimesheetModel.dart';
import 'package:timesheet/TimesheetDAO.dart';


  Future<List<TimeSheetModel>> ExportToExcel() async {
    var tsDAO = TimesheetDAO();
    List tsMapList = await tsDAO.getAll(tsDAO.date); //store data retrieved from db to a variable
    List timesheetModels = tsMapList.map((tsRowAsMap) => TimeSheetModel.convertToTimeSheetModel(tsRowAsMap)).toList();
    return timesheetModels;
  }

