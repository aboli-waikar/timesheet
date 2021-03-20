import 'package:timesheet/models/Timesheet.dart';

class DeleteTimeSheetViewModel {
  TimeSheet tsModel;
  bool isDelete;

  DeleteTimeSheetViewModel(this.tsModel, this.isDelete);

  static getNullObject() {
    return DeleteTimeSheetViewModel(TimeSheet.getNullObject(), false);
  }

  @override
  String toString() {
    return "DeleteTimeSheetViewModel(${tsModel.toString()}, $isDelete)";
  }
}
