import 'package:flutter/material.dart';
import 'insertUpdateTimeSheet.dart';

//In Android the navigation to one and other screen is called routes. This is route 1 where List of Timesheet entries will be displayed.
class TimeSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text('Timesheet')),
      //body: Card(),
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
