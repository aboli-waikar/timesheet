import 'package:flutter/material.dart';
import 'package:timesheet/ReadTimeSheet.dart';
import 'TimesheetDAO.dart';
import 'package:timesheet/DeleteTimeSheetViewModel.dart';


class DeleteTimeSheetList extends StatefulWidget {

  List<DeleteTimeSheetViewModel> listDelTSViewModel;

  DeleteTimeSheetList(this.listDelTSViewModel);

  @override
  _DeleteTimeSheetListState createState() => _DeleteTimeSheetListState();
}

class _DeleteTimeSheetListState extends State<DeleteTimeSheetList> {

  final tsDAO = TimesheetDAO();

  Future<List<DeleteTimeSheetViewModel>> getTSData() async {
    debugPrint("In getTSData");
    // List tsMapList = await tsDAO.getAll(); //store data retrieved from db to a variable
    // List<TimeSheetModel> timesheetModels = tsMapList.map((tsRowAsMap) => TimeSheetModel.readDBRowMapAsTimeSheetModel(tsRowAsMap)).toList();
    //List<DeleteTimeSheetViewModel> listDelTSViewModel = timesheetModels.map((tsm) => DeleteTimeSheetViewModel(tsm, false)).toList();

    var listDelTSViewModel = widget.listDelTSViewModel;
    return listDelTSViewModel;
  }

  deleteTS() async {
    debugPrint ("In DeleteTS");
    List<DeleteTimeSheetViewModel> delTSViewModel = widget.listDelTSViewModel.where((element) => element.isDelete == true).toList();
    List<int> idsToBeDeleted = delTSViewModel.map((e) => e.tsModel.id).toList();
    debugPrint('$idsToBeDeleted');
    await idsToBeDeleted.forEach((id) => tsDAO.delete(id));

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
                //Navigator.pushReplacementNamed(context,'/');
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ReadTimeSheet())).then((value) => setState((){}));
              }
          )
        ],
      ),
      body: FutureBuilder<List<DeleteTimeSheetViewModel>>(
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
                      value: snapshot.data[index].isDelete,
                      onChanged: (bool newValue) {
                        setState(() {
                          snapshot.data[index].isDelete = newValue;
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
                          Text(snapshot.data[index].tsModel.selectedDateStr),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Hours Spent:"),
                          Text(snapshot.data[index].tsModel.hrs.toString()),
                        ],
                      )
                    ]),
                    subtitle: Text(snapshot.data[index].tsModel.workDescription),
                  
                );
              },
            );
          }
        },
      ),
    );
  }
}