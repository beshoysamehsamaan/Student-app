import 'package:flutter/material.dart';
import 'package:authapp/ui/home.dart';
import 'package:authapp/ui/loginpage.dart';
import 'package:authapp/ui/registerpage.dart';
void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new LoginPage(),
      debugShowCheckedModeBanner: false,
      routes: <String , WidgetBuilder>{
        '/landingpage' : (BuildContext context) => new MyApp(),
        '/register' : (BuildContext context) => new RegisterPage(),
        '/home' : (BuildContext context) => new Home(),
      }

      );

  }
}