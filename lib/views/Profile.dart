import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'Login.dart';

const FlutterSecureStorage secureStorage = FlutterSecureStorage();

final FirebaseAuth _auth = FirebaseAuth.instance;

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var picture = AssetImage("images/profile.png");
  String name;
  String email;
  List<String> projects = ['P1', 'P2'];
  TextEditingController projectnameController = TextEditingController();
  TextEditingController projectcompanyController = TextEditingController();
  TextEditingController projecthourlyrateController = TextEditingController();

  @override
  void initState() {
    getFirebaseUser();
    super.initState();
  }

  getFirebaseUser() async {
    debugPrint("getFirebaseUser");
    final FirebaseUser user = await _auth.currentUser();

    setState(() {
      picture = (user.photoUrl == null) ? AssetImage("images/profile.png") : NetworkImage(user.photoUrl);
      name = (user.displayName == null) ? user.displayName : 'Profile';
      email = user.email;
    });
  }

  addProject(String text) {
    projects.add(text);
    debugPrint('$projects');
  }

  showProjectDialog() {
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
                  decoration: InputDecoration(labelText: 'Hourly Rate'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FlatButton(
                        onPressed: () {
                          setState(() {
                            addProject(projectnameController.text);
                            //textEditingController.text = '';
                          });
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
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.red, Colors.orangeAccent])),
        ),
        title: Text('Profile', style: TextStyle(fontSize: 16.0)),
        actions: [
          FlatButton(
            onPressed: () async {
              final FirebaseUser user = await _auth.currentUser();
              if (user == null) {
                Scaffold.of(context).showSnackBar(SnackBar(content: Text('No one has signed in')));
                return;
              }
              await _auth.signOut();
              final String uid = user.email;
              await secureStorage.delete(key: 'uid');
              Scaffold.of(context).showSnackBar(SnackBar(content: Text('User $uid has successfully signed out.')));
              Navigator.pushAndRemoveUntil(
                  context, MaterialPageRoute(builder: (BuildContext context) => Login()), ModalRoute.withName('/'));
            },
            child: Text(
              'Sign out',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
                child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, bottom: 10.0, top: 10.0),
                      child: Image(
                        image: picture,
                        height: 80,
                        width: 80,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 237,
                          child: ListTile(
                            title: Text(
                              '$name',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            visualDensity: VisualDensity(vertical: -4.0),
                            subtitle: Text('$email'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            )),
            Card(
              child: ExpansionTile(
                title: Text(
                  'Project Information',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: projects.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                            title: Text(projects[index]),
                            visualDensity: VisualDensity(vertical: -4.0),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: null,
                            ),
                            onTap: null //edit the project,
                            );
                      })
                ],
              ),
            )
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   tooltip: 'Add Project',
      //   child: Icon(Icons.add),
      //   onPressed: () => showProjectDialog(),
      // )
    );
  }
}
