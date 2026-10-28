import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loving_brain/other/app_color.dart';

/// Centralized animated three-bounce loading indicator across LovingBrain.
/// Matches the design system and replaces generic CircularProgressIndicator.
class AppLoadingIndicator extends StatelessWidget {
  final Color color;
  final double? size;
  final bool centered;

  const AppLoadingIndicator({
    super.key,
    this.color = primaryColor,
    this.size,
    this.centered = true,
  });

  @override
  Widget build(BuildContext context) {
    final Widget indicator = SpinKitThreeBounce(
      color: color,
      size: (size ?? 24).r,
    );

    if (centered) {
      return Center(child: indicator);
    }
    return indicator;
  }
}
