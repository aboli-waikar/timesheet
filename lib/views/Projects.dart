import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timesheet/daos/ProjectDAO.dart';
import 'package:timesheet/models/Project.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:core';

const FlutterSecureStorage secureStorage = FlutterSecureStorage();

class Projects extends StatefulWidget {
  @override
  ProjectsState createState() => ProjectsState();
}

class ProjectsState extends State<Projects> {
  @override

  var prDAO = ProjectDAO();
  var prModel = Project.getNullObject();

  TextEditingController projectnameController = TextEditingController();
  TextEditingController projectcompanyController = TextEditingController();
  TextEditingController projecthourlyrateController = TextEditingController();
  
  Future<List<Project>> getProject() async {
    final String storedUIDToken = await secureStorage.read(key: 'uid');
    List prMapList = await prDAO.getAll(prDAO.pkColumn);
    List<Project> prModels = prMapList.map((e)=> Project.convertToProject(e)).toList();
    if (prModels == null) {
      var prDefModel = Project(storedUIDToken, 'Default', 'Default', 10);
      await prDAO.insert(prDefModel);
      prMapList = await prDAO.getAll(prDAO.pkColumn);
      prModels = prMapList.map((e)=> Project.convertToProject(e)).toList();
      return prModels;
    }
    else
    return prModels;
  }

  addProject(String name, String company, num rate) async {
    final String storedUIDToken = await secureStorage.read(key: 'uid');
    prModel = Project(storedUIDToken, name, company, rate);
    var savedProjectId = await prDAO.insert(prModel);
    debugPrint('$savedProjectId');
  }

  editProject() {  }

  deleteProject() {  }

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
                  controller: projectcompanyController,
                  decoration: InputDecoration(labelText: 'Company Name'),
                ),
                TextField(
                  controller: projectnameController,
                  decoration: InputDecoration(labelText: 'Project Name'),
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
                    FlatButton(
                        onPressed: () {
                          addProject(projectcompanyController.text, projectnameController.text, hourlyrate);
                          Navigator.pop(context);
                        },
                        child: Text('Add Project')),
                    FlatButton(onPressed: null, child: Text('Cancel')),
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
            if(snapshot.data == null) {
              return Container(
                child: Center(
                  child: Text("Loading"),
                ),
              );
            }
            else
          {return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return ListTile(
                    title: Text(snapshot.data[index].name),
                    visualDensity: VisualDensity(vertical: -4.0),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: deleteProject(),
                    ),
                    onTap: editProject() //edit the project,
                );
              });}
        },
        )
      ],
    );
  }
}
