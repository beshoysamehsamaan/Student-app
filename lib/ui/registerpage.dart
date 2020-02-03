import 'package:authapp/model/student.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:authapp/utils/user_to_database.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  int _validate = 0;
  String msg = '';
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Container(
        padding: EdgeInsets.all(14.0),
        child: ListView(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Name',
                    icon: Icon(Icons.person),
                    errorText: _validate == 1 ? 'Value Can\'t Be Empty' : null,
                  ),
                  controller: _nameController,
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    icon: Icon(Icons.email),
                    errorText: _validate == 2 ? 'Value Can\'t Be Empty' : null,
                  ),
                  controller: _emailController,
                ),
                SizedBox(
                  height: 15.0,
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    icon: Icon(Icons.vpn_key),
                    errorText: _validate == 3 ? 'Value Can\'t Be Empty' : null,
                  ),
                  controller: _passwordController,
                ),
                SizedBox(
                  height: 15.0,
                ),
                FlatButton(
                  child: Text('Register'),
                  color: Colors.deepPurple,
                  textColor: Colors.white,
                  onPressed: () {
                    setState(() {
                      if (_nameController.text.isEmpty) {
                        _validate = 1;
                      } else {
                        if (_emailController.text.isEmpty) {
                          _validate = 2;
                        } else {
                          if (_passwordController.text.isEmpty) {
                            _validate = 3;
                          } else {
                            _validate = 0;
                            Student s;
                            FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text,
                            )
                                .then((user) {
                              s = new Student(
                                  null,
                                  user.uid,
                                  _nameController.text,
                                  _passwordController.text,
                                  _emailController.text,
                                  '');
                              UserToDatabase().addNewUser(s, context);
                              Navigator.of(context)
                                  .pushReplacementNamed('/landingpage');
                            }).catchError((e) {
                              debugPrint(e);
                            });
                          }
                        }
                      }
                    });
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
