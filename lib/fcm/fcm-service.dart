import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FcmService {
  FcmService._();

  factory FcmService() => _instance;
  static final FcmService _instance = FcmService._();

  final FirebaseMessaging _fcm = FirebaseMessaging();

  final FlutterLocalNotificationsPlugin _flutterNotifications =
  FlutterLocalNotificationsPlugin();

  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    debugPrint("FCMMSG__BACKGROUND: $message");
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }
    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

    // Or do other work.
  }

  Future<void> _showNotification(title, body, payload) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('channelid', 'flutterfcm', 'your channel description',ticker: 'ticker',
        playSound: true,enableLights: true, enableVibration: true, icon: "ic_notification_icon",
        importance: Importance.max, priority: Priority.high);
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await _flutterNotifications.show(1, title, body, platformChannelSpecifics,
        payload: payload);
  }

  Future<void> init() async {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        debugPrint("FCMMSG__onMessage: $message");
        await _showNotification(
            'The Naradmuni',
            message['notification']['body'], "payload"
        );
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        debugPrint("FCMMSG__onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        debugPrint("FCMMSG__onResume: $message");
      },
    );
  }

  Future<dynamic> getToken() async {
    return await _fcm.getToken();
  }

  Future<dynamic> getTopic() async {
    return await _fcm.subscribeToTopic("news");
  }
}

class ReceivedNotification {
  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });

  final int id;
  final String title;
  final String body;
  final String payload;
}
