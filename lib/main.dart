import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loving_brain/provider.dart';
import 'package:loving_brain/router/app_router.dart';
import 'firebase_options.dart';
import 'generated/locale_keys.g.dart';
import 'manager/deep_link/deep_link_manager.dart';
import 'manager/google_sign_in/google_signin_manager.dart';
import 'other/app_color.dart';
import 'other/app_extentions.dart';
import 'other/notification_util.dart';
import 'other/preferances.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationUtil.initializeBGNotifications();

  // Data-only messages are not automatically displayed by the Android OS tray,
  // so we display them via local notifications while preventing duplicates for notification messages.
  if (message.notification == null) {
    final String title = message.data['title']?.toString() ?? 'Loving Brain';
    final String body = message.data['body']?.toString() ?? '';
    final String payload =
        message.data['type']?.toString() ??
        message.data['route']?.toString() ??
        '';

    if (title.isNotEmpty || body.isNotEmpty) {
      await NotificationUtil.showLocalNotification(
        id: message.hashCode,
        title: title,
        body: body,
        payload: payload,
      );
    }
  }
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse? payload) {
  if (payload != null && payload.payload != null) {
    NotificationUtil.handleNotificationClick(payload.payload);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await EasyLocalization.ensureInitialized();
  await SharedPreference.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GoogleSignInManager.instance.initialise();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  configLoading();
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('gu'), Locale('hi')],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      child: MyApp(),
    ),
  );
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
          theme: ThemeData(
            scaffoldBackgroundColor: const Color(0xFFFEF8F4),
            canvasColor: const Color(0xFFFEF8F4),
            colorScheme: ColorScheme.fromSeed(
              seedColor: primaryColor,
              surface: const Color(0xFFFEF8F4),
              brightness: Brightness.light,
            ),
            fontFamily: GoogleFonts.quicksand().fontFamily,
            inputDecorationTheme: InputDecorationTheme(
              hintStyle: getTextStyle(
                fontSize: 16,
                color: greyColor4,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          builder: (BuildContext context, Widget? child) {
            final Widget easyLoadingChild = EasyLoading.init()(context, child);
            return ColoredBox(
              color: const Color(0xFFFEF8F4),
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: MediaQuery.textScalerOf(
                    context,
                  ).clamp(minScaleFactor: 0.85, maxScaleFactor: 1.35),
                ),
                child: easyLoadingChild,
              ),
            );
          },
        ),
      ),
    );
  }
}

void configLoading() {
  const Color indicatorColor = primaryColor;
  const Color backgroundColor = Color(0xFFFEF8F4);
  const Color textColor = greyColor9;
  final Color maskColor = Colors.black.withValues(alpha: 0.25);

  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.threeBounce
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 36.0
    ..radius = 24.0
    ..progressColor = indicatorColor
    ..backgroundColor = backgroundColor
    ..indicatorColor = indicatorColor
    ..textColor = textColor
    ..maskColor = maskColor
    ..maskType = EasyLoadingMaskType.custom
    ..userInteractions = false
    ..dismissOnTap = false
    ..textStyle = getTextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: textColor,
      letterSpacing: 0.2,
    )
    ..contentPadding = const EdgeInsets.symmetric(horizontal: 28, vertical: 22)
    ..textPadding = const EdgeInsets.only(top: 12)
    ..boxShadow = [
      BoxShadow(
        color: primaryColor.withValues(alpha: 0.16),
        blurRadius: 24.0,
        spreadRadius: 2.0,
        offset: const Offset(0, 8),
      ),
    ];
}
