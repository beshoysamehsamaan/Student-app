import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';

class UserToDatabase {
  addNewUser(student, context) {
    FirebaseDatabase.instance
        .reference()
        .child('student')
        .push()
        .set({
          'email': student.email, 
          'uid': student.uid,
          'name': student.name,
          'password': student.password,
          }).then((value) {
      Navigator.of(student).pushReplacementNamed('/home');
    }).catchError((e) {
      print(e);
    });
  }
}