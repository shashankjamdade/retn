import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_rentry_new/model/get_notification_response.dart';
import 'package:overlay_support/overlay_support.dart';

class PushNotificationsManager {
  BuildContext contex;

  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  static final PushNotificationsManager _instance =
  PushNotificationsManager._();

   FirebaseMessaging _firebaseMessaging;
  bool _initialized = false;

  Future<void> init() async {
    _firebaseMessaging = FirebaseMessaging.instance;
    if (_initialized == true) {
      // For iOS request permission first.

      var initializationSettingsAndroid =
      new AndroidInitializationSettings('@mipmap/ic_launcher');
      var initializationSettingsIOS = new IOSInitializationSettings();
      var initializationSettings = new InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS);

      flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
      flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: onSelectNotification);

      _firebaseMessaging.requestPermission(alert: true, criticalAlert: true);
     /* _firebaseMessaging.c(onMessage: (Map<String, dynamic> message) {
        print('onMessage: $message');
        var result = message['data'];
        // Platform.isAndroid ? _showNotification(message['data']));

        return;
      }, onResume: (Map<String, dynamic> message) {
        print('onResume: $message');
        var result = message['data'];
        return;
      }, onLaunch: (Map<String, dynamic> message) {
        print('onLaunch: $message');
        var result = message['data'];
        return;
      });*/

      _showNotification(
          1234,
          "GET title FROM message OBJECT",
          "GET description FROM message OBJECT",
          "GET PAYLOAD FROM message OBJECT");

      // For testing purposes print the Firebase Messaging token
      String token = await _firebaseMessaging.getToken();

      var res = await print("FirebaseMessaging token: $token");

      _initialized = true;
    }
  }

  Future<dynamic> onSelectNotification(String payload) async {
    /*Do whatever you want to do on notification click. In this case, I'll show an alert dialog*/
    showDialog(
      context: contex,
      builder: (_) => AlertDialog(
        title: Text(payload),
        content: Text("Payload: $payload"),
      ),
    );
  }

  Future<void> _showNotification(
      int notificationId,
      String notificationTitle,
      String notificationContent,
      String payload, {
        String channelId = '1234',
        String channelTitle = 'Android Channel',
        String channelDescription = 'Default Android Channel for notifications',
        Priority notificationPriority = Priority.high,
        Importance notificationImportance = Importance.max,
      }) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      channelId,
      channelTitle,
      channelDescription,
      playSound: true,
      importance: notificationImportance,
      priority: notificationPriority,
    );
    var iOSPlatformChannelSpecifics =
    new IOSNotificationDetails(presentSound: false);
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      notificationId,
      notificationTitle,
      notificationContent,
      platformChannelSpecifics,
      payload: payload,
    );
  }
}

class NotificationS {
  String token;
  BuildContext _context;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static const _channel = MethodChannel('custom notification channel');

  //static final _log = Logger('Notification');

  Future<dynamic> _backgroundMessageHandler(
      Map<String, dynamic> message) async {
    _displayNotification(message);
  }

  Future<void> configureFirebase() async {
    final _permissionGranted =
    await _messaging.requestPermission(alert: true,criticalAlert: true);

    if (_permissionGranted == null || _permissionGranted == true) {
      token = await _messaging.getToken();
      /*_messaging.configure(
        onMessage: (message) async {
          await _displayNotification(message);
        },
        onLaunch: (message) async {
          await _displayNotification(message);
        },
        onResume: (message) async {
          await _displayNotification(message);
        },
         onBackgroundMessage: _backgroundMessageHandler,
      );*/
    }
  }

  List<NotificationData> parseAuthOTP(String response) {
    List<NotificationData> products = new List<NotificationData>();
    Map<String, String> jsonParsed = json.decode(response);
    products.add(new NotificationData.fromJson(jsonParsed));
    return products;
  }

  Future _displayNotification(Map<String, dynamic> message) async {
    print("Mymsg" + message.toString());

    if(message!=null){
      showSimpleNotification(
        Text(message['notification']['body']),
        background: Colors.red,
        autoDismiss: true,
        trailing: Builder(builder: (context) {
          return FlatButton(
              textColor: Colors.yellow,
//              onPressed: () {
//                OverlaySupportEntry.of(context).dismiss();
//              },
              child: Text('Dismiss'));
        }),
      );
    }


    final priority =
    (message['android'] != null ? ['priority'] : null) as String;
    final highPriority = priority == 'high';

    final result = await _channel.invokeMethod(
      'displayNotification',
      <String, dynamic>{
        'title': message['notification']['title'],
        'body': message['notification']['body'],
        'highPriority': true,
      },
    );

    print("result" + result);
  }
}