import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:timesheet/views/NavigateMenus.dart';
import 'package:timesheet/views/NewUserRegistration.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

const FlutterSecureStorage secureStorage = FlutterSecureStorage();

class Login extends StatefulWidget {
  static String routeName = '/Login';

  final String title = 'Registration';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _success;
  String userEmail;
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                //padding: EdgeInsets.all(1.0),
                                alignment: Alignment.center,
                                child: ElevatedButton(
                                    child: Text('Submit'),
                                    style: ButtonStyle(shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)))),
                                    onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                        _loginWithEmail();
                                      }
                                    }),
                              ),
                              Container(
                                  //padding: EdgeInsets.all(1.0),
                                  alignment: Alignment.center,
                                  child: ElevatedButton(
                                      child: Text(
                                        'Sign Up',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
                                      shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)))
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context, MaterialPageRoute(builder: (context) => NewUserRegistration()));
                                      }))
                            ],
                          ),
                          Container(
                              alignment: Alignment.center,
                              child: Text(
                                //_success == null ? '' : (_success ? 'Successfully registered' + _userEmail : 'Registration Failed'),
                                _success == null ? '' : (_success ? '' : 'Registration Failed'),
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
                              onTap: () => signInWithGoogle(),
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

  void _loginWithEmail() async {
    debugPrint("In loginwithEmail");

    var x = await _auth.signInWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);
    final emailUsr = x.user;
    await secureStorage.write(key: 'uid', value: emailUsr.uid);

    final String storedUIDToken = await secureStorage.read(key: 'uid');
    debugPrint('From _loginWithEmail: $storedUIDToken');

    if (emailUsr != null) {
      setState(() {
        _success = true;
        userEmail = emailUsr.email;
        clearForm();
        Navigator.push(context, MaterialPageRoute(builder: (context) => NavigateMenus()));
      });
    } else {
      setState(() {
        _success = false;
        debugPrint(_success.toString());
      });
    }
  }

  void signInWithGoogle() async{

    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );

    _handleSignIn() async {
      try {
        await _googleSignIn.signIn();
      } catch (error) {
        print(error);
      }
    }
    //final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAccount googleUser = await _handleSignIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential googleAuthCredential = GoogleAuthProvider.credential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

    var x = await _auth.signInWithCredential(googleAuthCredential);
    final googleUsr = x.user;
    await secureStorage.write(key: 'uid', value: googleUsr.uid);
    final storedUIDToken = await secureStorage.read(key: 'uid');
    debugPrint('From signInWithGoogle: $storedUIDToken');

    if (googleUsr != null) {
      setState(() {
        _success = true;
        userEmail = googleUsr.email;
        clearForm();
        Navigator.push(context, MaterialPageRoute(builder: (context) => NavigateMenus()));
      });
    } else {
      setState(() {
        _success = false;
        debugPrint(_success.toString());
      });
    }

  }

}
