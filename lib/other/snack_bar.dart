import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';

import '../main.dart';

/// App-wide toast-style snackbar: chunky outline, playful shadow, QuickSand text.
Future<void> showSnackBar({
  required String message,
  required SnackBarType type,
}) async {
  final BuildContext? context = navigatorKey.currentContext;
  if (context == null) {
    return;
  }
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.zero),
      ),
      margin: EdgeInsets.fromLTRB(18.w, 0, 18.w, 22.h),
      padding: EdgeInsets.zero,
      behavior: SnackBarBehavior.floating,
      clipBehavior: Clip.none,
      duration: const Duration(seconds: 3),
      dismissDirection: DismissDirection.horizontal,
      content: _CartoonSnackBody(message: message, type: type),
    ),
  );
}

enum SnackBarType { SUCCESS, ERROR, None }

/// Matches the punchy pastel + outline look used across the rest of the app.
class _CartoonSnackBody extends StatelessWidget {
  const _CartoonSnackBody({required this.message, required this.type});

  final String message;
  final SnackBarType type;

  static const Color _inkOutline = Color(0xFF2E2640);

  Color get _bubbleFill {
    switch (type) {
      case SnackBarType.SUCCESS:
        return const Color(0xFFE6FADB);
      case SnackBarType.ERROR:
        return const Color(0xFFFFE5EE);
      case SnackBarType.None:
        return const Color(0xFFFFF9E8);
    }
  }

  Color get _ribbon {
    switch (type) {
      case SnackBarType.SUCCESS:
        return greenPlayButtonColor;
      case SnackBarType.ERROR:
        return pinkColor;
      case SnackBarType.None:
        return yellowButtonColor;
    }
  }

  IconData get _glyph {
    switch (type) {
      case SnackBarType.SUCCESS:
        return Icons.celebration_rounded;
      case SnackBarType.ERROR:
        return Icons.sentiment_very_dissatisfied_rounded;
      case SnackBarType.None:
        return Icons.notifications_rounded;
    }
  }

  Color get _glyphColor {
    switch (type) {
      case SnackBarType.SUCCESS:
        return const Color(0xFF237B3F);
      case SnackBarType.ERROR:
        return const Color(0xFFA61B3A);
      case SnackBarType.None:
        return primaryColor;
    }
  }

  Color get _messageColor {
    switch (type) {
      case SnackBarType.SUCCESS:
        return const Color(0xFF1F4D31);
      case SnackBarType.ERROR:
        return const Color(0xFF5C1430);
      case SnackBarType.None:
        return blackTextColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double radius = 22.r;
    final double borderW = 2.8.r;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: _inkOutline.withValues(alpha: 0.28),
            offset: Offset(5.w, 5.h),
            blurRadius: 0,
          ),
          BoxShadow(
            color: _ribbon.withValues(alpha: 0.45),
            offset: Offset(2.5.w, 2.5.h),
            blurRadius: 0,
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: _bubbleFill,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: _inkOutline, width: borderW),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius - borderW * 0.5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(width: 8.w, color: _ribbon),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(12.w, 14.h, 16.w, 14.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.92),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _inkOutline.withValues(alpha: 0.55),
                            width: 2.r,
                          ),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: _inkOutline.withValues(alpha: 0.12),
                              offset: Offset(2.w, 2.h),
                              blurRadius: 0,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.r),
                          child: Icon(_glyph, size: 24.sp, color: _glyphColor),
                        ),
                      ),
                      10.spaceW,
                      Expanded(
                        child: message.appText(
                          color: _messageColor,
                          textAlign: TextAlign.start,
                          fontWeight: FontWeight.w800,
                          height: 1.28,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
