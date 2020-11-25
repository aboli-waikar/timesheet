import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'timesheet.dart';
import 'timesheetDAO.dart';
import 'timesheetModel.dart';

class InsertUpdateTimeSheet extends StatefulWidget {
  @override
  InsertUpdateTimeSheetState createState() => InsertUpdateTimeSheetState();
}

class InsertUpdateTimeSheetState extends State<InsertUpdateTimeSheet> {
  final TextEditingController textFormField = TextEditingController();
  var tsDAO = TimesheetDAO();
  var tsModel = TimeSheetModel.getNullObject();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime d = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2030));
    debugPrint('$d');
    if (d != null) {
      setState(() {
        tsModel.selectedDate = d;
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Timesheet'),
      ),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            //To align Text and Container vertically
            crossAxisAlignment: CrossAxisAlignment.center,
            //To align container and Text widgets horizontally
            children: [
              Text(
                'Date:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(icon: Icon(Icons.calendar_today), tooltip: 'Pick a date', onPressed: () => _selectDate(context)),
              Text(
                tsModel.selectedDateStr,
                style: TextStyle(fontSize: 15, color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Start Time:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(icon: Icon(Icons.access_time), tooltip: 'Pick a Start time', onPressed: () => _selectStartTime(context)),
              Text(
                tsModel.timeOfDayToString(tsModel.startTime),
                style: TextStyle(fontSize: 15, color: Colors.blue),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'End Time:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(icon: Icon(Icons.access_time), tooltip: 'Pick a Start time', onPressed: () => _selectEndTime(context)),
              Text(
                tsModel.timeOfDayToString(tsModel.endTime),
                style: TextStyle(fontSize: 15, color: Colors.blue),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 8.0, 0.0, 4.0),
          child: Text(
            'Description',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Card(
          margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 4.0),
          color: Colors.grey,
          shadowColor: Colors.black,
          child: TextFormField(
            maxLength: 1000,
            maxLines: 10,
            autofocus: true,
            controller: textFormField,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  //Call database here
                  saveTimeSheet(textFormField.text);

                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => TimeSheet(),)
                  );
                },
                child: Text('Submit'))
          ],
        ),
      ]),
    );
  }

  void saveTimeSheet(String text) async {
    tsModel.workDescription = text;
    int savedTimeSheetId = await tsDAO.insert(tsModel);
    print('$savedTimeSheetId');
  }
}
