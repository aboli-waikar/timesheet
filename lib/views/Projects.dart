import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timesheet/daos/ProjectDAO.dart';
import 'package:timesheet/models/Project.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:core';
import 'PageRoutes.dart';

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
    //debugPrint("In getProject");
    List prMapList = await prDAO.getAll(prDAO.pkColumn);
    List<Project> prModels = prMapList.map((e) => Project.convertToProject(e)).toList();
    //debugPrint("In view Projects-GetProject: $prModels");
    return prModels;
  }

  addProject(String name, String company, num rate) async {
    final String storedUIDToken = await secureStorage.read(key: 'uid');
    prModel = Project(storedUIDToken, name, company, rate);
    var savedProjectId = await prDAO.insert(prModel);
    debugPrint('$savedProjectId');
  }

  editProject() {  }

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
                          //Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
                          //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Profile()), (route) => false);
                          //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Profile()));
                          Navigator.pop(context);
                          //Use PushReplacementNamed method to go back to the root page without back arrow in Appbar.
                          Navigator.pushReplacementNamed(context, PageRoutes.profile);
                        },
                        child: Text('Add Project')),
                    TextButton(onPressed: () => Navigator.of(context), child: Text('Cancel')),
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
                      onPressed: () async {
                        await prDAO.delete(snapshot.data[index].id);
                        Navigator.pushReplacementNamed(context, '/');
                      },
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
