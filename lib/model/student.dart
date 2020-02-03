import 'package:firebase_database/firebase_database.dart';

class Student {
  String _id ;
  String _uid ;
  String _name;
  String courses;
  String _password;
  String _email;

  Student(this._id,this._uid,this._name,
      this._password,
      this._email,this.courses);


  Student.map(dynamic obj){
    this._name = obj['name'];
    this._uid = obj['uid'];
    this._email = obj['email'];
    this._password = obj['password'];
    this.courses = obj['courses'];
  }

  String get id => _id;
  String get uid => _uid;
  String get name => _name;
  String get email => _email;
  String get password => _password;


  Student.fromSnapShot(DataSnapshot snapshot){
    _id = snapshot.key;
    _uid = snapshot.value['uid'];
    _name = snapshot.value['name'];
    _email = snapshot.value['email'];
    _password = snapshot.value['password'];
    courses = snapshot.value['courses'];
  }
}