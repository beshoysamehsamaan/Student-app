import 'dart:async';
import 'package:authapp/model/student.dart';
import 'package:authapp/model/course.dart';
import 'package:authapp/ui/addviewcourse.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Mange extends StatefulWidget {
  Student s;
  Mange(this.s);
  @override
  State<StatefulWidget> createState() => new _MangeState(s);
}

final courseReference = FirebaseDatabase.instance.reference().child('course');

class _MangeState extends State<Mange> {
  Student _student;
  _MangeState(this._student);
  List<Course> items;
  StreamSubscription<Event> _onMajorAddedSubscription;
  List sos = List();
  @override
  void initState() {
    super.initState();
    items = new List();
    _onMajorAddedSubscription =
        courseReference.onChildAdded.listen(_onMajorAdded);
    sos = List();
    setState(() {
      if (_student.courses != null) {
        sos = _student.courses.split(',');
      } else {
        sos = null;
      }
    });
  }
  void dispose() {
    super.dispose();
    _onMajorAddedSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Courses Dashboard'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: ListView.builder(
            itemCount: sos != null ? sos.length : 0,
            itemBuilder: (context, position) {
              return Column(
                children: <Widget>[
                  Divider(
                    height: 6.0,
                  ),
                  Card(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                              title: Text(
                                'Name: ${sos[position]}',
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 22.0,
                                ),
                              ),
                              onTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CourseeInformation(
                                                items.singleWhere((course) => course.name == sos[position])
                                              )),
                                    );
                                  },),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }

  void _onMajorAdded(Event event) {
    setState(() {
      items.add(new Course.fromSnapShot(event.snapshot));
    });
  }
}
