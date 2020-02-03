import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:authapp/model/course.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'dart:async';

import 'package:path_provider/path_provider.dart';

class CourseInformation extends StatefulWidget {
  final Course course;
  CourseInformation(this.course);
  @override
  State<StatefulWidget> createState() => new _CourseInformationState(course);
}

final courseReferance = FirebaseDatabase.instance.reference().child('course');

class _CourseInformationState extends State<CourseInformation> {
  Course course;
  _CourseInformationState(this.course);
  List<String> sos;
  List<String> sos1;
  List<String> sos2;
  String path =
      'https://firebasestorage.googleapis.com/v0/b/testt-1589b.appspot.com/o/images%2Fpola-2019-12-12 11%3A10%3A02.900050.jpg?alt=media';

  @override
  void initState() {
    super.initState();
    sos = List();
    sos1 = List();
    sos2 = List();
    setState(() {
      if (course.material != null) {
        sos = course.material.split('+');
      } else {
        sos = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Course Information'),
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
                    Row(
                      children: <Widget>[
                        Text(
                          sos[position].split('/images%2F')[1].split(' ')[0],
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 22.0,
                          ),
                        ),
                        new IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () async {
                            var dio = Dio();
                            dio.interceptors.add(LogInterceptor());
                            await download1(dio, sos[position]+'?alt=media',
                                "/storage/emulated/0/"+sos[position].split('/images%2F')[1]);
                          },
                        ),
                      ],
                    ),
                  ],
                );
            }),
      ),
    );
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }

  Future download1(Dio dio, String url, savePath) async {
    CancelToken cancelToken = CancelToken();
    try {
      await dio.download(url, savePath,
          onReceiveProgress: showDownloadProgress, cancelToken: cancelToken);
    } catch (e) {
      print(e);
    }
  }
}
