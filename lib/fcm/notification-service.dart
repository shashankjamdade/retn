import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

import 'fcm-service.dart';

class NotificationService {
  NotificationService._();

  factory NotificationService() => _instance;
  static final NotificationService _instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _flutterNotifications =
      FlutterLocalNotificationsPlugin();
  final BehaviorSubject<ReceivedNotification>
      didReceiveLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();

  final BehaviorSubject<String> selectNotificationSubject =
      BehaviorSubject<String>();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_appicon');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: false,
            requestSoundPermission: true,
            onDidReceiveLocalNotification:
                (int id, String title, String body, String payload) async {
              didReceiveLocalNotificationSubject.add(ReceivedNotification(
                  id: id, title: title, body: body, payload: payload));
            });
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await _flutterNotifications.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      if (payload != null) {
        debugPrint('notification payload: $payload');
      }
      selectNotificationSubject.add(payload);
    });
  }
}
