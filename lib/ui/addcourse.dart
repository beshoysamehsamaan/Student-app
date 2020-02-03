import 'dart:async';
import 'package:authapp/model/course.dart';
import 'package:authapp/model/student.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:authapp/ui/addviewcourse copy.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:authapp/ui/messaging.dart';
import 'package:authapp/ui/message.dart';

class Addcourse extends StatefulWidget {
  Student s;
  Addcourse(this.s);
  @override
  State<StatefulWidget> createState() => new _AddcourseState(s);
}

final majorReference = FirebaseDatabase.instance.reference().child('course');
final studentReference = FirebaseDatabase.instance.reference().child('student');

class _AddcourseState extends State<Addcourse> {
  Student _student;
  _AddcourseState(this._student);
  List<Course> items;
  StreamSubscription<Event> _onMajorAddedSubscription;
  List sos = List();
  List ss = List();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  TextEditingController titleController = TextEditingController(text: ' ');
  TextEditingController bodyController = TextEditingController(text: ' ');
  List<Message> messages = [];

  @override
  void initState() {
    super.initState();

    _firebaseMessaging.onTokenRefresh.listen(sendTokenToServer);
    _firebaseMessaging.getToken();

    _firebaseMessaging.subscribeToTopic('all');

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        final notification = message['notification'];
        setState(() {
          messages.add(Message(
              title: notification['title'], body: notification['body']));
        });
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");

        final notification = message['data'];
        setState(() {
          messages.add(Message(
            title: '${notification['title']}',
            body: '${notification['body']}',
          ));
        });
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));

    items = new List();
    _onMajorAddedSubscription =
        majorReference.onChildAdded.listen(_onMajorAdded);
    if (_student.courses != null) {
      ss = _student.courses.split(',');
    } else {
      ss = null;
    }
  }

  void dispose() {
    super.dispose();
    _onMajorAddedSubscription.cancel();
  }

  void _onPress(Course course) {
    bool flag = true;
    if (_student.courses != null) {
      sos = _student.courses.split(',');
      for (String name in sos) {
        if (name == course.name) {
          flag = false;
          break;
        }
      }
    } else {
      sos = null;
    }
    if (sos != null && flag == true) {
      _student.courses = '${_student.courses},${course.name}';
      studentReference
          .child(_student.id)
          .update({'courses': _student.courses}).then((_) {
        int x = int.parse(course.numofstud) - 1;
        course.numofstud = '$x';
        majorReference.child(course.id).update({'numofstud': course.numofstud});
      });
      sendNotification(_student.name+'enroll in course', course.name);
    }
    if (sos == null && flag == true) {
      _student.courses = course.name;
      studentReference
          .child(_student.id)
          .update({'courses': _student.courses}).then((_) {
        int x = int.parse(course.numofstud) - 1;
        course.numofstud = '$x';
        majorReference.child(course.id).update({'numofstud': course.numofstud});
      });
      sendNotification(_student.name+'enroll in course', course.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.all(14.0),
          child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, position) {
                bool flag = true;
                if (ss != null) {
                  for (String name in ss) {
                    if (name == items[position].name) {
                      flag = false;
                      break;
                    }
                  }
                }
                if (flag) {
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
                                  '${items[position].name}',
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 22.0,
                                  ),
                                ),
                                subtitle: Text(
                                  '${items[position].department}',
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 14.0,
                                  ),
                                ),
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CourseeInformation(
                                                items.singleWhere((course) =>
                                                    course.name ==
                                                    items[position].name))),
                                  );
                                },
                              ),
                            ),
                            new IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                _onPress(items[position]);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              })),
      appBar: AppBar(
        title: Text('Select course'),
        backgroundColor: Colors.blueAccent.shade200,
      ),
    );
  }

  void _onMajorAdded(Event event) {
    setState(() {
      items.add(new Course.fromSnapShot(event.snapshot));
    });
  }

  Future sendNotification(String x ,String y) async {
    final response = await Messaging.sendToAll(
      title: titleController.text+x,
      body: bodyController.text+y,
      // fcmToken: fcmToken,
    );

    if (response.statusCode != 200) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content:
            Text('[${response.statusCode}] Error message: ${response.body}'),
      ));
    }
  }

  void sendTokenToServer(String fcmToken) {
    print('Token: $fcmToken');
  }
}
