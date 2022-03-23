import 'dart:math';

import 'package:flutter/material.dart';
import 'package:timesheet/daos/ProjectDAO.dart';
import 'package:timesheet/daos/ProjectTable.dart';
import 'package:timesheet/models/Project.dart';
import 'package:timesheet/views/ReadTimeSheet.dart';
import 'package:timesheet/daos/TimesheetDAO.dart';
import 'dart:async';
import '../models/Timesheet.dart';

class InsertUpdateTimeSheet extends StatefulWidget {
  TimeSheet tsModel;

  InsertUpdateTimeSheet.defaultModel() {
    this.tsModel = TimeSheet.getNullObject();
  }

  InsertUpdateTimeSheet(this.tsModel);

  @override
  InsertUpdateTimeSheetState createState() => InsertUpdateTimeSheetState();
}

class InsertUpdateTimeSheetState extends State<InsertUpdateTimeSheet> {
  final tsDAO = TimesheetDAO();
  final prDAO = ProjectDAO();
  final tsRead = ReadTimeSheet();

  TextEditingController textFormField;
  int projectID;
  String projectName;
  List<String> projectList = [''];
  String projectSelected;
  bool isEnabled;

  @override
  void initState() {
    debugPrint("Init");
    super.initState();
    textFormField = TextEditingController(text: widget.tsModel.workDescription);
    isEnabled = (widget.tsModel.id == null) ? false : true;
    projectID = widget.tsModel.projectId;
    getProjectName().then((value) {
      setState(() {
        projectName = value;
      });
    });
    getProjectList().then((value) {
      setState(() {
        projectList = value;
      });
    });
    debugPrint('InsertUpdateTimeSheet InitProjectList: ${projectList.toString()}');
    //setProjectSelected();
  }

  Future<String> getProjectName() async {
    var prMap = await prDAO.getById(projectID);
    var pr = Project.convertToProject(prMap);
    var _projectName = pr.displayName;
    debugPrint('InsertUpdateTimeSheet getProjectName: $_projectName');
    return _projectName;
  }

  Future<List<String>> getProjectList() async {
    debugPrint("InsertUpdateTimesheet - In getProjectList");
    List prMapList = await prDAO.getAll(prDAO.pkColumn);
    List<Project> prModels = prMapList.map((e) => Project.convertToProject(e)).toList();
    List<String> _projectList = prModels.map((e) => e.id.toString() + '-' + e.name).toList();
    return _projectList;
  }

  Future<String> setProjectSelected() async {
    debugPrint('InsertUpdateTimeSheet - tsModelId: ${widget.tsModel.id}');
    Map<String, dynamic> projectRow = await prDAO.getById(widget.tsModel.projectId);
    Project project = Project.convertToProject(projectRow);
    var _projectSelected = project.displayName;
    debugPrint('ProjectSelected: $_projectSelected');
    return _projectSelected;
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime d =
        await showDatePicker(context: context, initialDate: widget.tsModel.selectedDate, firstDate: DateTime(2000), lastDate: DateTime(2030));
    debugPrint('InsertUpdateTimeSheet - d: $d');
    setState(() {
      widget.tsModel.selectedDate = d;
      return d;
    });
  }

  Future<void> _selectStartTime(BuildContext context) async {
    TimeOfDay t = await showTimePicker(context: context, initialTime: widget.tsModel.startTime);
    debugPrint('InsertUpdateTimeSheet - t: $t');
    if (t != null) {
      setState(() {
        //tsModel.startTime = t.format(context);
        widget.tsModel.startTime = t;
        debugPrint('InsertUpdateTimeSheet - ST: ${widget.tsModel.startTime}');
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    TimeOfDay t = await showTimePicker(context: context, initialTime: widget.tsModel.endTime);
    debugPrint('InsertUpdateTimeSheet - t: $t');
    if (t != null) {
      setState(() {
        //tsModel.endTime = t.format(context);
        widget.tsModel.endTime = t;
        debugPrint('InsertUpdateTimeSheet - ET: ${widget.tsModel.endTime}');
      });
    }
  }

  void saveTimeSheet(String text, int id) async {
    debugPrint('text: $text, id: $id');
    widget.tsModel.workDescription = text;
    widget.tsModel.projectId = id;

    if (widget.tsModel.id == null) {
      int savedTimeSheetId = await tsDAO.insert(widget.tsModel);
      print('SavedTimeSheetID: $savedTimeSheetId');
    } else
      await tsDAO.update(widget.tsModel);
  }

  void deleteTimeSheet(int id) async {
    widget.tsModel.id = id;
    await tsDAO.delete(id);
  }

  DeleteButton() {
    var delete = ElevatedButton(
        onPressed: () {
          deleteTimeSheet(widget.tsModel.id);
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, '/');
        },
        child: Text('Delete'));
    return delete;
  }

  projectDropDown() {
    return DropdownButton(
      value: projectSelected,
      isDense: true,
      style: TextStyle(fontSize: 14, color: Colors.black),
      items: projectList.map((item) {
        return DropdownMenuItem(value: item, child: Text(item));
      }).toList(),
      onChanged: (selectedItem) {
        setState(() {
          projectSelected = selectedItem;
          projectID = Project.getProjectID(projectSelected);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    getProjectList();
    setProjectSelected();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        //toolbarHeight: 0.0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.red, Colors.orangeAccent])),
        ),
        title: Text((widget.tsModel.id == null) ? "Enter Timesheet" : "Update Timesheet"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 8, 0, 0),
                  child: Text('Project:    ', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                //(widget.tsModel.id == null) ?  projectDropDown() : Text('${widget.tsModel.projectId}'),
                (widget.tsModel.id == null) ?  projectDropDown() : Text(projectName),
              ],
            ),
            Padding(padding: const EdgeInsets.fromLTRB(12.0, 8, 0, 0)),
            Row(
              children: [
                IconButton(
                    icon: Icon(
                      Icons.calendar_today,
                      color: Colors.blueAccent,
                    ),
                    tooltip: 'Pick a date',
                    onPressed: () => selectDate(context)),
                Text('Date: ', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(widget.tsModel.selectedDateStr),
              ],
            ),
            Row(
              children: [
                IconButton(
                    icon: Icon(Icons.access_time, color: Colors.blueAccent),
                    tooltip: 'Pick a Start time',
                    onPressed: () => _selectStartTime(context)),
                Text('Start Time: ', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(widget.tsModel.timeOfDayToString(widget.tsModel.startTime)),
              ],
            ),
            Row(children: [
              IconButton(
                  icon: Icon(Icons.access_time, color: Colors.blueAccent), tooltip: 'Pick a Start time', onPressed: () => _selectEndTime(context)),
              Text('End Time: ', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(widget.tsModel.timeOfDayToString(widget.tsModel.endTime))
            ]),
            Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 8, 0, 0),
                child: Row(
                  children: [Text('Work Description:', style: TextStyle(fontWeight: FontWeight.bold))],
                )),
            Padding(
              padding: const EdgeInsets.fromLTRB(14.0, 8, 14.0, 0),
              child: TextFormField(
                  maxLength: 300, maxLines: 5, autofocus: true, controller: textFormField, decoration: InputDecoration(border: OutlineInputBorder())),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 8, 0, 0),
              child: Row(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        //Call database here
                        debugPrint('PROJECTID: $projectID');
                        saveTimeSheet(textFormField.text, projectID);
                        Navigator.pop(context);
                        //Use PushReplacementNamed method to go back to the root page without back arrow in Appbar.
                        //Navigator.pushReplacementNamed(context, '/');
                      },
                      child: Text(isEnabled ? 'Update' : 'Submit')),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: isEnabled ? DeleteButton() : null,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
