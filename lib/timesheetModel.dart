import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timesheet/Domain.dart';

// This is domain model class of TimeSheet. It defines the database fields and table

class TimeSheetModel implements Domain {
  DateTime _selectedDate;
  TimeOfDay _startTime;
  TimeOfDay _endTime;
  String _workDescription;
  int _id;

  //Constructor to pass the values taken from User

  TimeSheetModel(this._selectedDate, this._startTime, this._endTime, this._workDescription);

  //Constructor to take values from map where Date, ST, ET, WD are columns of database table TimeSheet and assign to class variables UI-->TSmodel -->Database
  TimeSheetModel.fromMap(Map<String, dynamic> map) {
    print('inside fromMap: ${map["Date"]}');
    var dt = DateTime.parse(map["Date"]);
    print('dt: $dt');
    this._selectedDate = dt;
    this._startTime = fromTimeStr(map["ST"]);
    this._endTime = fromTimeStr(map["ET"]);
    this._workDescription = map["WD"];
    this._id = map["ID"];
  }

  static getNullObject() {
    return TimeSheetModel(DateTime.now(), TimeOfDay.now(), TimeOfDay.now(), "WDs");
  }

  //The private variables of class can be accessed using get method
  DateTime get selectedDate => _selectedDate;
  set selectedDate(DateTime selectedDate) {
    this._selectedDate = selectedDate;
  }

  String get selectedDateStr => DateFormat.yMMMMd("en_US").format(selectedDate);

  TimeOfDay get startTime => _startTime;
  set startTime(TimeOfDay startTime) {
    this._startTime = startTime;
  }

  String toTimeStr(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    return DateFormat.jm().format(dt);
  }

  TimeOfDay fromTimeStr(String ts) {
    final format = DateFormat.jm(); //"6:00 AM"
    return TimeOfDay.fromDateTime(format.parse(ts));
  }

  TimeOfDay get endTime => _endTime;
  set endTime(TimeOfDay endTime) {
    this._endTime = endTime;
  }

  String get workDescription => _workDescription;
  set workDescription(String workDescription) {
    this._workDescription = workDescription;
  }

  int get id => _id;

  //Domain class is expecting to override toMap and toUpdateMap methods. These methods are used to take values from User and populate map. Database-->TSmodel -->UI
  @override
  Map<String, dynamic> toMap() {
    var m = toUpdateMap();

    if (_id != null) {
      m["ID"] = _id;
    }
    return m;
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    var updateMap = Map<String, dynamic>();
    updateMap["Date"] = selectedDateStr;
    updateMap["ST"] = toTimeStr(startTime);
    updateMap["ET"] = toTimeStr(endTime);
    updateMap["WD"] = workDescription;

    return updateMap;
  }
}
