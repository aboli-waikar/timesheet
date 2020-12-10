import 'package:timesheet/TimesheetModel.dart';
import 'TimesheetDAO.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'InsertUpdateTimeSheet.dart';
import 'DelTimeSheet.dart';

class DeleteTimeSheetViewModel {
  TimeSheetModel timeSheetModel;
  bool toDelete;

  DeleteTimeSheetViewModel(this.timeSheetModel, this.toDelete);
}

class ListTimeSheet extends StatefulWidget {
  List<DeleteTimeSheetViewModel> deleteTSVMs;

  @override
  _ListTimeSheetState createState() => _ListTimeSheetState();
}

class _ListTimeSheetState extends State<ListTimeSheet> {
  final tsDAO = TimesheetDAO();

  Future<List<DeleteTimeSheetViewModel>> getTSData() async {
    debugPrint("In getTSData");
    List tsMapList = await tsDAO.getAll(); //store data retrieved from db to a variable
    List<TimeSheetModel> timesheetModels = tsMapList.map((tsRowAsMap) => TimeSheetModel.readDBRowMapAsTimeSheetModel(tsRowAsMap));
    widget.deleteTSVMs = timesheetModels.map((tsm) => DeleteTimeSheetViewModel(tsm, false));
    return widget.deleteTSVMs.toList();
  }

  Future<List<DeleteTimeSheetViewModel>> toBeDeletedList() async {
    debugPrint("In to be deleted");
    List<DeleteTimeSheetViewModel> deleteTSVMs = widget.deleteTSVMs.where((dtsvm) => dtsvm.toDelete == true);
    await tsDAO.delete(deleteTSVMs.map((dtsvm) => dtsvm.timeSheetModel.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("TimeSheet"),),
      body: FutureBuilder<List<DeleteTimeSheetViewModel>>(
        future: getTSData(),
        builder: (context, snapshot) {
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
                  //leading: Icon(Icons.update),
                    leading: Checkbox(
                      value: snapshot.data[index].toDelete,
                      onChanged: (bool newValue) {
                        setState(() {
                          snapshot.data[index].toDelete = newValue;
                          Navigator.push(context, MaterialPageRoute(builder: (context) => DelTimeSheet(snapshot.data[index])));
                        });
                      },
                    ),
                    // trailing: FlatButton(
                    //   child: Icon(Icons.update),
                    //   onPressed: null,),
                    title: Column(children: [
                      Row(
                        children: [
                          Text("Date:"),
                          Text(snapshot.data[index].timeSheetModel.selectedDateStr),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Hours Spent:"),
                          Text(snapshot.data[index].timeSheetModel.hrs.toString()),
                        ],
                      )
                    ]),
                    subtitle: Text(snapshot.data[index].timeSheetModel.workDescription),
                    onLongPress: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => InsertUpdateTimeSheet(snapshot.data[index].timeSheetModel)));
                    }
                );
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