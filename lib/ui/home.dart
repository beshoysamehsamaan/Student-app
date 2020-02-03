import 'dart:async';
import 'package:authapp/model/student.dart';
import 'package:authapp/ui/addcourse.dart';
import 'package:authapp/ui/m_courses.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _HomeState();
}

final studentReference = FirebaseDatabase.instance.reference().child('student');

class _HomeState extends State<Home> {
  var mymap = {};
  var title = "";
  var body = {};
  var mytoken = '';

  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  //String _name = '';
  String _uid = '';
  Student _student = new Student('', '', '', '', '', '');
  List<Student> items;
  StreamSubscription<Event> _onStudentAddedSubscription;
  @override
  void initState() {
    super.initState();
    var android = new AndroidInitializationSettings('mipmap/ic_launcher');
    var ios = new IOSInitializationSettings();
    var platform = new InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(platform);
    firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> msg) {
        print("onLaunch called : ${(msg)}");
      },
      onResume: (Map<String, dynamic> msg) {
        print("onResume called : ${(msg)}");
      },
      onMessage: (Map<String, dynamic> msg) {
        print("onMessage called : ${(msg)}");
        mymap = msg;
        showNotification(msg);
      },
    );

    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, alert: true, badge: true));
    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings setting) {
      print("Ios Settings Registered");
    });

    firebaseMessaging.getToken().then((token) {
      update(token);
    });
    items = new List();
    _onStudentAddedSubscription =
        studentReference.onChildAdded.listen(_onStudentAdded);
    FirebaseAuth.instance.currentUser().then((user) {
      //  _name = user.email;
      _uid = user.uid;
      for (Student s in items) {
        if (s.uid == user.uid) {
          _student = s;
        }
      }
    }).catchError((e) {
      debugPrint(e);
    });
  }

  showNotification(Map<String, dynamic> msg) async {
    var android = new AndroidNotificationDetails(
        "1", "channelName", "channelDescription");
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);

    msg.forEach((k, v) {
      print('$k , $v');
      title = k;
      body = v;
      setState(() {});
    });

    await flutterLocalNotificationsPlugin.show(
        0, "mytitle ${body.keys}", "body : ${body.values}", platform);
  }

  update(String token) {
    print(token);
    DatabaseReference databaseReference = new FirebaseDatabase().reference();
    databaseReference.child('fcm-token/$token').set({"token": token});
    mytoken = token;
    setState(() {});
  }

  void dispose() {
    super.dispose();
    _onStudentAddedSubscription.cancel();
  }

  @override
  void setState(fn) {
    super.setState(fn);
    for (Student s in items) {
      if (s.uid == _uid) {
        _student = s;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.all(14.0),
          child: ListView(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Dashboard',
                    style: TextStyle(
                      color: Colors.deepPurpleAccent,
                      fontSize: 22.0,
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Center(
                    child: Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const ListTile(
                            leading: Icon(Icons.book),
                            title: Text('Mange Courses'),
                            subtitle:
                                Text('We Provide to you mange your Courses'),
                          ),
                          ButtonTheme.bar(
                            // make buttons use the appropriate styles for cards
                            child: ButtonBar(
                              children: <Widget>[
                                FlatButton(
                                  child: const Text('Mange Courses'),
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Mange(_student)),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const ListTile(
                            leading: Icon(Icons.book),
                            title: Text('new Courses'),
                            subtitle: Text(
                                'We Provide to you add Courses by Department'),
                          ),
                          ButtonTheme.bar(
                            // make buttons use the appropriate styles for cards
                            child: ButtonBar(
                              children: <Widget>[
                                FlatButton(
                                  child: const Text('Add Course'),
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Addcourse(_student)),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  new Text(
                    '',
                    style: Theme.of(context).textTheme.display1,
                  ),
                ],
              ),
            ],
          )),
      appBar: AppBar(
        title: Text('Welcome ${_student.name.toUpperCase()}'),
        backgroundColor: Colors.green,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.lock_open),
            color: Colors.blueGrey,
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) {
                Navigator.of(context).pushReplacementNamed('/landingpage');
              }).catchError((e) {
                debugPrint(e);
              });
            },
          )
        ],
      ),
    );
  }

  void _onStudentAdded(Event event) {
    setState(() {
      items.add(new Student.fromSnapShot(event.snapshot));
    });
  }
}
