import 'package:email_todo/screens/signupname.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _obscureText = true;
  bool _isButtonDisabled = false;
  String loginText = 'sign up'.toUpperCase();
  String note = '';
  bool _isfetching = false;

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  final _emailController = new TextEditingController();
  final _passwordController = new TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String url;
// user defined function

  void _showDialog() {
    // flutter defined function
    if (_isfetching) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              titleTextStyle: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              content: Column(
                children: <Widget>[CircularProgressIndicator()],
              ),
            );
          });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Column(
              children: <Widget>[
                Center(child: Text("This email is already ")),
                Center(child: Text("connected to an account")),
              ],
            ),
            titleTextStyle: TextStyle(
                fontSize: 20.0,
                color: Colors.black,
                fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            // contentPadding: EdgeInsets.only(top: 10.0),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 30.0,
                ),
                Material(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  color: Color(0xFF4a00e0),
                  elevation: 3.0,
                  child: Container(
                    width: 200.0,
                    child: MaterialButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/login'),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "go to Login".toUpperCase(),
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    "Close".toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          );
        },
      );
    }
  }

  Future<bool> verifyEmail() async {
    setState(() {
      _isfetching = true;
    });
    bool _isVerified = true;
    print("Inside");
    setState(() {
      if (_emailController.text.isNotEmpty) {
        url = 'https://metropolis-api-email.p.rapidapi.com/analysis?email=' +
            _emailController.text;
      } else {
        url =
            'https://metropolis-api-email.p.rapidapi.com/analysis?email=john@gmail.com';
      }
    });
    print(url);
    var response = await http.get(Uri.encodeFull(url), headers: {
      "Accept": 'application/json',
      "X-RapidAPI-Host": "metropolis-api-email.p.rapidapi.com",
      "X-RapidAPI-Key": "3ec14112bfmsh6d2e65f08e50d3cp19ae4ajsnd975d3779fc8"
    });

    setState(() {
      var extractdata = json.decode(response.body);

      if (extractdata['valid'] == false) {
        _isVerified = false;
      }
      if (extractdata['recoded-email'] != '' && extractdata['valid'] == true) {
        print(extractdata);
        _isVerified = false;
      } else {
        print(extractdata);
        if (extractdata['valid'] == true) {
          _isVerified = true;
        }
      }
    });
    return _isVerified;
  }

  Future<void> _handleSignIn() async {
    FirebaseUser user;
    if (EmailValidator.validate(_emailController.text) == false) {
      setState(() {
        note = 'The email and password combination is incorrect';
      });
    } else {
      try {
        bool _testEmail = await verifyEmail();
        setState(() {
          _isfetching = false;
        });
        print(_testEmail);
        if (_testEmail == false) {
          setState(() {
            note = 'The email and password combination is incorrect';
          });
        } else {
          user = await _firebaseAuth.signInWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          );
          if (user != null) {
            _showDialog();
            setState(() {
              note = '';
            });
          }
        }
      } catch (e) {
        print(e);
        if (e is PlatformException) {
          if (e.code == 'ERROR_WRONG_PASSWORD') {
            _showDialog();
            setState(() {
              note = '';
            });
          }
          if (e.code == 'ERROR_USER_NOT_FOUND') {
            if (user == null) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SignUpName(
                            email: _emailController.text,
                            password: _passwordController.text,
                          )));
            }
          }
        }
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailController.addListener(listener1);
    _passwordController.addListener(listener1);
  }

  listener1() {
    setState(() {
      if (_emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty) {
        if (_passwordController.text.length < 8) {
          _isButtonDisabled = false;
        } else {
          _isButtonDisabled = true;
        }
      } else {
        _isButtonDisabled = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
          constraints: BoxConstraints.expand(),
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
              stops: [0.3, 0.7, 0.9],
              colors: [
                // Colors are easy thanks to Flutter's Colors class.
                Colors.indigo[700],
                Colors.indigo[600],
                Colors.indigo[400],
              ],
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 80.0,
                child: Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.chevron_left,
                      size: 40.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                child: Center(
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                        fontSize: 35.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding:
                            EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(bottom: 10.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "What\'s your email address ?",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            TextFormField(
                              controller: _emailController,
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  contentPadding: new EdgeInsets.symmetric(
                                      vertical: 15.0, horizontal: 10.0),
                                  helperText: 'example@email.com',
                                  helperStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                  fillColor: Colors.white70,
                                  filled: true,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 0.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0))),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Align(
                                child: Text(
                                  "Create a password",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                                alignment: Alignment.topLeft,
                              ),
                            ),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscureText,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                  contentPadding: new EdgeInsets.symmetric(
                                      vertical: 15.0, horizontal: 10.0),
                                  helperText: 'use atleast 8 characters.',
                                  helperStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _obscureText = !_obscureText;
                                      });
                                    },
                                    child: new Icon(
                                      _obscureText
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      size: 25.0,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  fillColor: Colors.white70,
                                  filled: true,
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(width: 0.0)),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(width: 0.0),
                                      borderRadius:
                                          BorderRadius.circular(10.0))),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: SizedBox(
                                height: 40.0,
                                child: Text(
                                  note,
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.white),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30.0,
                            ),
                            Container(
                              width: 200.0,
                              decoration: BoxDecoration(
                                color: _isButtonDisabled
                                    ? Colors.white
                                    : Colors.white54,
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: MaterialButton(
                                onPressed:
                                    _isButtonDisabled ? _handleSignIn : null,
                                child: Text(
                                  loginText,
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
/*Future<void> createUser(String email, String password) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        note = '';
      });
    }
    try {
      await _firebaseAuth
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text)
          .then((FirebaseUser user) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => SignUpName(user: user)));
      });
    } catch (e) {
      print(e.message);
      if (e is PlatformException) {
        if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
          // note = 'User already exists';
          _showDialog();
        }
        if (e.code == 'ERROR_WEAK_PASSWORD' ||
            e.code == 'ERROR_INVALID_EMAIL') {
          setState(() {
            note = 'The email and password combination is incorrect';
          });
        }
      }
    }
  }*/
