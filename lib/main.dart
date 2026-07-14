import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/provider.dart';
import 'package:loving_brain/router/app_router.dart';
import 'firebase_options.dart';
import 'generated/locale_keys.g.dart';
import 'manager/deep_link/deep_link_manager.dart';
import 'manager/google_sign_in/google_signin_manager.dart';
import 'other/app_extentions.dart';
import 'other/notification_util.dart';
import 'other/preferances.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationUtil.initializeBGNotifications();

  final String title =
      message.notification?.title ?? message.data['title']?.toString() ?? '';
  final String body =
      message.notification?.body ?? message.data['body']?.toString() ?? '';

  await NotificationUtil.showLocalNotification(
    id: message.hashCode,
    title: title,
    body: body,
    payload: message.data['type']?.toString() ?? '',
  );
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse? payload) {
  if (payload != null) {
    //Get.toNamed(Routes.login);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await SharedPreference.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GoogleSignInManager.instance.initialise();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('gu'), Locale('hi')],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      child: MyApp(),
    ),
  );
  configLoading();
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final _router = AppRouter.createRouter(navigatorKey);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initNotification();
      // Must run at startup so invitation links work on cold start (before BaseScreen).
      DeepLinkManager.instance.init();
    });
  }

  Future<void> initNotification() async {
    await NotificationUtil.initializePlatformNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: blocProvider,
      child: ScreenUtilInit(
        designSize: const Size(389, 780),
        minTextAdapt: true,
        splitScreenMode: true,
        child: MaterialApp.router(
          routerConfig: _router,
          scaffoldMessengerKey: scaffoldMessengerKey,
          title: LocaleKeys.appName.tr(),
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          builder: EasyLoading.init(),
        ),
      ),
    );
  }
}

void configLoading() {
  final Color indicatorColor = const Color(0xFF9F35B1);
  final Color backgroundColor = Colors.white;
  final Color textColor = const Color(0xFF1A1A1A);
  final Color maskColor = const Color(0x80FFFFFF);

  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 50.0
    ..radius = 12.0
    ..progressColor = indicatorColor
    ..backgroundColor = backgroundColor
    ..indicatorColor = indicatorColor
    ..textColor = textColor
    ..maskColor = maskColor
    ..userInteractions = false
    ..dismissOnTap = false
    ..textStyle = getTextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: textColor,
      letterSpacing: 0.3,
    )
    ..contentPadding = const EdgeInsets.symmetric(horizontal: 24, vertical: 20)
    ..textPadding = const EdgeInsets.only(top: 12)
    ..boxShadow = [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.15),
        blurRadius: 20.0,
        spreadRadius: 2.0,
        offset: const Offset(0, 4),
      ),
    ];
}
