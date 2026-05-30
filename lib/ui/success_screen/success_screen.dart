import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

class SucessScreen extends StatefulWidget {
  const SucessScreen({super.key, required this.successText});
  final String successText;

  @override
  State<SucessScreen> createState() => _SucessScreenState();
}

class _SucessScreenState extends State<SucessScreen> {
  @override
  Widget build(BuildContext context) {
    final double width = context.width;

    return Scaffold(
      body: Stack(
        children: [
          _background(),
          SafeArea(
            child: Column(
              children: [
                _appBar(),
                Expanded(child: Center(child: _successCard(width))),
                _doneButton().appPadding(left: 24, right: 24, bottom: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _background() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color(0xFFF5F1FF),
            Color(0xFFEAF8FF),
            Color(0xFFFFF9EE),
          ],
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: -70.h,
            right: -60.w,
            child: Container(
              width: 180.w,
              height: 180.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withValues(alpha: 0.12),
              ),
            ),
          ),
          Positioned(
            bottom: -80.h,
            left: -70.w,
            child: Container(
              width: 220.w,
              height: 220.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: yellowButtonColor.withValues(alpha: 0.18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _appBar() {
    return Row(
      children: <Widget>[
        BaseButton(
          child: Assets.icons.icBackIcon.image(
            height: 36.w,
            width: 36.w,
            color: Colors.black.withValues(alpha: 0.82),
          ),
          onTap: () {
            context.pop();
          },
        ),
      ],
    ).appPadding(left: 20, top: 8, right: 20);
  }

  Widget _successCard(double width) {
    return Container(
      width: width * 0.9,
      padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 26.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        color: Colors.white.withValues(alpha: 0.88),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.92),
          width: 1.5.w,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.12),
            blurRadius: 26.r,
            offset: Offset(0, 12.h),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Assets.images.imgSuccessCartoon.image(
            width: 180.w,
            fit: BoxFit.contain,
          ),
          10.h.spaceH,
          "Success".appText(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: primaryColor,
            letterSpacing: 0.4,
          ),
          10.h.spaceH,
          widget.successText.appText(
            fontSize: 16,
            color: const Color(0xFF3A3A3A),
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
            height: 1.5,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _doneButton() {
    return BaseButton(
      onTap: () {
        context.pop();
      },
      child: Container(
        height: 54.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          gradient: const LinearGradient(
            colors: <Color>[Color(0xFF9A66DB), Color(0xFF7E4CCF)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.32),
              blurRadius: 14.r,
              offset: Offset(0, 8.h),
            ),
          ],
        ),
        child: Center(
          child: "Done".appText(
            fontSize: 17,
            color: Colors.white,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}
