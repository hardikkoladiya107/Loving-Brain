import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/other/v2_notification_scheduler.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';

class NotificationUtil {
  NotificationUtil._();

  static const String channelId = 'com.app.lovingbrain';
  static const String channelName = 'Loving Brain Notifications';
  static const String channelDesc =
      'Loving Brain mobile app notifications for bedtime, routines, sleep, and family updates';

  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static FlutterLocalNotificationsPlugin instance() => _localNotifications;

  static String? _pendingNotificationRoute;

  /// Returns and clears any pending route queued by cold-start notification clicks.
  static String? consumePendingNotificationRoute() {
    final String? route = _pendingNotificationRoute;
    _pendingNotificationRoute = null;
    return route;
  }

  /// Resolves the app route for a given notification payload or type string.
  static String resolveRouteForPayload(String? payload) {
    if (payload == null || payload.trim().isEmpty) {
      return RoutePaths.base;
    }
    final String clean = payload.trim();

    // V2 Sleep notifications -> Tonight's Plan (Doc 03 §2)
    if (clean == 'sleep_window' ||
        clean == 'sleep_estimate_changed' ||
        clean == 'tonights_plan' ||
        clean == 'sleep_plan') {
      return RoutePaths.tonightsPlan;
    }

    // V2 Behaviour risk notification -> Calm Plan (Doc 03 §2)
    if (clean == 'calm_heads_up' || clean == 'calm_plan') {
      return RoutePaths.calmPlan;
    }

    // V2 Weekly review notification -> Journey / Weekly Review (Doc 03 §2)
    if (clean == 'weekly_review' || clean == 'weekly_family_review') {
      return RoutePaths.weeklyReview;
    }

    // V2 Mentorship session booking & reminders (Doc 03 §2)
    if (clean == 'mentorship_booking' ||
        clean == 'mentorship_reminder' ||
        clean == 'session_confirmation') {
      return RoutePaths.sessionConfirmation;
    }

    // V2 Waitlist or general mentorship availability -> Mentorship Landing (Screen 43)
    if (clean == 'waitlist_availability' || clean == 'mentorship') {
      return RoutePaths.mentorshipLanding;
    }

    // Quick check-in prompt -> Quick Update (Screen 22 / AddBehaviourSheet)
    if (clean == 'gentle_check_in' || clean == 'quick_update') {
      return RoutePaths.quickUpdate;
    }

    if (clean == 'energy_bridge' || clean.startsWith('energy_bridge:')) {
      return RoutePaths.base;
    }
    if (clean == 'invitation' ||
        clean == 'co_parent_invitation' ||
        clean == 'invite') {
      return RoutePaths.inviteRespond;
    }
    if (clean == 'essentials') {
      return RoutePaths.essentials;
    }
    if (clean == 'help' || clean == 'guidance') {
      return RoutePaths.helpProblemSelection;
    }
    if (clean == 'family_snapshot') {
      return RoutePaths.familySnapshot;
    }
    if (clean == 'subscription') {
      return RoutePaths.subscription;
    }
    return RoutePaths.base;
  }

  /// Centralized notification click handler for foreground, background, and cold start.
  static void handleNotificationClick(String? payload) {
    if (payload == null) return;
    V2NotificationScheduler.recordOpened(payload);
    final String targetRoute = resolveRouteForPayload(payload);

    final BuildContext? context = navigatorKey.currentContext;
    if (context != null && context.mounted) {
      final UserModel? userModel = preferences.getUserModel();
      final bool isLogin =
          (preferences.getBool(SharedPreference.isLogin) ?? false) &&
          (userModel?.uid?.trim().isNotEmpty ?? false);

      if (isLogin) {
        if (userModel?.isOnboardingCompleted != true) {
          context.go(RoutePaths.onboarding);
          return;
        }
        context.push(targetRoute);
      } else {
        context.go(RoutePaths.welcome);
      }
    } else {
      _pendingNotificationRoute = targetRoute;
    }
  }

  static Future<void> initializePlatformNotifications() async {
    if (!kIsWeb && Platform.isIOS) {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_notification_icon');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestSoundPermission: false,
          requestBadgePermission: false,
          requestAlertPermission: false,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    // Create high-importance notification channel on Android (API 26+)
    if (!kIsWeb && Platform.isAndroid) {
      const AndroidNotificationChannel androidNotificationChannel =
          AndroidNotificationChannel(
            channelId,
            channelName,
            description: channelDesc,
            importance: Importance.max,
            playSound: true,
            enableVibration: true,
          );

      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _localNotifications
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();

      await androidImplementation?.createNotificationChannel(
        androidNotificationChannel,
      );
    }

    await _localNotifications.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse? payload) {
        handleNotificationClick(payload?.payload);
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    // Check if cold start was launched from a local notification
    final NotificationAppLaunchDetails? launchDetails =
        await _localNotifications.getNotificationAppLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp ?? false) {
      final NotificationResponse? response =
          launchDetails?.notificationResponse;
      if (response != null && response.payload != null) {
        handleNotificationClick(response.payload);
      }
    }

    // Foreground FCM listener: display local banner for data-only messages.
    // On iOS, messages that already include a notification payload are presented
    // by setForegroundNotificationPresentationOptions — avoid a second banner.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final bool hasNotificationPayload = message.notification != null;
      if (!kIsWeb && Platform.isIOS && hasNotificationPayload) {
        return;
      }

      final String title =
          message.notification?.title ??
          message.data['title']?.toString() ??
          'Loving Brain';
      final String body =
          message.notification?.body ?? message.data['body']?.toString() ?? '';
      final String payload =
          message.data['type']?.toString() ??
          message.data['route']?.toString() ??
          '';

      if (title.isNotEmpty || body.isNotEmpty) {
        await showLocalNotification(
          id: message.hashCode,
          title: title,
          body: body,
          payload: payload,
        );
      }
    }, onError: (_) {});

    // FCM opened app from background listener
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final String payload =
          message.data['type']?.toString() ??
          message.data['route']?.toString() ??
          '';
      handleNotificationClick(payload);
    }, onError: (_) {});

    // FCM cold start launch
    final RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();
    if (initialMessage != null) {
      final String payload =
          initialMessage.data['type']?.toString() ??
          initialMessage.data['route']?.toString() ??
          '';
      handleNotificationClick(payload);
    }
  }

  static Future<bool> isPermissionGranted() async {
    try {
      if (Firebase.apps.isNotEmpty) {
        final NotificationSettings settings = await FirebaseMessaging.instance
            .getNotificationSettings();
        if (settings.authorizationStatus == AuthorizationStatus.authorized ||
            settings.authorizationStatus == AuthorizationStatus.provisional) {
          return true;
        }
      }
      if (!kIsWeb && Platform.isAndroid) {
        final bool? enabled = await _localNotifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.areNotificationsEnabled();
        if (enabled == true) {
          return true;
        }
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> requestNotificationPermission() async {
    try {
      bool isAuthorized = false;
      if (Firebase.apps.isNotEmpty) {
        final NotificationSettings settings = await FirebaseMessaging.instance
            .requestPermission(alert: true, badge: true, sound: true);
        isAuthorized =
            settings.authorizationStatus == AuthorizationStatus.authorized ||
            settings.authorizationStatus == AuthorizationStatus.provisional;
      }

      if (!kIsWeb && Platform.isAndroid) {
        final bool? androidGranted = await _localNotifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.requestNotificationsPermission();
        if (androidGranted != null) {
          isAuthorized = isAuthorized || androidGranted;
        }
      }

      await preferences.putBool(
        SharedPreference.notificationPermissionRequested,
        true,
      );
      return isAuthorized;
    } catch (_) {}
    return false;
  }

  static Future<void> initializeBGNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_notification_icon');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _localNotifications.initialize(settings: initializationSettings);
  }

  static Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) async {
    try {
      final NotificationDetails platformChannelSpecifics =
          await _notificationDetails(
            channelId: channelId,
            channelName: channelName,
            channelDesc: channelDesc,
          );
      await _localNotifications.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: platformChannelSpecifics,
        payload: payload,
      );
    } catch (_) {}
  }

  static Future<bool> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
    required DateTime scheduledDate,
  }) async {
    try {
      final NotificationDetails platformChannelSpecifics =
          await _notificationDetails(
            channelId: channelId,
            channelName: channelName,
            channelDesc: channelDesc,
          );
      await _localNotifications.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: tz.TZDateTime.from(scheduledDate, tz.local),
        notificationDetails: platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: payload,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Opens the OS page where the parent can enable notifications for this app.
  static Future<void> openSystemNotificationSettings() async {
    try {
      if (kIsWeb) {
        return;
      }
      if (Platform.isIOS) {
        await launchUrl(Uri.parse('app-settings:'));
        return;
      }
      if (Platform.isAndroid) {
        final Uri notificationSettings = Uri.parse(
          'intent:#Intent;action=android.settings.APP_NOTIFICATION_SETTINGS;'
          'S.android.provider.extra.APP_PACKAGE=com.app.loving_brain;end',
        );
        if (await canLaunchUrl(notificationSettings)) {
          await launchUrl(
            notificationSettings,
            mode: LaunchMode.externalApplication,
          );
          return;
        }
        final Uri appDetails = Uri.parse(
          'intent:#Intent;action=android.settings.APPLICATION_DETAILS_SETTINGS;'
          'data=package:com.app.loving_brain;end',
        );
        if (await canLaunchUrl(appDetails)) {
          await launchUrl(appDetails, mode: LaunchMode.externalApplication);
        }
      }
    } catch (_) {}
  }

  /// True when the OS has already been asked for notification permission.
  static Future<bool> wasNotificationPermissionRequested() async {
    return preferences.getBool(
          SharedPreference.notificationPermissionRequested,
        ) ??
        false;
  }

  static Future<void> cancelNotification(int id) async {
    try {
      await _localNotifications.cancel(id: id);
    } catch (_) {}
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
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          channelId,
          channelName,
          channelDescription: channelDesc,
          icon: '@drawable/ic_notification_icon',
          color: const Color(0xFFFA8676),
          importance: Importance.max,
          priority: Priority.max,
          playSound: sound,
          showProgress: showProgress,
          progress: progress,
          maxProgress: maxProgress,
          onlyAlertOnce: onlyAlertOnce,
          enableVibration: vibration,
        );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        presentBanner: true,
        presentList: true,
      ),
    );
    return platformChannelSpecifics;
  }
}
