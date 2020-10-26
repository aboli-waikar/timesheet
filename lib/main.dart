import 'package:flutter/material.dart';
import 'home.dart';
import 'report.dart';
import 'timesheet.dart';

void main() => runApp(TimeSheetApp());

class TimeSheetApp extends StatefulWidget {
  @override
  _TimeSheetAppState createState() => _TimeSheetAppState();
}

class _TimeSheetAppState extends State<TimeSheetApp> {
  int _selectedIndex = 0;
  List _widgetClasses = [
    Home(),
    TimeSheet(),
    Report(),
  ];

  void _onTapped(int value) {
    setState(() {
      _selectedIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TimeSheet',
      home: Scaffold(
        appBar: AppBar(
          title: Text('TimeSheet'),
          backgroundColor: Colors.blueAccent,
        ),
        body: Center(
          child: _widgetClasses.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.update), label: 'TimeSheet'),
            BottomNavigationBarItem(icon: Icon(Icons.import_export), label: 'Report'),
          ],
          currentIndex: _selectedIndex,
          onTap: _onTapped,
        ),
      ),
    );
  }
}
