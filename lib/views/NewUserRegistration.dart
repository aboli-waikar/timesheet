import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:timesheet/views/NavigateMenus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const FlutterSecureStorage secureStorage = FlutterSecureStorage();

class NewUserRegistration extends StatefulWidget {
  final String title = 'Registration';

  @override
  _NewUserRegistrationState createState() => _NewUserRegistrationState();
}

class _NewUserRegistrationState extends State<NewUserRegistration> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _success;
  String _userEmail;
  bool showPassword = true;

  var _auth = FirebaseAuth.instance;

  //The GlobalKey<FormState> object will be used for validating the user’s entered email and password, and both of the TextEditingControllers are used for tracking changes to those text fields. The last two attributes, _success and _userEmail, will be used to keep track of state for this screen.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
        ),
        body: Stack(
          children: [
            Container(
              height: 410,
              width: 430,
              decoration:
                  BoxDecoration(image: DecorationImage(image: AssetImage("images/background.jpeg"), fit: BoxFit.cover)),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 3,
                    width: MediaQuery.of(context).size.width / 3,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: AssetImage("images/icon.png")),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('L O G I N',
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 8.0),
                            child: TextFormField(
                              controller: _emailController,
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(fontSize: 14),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                ),
                              ),
                              validator: (String value) {
                                debugPrint(_emailController.text);
                                if (value.isEmpty) {
                                  return 'Email required';
                                }
                                return null;
                              },
                              //keyboardType: TextInputType.emailAddress,
                              //inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 8.0),
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: showPassword,
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(fontSize: 14),
                                suffixIcon: IconButton(
                                  icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      showPassword = false;
                                    });
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                ),
                              ),
                              validator: (String value) {
                                debugPrint(value);
                                if (value.isEmpty) {
                                  return 'Please enter password';
                                }
                                return null;
                              },
                              //inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 8.0),
                            child: TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: showPassword,
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                labelStyle: TextStyle(fontSize: 14),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                ),
                              ),
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Password do not match';
                                }
                                return null;
                              },
                              //inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
                            ),
                          ),
                          Container(
                            //padding: EdgeInsets.all(1.0),
                            alignment: Alignment.center,
                            child: RaisedButton(
                                child: Text('Register'),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    _register();
                                  }
                                }),
                          ),
                          Container(
                              alignment: Alignment.center,
                              child: Text(
                                _success == null
                                    ? ''
                                    : (_success ? 'Successfully registered' + _userEmail : 'Registration Failed'),
                              )),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: InkWell(
                              child: Container(
                                height: MediaQuery.of(context).size.height / 18,
                                width: MediaQuery.of(context).size.width / 1.8,
                                margin: EdgeInsets.only(top: 0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.black,
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        height: 30.0,
                                        width: 30.0,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage('images/google.png'), fit: BoxFit.cover),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      Text(
                                        'Sign in with Google',
                                        style:
                                            TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () => null,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  clearForm() {
    //on Logout the login page is again displayed. This function clears the user input fields.
    _emailController.text = '';
    _passwordController.text = '';
  }

  void _register() async {
    debugPrint("In register");

    AuthResult x = await _auth.createUserWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);
    final FirebaseUser User = x.user;
    await secureStorage.write(key: 'uid', value: User.uid);
    debugPrint(User.uid);

    if (User != null) {
      setState(() {
        _success = true;
        _userEmail = User.email;
        clearForm();
        Navigator.push(context, MaterialPageRoute(builder: (context) => NavigateMenus()));
      });
    } else {
      setState(() {
        _success = false;
      });
    }
  }
}
