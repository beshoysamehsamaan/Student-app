import 'package:firebase_database/firebase_database.dart';

class Course {
  String _id;
  String _name;
  String _hours;
  String _description;
  String _department;
  String numofstud;
  String _material;

  Course(this._id, this._name, this._description, this._hours, this._department,
      this.numofstud,this._material);

  Course.map(dynamic obj) {
    this._name = obj['name'];
    this._description = obj['description'];
    this._hours = obj['hours'];
    this._department = obj['department'];
    this.numofstud = obj['numofstud'];
    this._material = obj['material'];
  }
  String get id => _id;
  String get description => _description;
  String get hours => _hours;
  String get name => _name;
  String get department => _department;
  String get material => _material;
  
  Course.fromSnapShot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _name = snapshot.value['name'];
    _description = snapshot.value['description'];
    _hours = snapshot.value['hours'];
    _department = snapshot.value['department'];
    numofstud = snapshot.value['numofstud'];
    _material = snapshot.value['material'];
  }
}