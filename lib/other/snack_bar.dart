import 'package:flutter/material.dart';
import 'package:loving_brain/other/app_extentions.dart';

import '../main.dart';

Future<void> showSnackBar({
  required String message,
  required SnackBarType type,
}) async {
  ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
    SnackBar(
      backgroundColor: type == SnackBarType.None
          ? Colors.white
          : type == SnackBarType.SUCCESS
          ? Colors.green
          : Colors.red,
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.all(10),
      behavior: SnackBarBehavior.floating,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: message.appText(
              color: type == SnackBarType.None ? Colors.black : Colors.white,
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    ),
  );
}

enum SnackBarType { SUCCESS, ERROR, None }
