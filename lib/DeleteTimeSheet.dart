import 'package:flutter/material.dart';
import 'TimesheetModel.dart';
import 'TimesheetDAO.dart';

class DeleteTimeSheet extends StatefulWidget {
  @override
  _DeleteTimeSheetState createState() => _DeleteTimeSheetState();
  List<bool> isDeleteList;
  TimeSheetModel tsModel;

  DeleteTimeSheet(this.isDeleteList, this.tsModel);
}

class _DeleteTimeSheetState extends State<DeleteTimeSheet> {
  final tsDAO = TimesheetDAO();

  Future<List<TimeSheetModel>> getTSData() async {
    debugPrint("In getTSData");
    List tsMapList = await tsDAO.getAll(); //store data retrieved from db to a variable
    List<TimeSheetModel> timesheetModels = tsMapList.map((tsRowAsMap) => TimeSheetModel.readDBRowMapAsTimeSheetModel(tsRowAsMap)).toList();

    return timesheetModels;
  }


  deleteTS(TimeSheetModel tsModel) async {

    await tsDAO.delete(widget.tsModel.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TimeSheet"),
        actions: [
          IconButton(icon: Icon(Icons.delete),
              onPressed: (){
              if(widget.isDeleteList == true) {
                deleteTS(widget.tsModel);
                Navigator.pushReplacementNamed(context,'/').then((value) => setState((){}));
              }
              else
              null;
              }
          )
        ],
      ),
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
                  //leading: Icon(Icons.update),
                    leading: Checkbox(
                      value: widget.isDeleteList[index],
                      onChanged: (bool newValue) {
                        setState(() {
                          widget.isDeleteList[index] = newValue;
                        });
                      },
                    ),
                    // trailing: FlatButton(
                    //   child: Icon(Icons.update),
                    //   onPressed: null,),
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
                  
                );
              },
            );
          }
        },
      ),
    );
  }
}