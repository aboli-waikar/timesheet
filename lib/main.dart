import 'package:flutter/material.dart';
import 'package:timesheet/TimesheetBarChart.dart';
import 'Home.dart';
import 'Profile.dart';
import 'ReadTimeSheet.dart';

void main() => runApp(TimeSheetApp());

class TimeSheetApp extends StatefulWidget {
  @override
  TimeSheetAppState createState() => TimeSheetAppState();
}

class TimeSheetAppState extends State<TimeSheetApp> {
  int _selectedIndex = 0;
  List _widgetClasses = [
    Home(),
    ReadTimeSheet(),
    Profile(),
  ];

  //forTimeSheet(this._selectedIndex);

  void onTapped(int value) {
    setState(() {
      _selectedIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TimeSheet',
      home: Scaffold(
        //appBar: AppBar(title: Text('TimeSheet'), backgroundColor: Colors.blueAccent,),
        body: Center(
          child: _widgetClasses.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.update), label: 'TimeSheet'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
          currentIndex: _selectedIndex,
          onTap: onTapped,
        ),
      ),
    );
  }
}
