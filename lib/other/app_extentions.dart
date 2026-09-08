import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

extension extOnString on String {
  Widget appText({
    double? fontSize,
    Color? color,
    FontWeight? fontWeight,
    double? letterSpacing,
    TextAlign? textAlign,
    FontStyle? fontStyle,
    int? maxLines,
    TextOverflow? overflow,
    TextDecoration? textDecoration,
    double? height,
    TextStyle? textStyle,
  }) {
    return Text(
      this,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign ?? TextAlign.center,
      style: textStyle ?? getTextStyle(
        fontSize: (fontSize ?? 16).sp,
        color: color,
        fontStyle: fontStyle,
        textDecoration: textDecoration,
        fontWeight: fontWeight ?? FontWeight.normal,
        letterSpacing: letterSpacing ?? 1,
        height: height,
      ),
    );
  }

  Widget appText2({
    double? fontSize,
    Color? color,
    FontWeight? fontWeight,
    double? letterSpacing,
    TextAlign? textAlign,
    FontStyle? fontStyle,
    int? maxLines,
    TextOverflow? overflow,
    TextDecoration? textDecoration,
    double? height,
    TextStyle? textStyle,
  }) {
    return Text(
      this,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign ?? TextAlign.center,
      style: textStyle ?? getTextStyle2(
        fontSize: (fontSize ?? 16).sp,
        color: color,
        fontStyle: fontStyle,
        textDecoration: textDecoration,
        fontWeight: fontWeight ?? FontWeight.normal,
        letterSpacing: letterSpacing ?? 1,
        height: height,
      ),
    );
  }


  String replaceAll2(String from, String replace) {
    if (replace.isNotEmpty) {
      return replaceAll(from, replace);
    }
    return replaceAll(from, "");
  }

  bool get isValidEmail {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(this);
  }
}

extension DateTimeAgo on DateTime {
  String timeAgo() {
    final Duration diff = DateTime.now().difference(this);

    if (diff.inSeconds < 60) {
      return "just now";
    } else if (diff.inMinutes < 60) {
      final m = diff.inMinutes;
      return "$m minute${m == 1 ? '' : 's'} ago";
    } else if (diff.inHours < 24) {
      final h = diff.inHours;
      return "$h hour${h == 1 ? '' : 's'} ago";
    } else if (diff.inDays < 30) {
      final d = diff.inDays;
      return "$d day${d == 1 ? '' : 's'} ago";
    } else if (diff.inDays < 365) {
      final m = (diff.inDays / 30).floor();
      return "$m month${m == 1 ? '' : 's'} ago";
    } else {
      final y = (diff.inDays / 365).floor();
      return "$y year${y == 1 ? '' : 's'} ago";
    }
  }
}

extension FirebaseUrlUtils on String {
  /// Extracts file name (with extension) from a Firebase Storage URL
  String get firebaseFileName {
    try {
      // Decode URL to handle %2F etc.
      final decoded = Uri.decodeFull(this);
      // Split by '/' and get the last part (file name with extension)
      final parts = decoded.split('/');
      if (parts.isNotEmpty) {
        // Remove query parameters if present
        return parts.last.split('?').first;
      }
      return '';
    } catch (_) {
      return '';
    }
  }
}


TextStyle getTextStyle({
  double? fontSize,
  Color? color,
  FontWeight? fontWeight,
  double? letterSpacing,
  FontStyle? fontStyle,
  TextDecoration? textDecoration,
  double? height,
}) {
  return GoogleFonts.quicksand(
    fontSize: fontSize ?? 16,
    fontStyle: fontStyle,
    decoration: textDecoration,
    color: color,
    fontWeight: fontWeight ?? FontWeight.normal,
    letterSpacing: letterSpacing ?? 1,
    height: height,
  );
}

TextStyle getTextStyle2({
  double? fontSize,
  Color? color,
  FontWeight? fontWeight,
  double? letterSpacing,
  FontStyle? fontStyle,
  TextDecoration? textDecoration,
  double? height,
}) {
  return GoogleFonts.fraunces(
    fontSize: fontSize ?? 16,
    fontStyle: fontStyle,
    decoration: textDecoration,
    color: color,
    fontWeight: fontWeight ?? FontWeight.normal,
    letterSpacing: letterSpacing ?? 1,
    height: height,
  );
}

TextStyle getTextStyle3({
  double? fontSize,
  Color? color,
  FontWeight? fontWeight,
  double? letterSpacing,
  FontStyle? fontStyle,
  TextDecoration? textDecoration,
  double? height,
}) {
  return GoogleFonts.fraunces(
    fontSize: fontSize ?? 16,
    fontStyle: fontStyle,
    decoration: textDecoration,
    color: color,
    fontWeight: fontWeight ?? FontWeight.normal,
    letterSpacing: letterSpacing ?? 1,
    height: height,
  );
}

extension extOnContext on BuildContext {
  double get width {
    return MediaQuery.of(this).size.width;
  }

  double get height {
    return MediaQuery.of(this).size.height;
  }
}

extension extOnDouble on double {
  Widget get spaceH {
    return SizedBox(height: this);
  }

  Widget get spaceW {
    return SizedBox(width: this);
  }

  double toDoubleAsFixed(int i) {
    return double.parse(toStringAsFixed(i));
  }
}

extension extOnInt on int {
  Widget get spaceH {
    return SizedBox(height: h);
  }

  Widget get spaceW {
    return SizedBox(width: w);
  }
}

extension extOnWidget on Widget {
  Widget appPadding({
    double? all,
    double? left,
    double? right,
    double? top,
    double? bottom,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: (all ?? left ?? 0.0).w,
        right: (all ?? right ?? 0.0).w,
        top: (all ?? top ?? 0.0).h,
        bottom: (all ?? bottom ?? 0.0).h,
      ),
      child: this,
    );
  }
}
