import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:intl/intl.dart';

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
