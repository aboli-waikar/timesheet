import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timesheet/daos/ProjectTable.dart';
import 'package:timesheet/daos/TimesheetTable.dart';
import 'package:timesheet/models/Domain.dart';
import 'Project.dart';
//import '../daos/ProjectDAO.dart';

// This is domain model class of TimeSheet. It defines the database fields and table

class TimeSheet implements Domain {
  int _id;
  int _projectId;
  DateTime _selectedDate;
  TimeOfDay _startTime;
  TimeOfDay _endTime;
  String _workDescription;
  num _numberOfhrs;
  String _totalHrs;
  // String _projectName;
  // int _rate;
  Project _project;


  // Constructor to pass the values taken from User
  TimeSheet(this._projectId, this._selectedDate, this._startTime, this._endTime, this._workDescription);

  // Constructor to take values from map where Date, ST, ET, WD are columns of
  // database table TimeSheet and assign to class variables Database -> TSModel
  TimeSheet.convertToTimeSheet(Map<String, dynamic> map) {
    this._projectId = map[TimesheetTable.ProjectId];
    this._selectedDate = DateTime.parse(map[TimesheetTable.Date]);
    this._startTime = stringToTimeOfDay(map[TimesheetTable.ST]);
    this._endTime = stringToTimeOfDay(map[TimesheetTable.ET]);
    this._workDescription = map[TimesheetTable.WD];
    this._id = map[TimesheetTable.PKColumn];
    this._numberOfhrs = map[TimesheetTable.Hrs];
  }

  TimeSheet.convertToProjectTimeSheet(Map<String, dynamic> map) {
    this._projectId = map[TimesheetTable.ProjectId];
    this._selectedDate = DateTime.parse(map[TimesheetTable.Date]);
    this._startTime = stringToTimeOfDay(map[TimesheetTable.ST]);
    this._endTime = stringToTimeOfDay(map[TimesheetTable.ET]);
    this._workDescription = map[TimesheetTable.WD];
    this._id = map[TimesheetTable.PKColumn];
    this._numberOfhrs = map[TimesheetTable.Hrs];
    //this._totalHrs = map[]
    // this._projectName = map[ProjectTable.Name];
    // this._rate = map[ProjectTable.Rate];

    this._project = Project.convertToProject(map);
  }

  static getNullObject() {
    return TimeSheet(0, DateTime.now(), TimeOfDay.now(), TimeOfDay.now(), "");
  }

  // The private variables of class can be accessed using get method
  int get id => _id;
  set id(int id) {
    this._id = id;
  }

  int get projectId => _projectId;
  set projectId(int projectId) {
    this._projectId = projectId;
  }

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

  num get hrs => _numberOfhrs;

  Project get project => _project;
  set project(Project project) {
    this._project = project;
  }

  //Project getProject() {
  //   debugPrint('Project if Not Null: ${_project.toString()}');
  //   if(_project == null) {
  //     prDAO.getById(projectId).then((projectRow) {
  //       Project project = Project.convertToProject(projectRow);
  //       _project = project;
  //       debugPrint('Project if Null: ${_project.toString()}');
  //       return _project;
  //     });
  //   }
  //
  //   return _project;
  // }

  // Domain class is expecting to override toMap and toUpdateMap methods. These
  // methods are used to take values from User and populate map. TSModel -> Map -> DB
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
    updateMap[TimesheetTable.Date] = selectedDateStr;
    updateMap[TimesheetTable.ST] = timeOfDayToString(startTime);
    updateMap[TimesheetTable.ET] = timeOfDayToString(endTime);
    updateMap[TimesheetTable.WD] = workDescription;

    int smin = startTime.hour * 60 + startTime.minute;
    int emin = endTime.hour * 60 + endTime.minute;
    var diffmin = (emin - smin) / 60;
    _numberOfhrs = diffmin.toInt() + ((emin - smin) % 60) / 100;
    //debugPrint('$_numberOfhrs');

    updateMap["HRS"] = (_numberOfhrs == 0.0) ? 0.0 : _numberOfhrs;
    updateMap[TimesheetTable.ProjectId] = projectId;
    return updateMap;
  }

  @override
  String toString() {
    return "Timesheet($id, $projectId, $selectedDate, $startTime, $endTime, $workDescription, $hrs, ${project.toString()})";
  }
}
