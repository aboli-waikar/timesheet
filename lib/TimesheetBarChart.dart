import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
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
  var chModel = ChartModel(DateTime.now(), 0);
  List<ChartModel> _myData = [ChartModel(DateTime.now(), 0)];
  var selectedMonth = DateTime.now();
  List<String> projectList = ['P1', 'P2'];

  @override
  void initState() {
    super.initState();
    getTSData();
  }

  getMonth(DateTime dT) {
    final DateFormat formatter = DateFormat('yyyy-MM');
    var yearMonth = formatter.format(dT);
    return yearMonth;
  }

  getMonthStr(DateTime dT) {
    final DateFormat formatter = DateFormat('MMM-yyyy');
    var yearMonth = formatter.format(dT);
    return yearMonth;
  }

  Future<void> selectMonth(BuildContext context) async {
    final DateTime d = await showMonthPicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2030));
    setState(() {
      selectedMonth = d;
      getTSData();
    });
  }

  Future getTSData() async {
    final tsDAO = TimesheetDAO();
    List tsMapList = await tsDAO.getAll(tsDAO.date); //store data retrieved from db to a variable
    var tsModels = tsMapList.map((e) => TimeSheetModel.convertToTimeSheetModel(e)).toList();
    //debugPrint(tsModels.join(", ").toString());

    setState(() {
      //debugPrint(selectedMonth.toString());
      _myData = tsModels.where((tsModel) => getMonth(tsModel.selectedDate) == getMonth(selectedMonth)).map((tsModel) {
        final DateTime date = tsModel.selectedDate;
        var hrs = tsModel.hrs;
        return ChartModel(date, hrs);
      }).toList();
    });
    //debugPrint(_myData.join(", ").toString());
  }

  Widget getTSChart() {
    final List<Charts.Series<ChartModel, DateTime>> seriesList = [
      Charts.Series<ChartModel, DateTime>(
        id: 'chart000',
        domainFn: (ChartModel chartData, _) => chartData.date,
        measureFn: (ChartModel chartData, _) => chartData.hrs,
        colorFn: (ChartModel chartData, _) => Charts.MaterialPalette.green.shadeDefault,
        data: _myData,
      ),
    ];

    var currentMonth = getMonthStr(selectedMonth);
    var tMin = _myData.fold(0, (prev, ChartModel element) => prev + element.getMins());
    var totalHrs = chModel.getHrsMin(tMin);

    return ListView(
      children: [
        Container(
          height: 150,
          child: Charts.TimeSeriesChart(
            seriesList,
            animate: true,
            defaultRenderer:
            Charts.BarRendererConfig<DateTime>(
                groupingType: Charts.BarGroupingType.stacked,
                cornerStrategy: Charts.ConstCornerStrategy(2)),
                domainAxis: Charts.DateTimeAxisSpec(tickProviderSpec: Charts.DayTickProviderSpec(increments: [2])),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: Text(
            "$currentMonth: $totalHrs hours",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 12),
          )),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.red, Colors.orangeAccent]
              )
            ),
          ),
          title: Text("Home", style: TextStyle(fontSize: 16.0),),
          actions: [
            IconButton(
              icon: Icon(Icons.calendar_today, color: Colors.white), onPressed: () => selectMonth(context),),
          ],
        ),
        body: ListView.builder(
          shrinkWrap: false,
          scrollDirection: Axis.horizontal,
          itemCount: projectList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                Text('${projectList[index]}'),
                ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Container(
                        //color: Theme.of(context).colorScheme.background,
                        padding: MediaQuery.of(context).padding,
                        child: getTSChart(),
                        height: 185,
                        width: 200))
              ]),
            );
          },
        ));
  }
}
