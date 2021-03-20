import 'package:timesheet/models/Domain.dart';

class Project implements Domain {
  int _id;
  String _name;
  String _company;
  num _rate;

  // Constructor to pass the values taken from User
  Project(this._name, this._company, this._rate);

  // Constructor to take values from map where Date, ST, ET, WD are columns of
  // database table Project and assign to class variables Database -> TSModel
  Project.convertToProject(Map<String, dynamic> map) {
    this._id = map["id"];
    this._name = map["name"];
    this._company = map["company"];
    this._rate = map["rate"];
  }

  static getNullObject() {
    return Project("", "", 0.0);
  }

  @override
  int get id => _id;
  set id(int id) {
    this._id = id;
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

  @override
  Map<String, dynamic> mapForDBInsert() {
    var m = mapForDBUpdate();

    if (_id != null) {
      m["id"] = _id;
      m["name"] = _name;
      m["company"] = _company;
      m["rate"] = _rate;
    }
    return m;
  }

  @override
  Map<String, dynamic> mapForDBUpdate() {
    var updateMap = Map<String, dynamic>();
    updateMap["name"] = _name;
    updateMap["company"] = _company;
    updateMap["rate"] = _rate;
    return updateMap;
  }

  @override
  String toString() {
    return "Project($id, $name, $company, $rate)";
  }
}
