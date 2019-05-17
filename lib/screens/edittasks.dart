import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class EditTask extends StatefulWidget {
  EditTask({this.index, this.title, this.date});
  final String title;
  final DateTime date;
  final index;
  @override
  _EditTaskState createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  Color _allColor = Colors.white;
  DateTime _date;
  bool _autoValidate = false;
  TimeOfDay _time;
  String _task = '';
  final dateFormat = DateFormat.yMMMEd();
  final timeFormat = DateFormat("h:mm a");
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  bool _verifyTaskForm() {
    if (_formKey1.currentState.validate()) {
      _formKey1.currentState.save();
      return true;
    } else {
      setState(() {
        _autoValidate = true;
      });
      return false;
    }
  }

  void _editTask() {
    Firestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(widget.index);
      await transaction
          .update(snapshot.reference, {"title": _task, "date": _date});
    });
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _date = widget.date;
    _task = widget.title;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
          alignment: Alignment.center,
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
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                child: Form(
                  key: _formKey1,
                  autovalidate: _autoValidate,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    //mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        height: 70.0,
                      ),
                      Container(
                        child: Text(
                          "Edit Task",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 70.0,
                      ),
                      Container(
                        padding: EdgeInsets.all(16.0),
                        child: TextFormField(
                          onSaved: (String arg) => _task = arg,
                          validator: validateTaskNote,
                          cursorColor: _allColor,
                          initialValue: _task,
                          autofocus: true,
                          style: TextStyle(fontSize: 18.0),
                          decoration: InputDecoration(
                            icon: Icon(
                              FontAwesomeIcons.tasks,
                              size: 20.0,
                              color: _allColor,
                            ),
                            border: InputBorder.none,
                            hintText: "New Task",
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Align(
                          child: Text(
                            "Remind me at",
                            style: TextStyle(color: _allColor, fontSize: 18.0),
                          ),
                          alignment: Alignment.topLeft,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: DateTimePickerFormField(
                          dateOnly: true,
                          initialValue: _date,
                          validator: validateTaskDate,
                          style: TextStyle(fontSize: 18.0),
                          inputType: InputType.date,
                          format: dateFormat,
                          initialDate: DateTime.now().add(Duration(seconds: 1)),
                          firstDate: DateTime.now(),
                          editable: false,
                          decoration: InputDecoration(
                            icon: Icon(
                              FontAwesomeIcons.calendarAlt,
                              color: _allColor,
                              size: 20.0,
                            ),
                            border: InputBorder.none,
                            labelText: 'Date',
                          ),
                          onSaved: (pickeddate) {
                            _date = pickeddate;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: DateTimePickerFormField(
                          validator: validateTaskTime,
                          initialValue: _date,
                          onSaved: (pickedtime) {
                            _time = TimeOfDay.fromDateTime(pickedtime);
                          },
                          style: TextStyle(fontSize: 18.0),
                          inputType: InputType.time,
                          format: timeFormat,
                          initialTime: TimeOfDay(
                              hour: TimeOfDay.now().hour,
                              minute: TimeOfDay.now().minute),
                          editable: false,
                          decoration: InputDecoration(
                            icon: Icon(
                              FontAwesomeIcons.clock,
                              size: 20.0,
                              color: _allColor,
                            ),
                            border: InputBorder.none,
                            labelText: 'Time',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          FlatButton(
                            splashColor: Colors.transparent,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.clear,
                                    size: 30.0,
                                  ),
                                ),
                                Text(
                                  "Cancel",
                                  style: TextStyle(fontSize: 18.0),
                                )
                              ],
                            ),
                          ),
                          FlatButton(
                            splashColor: Colors.transparent,
                            onPressed: () {
                              if (_verifyTaskForm()) {
                                _editTask();
                              }
                            },
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.check,
                                    size: 30.0,
                                  ),
                                ),
                                Text("Save", style: TextStyle(fontSize: 18.0))
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
        ),
      ),
    );
  }

  String validateTaskNote(String value) {
    if (value.isNotEmpty) {
      return null;
    } else {
      return 'Please add a task';
    }
  }

  String validateTaskDate(DateTime value) {
    if (value != null) {
      return null;
    } else {
      return 'Please add a date';
    }
  }

  String validateTaskTime(DateTime value) {
    if (value != null) {
      return null;
    } else {
      return 'Please add a time';
    }
  }
}
