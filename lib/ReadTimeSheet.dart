import 'package:timesheet/TimesheetModel.dart';
import 'TimesheetDAO.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'InsertUpdateTimeSheet.dart';
import 'DeleteTimeSheet.dart';
import 'package:timesheet/DeleteTimeSheetViewModel.dart';

class ReadTimeSheet extends StatefulWidget {
  List<DeleteTimeSheetViewModel> listDelTSViewModel;
  DeleteTimeSheetViewModel delTSViewModel;

  @override
  _ReadTimeSheetState createState() => _ReadTimeSheetState();
}

class _ReadTimeSheetState extends State<ReadTimeSheet> {
  final tsDAO = TimesheetDAO();
  List<bool> isDelete = [];
  List idsToBeDeleted=[];

  Future<List<TimeSheetModel>> getTSData() async {
    debugPrint("In getTSData");
    List tsMapList = await tsDAO.getAll(); //store data retrieved from db to a variable
    List<TimeSheetModel> timesheetModels = tsMapList.map((tsRowAsMap) => TimeSheetModel.readDBRowMapAsTimeSheetModel(tsRowAsMap)).toList();

    for (int i = 0; i<=timesheetModels.length; i++)
      {
        isDelete.add(false);
      }

    return timesheetModels;
  }

  deleteTS() async {
    debugPrint("In DeleteTS");
    await idsToBeDeleted.forEach((id) => tsDAO.delete(id));
  }

  populateDeleteList(int id) {
    idsToBeDeleted.add(id);
    debugPrint(idsToBeDeleted.toString());
  }

  GetAppBar() {
    var appBar = AppBar(
      title: Text("TimeSheet"),
      actions: [
        IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              deleteTS();
              //Navigator.pop(context);
              Navigator.pushReplacementNamed(context,'/');
            })
      ],
    );

    var title = AppBar(
      title: Text("TimeSheet"),
    );

    if (isDelete.any((element) => element ==true))
      return appBar;
    else
      return title;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text("TimeSheet"),),
      appBar: GetAppBar(),
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
                    leading: Checkbox(
                      value: isDelete[index],
                      onChanged: (bool newValue) {
                        setState(() {
                          isDelete[index] = newValue;
                          int id = snapshot.data[index].id;
                          debugPrint('$id');
                          populateDeleteList(id);
                        });
                      },
                    ),
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
                    onLongPress: () {
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
