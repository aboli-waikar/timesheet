import 'package:flutter/material.dart';
import 'package:timesheet/TimesheetBarChart.dart';

class Home extends StatelessWidget {
  Home();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text("Dashboard"),),
      body: TimesheetBarChart()
    );
  }
}