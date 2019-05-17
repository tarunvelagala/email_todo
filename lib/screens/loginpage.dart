import 'package:email_todo/screens/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  // Initially password is obscure
  bool _obscureText = true;
  bool _isButtonDisabled = false;
  String loginText = 'Login'.toUpperCase();
  String note = '';
  final _emailController = new TextEditingController();
  final _passwordController = new TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    _emailController.addListener(listener1);
    _passwordController.addListener(listener1);
  }

  listener1() {
    setState(() {
      if (_emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty) {
        _isButtonDisabled = true;
      } else {
        _isButtonDisabled = false;
      }
    });
  }

  Future<void> signInEmail() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        loginText = 'Logging In...'.toUpperCase();
        note = '';
      });
      try {
        await _auth
            .signInWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text)
            .then((FirebaseUser user) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage(
                        user: user,
                      )));
        });
      } catch (e) {
        print(e.message);

        setState(() {
          loginText = 'Login'.toUpperCase();
          note = 'The email and password combination is incorrect';
        });
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
                    padding: const EdgeInsets.only(top: 20.0),
                    child: IconButton(
                      onPressed: () =>
                          Navigator.of(context).popAndPushNamed('/signin'),
                      icon: Icon(
                        Icons.chevron_left,
                        size: 40.0,
                        color: Colors.white,
                      ),
                    ),
                  )),
              SizedBox(
                child: Center(
                  child: Text(
                    "Login",
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
                        padding: const EdgeInsets.only(
                            top: 20.0, right: 20.0, left: 20.0),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Align(
                                child: Text(
                                  "Email",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                                alignment: Alignment.topLeft,
                              ),
                            ),
                            TextFormField(
                              controller: _emailController,
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  contentPadding: new EdgeInsets.symmetric(
                                      vertical: 15.0, horizontal: 10.0),
                                  fillColor: Colors.white70,
                                  filled: true,
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(width: 0.0)),
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
                                  "Password",
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
                                      borderRadius:
                                          BorderRadius.circular(10.0))),
                            ),
                            SizedBox(
                              height: 10.0,
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
                              height: 20.0,
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
                                onPressed: _isButtonDisabled
                                    ? () => signInEmail()
                                    : null,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
