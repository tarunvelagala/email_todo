import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_todo/screens/addtasks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'completedtasks.dart';
import 'edittasks.dart';
import 'homescreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key, this.user}) : super(key: key);
  final FirebaseUser user;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //FirebaseAuth _auth;
  //GoogleSignIn _googleSignIn;
  FirebaseUser user;
  var _currentIndex = 0;

  void initState() {
    // TODO: implement initState
    super.initState();
    //_auth = FirebaseAuth.instance;
    //_googleSignIn = GoogleSignIn();
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _children = [
      HomeScreen(user: widget.user),
      CompletedTasks(
        user: widget.user,
      )
    ];
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0.0,
          currentIndex: _currentIndex,
          onTap: onTabTapped,
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: Colors.indigo,
                ),
                title: Text("Home", style: TextStyle(color: Colors.indigo))),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.check_box,
                  color: Colors.indigo,
                ),
                title: Text(
                  "Completed",
                  style: TextStyle(color: Colors.indigo),
                ))
          ],
        ),
        resizeToAvoidBottomPadding: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => new AddTask(
                        email: widget.user.email,
                      ))),
          backgroundColor: Colors.indigo,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: _children[_currentIndex],
      ),
    );
  }
}

class TaskList extends StatefulWidget {
  TaskList({this.document, this.isHomePage});
  final List<DocumentSnapshot> document;
  final bool isHomePage;

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  List<DocumentSnapshot> document;
  Color completedColor = Colors.white;
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          String title = widget.document[index].data['title'].toString();
          DateTime _date = widget.document[index].data['date'].toDate();
          String date = DateFormat("EEE, MMM d, ''yy").format(_date);
          bool _isCompleted = widget.document[index].data['isCompleted'];
          return Dismissible(
            onDismissed: (direction) async {
              if (widget.isHomePage) {
                if (_isCompleted == false) {
                  Firestore.instance.runTransaction((transaction) async {
                    DocumentSnapshot snapshot =
                        await transaction.get(widget.document[index].reference);
                    await transaction
                        .update(snapshot.reference, {"isCompleted": true});
                  });
                }
              } else {
                Firestore.instance.runTransaction((transaction) async {
                  DocumentSnapshot snapshot =
                      await transaction.get(widget.document[index].reference);
                  await transaction.delete(snapshot.reference);
                });
              }
            },
            direction: widget.isHomePage
                ? DismissDirection.startToEnd
                : DismissDirection.endToStart,
            background: Card(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.indigo[800]),
                alignment: widget.isHomePage
                    ? AlignmentDirectional.centerStart
                    : AlignmentDirectional.centerEnd,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 50.0,
                    width: 50.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        color: Colors.white12),
                    child: widget.isHomePage
                        ? Icon(
                            Icons.check,
                            color: Colors.green,
                          )
                        : Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                  ),
                ),
              ),
            ),
            key: Key(widget.document[index].documentID),
            child: Card(
              color: Colors.indigo,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Row(
                          children: <Widget>[
                            Container(
                                height: 50.0,
                                width: 50.0,
                                decoration: BoxDecoration(
                                    color: Colors.white12,
                                    borderRadius: BorderRadius.circular(50.0)),
                                child: IconButton(
                                    onPressed: () async {
                                      if (_isCompleted == false) {
                                        Firestore.instance.runTransaction(
                                            (transaction) async {
                                          DocumentSnapshot snapshot =
                                              await transaction.get(widget
                                                  .document[index].reference);
                                          await transaction.update(
                                              snapshot.reference,
                                              {"isCompleted": true});
                                        });
                                      }
                                    },
                                    icon: Icon(FontAwesomeIcons.tasks,
                                        color: Colors.white))),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(left: 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        title,
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.white),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        date,
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    child: IconButton(
                                      onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  new EditTask(
                                                      date: _date,
                                                      title: title,
                                                      index: widget
                                                          .document[index]
                                                          .reference))),
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        childCount: widget.document.length,
      ),
    );
  }
}
