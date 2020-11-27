import 'package:flutter/material.dart';
import 'package:timesheet/readTimeSheet.dart';
import 'package:timesheet/timesheetDAO.dart';
import 'dart:async';
import 'timesheet.dart';
import 'timesheetModel.dart';


class insertTimeSheet extends StatefulWidget {
  @override
  _insertTimeSheetState createState() => _insertTimeSheetState();
}

class _insertTimeSheetState extends State<insertTimeSheet> {
  var tsDAO = TimesheetDAO();
  var tsModel = TimeSheetModel.getNullObject();
  final tsRead = readTimeSheet();
  Future<List<TimeSheetModel>> tsList;

  final TextEditingController textFormField = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime d = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2030));
    debugPrint('$d');
    setState(() {
      tsModel.selectedDate = d;
      return d;
    });
  }

  Future<void> _selectStartTime(BuildContext context) async {
    TimeOfDay t = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    debugPrint('$t');
    if (t != null) {
      setState(() {
        //tsModel.startTime = t.format(context);
        tsModel.startTime = t;
        debugPrint('$tsModel.startTime');
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    TimeOfDay t = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    debugPrint('$t');
    if (t != null) {
      setState(() {
        //tsModel.endTime = t.format(context);
        tsModel.endTime = t;
        debugPrint('$tsModel.endTime');
      });
    }
  }

  void saveTimeSheet(String text) async {
    tsModel.workDescription = text;
    int savedTimeSheetId = await tsDAO.insert(tsModel);
    print('$savedTimeSheetId');
    //SetState is required here to refresh the timesheet list
    setState(() {
      tsList = tsRead.getTSData();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Enter Timesheet"),),
      body: ListView(
        children: [
          Row(
            children: [
              Text('Date:', style: TextStyle(fontWeight: FontWeight.bold),),
              IconButton(icon: Icon(Icons.calendar_today), tooltip: 'Pick a date', onPressed: () => _selectDate(context)),
              Text(tsModel.selectedDateStr, style: TextStyle(fontSize: 15, color: Colors.blue, fontWeight: FontWeight.bold),),
            ],
          ),
          Row(
            children: [
              Text('Start Time:', style: TextStyle(fontWeight: FontWeight.bold),),
              IconButton(icon: Icon(Icons.access_time), tooltip: 'Pick a Start time', onPressed: () => _selectStartTime(context)),
              Text(tsModel.timeOfDayToString(tsModel.startTime), style: TextStyle(fontSize: 15, color: Colors.blue),),
            ],
          ),
          Row(
            children: [
              Text('End Time:', style: TextStyle(fontWeight: FontWeight.bold),),
              IconButton(icon: Icon(Icons.access_time), tooltip: 'Pick a Start time', onPressed: () => _selectEndTime(context)),
              Text(tsModel.timeOfDayToString(tsModel.endTime), style: TextStyle(fontSize: 15, color: Colors.blue),),
            ],
          ),
          Row(
            children: [
              Text('Description', style: TextStyle(fontWeight: FontWeight.bold),),
            ],
          ),
          TextFormField(maxLength: 300, maxLines: 5, autofocus: true, controller: textFormField,),
          Row(
            children: [
              ElevatedButton(
                  onPressed: () {
                    //Call database here
                    saveTimeSheet(textFormField.text);
                    Navigator.pop(context);
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => TimeSheetApp()));
                    //Read TS List is not refreshed here.
                  },
                  child: Text('Submit'))
            ],
          ),
        ],
      ),
    );
  }

}
