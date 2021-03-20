import 'package:flutter/material.dart';
import 'package:timesheet/views/Login.dart';
import 'package:timesheet/views/NavigateMenus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const FlutterSecureStorage secureStorage = FlutterSecureStorage();

/// -----------------------------------
///                 App
/// -----------------------------------
void main() => runApp(const TimeSheetApp());

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
      home: Scaffold(
        body: Center(
          child: isBusy
              ? const CircularProgressIndicator()
              : isLoggedIn
                  ? NavigateMenus()
                  : Login(),
        ),
      ),
    );
  }
}
