import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_extentions.dart';

import '../main.dart';

/// App-wide snackbar with premium dark styling.
Future<void> showSnackBar({
  required String message,
  required SnackBarType type,
}) async {
  final ScaffoldMessengerState? messenger = scaffoldMessengerKey.currentState;
  if (messenger == null) {
    return;
  }
  WidgetsBinding.instance.addPostFrameCallback((_) {
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.zero),
        ),
        margin: EdgeInsets.fromLTRB(18.w, 0, 18.w, 22.h),
        padding: EdgeInsets.zero,
        behavior: SnackBarBehavior.floating,
        clipBehavior: Clip.antiAlias,
        duration: const Duration(seconds: 3),
        dismissDirection: DismissDirection.horizontal,
        content: SizedBox(
          width: double.infinity,
          child: _CartoonSnackBody(message: message, type: type),
        ),
      ),
    );
  });
}

enum SnackBarType { SUCCESS, ERROR, None }

class _CartoonSnackBody extends StatelessWidget {
  const _CartoonSnackBody({required this.message, required this.type});

  final String message;
  final SnackBarType type;

  Color get _surfacePrimary {
    switch (type) {
      case SnackBarType.SUCCESS:
        return const Color(0xFF1E7A49);
      case SnackBarType.ERROR:
        return const Color(0xFFAD2E56);
      case SnackBarType.None:
        return const Color(0xFF9B7409);
    }
  }

  Color get _surfaceSecondary {
    switch (type) {
      case SnackBarType.SUCCESS:
        return const Color(0xFF2C8F5B);
      case SnackBarType.ERROR:
        return const Color(0xFFC83D68);
      case SnackBarType.None:
        return const Color(0xFFB88B15);
    }
  }

  Color get _accentColor {
    switch (type) {
      case SnackBarType.SUCCESS:
        return const Color(0xFFD8FBE6);
      case SnackBarType.ERROR:
        return const Color(0xFFFFE0EA);
      case SnackBarType.None:
        return const Color(0xFFFFF0C8);
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
        return const Color(0xFF0E5F36);
      case SnackBarType.ERROR:
        return const Color(0xFF8C1F44);
      case SnackBarType.None:
        return const Color(0xFF7C5A00);
    }
  }

  Color get _messageColor {
    return const Color(0xFFFFFFFF);
  }

  @override
  Widget build(BuildContext context) {
    final double radius = 18.r;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            offset: Offset(0, 5.h),
            blurRadius: 14.r,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: _surfacePrimary,
          borderRadius: BorderRadius.circular(radius),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[_surfaceSecondary, _surfacePrimary],
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 5.w,
                decoration: BoxDecoration(
                  color: _accentColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(radius),
                    bottomLeft: Radius.circular(radius),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(12.w, 12.h, 14.w, 12.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: <Color>[
                              Colors.white.withValues(alpha: 0.26),
                              Colors.white.withValues(alpha: 0.12),
                            ],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.10),
                              offset: Offset(0, 3.h),
                              blurRadius: 8.r,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.5.r),
                          child: Icon(_glyph, size: 20.sp, color: _glyphColor),
                        ),
                      ),
                      11.spaceW,
                      Expanded(
                        child: message.appText(
                          color: _messageColor,
                          textAlign: TextAlign.start,
                          fontWeight: FontWeight.w700,
                          height: 1.35,
                          fontSize: 14.5,
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
