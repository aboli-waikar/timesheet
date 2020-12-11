import 'package:flutter/material.dart';
import 'package:timesheet/ListTimeSheet.dart';
import 'TimesheetModel.dart';
import 'TimesheetDAO.dart';


class DelTimeSheet extends StatefulWidget {
  DeleteTimeSheetViewModel deleteTimeSheetViewModel;

  DelTimeSheet(this.deleteTimeSheetViewModel);

  @override
  _DelTimeSheetState createState() => _DelTimeSheetState();
}

class _DelTimeSheetState extends State<DelTimeSheet> {
  final tsDAO = TimesheetDAO();

  deleteTS() async {
    await tsDAO.delete(widget.deleteTimeSheetViewModel.timeSheetModel.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TimeSheet"),
        actions: [
          IconButton(icon: Icon(Icons.delete),
              onPressed: (){
                deleteTS();
                Navigator.pushReplacementNamed(context,'/').then((value) => setState((){}));
              }
          )
        ],
      ),
      body: FutureBuilder<List<TimeSheetModel>>(
        //future: getTSData(),
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
                    value: widget.deleteTimeSheetViewModel.toDelete,
                    onChanged: (bool newValue) {
                      setState(() {
                        widget.deleteTimeSheetViewModel.toDelete = newValue;
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