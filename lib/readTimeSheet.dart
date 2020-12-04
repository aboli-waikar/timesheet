import 'package:timesheet/timesheetModel.dart';
import 'timesheetDAO.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'insertTimeSheet.dart';

class ReadTimeSheet extends StatefulWidget {
  @override
  _ReadTimeSheetState createState() => _ReadTimeSheetState();
}

class _ReadTimeSheetState extends State<ReadTimeSheet> {
  final tsDAO = TimesheetDAO();

  Future<List<TimeSheetModel>> getTSData() async {
    List tsMapList = await tsDAO.getAll(); //store data retrieved from db to a variable
    var timesheetModels = tsMapList.map((tsMap) => TimeSheetModel.readDBRowAsAMap(tsMap));
    return timesheetModels.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("TimeSheet"),),
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
                  leading: Icon(Icons.update),
                  title: Column(children: [
                    Row(
                      children: [
                        Text("Date:"),
                        Text(snapshot.data[index].selectedDateStr),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Hours Spent:"),
                        Text(snapshot.data[index].hrs.toString()),
                      ],
                    )
                  ]),
                  subtitle: Text(snapshot.data[index].workDescription),
                  onTap: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateTimeSheet(snapshot.data[index])));
                    Navigator.push(context, MaterialPageRoute(builder: (context) => InsertUpdateTimeSheet(snapshot.data[index])));
                    });
                  },
                );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
          tooltip: 'Enter Timesheet',
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => InsertUpdateTimeSheet.defaultModel()));
          }),
    );
  }
}
