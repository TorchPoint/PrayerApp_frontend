import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:prayer_hybrid_app/services/push_notifications_class.dart';
import 'package:prayer_hybrid_app/utils/app_colors.dart';

class LocalNotifications {
  PushNotificationsManager pushNotificationsManager =
      PushNotificationsManager();
  final FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }

    pushNotificationsManager.handleMessage(jsonDecode(payload));
  }

  void initialize() {
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/launcher_icon"),
      iOS: IOSInitializationSettings(
          defaultPresentAlert: true,
          defaultPresentBadge: true,
          defaultPresentSound: true,
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true),
    );

    localNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  Future<void> showLocalNotifications(RemoteMessage remoteMessage) async {
    try {
      var id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      await localNotificationsPlugin.getNotificationAppLaunchDetails();
      NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "prayer",
          "prayer",
          priority: Priority.high,
          importance: Importance.max,
          color: AppColors.BACKGROUND1_COLOR,
          icon: "@mipmap/launcher_icon",
        ),
        iOS: IOSNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            subtitle: ""),
      );
      localNotificationsPlugin.show(id, remoteMessage.notification.title,
          remoteMessage.notification.body, notificationDetails,
          payload: jsonEncode(remoteMessage.data));
    } on Exception catch (e) {
      print(e);
    }
  }
}
