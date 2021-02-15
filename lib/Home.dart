import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'TimesheetBarChart.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TimeSheet"),
      ),
      body: TimesheetBarChart(),
    );
  }
}

