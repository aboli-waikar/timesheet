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
  num _numberOfhrs;

  //Constructor to pass the values taken from User
  TimeSheetModel(this._selectedDate, this._startTime, this._endTime, this._workDescription);

  //Constructor to take values from map where Date, ST, ET, WD are columns of database table TimeSheet and assign to class variables Database -> TSModel
  TimeSheetModel.convertToTimeSheetModel(Map<String, dynamic> map) {
    this._selectedDate = DateTime.parse(map["Date"]);
    this._startTime = stringToTimeOfDay(map["ST"]);
    this._endTime = stringToTimeOfDay(map["ET"]);
    this._workDescription = map["WD"];
    this._id = map["ID"];
    this._numberOfhrs = map["HRS"];
  }

  static getNullObject() {
    return TimeSheetModel(DateTime.now(), TimeOfDay.now(), TimeOfDay.now(), "");
  }

  //The private variables of class can be accessed using get method
  DateTime get selectedDate => _selectedDate;
  set selectedDate(DateTime selectedDate) {
    this._selectedDate = selectedDate;
  }

  String get selectedDateStr {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    var toFormat = (this._selectedDate == null) ? DateTime.now() : this._selectedDate;
    return formatter.format(toFormat);
  }

  TimeOfDay get startTime => _startTime;
  set startTime(TimeOfDay startTime) {
    this._startTime = startTime;
  }

  String timeOfDayToString(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    return DateFormat.jm().format(dt);
  }

  TimeOfDay stringToTimeOfDay(String ts) {
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
  set id(int id){
    this._id = id;
  }
  num get hrs => _numberOfhrs;

  //Domain class is expecting to override toMap and toUpdateMap methods. These methods are used to take values from User and populate map. TSModel -> Map -> DB
  @override
  Map<String, dynamic> mapForDBInsert() {
    var m = mapForDBUpdate();

    if (_id != null) {
      m["ID"] = _id;
      m["HRS"] = _numberOfhrs;
    }
    return m;
  }

  @override
  Map<String, dynamic> mapForDBUpdate() {
    var updateMap = Map<String, dynamic>();
    updateMap["Date"] = selectedDateStr;
    updateMap["ST"] = timeOfDayToString(startTime);
    updateMap["ET"] = timeOfDayToString(endTime);
    updateMap["WD"] = workDescription;

    int smin = startTime.hour*60+startTime.minute;
    int emin = endTime.hour*60+endTime.minute;
    var diffmin = (emin-smin)/60;
    _numberOfhrs = diffmin.toInt() + ((emin-smin)%60)/100 ;
    debugPrint('$_numberOfhrs');

    updateMap["HRS"] = (_numberOfhrs == 0.0) ? 0.0 : _numberOfhrs ;
    return updateMap;
  }
}
