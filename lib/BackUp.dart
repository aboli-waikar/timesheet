//External Packages
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

//Flutter Packages
import 'package:flutter/material.dart';
import 'Home.dart';
import 'ReadTimeSheet.dart';
import 'package:timesheet/Login.dart';
import 'Profile.dart';

//Auth variables https://manage.auth0.com/

const AUTH0_DOMAIN = 'dev-sctokcpr.us.auth0.com';
const AUTH0_CLIENT_ID = 'UNPiqx2hiVssK5im3qxw54YiQNPPp02U';

const AUTH0_REDIRECT_URI = 'codionics.com.timesheet://login-callback';
const AUTH0_ISSUER = 'https://$AUTH0_DOMAIN';


void main() => runApp(TimeSheetApp());

class TimeSheetApp extends StatefulWidget {
  @override
  _TimeSheetAppState createState() => _TimeSheetAppState();
}

//App State

class _TimeSheetAppState extends State<TimeSheetApp> {
  int _selectedIndex = 2;
  bool isBusy = false;
  bool isLoggedIn = false;
  String errorMessage;
  String name;
  String picture;

  final FlutterAppAuth appAuth = FlutterAppAuth();
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

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
      Profile(logoutAction, name , picture),
    ];

    return MaterialApp(
      title: 'TimeSheet',
      home: Scaffold(
        //appBar: AppBar(title: Text('TimeSheet'), backgroundColor: Colors.blueAccent,),
        body: Center(
          child: //_widgetClasses.elementAt(_selectedIndex),
          isBusy
              ? const CircularProgressIndicator()
              : isLoggedIn
              ? _widgetClasses.elementAt(_selectedIndex)
              : Login(loginAction, errorMessage),

        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.update), label: 'TimeSheet'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
          currentIndex: _selectedIndex,
          onTap: onTapped,
        ),
      ),
    );
  }


  Map<String, dynamic> parseIdToken(String idToken){
    final List<String> parts = idToken.split(r'.');
    assert (parts.length == 3);
    return jsonDecode(utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
  }

  Future<Map> getUserDetails(String accessToken) async {
    final url = 'https://$AUTH0_DOMAIN/userinfo';
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200)
      return jsonDecode(response.body);
    else
      throw Exception('Failed to get user details');

  }

  Future<void> loginAction() async {
    setState(() {
      isBusy = true;
      errorMessage = '';
    });

    try{
      final AuthorizationTokenResponse result = await appAuth.authorizeAndExchangeCode(
          AuthorizationTokenRequest(AUTH0_CLIENT_ID, AUTH0_REDIRECT_URI, issuer: 'https://$AUTH0_DOMAIN',
            scopes: ['openid', 'profile', 'offline_access'],
            promptValues: ['login'], // ignore any existing session; force interactive login prompt
          )
      );

      final idToken = parseIdToken(result.idToken);
      final profile = await getUserDetails(result.accessToken);

      await secureStorage.write(key: 'refresh_token', value: result.refreshToken);

      setState(() {
        isBusy = false;
        isLoggedIn = true;
        name = idToken['name'];
        picture = profile['picture'];
      });
    }
    catch (e, s)
    {
      print('login error: $e - stack: $s');
      setState(() {
        isBusy = false;
        isLoggedIn = false;
        errorMessage = e.toString();
      });

    }
  }

  logoutAction() async {
    await secureStorage.delete(key: 'refresh_token');
    setState(() {
      isLoggedIn = false;
      isBusy = false;
    });
  }

  @override
  void initState() {
    initAction();
    super.initState();
  }

  void initAction() async {
    final storedRefreshToken = await secureStorage.read(key: 'refresh_token');
    if(storedRefreshToken == null ) return;
    setState(() {
      isBusy = true;
    });

    try{
      final response = await appAuth.token(
          TokenRequest(AUTH0_CLIENT_ID, AUTH0_REDIRECT_URI,
              issuer: AUTH0_ISSUER, refreshToken: storedRefreshToken));
      final idToken = parseIdToken(response.idToken);
      final profile = await getUserDetails(response.accessToken);

      secureStorage.write(key: 'refresh_token', value: response.refreshToken);

      setState(() {
        isBusy = false;
        isLoggedIn = true;
        name = idToken ['name'];
        picture = profile['picture'];
      });

    }
    catch(e,s) {
      print('error on refresh token: $e - stack: $s');
      logoutAction();
    }
  }

}



