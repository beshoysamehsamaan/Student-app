 import 'dart:convert';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

class Messaging {
  static final Client client = Client();
  static const String serverKey =
      'AAAAMF2P81Y:APA91bF2YnaXiOWZVtFFlMbnO1SE9qtBG7c6vopK7CuIof8oMFuM_uoxwJUMiJ2nhQV3AXmjjdwjOllGITV5GautjIVIICqnWLmAfsQgsxYSYK_aBzE6oft2RHWmwYGrV-y8cTMWxaqY';

  static Future<Response> sendToAll({
    @required String title,
    @required String body,
  }) =>
      sendToTopic(title: title, body: body, topic: 'd9ZgVFTqw1A:APA91bHN5WlVDBoagiQpvogtiHU_WQbd-zPzcr591C5cBDPJVe8ScHVaoQORb8HqVgb4ewSXtHa9x1qgrBHQGZJKTGJlkMKq88DeJvTowGmpDYWJ18yirKOw429R_N6EJieBU51pbQLA');

  static Future<Response> sendToTopic(
          {@required String title,
          @required String body,
          @required String topic}) =>
      sendTo(title: title, body: body, fcmToken: topic);

  static Future<Response> sendTo({
    @required String title,
    @required String body,
    @required String fcmToken,
  }) =>
      client.post(
        'https://fcm.googleapis.com/fcm/send',
        body: json.encode({
          'notification': {'body': '$body', 'title': '$title'},
          'priority': 'high',
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
          },
          'to': 'd9ZgVFTqw1A:APA91bHN5WlVDBoagiQpvogtiHU_WQbd-zPzcr591C5cBDPJVe8ScHVaoQORb8HqVgb4ewSXtHa9x1qgrBHQGZJKTGJlkMKq88DeJvTowGmpDYWJ18yirKOw429R_N6EJieBU51pbQLA',
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
      );
}
