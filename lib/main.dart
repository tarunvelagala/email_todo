import 'dart:async';
import 'package:email_todo/screens/homepage.dart';
import 'package:email_todo/screens/loginpage.dart';
import 'package:email_todo/screens/settings.dart';
import 'package:email_todo/screens/signupemail.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'screens/signin.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(new MaterialApp(
    theme: ThemeData(),
    debugShowCheckedModeBanner: false,
    home: new SplashScreen(),
    routes: <String, WidgetBuilder>{
      '/signin': (BuildContext context) => new SignInPage(),
      '/login': (BuildContext context) => new LoginPage(),
      '/signup': (BuildContext context) => new SignUpPage(),
      '/settings': (BuildContext context) => new SettingsScreen(),
    },
  ));
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // final GoogleSignIn _googleSignIn = GoogleSignIn();

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser firebaseUser) {
      if (firebaseUser == null) {
        //signed out
        Navigator.of(context).pushReplacementNamed('/signin');
      } else {
        //signed in
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(user: firebaseUser)));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.3, 0.7, 0.9],
            colors: [
              // Colors are easy thanks to Flutter's Colors class.
              Colors.indigo[700],
              Colors.indigo[600],
              Colors.indigo[400],
            ],
          ),
        ),
        child: Center(
          child: Icon(
            FontAwesomeIcons.tasks,
            color: Colors.white,
            size: 80.0,
          ),
        ),
      ),
    );
  }
}
