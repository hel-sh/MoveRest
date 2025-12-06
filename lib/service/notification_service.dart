import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const int _notificationId = 0;

  NotificationService._internal();
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> updateNotification({
    required String title,
    required String body,
    required bool isMoveState,
  }) async {
    final String status = isMoveState ? 'MOVE' : 'REST';
    final String finalTitle = isMoveState ? '$status: $title' : status;
    final AndroidNotificationDetails
    androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'timer_channel_id',
      'Workout Timer',
      channelDescription: 'Persistent notification for workout timer status.',
      importance: Importance.low,
      priority: Priority.low,
      ongoing: true,
      onlyAlertOnce: true,
      color: isMoveState ? Colors.black : Colors.white,

      styleInformation: BigTextStyleInformation(body, contentTitle: finalTitle),
    );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      _notificationId,
      finalTitle,
      body,
      platformChannelSpecifics,
    );
  }

  Future<void> cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancel(_notificationId);
  }
}
