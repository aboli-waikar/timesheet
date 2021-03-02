import 'dart:async';
import 'package:flutter/material.dart';
import 'package:timesheet/DeleteTimeSheetViewModel.dart';
import 'package:timesheet/TimesheetModel.dart';
import 'ExportToExcel.dart';
import 'Home.dart';
import 'InsertUpdateTimeSheet.dart';
import 'Profile.dart';
import 'TimesheetDAO.dart';

class ReadTimeSheet extends StatefulWidget {
  @override
  _ReadTimeSheetState createState() => _ReadTimeSheetState();
}

class _ReadTimeSheetState extends State<ReadTimeSheet> {
  final tsDAO = TimesheetDAO();
  List<DeleteTimeSheetViewModel> listDelTSViewModel;
  List<TimeSheetModel> timesheetModels;

  Future<List<DeleteTimeSheetViewModel>> getTSData() async {
    debugPrint("In getTSData");
    List tsMapList = await tsDAO.getAll(tsDAO.date); //store data retrieved from db to a variable
    timesheetModels = tsMapList.map((tsRowAsMap) => TimeSheetModel.convertToTimeSheetModel(tsRowAsMap)).toList();
    List<DeleteTimeSheetViewModel> listDelTSViewModel = timesheetModels.map((tsm) => DeleteTimeSheetViewModel(tsm, false)).toList();
    return listDelTSViewModel;
  }

  void copyData(List<DeleteTimeSheetViewModel> initialData) {
    if (listDelTSViewModel == null) {
      listDelTSViewModel = initialData;
    }
  }

  deleteTS() async {
    debugPrint("In DeleteTS");
    await listDelTSViewModel.where((element) => element.isDelete).forEach((dtsvm) => tsDAO.delete(dtsvm.tsModel.id));
  }

  selectAll() {
    setState(() {
      listDelTSViewModel.forEach((e) => e.isDelete = true);
      debugPrint(listDelTSViewModel.join(", "));
      debugPrint("InSet");
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

  showExportProgressDialog(){
    showDialog(barrierDismissible: false,
      context: context,
      builder:(BuildContext context){
        return AlertDialog(
          content: new Row(
            children: [
              CircularProgressIndicator(),
              Container(margin: EdgeInsets.only(left: 20),child:Text("Exporting to excel.." )),
            ],),
        );
      },
    );
  }

  showExportCompleteDialog(){
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return AlertDialog(
          content: new Row(
            children: [
              CircularProgressIndicator(value: 100,),
              Container(margin: EdgeInsets.only(left: 20),child:Text("Export completed" )),
            ],),
        );
      },
    );
  }

  AppBar getAppBar() {
    var appBarWithDeleteIcon = AppBar(
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
      title: Text(
        "Project: ABC",
        style: TextStyle(fontSize: 16.0),
      ),
      actions: [
        IconButton(
            icon: Icon(
              Icons.import_export_sharp,
              color: Colors.white,
            ),
            onPressed: () async {
              var x = await ExportToExcel(); //Send Project name here
              debugPrint("X is ${x.toString()}"); //get filename here
              (x!=null) ? showExportCompleteDialog() : showExportProgressDialog();
            }),
        IconButton(
          icon: Icon(
            Icons.work_outline,
            color: Colors.white,
          ),
          onPressed: () => projectDialog(),
        )
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
                          Text("Date: ", style: TextStyle(fontSize: 13.0)),
                          Text(snapshot.data[index].tsModel.selectedDateStr, style: TextStyle(fontSize: 13.0)),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Hours Spent: ", style: TextStyle(fontSize: 12.0)),
                          Text(snapshot.data[index].tsModel.hrs.toString(),
                              style: TextStyle(fontSize: 14.0, color: Colors.blue, fontWeight: FontWeight.bold)),
                        ],
                      )
                    ]),
                    subtitle: Text(snapshot.data[index].tsModel.workDescription, style: TextStyle(fontSize: 14.0, color: Colors.blue)),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => InsertUpdateTimeSheet(snapshot.data[index].tsModel)));
                    });
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
          tooltip: 'Enter Timesheet',
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => InsertUpdateTimeSheet.defaultModel()));
          }),
    );
  }
}
