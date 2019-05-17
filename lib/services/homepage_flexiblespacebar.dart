import 'package:email_todo/screens/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MyFlexibleAppBar extends StatelessWidget {
  final double appBarHeight = 66.0;
  final String displayName;
  final bool isHomePage;
  MyFlexibleAppBar({Key key, this.displayName, this.isHomePage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    GoogleSignIn _googleSignIn = GoogleSignIn();

    return Container(
      padding: EdgeInsets.only(top: statusBarHeight),
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [
          Colors.indigo[800],
          Colors.indigo[700],
        ],
        stops: [0.1, 0.3],
        begin: FractionalOffset.topCenter,
        end: FractionalOffset.bottomCenter,
      )),
      height: statusBarHeight + appBarHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 20.0,
            child: Align(
              child: IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  _googleSignIn.signOut();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignInPage()));
                },
                icon: Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ),
              ),
              alignment: Alignment.topRight,
            ),
          ),
          SizedBox(
            height: 40.0,
          ),
          Container(
            child: Text(
              "Hey, " + displayName.split(" ")[0].toString(),
              style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            child: Text(
              isHomePage ? "Your ToDo\'s" : "Completed ToDo\'s",
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          SizedBox(
            height: 60.0,
          )
        ],
      ),
    );
  }
}
