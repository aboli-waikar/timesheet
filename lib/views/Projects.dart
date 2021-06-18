import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timesheet/daos/ProjectDAO.dart';
import 'package:timesheet/daos/TimesheetDAO.dart';
import 'package:timesheet/models/Project.dart';
import 'package:timesheet/models/Timesheet.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:core';
import 'PageRoutes.dart';
import 'NavigateMenus.dart';

const FlutterSecureStorage secureStorage = FlutterSecureStorage();

class Projects extends StatefulWidget {
  @override
  ProjectsState createState() => ProjectsState();
}

class ProjectsState extends State<Projects> {
  @override
  var prDAO = ProjectDAO();
  var tsDAO = TimesheetDAO();
  var prModel = Project.getNullObject();
  var tsModel = TimeSheet.getNullObject();

  TextEditingController projectnameController = TextEditingController();
  TextEditingController projectcompanyController = TextEditingController();
  TextEditingController projecthourlyrateController = TextEditingController();

  Future<List<Project>> getProject() async {
    //debugPrint("In getProject");
    List prMapList = await prDAO.getAll(prDAO.pkColumn);
    List<Project> prModels = prMapList.map((e) => Project.convertToProject(e)).toList();
    debugPrint("Projects - prModel: ${prModels.toString()}");
    return prModels;
  }

  addProject(String name, String company, num rate) async {
    final String storedUIDToken = await secureStorage.read(key: 'uid');
    debugPrint(storedUIDToken);
    prModel = Project(storedUIDToken, name, company, rate);
    var savedProjectId = await prDAO.insert(prModel);
    debugPrint('$savedProjectId');
  }

  editProject() {}

  deleteProjectWithTS(int id) async {
    var tsMapList = await tsDAO.getAllForProject(id, tsDAO.pkColumn);
    List<TimeSheet> tsModels = tsMapList.map((e) => TimeSheet.convertToTimeSheet(e)).toList();
    debugPrint("Projects - tsModel: ${tsModels.toString()}");
    List tsModelIds = tsModels.map((e) => e.id).toList();
    tsModelIds.forEach((element) async {await tsDAO.delete(element);});
    await prDAO.delete(id);
  }

  showProjectDialog(BuildContext context) {
    num hourlyrate;
    getProject();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Project'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextField(
                  controller: projectnameController,
                  decoration: InputDecoration(labelText: 'Project Name'),
                ),
                TextField(
                  controller: projectcompanyController,
                  decoration: InputDecoration(labelText: 'Company Name'),
                ),
                TextField(
                  controller: projecthourlyrateController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(labelText: 'Hourly Rate'),
                  onChanged: (value) => (hourlyrate = num.parse(value)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: () {
                          addProject(projectnameController.text, projectcompanyController.text, hourlyrate);
                          Navigator.pop(context);
                          //Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
                          Navigator.push(context, MaterialPageRoute(builder: (context) => NavigateMenus()));
                        },
                        child: Text('Add Project')),
                    TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: true,
      title: Text(
        'Project Information',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      children: [
        FutureBuilder(
          future: getProject(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: Text("Loading"),
                ),
              );
            } else {
              return ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        title: Text(snapshot.data[index].name),
                        visualDensity: VisualDensity(vertical: -4.0),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            if (snapshot.data[index].id == 1) {
                              //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Project can not be deleted")));
                              return showDialog(
                                  context: context,
                                  builder: (context) =>
                                      AlertDialog(title: Text("Project can not be deleted.", style: TextStyle(fontSize: 14)), actions: [
                                        ElevatedButton.icon(
                                          onPressed: () => Navigator.pop(context),
                                          icon: Icon(Icons.close_rounded),
                                          label: Text("Close"),
                                        ),
                                      ]));
                            } else {
                              deleteProjectWithTS(snapshot.data[index].id);
                              //await prDAO.delete(snapshot.data[index].id);
                            }
                            Navigator.pushReplacementNamed(context, '/');
                          },
                        ),
                        onTap: editProject() //edit the project,
                        );
                  });
            }
          },
        )
      ],
    );
  }
}
