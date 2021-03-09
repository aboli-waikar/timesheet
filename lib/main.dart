/// -----------------------------------
///          External Packages
/// -----------------------------------
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:timesheet/Home.dart';
import 'package:timesheet/ReadTimeSheet.dart';
import 'Profile.dart';
import 'package:timesheet/Login.dart';

final FlutterAppAuth appAuth = FlutterAppAuth();
const FlutterSecureStorage secureStorage = FlutterSecureStorage();

/// -----------------------------------
///           Auth0 Variables
/// -----------------------------------
const String AUTH0_DOMAIN = 'dev-sctokcpr.us.auth0.com';
const String AUTH0_CLIENT_ID = 'UNPiqx2hiVssK5im3qxw54YiQNPPp02U';

const String AUTH0_REDIRECT_URI = 'codionics.com.timesheet://login-callback';
const String AUTH0_ISSUER = 'https://$AUTH0_DOMAIN';

/// -----------------------------------
///                 App
/// -----------------------------------
void main() => runApp(const TimeSheetApp());

class TimeSheetApp extends StatefulWidget {
  const TimeSheetApp({Key key}) : super(key: key);

  @override
  _TimeSheetAppState createState() => _TimeSheetAppState();
}

/// -----------------------------------
///              App State
/// -----------------------------------
class _TimeSheetAppState extends State<TimeSheetApp> {
  int _selectedIndex = 2;
  bool isBusy = false;
  bool isLoggedIn = false;
  String errorMessage;
  String name;
  String picture;

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
      Profile(logoutAction, name, picture),
    ];
    return MaterialApp(
      title: 'TimeSheet',
      home: Scaffold(

        body: Center(
          child: isBusy
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

  Map<String, Object> parseIdToken(String idToken) {
    final List<String> parts = idToken.split('.');
    assert(parts.length == 3);

    return jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
  }

  Future<Map<String, Object>> getUserDetails(String accessToken) async {
    const String url = 'https://$AUTH0_DOMAIN/userinfo';
    final http.Response response = await http.get(
      url,
      headers: <String, String>{'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user details');
    }
  }

  Future<void> loginAction() async {
    setState(() {
      isBusy = true;
      errorMessage = '';
    });

    try {
      final AuthorizationTokenResponse result =
      await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          AUTH0_CLIENT_ID,
          AUTH0_REDIRECT_URI,
          issuer: 'https://$AUTH0_DOMAIN',
          scopes: <String>['openid', 'profile', 'offline_access'],
          // promptValues: ['login']
        ),
      );

      final Map<String, Object> idToken = parseIdToken(result.idToken);
      final Map<String, Object> profile =
      await getUserDetails(result.accessToken);

      await secureStorage.write(
          key: 'refresh_token', value: result.refreshToken);

      setState(() {
        isBusy = false;
        isLoggedIn = true;
        name = idToken['name'];
        picture = profile['picture'];
      });
    } on Exception catch (e, s) {
      debugPrint('login error: $e - stack: $s');

      setState(() {
        isBusy = false;
        isLoggedIn = false;
        errorMessage = e.toString();
      });
    }
  }

  Future<void> logoutAction() async {
    await secureStorage.delete(key: 'refresh_token');
    setState(() {
      isLoggedIn = false;
      isBusy = false;
    });
  }

  @override
  void initState() {
    //initAction();
    super.initState();
  }
  //
  // Future<void> initAction() async {
  //   final String storedRefreshToken =
  //   await secureStorage.read(key: 'refresh_token');
  //   if (storedRefreshToken == null) return;
  //
  //   setState(() {
  //     isBusy = true;
  //   });
  //
  //   try {
  //     final TokenResponse response = await appAuth.token(TokenRequest(
  //       AUTH0_CLIENT_ID,
  //       AUTH0_REDIRECT_URI,
  //       issuer: AUTH0_ISSUER,
  //       refreshToken: storedRefreshToken,
  //     ));
  //
  //     final Map<String, Object> idToken = parseIdToken(response.idToken);
  //     final Map<String, Object> profile =
  //     await getUserDetails(response.accessToken);
  //
  //     await secureStorage.write(
  //         key: 'refresh_token', value: response.refreshToken);
  //
  //     setState(() {
  //       isBusy = false;
  //       isLoggedIn = true;
  //       name = idToken['name'];
  //       picture = profile['picture'];
  //     });
  //   } on Exception catch (e, s) {
  //     debugPrint('error on refresh token: $e - stack: $s');
  //     await logoutAction();
  //   }
  // }
  //
}