import 'package:flutter/material.dart';
import 'ChartModel.dart';
import 'package:charts_flutter/flutter.dart' as Charts;
import 'TimesheetDAO.dart';
import 'TimesheetModel.dart';
import 'package:intl/intl.dart';

class TimesheetBarChart extends StatefulWidget {
  @override
  _TimesheetBarChartState createState() => _TimesheetBarChartState();
}

class _TimesheetBarChartState extends State<TimesheetBarChart> {
  List<ChartModel> _myData = [ChartModel(DateTime.now(), 0)];

  @override
  void initState() {
    super.initState();
    getTSData();
  }

  getMonth(DateTime dT) {
    final DateFormat formatter = DateFormat('yyyy-MM');
    var YearMonth = formatter.format(dT);
    return YearMonth;
  }

  getMonthStr(DateTime dT) {
    final DateFormat formatter = DateFormat('MMM-yyyy');
    var YearMonth = formatter.format(dT);
    return YearMonth;
  }


  void getTSData() async {
    final tsDAO = TimesheetDAO();

    List tsMapList = await tsDAO.getAll(); //store data retrieved from db to a variable
    var tsModels = tsMapList.map((e) => TimeSheetModel.convertToTimeSheetModel(e)).toList();

    debugPrint(tsModels.join(", "));

    setState(() {
      _myData = tsModels.where((tsModel) => getMonth(tsModel.selectedDate) == getMonth(DateTime.now())).map((tsModel) {
        final DateTime Date = tsModel.selectedDate;
        final double Hrs = tsModel.hrs;
        return ChartModel(Date, Hrs);
      }).toList();
    });
    debugPrint(_myData.join(", ").toString());
  }

  Widget getTSChart() {
    final List<Charts.Series<ChartModel, DateTime>> seriesList = [
      Charts.Series<ChartModel, DateTime>(
        id: 'chart000',
        domainFn: (ChartModel chartData, _) => chartData.Date,
        measureFn: (ChartModel chartData, _) => chartData.Hrs,
        colorFn: (ChartModel chartData, _) => Charts.MaterialPalette.deepOrange.shadeDefault,
        data: _myData,
      ),
    ];
    var currentMonth = getMonthStr(DateTime.now());
    var totalHrs = _myData.fold(0, (prev, ChartModel element) => prev + element.Hrs);
    return ListView(
      children: [
        Container(
          height: 150,
          child: Charts.TimeSeriesChart(
            seriesList,
            animate: true,
            defaultRenderer: Charts.BarRendererConfig<DateTime>(),
            domainAxis: Charts.DateTimeAxisSpec(tickProviderSpec: Charts.DayTickProviderSpec(increments: [2])),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text("Total hours for $currentMonth: $totalHrs", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: getTSChart());
  }
}
