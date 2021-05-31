import 'package:flutter/material.dart';
import 'Home.dart';
import 'package:timesheet/views/Profile.dart';
import 'package:timesheet/views/ReadTimeSheet.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'InsertUpdateTimeSheet.dart';
import 'Expenses.dart';
import 'Projects.dart';

const FlutterSecureStorage secureStorage = FlutterSecureStorage();

class NavigateMenus extends StatefulWidget {
  const NavigateMenus({Key key}) : super(key: key);

  @override
  _NavigateMenusState createState() => _NavigateMenusState();
}

class _NavigateMenusState extends State<NavigateMenus> {
  int _selectedIndex = 0;
  bool isBusy = false;
  bool isLoggedIn = false;

  void onTapped(int value) {
    setState(() {
      _selectedIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    List _widgetClasses = [
      Home(),
      ReadTimeSheet(),
      Home(),
      Expenses(),
      Profile(),
    ];
    return MaterialApp(
      title: 'TimeSheet',
      home: Scaffold(
        body: Center(child: _widgetClasses.elementAt(_selectedIndex)),
        bottomNavigationBar: BottomNavigationBar(
          iconSize: 40.0,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.green,
          selectedFontSize: 14,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.brown,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.update,
                  color: Colors.brown,
                ),
                label: 'TimeSheet'),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle,
                color: Colors.white,
              ),
              label: ' ',
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.money_outlined,
                  color: Colors.brown,
                ),
                label: 'Expenses'),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: Colors.brown,
              ),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: onTapped,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepOrange,
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 50.0,
          ),
          onPressed: () => showSheet(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
      // routes: {
      //   PageRoutes.login: (context) => Login(),
      // }
    );
  }

  showSheet() {
    var pr = ProjectsState();
    showModalBottomSheet(
      useRootNavigator: false,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      )),
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Timesheet",
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Divider(
                        height: 2.0,
                        color: Colors.black,
                      ),
                      Row(
                        children: [
                          Container(
                              //color: Colors.deepOrange,
                              height: 100,
                              width: 100,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ElevatedButton(
                                    child: Image.asset(
                                      "images/CreateTimeSheet.png",
                                      height: 100,
                                      width: 100,
                                      alignment: Alignment.center,
                                    ),
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => InsertUpdateTimeSheet.defaultModel()));
                                    }),
                              )),
                          Container(
                              //color: Colors.deepOrange,
                              height: 100,
                              width: 100,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ElevatedButton(
                                    child: Image.asset(
                                      "images/StartTimer.png",
                                      height: 100,
                                      width: 100,
                                      alignment: Alignment.center,
                                    ),
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => InsertUpdateTimeSheet.defaultModel()));
                                    }),
                              )),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Project",
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Divider(
                        height: 2.0,
                        color: Colors.black,
                      ),
                      Row(
                        children: [
                          Container(
                              //color: Colors.deepOrange,
                              height: 100,
                              width: 100,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ElevatedButton(
                                    child: Image.asset(
                                      "images/CreateProject.png",
                                      height: 100,
                                      width: 100,
                                      alignment: Alignment.center,
                                    ),
                                    onPressed: () => pr.showProjectDialog(context),

                                    ),
                              )),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0, bottom: 40.0),
                        child: Divider(
                          height: 2.0,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
