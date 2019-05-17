import 'package:email_todo/screens/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpName extends StatefulWidget {
  final String email;
  final String password;
  final FirebaseUser user;
  SignUpName({Key key, this.user, this.email, this.password}) : super(key: key);

  @override
  _SignUpNameState createState() => _SignUpNameState();
}

class _SignUpNameState extends State<SignUpName> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  final _nameController = new TextEditingController();
  bool _isButtonDisabled = false;
  UserUpdateInfo updateUser = UserUpdateInfo();
  String note = '';

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController.addListener(listener1);
  }

  _createUser() async {
    try {
      await _firebaseAuth
          .createUserWithEmailAndPassword(
        email: widget.email,
        password: widget.password,
      )
          .then((user) async {
        UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
        userUpdateInfo.displayName = _nameController.text;
        user.updateProfile(userUpdateInfo);
        await user.reload();
        user = await _firebaseAuth.currentUser();
        print(user.displayName);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => new HomePage(user: user)));
      });
    } catch (e) {
      print(e.message);
      print(e.code);
    }
  }

  listener1() {
    setState(() {
      _nameController.text.isNotEmpty
          ? _isButtonDisabled = true
          : _isButtonDisabled = false;
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
                    onPressed: () => Navigator.of(context).pushNamed('/signin'),
                    icon: Icon(
                      Icons.chevron_left,
                      size: 40.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Text(
                      "Your account is ready",
                      style: TextStyle(
                          fontSize: 30.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
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
                                  "What\'s your name ?",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            TextFormField(
                              controller: _nameController,
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  contentPadding: new EdgeInsets.symmetric(
                                      vertical: 15.0, horizontal: 10.0),
                                  helperText:
                                      'This appear\'s on your ToDo profile',
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
                              padding: const EdgeInsets.only(top: 20.0),
                              child: SizedBox(
                                height: 30.0,
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    note,
                                    style: TextStyle(
                                        fontSize: 18.0, color: Colors.white),
                                  ),
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
                                    ? () => _createUser()
                                    : null,
                                child: Text(
                                  "Next".toUpperCase(),
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
