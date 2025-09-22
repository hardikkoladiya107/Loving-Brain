import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loving_brain/provider.dart';
import 'package:loving_brain/ui/splash/splash_screen.dart';

import 'firebase_options.dart';
import 'generated/locale_keys.g.dart';
import 'manager/google_sign_in/google_signin_manager.dart';
import 'other/preferances.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await SharedPreference.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    GoogleSignInManager.instance.initialise();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: blocProvider,
      child: ScreenUtilInit(
        designSize: const Size(389, 780),
        minTextAdapt: true,
        splitScreenMode: true,
        child: MaterialApp(
          navigatorKey: navigatorKey,
          title: LocaleKeys.appName.tr(),
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          builder: EasyLoading.init(),
          home: SplashScreen(),
        ),
      ),
    );
  }
}

void configLoading() {
  EasyLoading.instance
    ..radius = 10.0
    ..indicatorWidget = Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SpinKitFadingCircle(color: Colors.black),
    )
    ..contentPadding = EdgeInsets.zero
    ..userInteractions = false
    ..dismissOnTap = false;
}
