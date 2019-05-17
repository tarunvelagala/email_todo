import 'package:email_todo/screens/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _loadingInProgress;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  Future<FirebaseUser> _handleSignIn() async {
    GoogleSignInAccount currentUser = _googleSignIn.currentUser;

    if (currentUser == null) {
      currentUser = await _googleSignIn.signIn();
      if (currentUser == null) {
        throw ('Login Cancelled');
      }
    }

    final GoogleSignInAuthentication googleAuth =
        await currentUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = await _auth.signInWithCredential(credential);
    print("signed in " + user.displayName);
    assert(user != null);
    assert(!user.isAnonymous);
    _dataLoaded();
    return user;
  }

  void _dataLoaded() {
    setState(() {
      _loadingInProgress = false;
    });
  }

  void _showLoadingDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog();
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadingInProgress = true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      FontAwesomeIcons.tasks,
                      size: 50.0,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        "ToDo",
                        style: TextStyle(
                            fontSize: 30.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 300.0,
                  child: Center(
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "Organize life \n Then go enjoy it…",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'DancingScript',
                              fontSize: 40.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                Material(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  color: Colors.indigo,
                  elevation: 5.0,
                  child: Container(
                    width: 250.0,
                    child: MaterialButton(
                      onPressed: () => Navigator.pushNamed(context, '/signup'),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(FontAwesomeIcons.userPlus, color: Colors.white),
                          SizedBox(
                            width: 20.0,
                          ),
                          Text(
                            "Sign Up for Free".toUpperCase(),
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
                Material(
                  color: Colors.red,
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(30.0),
                  child: Container(
                    width: 250.0,
                    child: MaterialButton(
                      onPressed: () {
                        return _handleSignIn().then((FirebaseUser user) {
                          if (_loadingInProgress) {
                            _showLoadingDialog();
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        HomePage(user: user)));
                          }
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.google,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            "Sign In With Google".toUpperCase(),
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
                Material(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  color: Colors.white,
                  elevation: 5.0,
                  child: Container(
                    width: 250.0,
                    child: MaterialButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/login'),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(FontAwesomeIcons.solidEnvelope,
                              color: Colors.indigo),
                          SizedBox(
                            width: 20.0,
                          ),
                          Text(
                            "Login with email".toUpperCase(),
                            style: TextStyle(color: Colors.indigo),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
