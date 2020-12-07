import 'package:timesheet/timesheetModel.dart';
import 'timesheetDAO.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'insertTimeSheet.dart';


class ReadTimeSheet extends StatefulWidget {
  @override
  _ReadTimeSheetState createState() => _ReadTimeSheetState();
}

class _ReadTimeSheetState extends State<ReadTimeSheet> {
  final tsDAO = TimesheetDAO();
  List<bool> isDelete = [];

  Future<List<TimeSheetModel>> getTSData() async {
    debugPrint("In getTSData");
    List tsMapList = await tsDAO.getAll(); //store data retrieved from db to a variable
    List<TimeSheetModel> timesheetModels = tsMapList.map((tsRowAsMap) => TimeSheetModel.readDBRowMapAsTimeSheetModel(tsRowAsMap)).toList();

    for(int i = 0; i< timesheetModels.length;i++){
      isDelete.add(false);
    }
    return timesheetModels;
  }

  deleteButton(int id) {
      ElevatedButton(
        onPressed:  () {
          //deleteTimeSheet(widget.tsModel.id);
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context,'/');
        } ,
        child: Text('Delete'));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("TimeSheet"),),
      body: FutureBuilder<List<TimeSheetModel>>(
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
                      value: isDelete[index],
                      onChanged: (bool newValue) {
                        setState(() {
                          isDelete[index] = newValue;
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
                          Text(snapshot.data[index].selectedDateStr),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Hours Spent:"),
                          Text(snapshot.data[index].hrs.toString()),
                        ],
                      )
                    ]),
                    subtitle: Text(snapshot.data[index].workDescription),
                    onLongPress: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => InsertUpdateTimeSheet(snapshot.data[index])));
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