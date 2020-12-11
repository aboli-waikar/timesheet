import 'package:timesheet/TimesheetModel.dart';
import 'TimesheetDAO.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'InsertUpdateTimeSheet.dart';
import 'DeleteTimeSheet.dart';
import 'package:timesheet/DeleteTimeSheetViewModel.dart';


class ReadTimeSheet extends StatefulWidget {

  List<DeleteTimeSheetViewModel> listDelTSViewModel;
  @override
  _ReadTimeSheetState createState() => _ReadTimeSheetState();
}

class _ReadTimeSheetState extends State<ReadTimeSheet> {

  final tsDAO = TimesheetDAO();

  Future<List<DeleteTimeSheetViewModel>> getTSData() async {
    debugPrint("In getTSData");
    List tsMapList = await tsDAO.getAll(); //store data retrieved from db to a variable
    List<TimeSheetModel> timesheetModels = tsMapList.map((tsRowAsMap) => TimeSheetModel.readDBRowMapAsTimeSheetModel(tsRowAsMap)).toList();
    List<DeleteTimeSheetViewModel> listDelTSViewModel = timesheetModels.map((tsm) => DeleteTimeSheetViewModel(tsm, false)).toList();

    //var listDelTSViewModel = widget.listDelTSViewModel;
    return listDelTSViewModel;
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
                      value: snapshot.data[index].isDelete,
                      onChanged: (bool newValue) {
                        setState(() {
                          snapshot.data[index].isDelete = newValue;
                          Navigator.push(context, MaterialPageRoute(builder: (context) => DeleteTimeSheetList(snapshot.data)));
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