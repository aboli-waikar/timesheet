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
  @override
  var tsDAO = TimesheetDAO();
  var tsModel = TimeSheetModel(DateTime.now(), TimeOfDay.now(), TimeOfDay.now(), '');

  Future<List<TimeSheetModel>> getTSData() async {
    List tsItemList = await tsDAO.getAll(); //store data retrieved from db to a variable
    debugPrint("In getDataFromDb");
    debugPrint('Printing tsItemList $tsItemList');

    List tsItems = [];

    for (var u in tsItemList) {
      TimeSheetModel x = TimeSheetModel(u["_selectedDate"],u["_startTime"],u["_endTime"],u["_workDescription"]);
      tsItems.add(x);
    }
    print(tsItems.length);

    return tsItems;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text('Timesheet')),
      body: FutureBuilder<List<dynamic>>(
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
                  title: Text(snapshot.data[index]._workDescription),
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
