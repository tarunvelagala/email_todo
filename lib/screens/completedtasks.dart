import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_todo/screens/homepage.dart';
import 'package:email_todo/services/homepage_flexiblespacebar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CompletedTasks extends StatefulWidget {
  final FirebaseUser user;
  CompletedTasks({this.user});

  @override
  _CompletedTasksState createState() => _CompletedTasksState();
}

class _CompletedTasksState extends State<CompletedTasks> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: FractionalOffset.topCenter,
        end: FractionalOffset.bottomCenter,
        stops: [0.3, 0.7, 0.9],
        colors: [
          // Colors are easy thanks to Flutter's Colors class.
          Colors.indigo[700],
          Colors.indigo[600],
          Colors.indigo[400],
        ],
      )),
      child: Center(
        child: StreamBuilder(
          stream: Firestore.instance
              .collection("tasks")
              .orderBy("date", descending: true)
              .where("email", isEqualTo: widget.user.email)
              .where("isCompleted", isEqualTo: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return new Container(
                child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                ),
              );
            }
            return CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: <Widget>[
                SliverAppBar(
                  backgroundColor: Colors.indigo[800],
                  pinned: false,
                  expandedHeight: 200.0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: MyFlexibleAppBar(
                      displayName: widget.user.displayName,
                      isHomePage: false,
                    ),
                  ),
                ),
                new TaskList(
                  document: snapshot.data.documents,
                  isHomePage: false,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
