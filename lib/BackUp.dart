//Backup of simplebarchart

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as Charts;
import 'TimesheetDAO.dart';
import 'TimesheetModel.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TimeSheet"),
      ),
      body: Container(child: SimpleBarChart()),
    );
  }
}

class SimpleBarChart extends StatefulWidget {
  @override
  _SimpleBarChartState createState() => _SimpleBarChartState();
}

class ChartModel {
  final DateTime Date;
  final double Hrs;

  ChartModel(this.Date, this.Hrs);
}

class _SimpleBarChartState extends State<SimpleBarChart> {
  List<ChartModel> _myData = [ChartModel(DateTime.now(), 0)];

  @override
  void initState() {
    super.initState();
    getTSData();
  }

  void getTSData() async {
    final tsDAO = TimesheetDAO();

    List tsMapList = await tsDAO.getAll(); //store data retrieved from db to a variable
    var tsModels = tsMapList.map((e) => TimeSheetModel.convertToTimeSheetModel(e)).toList();

    debugPrint(tsModels.join(", "));


    setState(() {
      _myData = tsModels.map((tsModel) {
        final DateTime Date = tsModel.selectedDate;
        final double Hrs = tsModel.hrs;
        return ChartModel(Date, Hrs);
      }).toList();
    });
    debugPrint(_myData.join(", "));
  }

  Widget getSimpleChart() {
    final List<Widget> widgets = <Widget>[];
    if (_myData.length > 0) {
      final List<Charts.Series<ChartModel, DateTime>> seriesList = [
        Charts.Series<ChartModel, DateTime>(
          id: 'chart000',
          domainFn: (ChartModel chartData, _) => chartData.Date,
          measureFn: (ChartModel chartData, _) => chartData.Hrs,
          colorFn: (ChartModel chartData, _) => Charts.MaterialPalette.deepOrange.shadeDefault,
          data: _myData,
        ),
      ];
      widgets.add(SizedBox(
        height: 150,
        width: 700,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Charts.TimeSeriesChart(
            seriesList,
            animate: true,
            defaultRenderer: Charts.BarRendererConfig<DateTime>(),
          ),
        ),
      ));
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Timesheet Overview Timesheet Overview Timesheet"),
        Column(children: widgets),

      ],

    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getSimpleChart(),
    );
  }
}
