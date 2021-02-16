import 'package:timesheet/TimesheetModel.dart';

class DeleteTimeSheetViewModel {
  TimeSheetModel tsModel;
  bool isDelete;

  DeleteTimeSheetViewModel(this.tsModel, this.isDelete);

  static getNullObject() {
    return DeleteTimeSheetViewModel(TimeSheetModel.getNullObject(), false);
  }

  @override
  String toString() {
    return "DeleteTimeSheetViewModel($isDelete)";
  }
}