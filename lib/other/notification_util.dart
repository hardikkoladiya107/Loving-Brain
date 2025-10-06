import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:loving_brain/ui/your_streak/your_streak_screen.dart';

import '../../main.dart';

class NotificationUtil {
  NotificationUtil._();

  static String channelId = 'com.app.lovingbrain';
  static String channelName = 'loving Brain Notification';
  static String channelDesc = 'loving Brain mobile app notification channel';
  static final _localNotifications = FlutterLocalNotificationsPlugin();

  static FlutterLocalNotificationsPlugin instance() => _localNotifications;

  static Future<void> initializePlatformNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_notification_icon');

    DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestSoundPermission: true,
          requestBadgePermission: true,
          requestAlertPermission: true,
        );

    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse? payload) {
        onDidReceiveLocalNotification(payload);
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (Platform.isAndroid) {
        await _localNotifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.requestNotificationsPermission();
      }

      showLocalNotification(
        id: message.data.hashCode,
        title: message.notification?.title ?? "",
        body: message.notification?.body ?? "",
        payload: message.toString(),
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (navigatorKey.currentContext != null) {
        _handleMessageClick(navigatorKey.currentContext!, message);
      }
    });
    FirebaseMessaging.instance.getInitialMessage().then((value) {
      if (value != null) {
        if (navigatorKey.currentContext != null) {
          _handleMessageClick(navigatorKey.currentContext!, value);
        }
      }
    });
  }

  static void _handleMessageClick(BuildContext context, RemoteMessage message) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const YourStreakScreen()));
  }

  static Future<void> initializeBGNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_notification_icon');

    DarwinInitializationSettings initializationSettingsIOS =
        const DarwinInitializationSettings();

    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotifications.initialize(initializationSettings);
  }

  static void onDidReceiveLocalNotification(dynamic payload) {
    if (payload != null) {}
  }

  static Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) async {
    final platformChannelSpecifics = await _notificationDetails(
      channelId: channelId,
      channelName: channelName,
      channelDesc: channelDesc,
    );
    await _localNotifications.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      // payload: payload,
    );
  }

  static Future<NotificationDetails> _notificationDetails({
    required String channelId,
    required String channelName,
    required String channelDesc,
    bool sound = true,
    bool vibration = true,
    bool showProgress = false,
    bool onlyAlertOnce = false,
    int progress = 0,
    int maxProgress = 0,
  }) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          channelId,
          channelName,
          channelDescription: channelDesc,
          importance: Importance.max,
          priority: Priority.max,
          playSound: sound,
          showProgress: showProgress,
          progress: progress,
          maxProgress: maxProgress,
          onlyAlertOnce: onlyAlertOnce,
          enableVibration: vibration,
        );

    await _localNotifications.getNotificationAppLaunchDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(presentSound: sound),
    );
    return platformChannelSpecifics;
  }
}
