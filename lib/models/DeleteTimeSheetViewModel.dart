import 'package:timesheet/models/Timesheet.dart';

class DeleteTimeSheetViewModel {
  TimeSheet tsModel;
  bool isDelete;
  String name;

  DeleteTimeSheetViewModel(this.tsModel, this.isDelete);

  static getNullObject() {
    return DeleteTimeSheetViewModel(TimeSheet.getNullObject(), false);
  }

  @override
  String toString() {
    return "DeleteTimeSheetViewModel(${tsModel.toString()}, $isDelete)";
  }
}
