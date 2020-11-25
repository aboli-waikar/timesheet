import 'package:flutter/material.dart';
import 'package:timesheet/timesheetDAO.dart';
import 'package:timesheet/timesheetModel.dart';
import 'insertUpdateTimeSheet.dart';
import 'dart:async';

//In Android the navigation to one and other screen is called routes. This is route 1 where List of Timesheet entries will be displayed.
class TimeSheet extends StatefulWidget {
  @override
  _TimeSheetState createState() => _TimeSheetState();
}

class _TimeSheetState extends State<TimeSheet> {
  var tsDAO = TimesheetDAO();
  var tsModel = TimeSheetModel.getNullObject();

  Future<List<TimeSheetModel>> getTSData() async {
    List tsMapList = await tsDAO.getAll(); //store data retrieved from db to a variable

    var timesheetModels = tsMapList.map((tsMap) => TimeSheetModel.readDBRowAsAMap(tsMap));
    return timesheetModels.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text('Timesheet')),
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
                  title: Text(snapshot.data[index].workDescription),
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
          Navigator.push(context, MaterialPageRoute(builder: (context) => InsertUpdateTimeSheet()));
        },
      ),
    );
  }
}
