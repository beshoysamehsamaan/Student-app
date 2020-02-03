import 'package:firebase_database/firebase_database.dart';
class CourseToDatabase {
  addNewCourse(context, student, courseName) {
    FirebaseDatabase.instance
        .reference()
        .child('student')
        .child(student.id)
        .child('courses')
        .push()
        .set({
          'courses': courseName,
        })
        .then((value) {})
        .catchError((e) {
          print(e);
        });
  }
}
