import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'TimesheetBarChart.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var selectedMonth;
    List<String> projectList = ['P1', 'P2', 'P3', 'P4'];
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today, color: Colors.white),
            onPressed: () {
              showMonthPicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2030))
                  .then((value) => selectedMonth);
            },
          )
        ],
      ),
      body: ListView(children: [
        Container(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: false,
            itemCount: projectList.length,
            itemBuilder: (context, index) {
              return Card(//color: Colors.lightBlue,
                  child: Column(children: [
                    //Text('${projectList[index]}'),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(child: TimesheetBarChart(), height: 150, width: 250),
                    ),

              ]));
            },
          ),
        ),
        Text("Hello"),
      ]),
    );
  }
}
