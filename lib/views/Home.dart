import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:timesheet/daos/TimesheetTable.dart';
import 'package:timesheet/views/ToDo.dart';
import '../models/ChartViewModel.dart';
import 'package:charts_flutter/flutter.dart' as Charts;
import '../daos/TimesheetDAO.dart';
import '../models/Timesheet.dart';
import 'package:intl/intl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:timesheet/daos/ProjectDAO.dart';
import 'package:timesheet/models/Project.dart';

const FlutterSecureStorage secureStorage = FlutterSecureStorage();

class Home extends StatefulWidget {
  static String routeName = '/Home';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var chModel = ChartViewModel(DateTime.now(), 0);
  List<ChartViewModel> _myData = [ChartViewModel(DateTime.now(), 0)];
  var selectedMonth = DateTime.now();
  var prDAO = ProjectDAO();
  var prModel = Project.getNullObject();
  var projectList = [''];

  @override
  void initState() {
    super.initState();
    getTSData();
    getProjectList();
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

  Future getProjectList() async {
    debugPrint("In getProjectList");
    List prMapList = await prDAO.getAll(prDAO.pkColumn);
    List<Project> prModels = prMapList.map((e) => Project.convertToProject(e)).toList();
    projectList = prModels.map((e) => e.name).toList();
    debugPrint(projectList.toString());
    return projectList;
  }

  Future getTSData() async {
    final tsDAO = TimesheetDAO();
    List tsMapList = await tsDAO.getAll(TimesheetTable.Date); //store data retrieved from db to a variable
    var tsModels = tsMapList.map((e) => TimeSheet.convertToTimeSheet(e)).toList();
    //debugPrint(tsModels.join(", ").toString());

    setState(() {
      //debugPrint(selectedMonth.toString());
      _myData = tsModels.where((tsModel) => getMonth(tsModel.selectedDate) == getMonth(selectedMonth)).map((tsModel) {
        final DateTime date = tsModel.selectedDate;
        var hrs = tsModel.hrs;
        return ChartViewModel(date, hrs);
      }).toList();
    });
    //debugPrint(_myData.join(", ").toString());
  }

  Widget getTSChart() {
    final List<Charts.Series<ChartViewModel, DateTime>> seriesList = [
      Charts.Series<ChartViewModel, DateTime>(
        id: 'chart000',
        domainFn: (ChartViewModel chartData, _) => chartData.date,
        measureFn: (ChartViewModel chartData, _) => chartData.hrs,
        colorFn: (ChartViewModel chartData, _) => Charts.MaterialPalette.green.shadeDefault,
        data: _myData,
      ),
    ];

    var currentMonth = getMonthStr(selectedMonth);
    var tMin = _myData.fold(0, (prev, ChartViewModel element) => prev + element.getMins());
    var totalHrs = chModel.getHrsMin(tMin);

    return ListView(
      children: [
        Container(
          height: 150,
          child: Charts.TimeSeriesChart(
            seriesList,
            animate: true,
            defaultRenderer:
            Charts.BarRendererConfig<DateTime>(groupingType: Charts.BarGroupingType.stacked, cornerStrategy: Charts.ConstCornerStrategy(2)),
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
    getProjectList();
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.red, Colors.orangeAccent])),
          ),
          title: Text(
            "Home",
            style: TextStyle(fontSize: 16.0),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.calendar_today, color: Colors.white),
              onPressed: () => selectMonth(context),
            ),
          ],
        ),
        body: ListView(
          shrinkWrap: true,
          children: [
            Container(
              height: 222,
              child: ListView.builder(
                shrinkWrap: true,
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
              ),
            ),
            ToDo(),
          ],
        ));
  }
}
