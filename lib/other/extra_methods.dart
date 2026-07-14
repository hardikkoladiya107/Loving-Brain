import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';

import '../generated/locale_keys.g.dart';
import '../model/api_result_status.dart';

Future<String> getUniqueDeviceId() async {
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  if (Platform.isAndroid) {
    final androidInfo = await deviceInfo.androidInfo;
    return androidInfo.id;
  } else if (Platform.isIOS) {
    final iosInfo = await deviceInfo.iosInfo;
    return iosInfo.identifierForVendor ?? "unknown-ios";
  } else {
    return "unsupported-platform";
  }
}

String formatDate(DateTime dateOfBirth) {
  String formattedDate = DateFormat('yyyy-MM-dd').format(dateOfBirth);
  return formattedDate;
}

ApiResultStatus onFirebaseException(FirebaseException e) {
  if (e.code == 'permission-denied') {
    return ApiResultStatus.error(
      error: Exception(LocaleKeys.somethingWentWrong.tr()),
    );
  } else if (e.code == 'unavailable') {
    return ApiResultStatus.error(
      error: Exception(LocaleKeys.somethingWentWrong.tr()),
    );
  } else if (e.code == 'not-found') {
    return ApiResultStatus.error(
      error: Exception(LocaleKeys.somethingWentWrong.tr()),
    );
  } else if (e.code == 'invalid-email') {
    return ApiResultStatus.error(
      error: Exception(LocaleKeys.pleaseEnterValidEmail.tr()),
    );
  } else if (e.code == 'user-disabled') {
    return ApiResultStatus.error(error: Exception("User has been disabled."));
  } else if (e.code == 'user-not-found') {
    return ApiResultStatus.error(
      error: Exception(LocaleKeys.userNotFound.tr()),
    );
  } else if (e.code == 'wrong-password') {
    return ApiResultStatus.error(
      error: Exception(LocaleKeys.invalidPassword.tr()),
    );
  } else if (e.code == 'email-already-in-use') {
    return ApiResultStatus.error(
      error: Exception(LocaleKeys.accountAlreadyExists.tr()),
    );
  } else if (e.code == 'weak-password') {
    return ApiResultStatus.error(
      error: Exception(LocaleKeys.passwordShouldBeMoreLetters.tr()),
    );
  } else if (e.code == 'invalid-credential') {
    return ApiResultStatus.error(
      error: Exception(LocaleKeys.invalidPassword.tr()),
    );
  } else if (e.code == 'requires-recent-login') {
    return ApiResultStatus.error(
      error: Exception(LocaleKeys.pleaseSignInAgainToDeleteAccount.tr()),
    );
  } else {
    return ApiResultStatus.error(
      error: Exception(e.message ?? LocaleKeys.somethingWentWrong.tr()),
    );
  }
}

bool isSameDate(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

bool isBeforeYesterday(DateTime input) {
  DateTime now = DateTime.now();
  DateTime yesterday = DateTime(
    now.year,
    now.month,
    now.day,
  ).subtract(Duration(days: 1));
  DateTime inputDate = DateTime(
    input.year,
    input.month,
    input.day,
  ); // ignore time
  return inputDate.isBefore(yesterday);
}

String getStringDate(DateTime? input) {
  if (input == null) {
    return "";
  }

  String formattedTime = DateFormat('yyyy-MM-dd').format(input);
  return formattedTime;
}

String getStringDateTime(DateTime? input) {
  if (input == null) {
    return "";
  }

  String formattedTime = DateFormat('yyyy-MM-dd hh:mm a').format(input);
  return formattedTime;
}

String getStringTime(DateTime? input) {
  if (input == null) {
    return "";
  }
  String formattedTime = DateFormat('hh:mm a').format(input);
  return formattedTime;
}

String convertToMMMMDYYYY(DateTime? input) {
  if (input == null) {
    return "";
  }
  String formatted = DateFormat('MMM d, yyyy').format(input);
  return formatted;
}

String coParentScheduleTime(DateTime? input) {
  if (input == null) {
    return "";
  }
  String formatted = DateFormat('MMM d - hh:mm a').format(input);
  return formatted;
}

String coParentEventDetailTime(DateTime? input) {
  if (input == null) {
    return "";
  }
  String formatted = DateFormat('EEE, MMM d').format(input);
  return formatted;
}
