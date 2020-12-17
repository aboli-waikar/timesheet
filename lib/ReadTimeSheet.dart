import 'dart:async';

import 'package:flutter/material.dart';
import 'package:timesheet/DeleteTimeSheetViewModel.dart';
import 'package:timesheet/TimesheetModel.dart';

import 'InsertUpdateTimeSheet.dart';
import 'TimesheetDAO.dart';

class ReadTimeSheet extends StatefulWidget {

  @override
  _ReadTimeSheetState createState() => _ReadTimeSheetState();
}

class _ReadTimeSheetState extends State<ReadTimeSheet> {
  final tsDAO = TimesheetDAO();
  List<DeleteTimeSheetViewModel> listDelTSViewModel;

  Future<List<DeleteTimeSheetViewModel>> getTSData() async {
    debugPrint("In getTSData");
    List tsMapList = await tsDAO.getAll(); //store data retrieved from db to a variable
    List<TimeSheetModel> timesheetModels = tsMapList.map((tsRowAsMap) => TimeSheetModel.readDBRowMapAsTimeSheetModel(tsRowAsMap)).toList();
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

  AppBar getAppBar() {
    var appBarWithDeleteIcon = AppBar(
      title: Text("TimeSheet"),
      actions: [
        IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              deleteTS();
              //Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/');
            })
      ],
    );

    var appBar = AppBar(
      title: Text("TimeSheet"),
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
                          Text("Date:"),
                          Text(snapshot.data[index].tsModel.selectedDateStr),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Hours Spent:"),
                          Text(snapshot.data[index].tsModel.hrs.toString()),
                        ],
                      )
                    ]),
                    subtitle: Text(snapshot.data[index].tsModel.workDescription),
                    onLongPress: () {
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
