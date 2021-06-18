import 'dart:async';
import 'package:flutter/material.dart';
import 'package:timesheet/daos/TimesheetTable.dart';
import 'package:timesheet/models/DeleteTimeSheetViewModel.dart';
import 'package:timesheet/models/Timesheet.dart';
import '../ExportToExcel.dart';
import 'InsertUpdateTimeSheet.dart';
import '../daos/TimesheetDAO.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import '../daos/ProjectDAO.dart';
import '../models/Project.dart';

class ReadTimeSheet extends StatefulWidget {
  static String routeName = '/ReadTimeSheet';
  @override
  _ReadTimeSheetState createState() => _ReadTimeSheetState();
}

class _ReadTimeSheetState extends State<ReadTimeSheet> {
  final tsDAO = TimesheetDAO();
  final prDAO = ProjectDAO();
  List<DeleteTimeSheetViewModel> listDelTSViewModel;
  List<TimeSheet> timesheetModels;
  //var selectedMonth = DateTime.now();
  var selectedMonth;
  var displayName = '';

  Future<List<DeleteTimeSheetViewModel>> getTSData() async {
    debugPrint(selectedMonth.toString());
    if (selectedMonth == null) {
      List tsMapList = await tsDAO.getAll(TimesheetTable.Date); //store data retrieved from db to a variable
      timesheetModels = tsMapList.map((tsRowAsMap) => TimeSheet.convertToTimeSheet(tsRowAsMap)).toList();
      List<DeleteTimeSheetViewModel> listDelTSViewModel =
          timesheetModels.map((tsm) => DeleteTimeSheetViewModel(tsm, false)).toList();
      return listDelTSViewModel;
    } else {
      List tsMapList = await tsDAO.getAll(TimesheetTable.Date); //store data retrieved from db to a variable
      List tsModels = tsMapList.map((tsRowAsMap) => TimeSheet.convertToTimeSheet(tsRowAsMap)).toList();
      timesheetModels = tsModels.where((element) => getMonth(element.selectedDate) == getMonth(selectedMonth)).toList();
      List<DeleteTimeSheetViewModel> listDelTSViewModel =
          timesheetModels.map((tsm) => DeleteTimeSheetViewModel(tsm, false)).toList();
      return listDelTSViewModel;
    }
  }

  Future<String> getProjectName(int id) async {
    Map<String, dynamic> prMap = await prDAO.getById(id);
    Project pr = Project.convertToProject(prMap);
    String _displayName = pr.displayName;
    return _displayName;
  }

  void copyData(List<DeleteTimeSheetViewModel> initialData) {
    if (listDelTSViewModel == null) {
      listDelTSViewModel = initialData;
      debugPrint('Initial Data: ${initialData.toString()}');
    }
  }

  deleteTS() async {
    await listDelTSViewModel.where((element) => element.isDelete).forEach((dtsvm) => tsDAO.delete(dtsvm.tsModel.id));
  }

  selectAll() {
    setState(() {
      listDelTSViewModel.forEach((e) => e.isDelete = true);
      //debugPrint(listDelTSViewModel.join(", "));
    });
  }

  projectDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Change Project"),
          //content:
        );
      },
    );
  }

  getMonth(DateTime dT) {
    final DateFormat formatter = DateFormat('yyyy-MM');
    var yearMonth = formatter.format(dT);
    return yearMonth;
  }

  getMonthStr(DateTime dT) {
    final DateFormat formatter = DateFormat('MMM-yyyy');
    var yearMonth = formatter.format(dT);
    return yearMonth;
  }

  Future<void> selectMonth(BuildContext context) async {
    final DateTime d = await showMonthPicker(
        context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2030));
    setState(() {
      selectedMonth = d;
      getTSData();
    });
  }

  showExportProgressDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: new Row(
            children: [
              CircularProgressIndicator(),
              Container(margin: EdgeInsets.only(left: 10), child: Text("Exporting to excel..")),
            ],
          ),
        );
      },
    );
  }

  showExportCompleteDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: new Row(
            children: [
              CircularProgressIndicator(
                value: 100.0,
              ),
              Container(margin: EdgeInsets.only(left: 10), child: Text("Export completed")),
            ],
          ),
        );
      },
    );
  }

  AppBar getAppBar() {
    var appBarWithDeleteIcon = AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.red, Colors.orangeAccent])),
      ),
      title: Text(
        "Project: ABC",
        style: TextStyle(fontSize: 16.0),
      ),
      actions: [
        IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              deleteTS();
              Navigator.pushReplacementNamed(context, '/');
            }),
        IconButton(
          icon: Icon(Icons.select_all_rounded),
          onPressed: () => selectAll(),
        ),
      ],
    );

    var appBar = AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.red, Colors.orangeAccent])),
      ),
      title: Text(
        "Project: ABC",
        style: TextStyle(fontSize: 16.0),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.work_outline,
            color: Colors.white,
          ),
          onPressed: () => projectDialog(),
        ),
        IconButton(
          icon: Icon(Icons.calendar_today, color: Colors.white),
          onPressed: () => selectMonth(context),
        ),
        IconButton(
            icon: Icon(
              Icons.import_export_sharp,
              color: Colors.white,
            ),
            onPressed: () async {
              var x = await exportToPDF(
                  timesheetModels, selectedMonth != null ? getMonth(selectedMonth) : null); //Send Project name here
              //debugPrint(x); //get filename here
              (x != null) ? showExportCompleteDialog() : showExportProgressDialog();
            }),
      ],
    );

    if (listDelTSViewModel != null && listDelTSViewModel.any((element) => element.isDelete == true)) {
      return appBarWithDeleteIcon;
    } else {
      return appBar;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text("TimeSheet"),),
      appBar: getAppBar(),
      body: FutureBuilder<List<DeleteTimeSheetViewModel>>(
        future: getTSData(),
        builder: (context, snapshot) {
          copyData(snapshot.data);
          if (snapshot.data == null) {
            return Container(
              child: Center(
                child: Text("Loading"),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return ListTile(
                    leading: Checkbox(
                      value: listDelTSViewModel[index].isDelete,
                      onChanged: (bool newValue) {
                        setState(() {
                          listDelTSViewModel[index].isDelete = newValue;
                          debugPrint('current value: ${listDelTSViewModel[index].isDelete}');
                          int id = snapshot.data[index].tsModel.id;
                          debugPrint('$id');
                        });
                      },
                    ),
                    title: Column(children: [
                      Row(
                        children: [
                          Text("Project ID: ", style: TextStyle(fontSize: 13.0)),
                          Text(snapshot.data[index].tsModel.projectId.toString(), style: TextStyle(fontSize: 13.0)),
                          //Text(snapshot.data[index].tsModel.getProject().displayName, style: TextStyle(fontSize: 13.0)),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Date: ", style: TextStyle(fontSize: 13.0)),
                          Text(snapshot.data[index].tsModel.selectedDateStr, style: TextStyle(fontSize: 13.0)),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Hours Spent: ", style: TextStyle(fontSize: 12.0)),
                          Text(snapshot.data[index].tsModel.hrs.toString(),
                              style: TextStyle(fontSize: 14.0, color: Colors.green, fontWeight: FontWeight.bold)),
                        ],
                      )
                    ]),
                    subtitle: Text(snapshot.data[index].tsModel.workDescription,
                        style: TextStyle(fontSize: 14.0, color: Colors.green)),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => InsertUpdateTimeSheet(snapshot.data[index].tsModel)));
                    });
              },
            );
          }
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //     tooltip: 'Enter Timesheet',
      //     child: Icon(Icons.add),
      //     onPressed: () {
      //       Navigator.push(context, MaterialPageRoute(builder: (context) => InsertUpdateTimeSheet.defaultModel()));
      //     }),
    );
  }
}
