import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:timesheet/models/Timesheet.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter/services.dart' show rootBundle;

Future exportToPDF(List<TimeSheet> timesheetModels, String selectedMonth) async {
  final doc = pw.Document();

  formatDate(dt) {
    var formatter = DateFormat('dd-MMM-yyyy');
    return formatter.format(dt);
  }

  var date = DateTime.now();
  var reportDate = formatDate(date);

  String showMonth = selectedMonth == null ? 'Till Date' : selectedMonth;

  var data = await rootBundle.load("fonts/OpenSans-Regular.ttf");

  doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.all(70.0),
      build: (context) => pw.Center(
              child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                pw.Container(
                    color: PdfColor.fromHex('#33FCFF'),
                    width: 500,
                    height: 20,
                    child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text("Name: Aboli Waikar",
                              style: pw.TextStyle(
                                font: pw.Font.ttf(data),
                              )),
                          pw.Text("Report Date: $reportDate",
                              style: pw.TextStyle(
                                font: pw.Font.ttf(data),
                              )),
                        ])),
                pw.Text("____________________________________________________________________________________",
                    style: pw.TextStyle(
                      font: pw.Font.ttf(data),
                    )),
                pw.Text("Project:",
                    style: pw.TextStyle(
                      font: pw.Font.ttf(data),
                    )),
                pw.Text("Timesheet: $showMonth",
                    style: pw.TextStyle(
                      font: pw.Font.ttf(data),
                    )),
                pw.Text("Total number of Hours:",
                    style: pw.TextStyle(
                      font: pw.Font.ttf(data),
                    )),
                pw.Text("____________________________________________________________________________________",
                    style: pw.TextStyle(
                      font: pw.Font.ttf(data),
                    )),
                pw.Padding(
                  padding: pw.EdgeInsets.all(10.0),
                  child: pw.Text("",
                      style: pw.TextStyle(
                        font: pw.Font.ttf(data),
                      )),
                ),
                pw.Table(
                    border: pw.TableBorder.all(),
                    columnWidths: {0: pw.FixedColumnWidth(70), 1: pw.FixedColumnWidth(50), 2: pw.FlexColumnWidth()},
                    defaultVerticalAlignment: pw.TableCellVerticalAlignment.top,
                    children: [
                      pw.TableRow(children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.all(4.0),
                          child: pw.Text("Date",
                              style: pw.TextStyle(
                                font: pw.Font.ttf(data),
                              )),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(4.0),
                          child: pw.Text("Total Hours",
                              style: pw.TextStyle(
                                font: pw.Font.ttf(data),
                              )),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(4.0),
                          child: pw.Text("Work Description",
                              style: pw.TextStyle(
                                font: pw.Font.ttf(data),
                              )),
                        ),
                      ])
                    ]),
                pw.ListView.builder(
                    itemCount: timesheetModels.length,
                    itemBuilder: (context, index) {
                      return pw.Table(
                          border: pw.TableBorder.all(),
                          columnWidths: {
                            0: pw.FixedColumnWidth(70),
                            1: pw.FixedColumnWidth(50),
                            2: pw.FlexColumnWidth()
                          },
                          defaultVerticalAlignment: pw.TableCellVerticalAlignment.top,
                          children: [
                            pw.TableRow(children: [
                              pw.Padding(
                                padding: pw.EdgeInsets.all(4.0),
                                child: pw.Text(timesheetModels[index].selectedDateStr,
                                    style: pw.TextStyle(
                                      font: pw.Font.ttf(data),
                                    )),
                              ),
                              pw.Padding(
                                padding: pw.EdgeInsets.all(4.0),
                                child: pw.Text(timesheetModels[index].hrs.toString(),
                                    style: pw.TextStyle(
                                      font: pw.Font.ttf(data),
                                    )),
                              ),
                              pw.Padding(
                                padding: pw.EdgeInsets.all(4.0),
                                child: pw.Text(timesheetModels[index].workDescription,
                                    style: pw.TextStyle(
                                      font: pw.Font.ttf(data),
                                    )),
                              ),
                            ])
                          ]);
                    })
              ]))));

  Directory documentDirectory = await getApplicationDocumentsDirectory();
  String path = documentDirectory.path;

  File file = File('$path/timesheet.pdf');
  debugPrint(file.toString());
  await file.writeAsBytes(await doc.save());
  OpenFile.open('$path/timesheet.pdf');
  return path;
}
