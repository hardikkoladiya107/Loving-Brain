import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:loving_brain/generated/locale_keys.g.dart';
import 'package:loving_brain/other/app_extentions.dart';

import '../../../other/app_color.dart';

class UnsupportedDeviceApp extends StatelessWidget {
  const UnsupportedDeviceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: LocaleKeys.appName.tr(),
      debugShowCheckedModeBanner: false,
      supportedLocales: const [],
      home: const NotSupportedScreen(),
    );
  }
}

class NotSupportedScreen extends StatelessWidget {
  const NotSupportedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Row(),
          LocaleKeys.notSupportedInThisDevice.tr().appText(),
        ],
      ),
    );
  }
}
