import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:authapp/model/course.dart';

class CourseeInformation extends StatefulWidget {
  final Course course;
  CourseeInformation(this.course);
  @override
  State<StatefulWidget> createState() {
    return _CourseeInformationState();
  }
}

final courseReferance = FirebaseDatabase.instance.reference().child('course');

class _CourseeInformationState extends State<CourseeInformation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Course Information'),
        backgroundColor: Colors.green,
      ),
      body: Container(
        margin: EdgeInsets.only(top: 15.0),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Text(
              widget.course.name,
              style: TextStyle(fontSize: 16.0, color: Colors.deepPurpleAccent),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
            ),
            Text(
              widget.course.description,
              style: TextStyle(fontSize: 16.0, color: Colors.deepPurpleAccent),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
            ),
            Text(
              widget.course.department,
              style: TextStyle(fontSize: 16.0, color: Colors.deepPurpleAccent),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
            ),
            Text(
              widget.course.hours,
              style: TextStyle(fontSize: 16.0, color: Colors.deepPurpleAccent),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
            ),
            Text(
              'See Material',
              style: TextStyle(fontSize: 16.0, color: Colors.deepPurpleAccent),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
            ),
          ],
        ),
      ),
    );
  }
}
