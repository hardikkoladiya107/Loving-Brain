import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/generated/locale_keys.g.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/ui/widget/app_button.dart';

/// Screen displayed upon successful action completion.
/// Conforms to AGENTS.md §2, §3, and §6.
class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key, required this.successText});
  final String successText;

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

typedef SucessScreen = SuccessScreen;

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  Widget build(BuildContext context) {
    final double width = context.width;

    return Scaffold(
      backgroundColor: const Color(0xFFFEF8F4),
      body: Stack(
        children: [
          _background(),
          SafeArea(
            child: Column(
              children: [
                _appBar(),
                Expanded(child: Center(child: _successCard(width))),
                _doneButton().appPadding(left: 20.w, right: 20.w, bottom: 24.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _background() {
    return Stack(
      children: <Widget>[
        Positioned(
          left: -150.w,
          top: -150.h,
          child: Container(
            width: 400.w,
            height: 400.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFFFD4C8).withValues(alpha: 0.8),
                  const Color(0xFFFFD4C8).withValues(alpha: 0.0),
                ],
                stops: const [0.0, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _appBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: InkWell(
          onTap: () => context.pop(),
          child: Container(
            padding: EdgeInsets.all(8.r),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back, color: darkBlue, size: 24.sp),
          ),
        ),
      ),
    );
  }

  Widget _successCard(double width) {
    return Container(
      width: width * 0.9,
      padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 26.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20.r,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Assets.images.imgSuccessCartoon.image(
            width: 160.w,
            fit: BoxFit.contain,
          ),
          16.spaceH,
          LocaleKeys.successMessage.tr().appText(
            fontSize: 26.sp,
            fontWeight: FontWeight.bold,
            color: darkBlue,
            fraunces: true,
          ),
          12.spaceH,
          widget.successText.appText(
            fontSize: 15.sp,
            color: greyColor,
            fontWeight: FontWeight.w500,
            height: 1.5,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _doneButton() {
    return AppButton(
      title: LocaleKeys.done.tr(),
      onTap: () {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
          return;
        }
        final UserModel? user = preferences.getUserModel();
        final bool isLoggedIn =
            (preferences.getBool(SharedPreference.isLogin) ?? false) &&
            (user?.uid?.trim().isNotEmpty ?? false);
        if (isLoggedIn) {
          context.go(RoutePaths.base);
        } else {
          context.go(RoutePaths.welcome);
        }
      },
      backgroundColor: primaryColor,
      textColor: Colors.white,
    );
  }
}
