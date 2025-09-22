import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:intl/intl.dart';

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
    return ApiResultStatus.error(error: Exception("Permission denied."));
  } else if (e.code == 'unavailable') {
    return ApiResultStatus.error(
      error: Exception("Service unavailable. Try again later."),
    );
  } else if (e.code == 'not-found') {
    return ApiResultStatus.error(error: Exception("Document not found."));
  } else if (e.code == 'invalid-email') {
    return ApiResultStatus.error(
      error: Exception("Email address is not valid!"),
    );
  } else {
    return ApiResultStatus.error(
      error: Exception("FireStore error: ${e.message}"),
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

String getStringDate(DateTime input) {
  return "${input.year}-${input.month}-${input.day}";
}

String convertToMMMMDYYYY(DateTime? input) {
  if (input == null) {
    return "";
  }
  String formatted = DateFormat('MMM d, yyyy').format(input);
  return formatted;
}
