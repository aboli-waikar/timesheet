import 'package:flutter/material.dart';

import 'insertTimeSheet.dart';
//import 'package:timesheet/timesheetModel.dart';
import 'readTimeSheet.dart';

//In Android the navigation to one and other screen is called routes. This is route 1 where List of Timesheet entries will be displayed.
class TimeSheet extends StatefulWidget {
  @override
  _TimeSheetState createState() => _TimeSheetState();
}

class _TimeSheetState extends State<TimeSheet> {
  final tsRead = readTimeSheet();
  @override


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text('Timesheet')),
      body: tsRead,
      floatingActionButton: FloatingActionButton(
          tooltip: 'Enter Timesheet', child: Icon(Icons.add),
          onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => insertTimeSheet()));
                        }
        ),
    );
  }
}

