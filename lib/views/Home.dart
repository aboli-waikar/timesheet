import 'package:flutter/material.dart';
import 'package:timesheet/views/TimesheetBarChart.dart';

class Home extends StatelessWidget {
  Home();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 0.0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.red, Colors.orangeAccent])),
          ),
        ),
        body: ListView(children: [Container(height: 280, child: TimesheetBarChart()), Text("Hello")]));
  }
}
