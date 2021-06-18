import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timesheet/views/NavigateMenus.dart';
import 'package:timesheet/views/PageRoutes.dart';
import 'package:timesheet/views/Profile.dart';
import 'package:timesheet/views/ReadTimeSheet.dart';
import 'package:timesheet/views/Expenses.dart';
import 'package:timesheet/views/Home.dart';
import 'package:timesheet/views/Login.dart';

const FlutterSecureStorage secureStorage = FlutterSecureStorage();

/// -----------------------------------
///                 App
/// -----------------------------------
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //above 2 lines are required because of Firebase integration

  runApp(const TimeSheetApp());
}

class TimeSheetApp extends StatefulWidget {
  const TimeSheetApp({Key key}) : super(key: key);

  @override
  _TimeSheetAppState createState() => _TimeSheetAppState();
}

class _TimeSheetAppState extends State<TimeSheetApp> {
  bool isBusy = false;
  bool isLoggedIn = false;

  @override
  void initState() {
    initAction();
    super.initState();
  }

  Future<void> initAction() async {
    final String storedUIDToken = await secureStorage.read(key: 'uid');
    debugPrint('From main: $storedUIDToken');
    if (storedUIDToken == null) return;

    setState(() {
      isBusy = false;
      isLoggedIn = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TimeSheet',
      theme: ThemeData(
        scrollbarTheme: ScrollbarThemeData(thumbColor: MaterialStateProperty.all(Colors.black)),
      ),
      home: Scaffold(
        body: Center(
          child: isBusy
              ? const CircularProgressIndicator()
              : isLoggedIn
                  ? NavigateMenus()
                  : Login(),
        ),
      ),
        routes: {
          PageRoutes.login: (context) => Login(),
          PageRoutes.home: (context) => Home(),
          PageRoutes.readTimeSheet: (context) => ReadTimeSheet(),
          PageRoutes.expenses: (context) => Expenses(),
          PageRoutes.profile: (context) => Profile(),
        }
    );
  }
}
