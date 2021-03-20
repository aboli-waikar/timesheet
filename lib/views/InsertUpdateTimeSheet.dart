import 'package:flutter/material.dart';
import 'package:timesheet/views/ReadTimeSheet.dart';
import 'package:timesheet/daos/TimesheetDAO.dart';
import 'dart:async';
import '../models/Timesheet.dart';

class InsertUpdateTimeSheet extends StatefulWidget {
  TimeSheet tsModel;

  InsertUpdateTimeSheet.defaultModel() {
    this.tsModel = TimeSheet.getNullObject();
  }

  InsertUpdateTimeSheet(this.tsModel);
  @override
  InsertUpdateTimeSheetState createState() => InsertUpdateTimeSheetState();
}

class InsertUpdateTimeSheetState extends State<InsertUpdateTimeSheet> {
  final tsDAO = TimesheetDAO();

  final ReadTimeSheet tsRead = ReadTimeSheet();

  TextEditingController textFormField;

  bool isEnabled;

  @override
  void initState() {
    super.initState();
    textFormField = TextEditingController(text: widget.tsModel.workDescription);
    isEnabled = (widget.tsModel.id == null) ? false : true;
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime d = await showDatePicker(
        context: context,
        initialDate: widget.tsModel.selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2030));
    debugPrint('$d');
    setState(() {
      widget.tsModel.selectedDate = d;
      return d;
    });
  }

  Future<void> _selectStartTime(BuildContext context) async {
    TimeOfDay t = await showTimePicker(context: context, initialTime: widget.tsModel.startTime);
    debugPrint('$t');
    if (t != null) {
      setState(() {
        //tsModel.startTime = t.format(context);
        widget.tsModel.startTime = t;
        debugPrint('${widget.tsModel.startTime}');
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    TimeOfDay t = await showTimePicker(context: context, initialTime: widget.tsModel.endTime);
    debugPrint('$t');
    if (t != null) {
      setState(() {
        //tsModel.endTime = t.format(context);
        widget.tsModel.endTime = t;
        debugPrint('${widget.tsModel.endTime}');
      });
    }
  }

  void saveTimeSheet(String text) async {
    widget.tsModel.workDescription = text;

    if (widget.tsModel.id == null) {
      int savedTimeSheetId = await tsDAO.insert(widget.tsModel);
      print('$savedTimeSheetId');
    } else
      await tsDAO.update(widget.tsModel);
  }

  void deleteTimeSheet(int id) async {
    widget.tsModel.id = id;
    await tsDAO.delete(id);
  }

  DeleteButton() {
    var delete = ElevatedButton(
        onPressed: () {
          deleteTimeSheet(widget.tsModel.id);
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, '/');
        },
        child: Text('Delete'));
    return delete;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //toolbarHeight: 0.0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.red, Colors.orangeAccent])),
        ),
        title: Text((widget.tsModel.id == null) ? "Enter Timesheet" : "Update Timesheet"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Row(
              children: [
                IconButton(
                    icon: Icon(
                      Icons.calendar_today,
                      color: Colors.blueAccent,
                    ),
                    tooltip: 'Pick a date',
                    onPressed: () => selectDate(context)),
                Text(
                  'Date: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.tsModel
                      .selectedDateStr, /*style: TextStyle(fontSize: 12,color: Colors.black, fontWeight: FontWeight.bold),*/
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                    icon: Icon(Icons.access_time, color: Colors.blueAccent),
                    tooltip: 'Pick a Start time',
                    onPressed: () => _selectStartTime(context)),
                Text(
                  'Start Time: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.tsModel.timeOfDayToString(widget.tsModel.startTime),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                    icon: Icon(Icons.access_time, color: Colors.blueAccent),
                    tooltip: 'Pick a Start time',
                    onPressed: () => _selectEndTime(context)),
                Text(
                  'End Time: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.tsModel.timeOfDayToString(widget.tsModel
                      .endTime), /*style: TextStyle(fontSize: 12,color: Colors.black, fontWeight: FontWeight.bold),*/
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 8, 0, 0),
              child: Row(
                children: [
                  Text(
                    'Work Description:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14.0, 8, 14.0, 0),
              child: TextFormField(
                maxLength: 300,
                maxLines: 5,
                autofocus: true,
                controller: textFormField,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 8, 0, 0),
              child: Row(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        //Call database here
                        saveTimeSheet(textFormField.text);
                        Navigator.pop(context);
                        //Use PushReplacementNamed method to go back to the root page without back arrow in Appbar.
                        Navigator.pushReplacementNamed(context, '/');
                      },
                      child: Text(isEnabled ? 'Update' : 'Submit')),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: isEnabled ? DeleteButton() : null,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
