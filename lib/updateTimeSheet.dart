import 'package:flutter/material.dart';
import 'package:timesheet/insertTimeSheet.dart';
import 'timesheetModel.dart';
import 'timesheetDAO.dart';

class UpdateTimeSheet extends StatefulWidget {
  TimeSheetModel tsModel;

  UpdateTimeSheet(this.tsModel);

  @override
  _UpdateTimeSheetState createState() => _UpdateTimeSheetState();
}

class _UpdateTimeSheetState extends State<UpdateTimeSheet> {

  final tsDAO = TimesheetDAO();

  Future<void> selectDate(BuildContext context) async {
    final DateTime d = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2030));
    setState(() {
      widget.tsModel.selectedDate = d;
      return d;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Update Timesheet"),
        ),

        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
                  child:
                  Row(
                    children: [
                      IconButton(icon: Icon(Icons.calendar_today), tooltip: 'Pick a date', onPressed: () => selectDate(context)),
                      Text('Date: ', style: TextStyle(fontWeight: FontWeight.bold),),
                      Text(widget.tsModel.selectedDateStr), /*style: TextStyle(fontSize: 12,color: Colors.black, fontWeight: FontWeight.bold),*/
                    ],
                  ),
                ),));
  }
}
