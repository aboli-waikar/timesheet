import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'Login.dart';
import 'Projects.dart';

const FlutterSecureStorage secureStorage = FlutterSecureStorage();

final FirebaseAuth _auth = FirebaseAuth.instance;

class Profile extends StatefulWidget {
  static String routename = '/Profile';
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var picture = CircleAvatar(backgroundColor: Colors.brown, child: Text('TS', style: TextStyle(fontSize: 22),), maxRadius: 35,);
  var imgUrl;
  String name = '';
  String email = '';

  @override
  void initState() {
    getFirebaseUser();
    super.initState();
  }

  getFirebaseUser() async {
    debugPrint("getFirebaseUser");
    final user = _auth.currentUser;

    setState(() {
      imgUrl = user.photoURL;
      name = user.displayName;
      email = user.email;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.red, Colors.orangeAccent])),
        ),
        title: Text('Profile', style: TextStyle(fontSize: 16.0)),
        actions: [
          TextButton(
            onPressed: () async {
              final user = _auth.currentUser;
              if (user == null) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No one has signed in')));
                return;
              }
              await _auth.signOut();
              final String uid = user.email;
              await secureStorage.delete(key: 'uid');
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User $uid has successfully signed out.')));
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => Login()), ModalRoute.withName('/'));
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
                      child: CircleAvatar(
                        maxRadius: 30,
                        backgroundImage: imgUrl != null ? NetworkImage(imgUrl) : null,
                        child: imgUrl == null ? picture : Container(),
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
              child: Projects(),
            )
          ],
        ),
      ),
    );
  }
}
