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
  }) {
    return Text(
      this,
      textAlign: textAlign ?? TextAlign.center,
      style: getTextStyle(
        fontSize: (fontSize ?? 16).sp,
        color: color,
        fontStyle: fontStyle,
        fontWeight: fontWeight ?? FontWeight.normal,
        letterSpacing: letterSpacing ?? 1,
      ),
    );
  }

  String replaceAll2(String from, String replace) {
    if (replace.isNotEmpty) {
      return replaceAll(from, replace);
    }
    return replaceAll(from, "");
  }

  String replaceOrRemove(String from, String replace) {
    if (replace.isEmpty) {
      return removeTagBlockContainingText(this, from);
    } else {
      return replaceAll2(from, replace);
    }
  }
}

String removeTagBlockContainingText(
  String input,
  String keyword, {
  String startTag = '{start_tag}',
  String endTag = '{end_tag}',
}) {
  final keywordIndex = input.indexOf(keyword);
  if (keywordIndex == -1) return input;

  final startIndex = input.lastIndexOf(startTag, keywordIndex);
  if (startIndex == -1) return input;

  int depth = 1;
  int i = startIndex + startTag.length;

  while (i < input.length && depth > 0) {
    final nextStart = input.indexOf(startTag, i);
    final nextEnd = input.indexOf(endTag, i);

    if (nextEnd == -1) break;

    if (nextStart != -1 && nextStart < nextEnd) {
      depth++;
      i = nextStart + startTag.length;
    } else {
      depth--;
      i = nextEnd + endTag.length;
    }
  }

  return input.replaceRange(startIndex, i, '');
}

TextStyle getTextStyle({
  double? fontSize,
  Color? color,
  FontWeight? fontWeight,
  double? letterSpacing,
  FontStyle? fontStyle,
}) {
  return GoogleFonts.quicksand(
    fontSize: fontSize ?? 16,
    fontStyle: fontStyle,
    color: color,
    fontWeight: fontWeight ?? FontWeight.normal,
    letterSpacing: letterSpacing ?? 1,
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
  Widget padding({
    double? all,
    double? left,
    double? right,
    double? top,
    double? bottom,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: all ?? left ?? 0.0,
        right: all ?? right ?? 0.0,
        top: all ?? top ?? 0.0,
        bottom: all ?? bottom ?? 0.0,
      ),
      child: this,
    );
  }

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
