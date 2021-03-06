import 'package:timesheet/TimesheetModel.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;


Future ExportToExcel(List<TimeSheetModel> timesheetModels) async {
  var tsModel = TimeSheetModel.getNullObject();

  Directory documentDirectory = await getApplicationDocumentsDirectory();
  String path = documentDirectory.path;

  final doc = pw.Document();

  var data = await rootBundle.load("assets/fonts/OpenSans-Regular.ttf");

  doc.addPage(pw.Page(
    build: (context) => pw.Center(
      child: pw.Text(timesheetModels[5].workDescription, style: pw.TextStyle(font: pw.Font.ttf(data),))),
    ),
  );
  File file = File('$path/timesheet.pdf');
  await file.writeAsBytes(await doc.save());
  OpenFile.open('$path/timesheet.pdf');
  return path;
}

