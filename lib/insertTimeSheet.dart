import 'package:flutter/material.dart';
import 'package:timesheet/readTimeSheet.dart';
import 'package:timesheet/timesheetDAO.dart';
import 'dart:async';
import 'timesheetModel.dart';

class InsertUpdateTimeSheet extends StatefulWidget {
  TimeSheetModel tsModel;

  InsertUpdateTimeSheet.defaultModel() {
    this.tsModel = TimeSheetModel.getNullObject();

  }

  InsertUpdateTimeSheet(this.tsModel);
  @override
  InsertUpdateTimeSheetState createState() => InsertUpdateTimeSheetState();

}

class InsertUpdateTimeSheetState extends State<InsertUpdateTimeSheet> {
  var tsDAO = TimesheetDAO();

  final tsRead = ReadTimeSheet();

  final textFormField = TextEditingController();


  Future<void> selectDate(BuildContext context) async {
    final DateTime d = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2030));
    debugPrint('$d');
    setState(() {
      widget.tsModel.selectedDate = d;
      return d;
    });
  }

  Future<void> _selectStartTime(BuildContext context) async {
    TimeOfDay t = await showTimePicker(context: context, initialTime: TimeOfDay.now());
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
    TimeOfDay t = await showTimePicker(context: context, initialTime: TimeOfDay.now());
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
      int savedTimeSheetId = await tsDAO.insert(widget.tsModel);
      print('$savedTimeSheetId');
      // if(widget.tsModel.id == 0)
      // {}
      // else {
      // debugPrint('In Else: $text');
      // await tsDAO.update(widget.tsModel);
      //      }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text((widget.tsModel.id == null) ? "Enter Timesheet": "Update Timesheet"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Row(
              children: [
                IconButton(icon: Icon(Icons.calendar_today), tooltip: 'Pick a date', onPressed: () => selectDate(context)),
                Text(
                  'Date: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.tsModel.selectedDateStr, /*style: TextStyle(fontSize: 12,color: Colors.black, fontWeight: FontWeight.bold),*/
                ),
              ],
            ),
            Row(
              children: [
                IconButton(icon: Icon(Icons.access_time), tooltip: 'Pick a Start time', onPressed: () => _selectStartTime(context)),
                Text(
                  'Start Time: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.tsModel.timeOfDayToString(widget.tsModel.startTime), /*style: TextStyle(fontSize: 12,color: Colors.black, fontWeight: FontWeight.bold),*/
                ),
              ],
            ),
            Row(
              children: [
                IconButton(icon: Icon(Icons.access_time), tooltip: 'Pick a Start time', onPressed: () => _selectEndTime(context)),
                Text(
                  'End Time:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.tsModel.timeOfDayToString(widget.tsModel.endTime), /*style: TextStyle(fontSize: 12,color: Colors.black, fontWeight: FontWeight.bold),*/
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 8, 0, 0),
              child: Row(
                children: [
                  Text('Work Description:', style: TextStyle(fontWeight: FontWeight.bold),),

                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14.0, 8, 0, 0),
              child: TextFormField(

                maxLength: 300,
                maxLines: 5,
                autofocus: true,
                controller: textFormField,
                // onChanged: (newValue){
                //   //saveTimeSheet(newValue);
                //   debugPrint("OnChanged TextFormField.Text");
                //   debugPrint(textFormField.text);
                // },

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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ReadTimeSheet()));
                      },
                      child: Text('Submit'))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
