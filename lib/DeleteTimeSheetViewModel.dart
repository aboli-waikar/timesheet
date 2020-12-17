import 'package:timesheet/TimesheetModel.dart';
import 'package:flutter/material.dart';

class DeleteTimeSheetViewModel {
  TimeSheetModel tsModel;
  bool isDelete;

  DeleteTimeSheetViewModel(this.tsModel, this.isDelete);

  static getNullObject() {
    return DeleteTimeSheetViewModel(TimeSheetModel.getNullObject(), false);
  }
}