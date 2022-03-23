import 'package:timesheet/daos/ProjectTable.dart';
import 'package:timesheet/models/Domain.dart';

class Project implements Domain {
  int _id;
  String _userId;
  String _name;
  String _company;
  num _rate;

  // Constructor to pass the values taken from User
  Project(this._userId, this._name, this._company, this._rate);

  // Constructor to take values from map where Date, ST, ET, WD are columns of
  // database table Project and assign to class variables Database -> TSModel
  Project.convertToProject(Map<String, dynamic> map) {
    this._id = map[ProjectTable.PKColumn];
    this._userId = map[ProjectTable.UserId];
    this._name = map[ProjectTable.Name];
    this._company = map[ProjectTable.Company];
    this._rate = map[ProjectTable.Rate];
  }

  static getNullObject() {
    return Project("", "", "", 0.0);
  }

  @override
  int get id => _id;
  set id(int id) {
    this._id = id;
  }

  String get userId => _userId;
  set userId(String userId) {
    this._userId = userId;
  }

  String get name => _name;
  set name(String name) {
    this._name = name;
  }

  String get company => _company;
  set company(String company) {
    this._company = company;
  }

  num get rate => _rate;
  set rate(num rate) {
    this._rate = rate;
  }

  String get displayName => '$_id-$_name';

  static int getProjectID(String displayName) {
    List<String> y = displayName.split('-');
    return int.parse(y[0]);
  }

  @override
  Map<String, dynamic> mapForDBInsert() {
    var m = mapForDBUpdate();

    if (_id != null) {
      m["id"] = _id;
    }
    return m;
  }

  @override
  Map<String, dynamic> mapForDBUpdate() {
    var updateMap = Map<String, dynamic>();
    updateMap[ProjectTable.UserId] = _userId;
    updateMap[ProjectTable.Name] = _name;
    updateMap[ProjectTable.Company] = _company;
    updateMap[ProjectTable.Rate] = _rate;
    return updateMap;
  }

  @override
  String toString() {
    return "Project($userId, $id, $name, $company, $rate)";
  }
}
