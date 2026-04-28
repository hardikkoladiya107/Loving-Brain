import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/generated/locale_keys.g.dart';
import 'package:loving_brain/manager/subscription_manager/subscription_utils.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/ui/widget/base_button.dart';
import 'package:url_launcher/url_launcher.dart';

import 'bloc/subscription_cubit.dart';
import 'bloc/subscription_state.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubscriptionCubit>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubscriptionCubit, SubscriptionState>(
      listener: (BuildContext context, SubscriptionState state) {
        if (state.message.isNotEmpty) {
          showSnackBar(message: state.message, type: SnackBarType.None);
        }
      },
      builder: (BuildContext context, SubscriptionState state) {
        return Scaffold(
          backgroundColor: const Color(0xFFFAFAFA),
          body: Stack(
            children: <Widget>[
              _buildAuroraBackground(),
              _buildGlassOverlay(),
              SafeArea(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: <Widget>[
                    SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 12.h,
                      ),
                      sliver: SliverToBoxAdapter(child: _topBar()),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _heroCard(),
                            18.h.spaceH,
                            ...List<Widget>.generate(
                              state.subsProductDetails.length,
                              (int index) => _planCard(
                                index: index,
                                state: state,
                              ).appPadding(bottom: 12.h),
                            ),
                            14.h.spaceH,
                            _comingSoonButton(),
                            12.h.spaceH,
                            _stripeInfoTag(),
                            24.h.spaceH,
                            _termsAndConditions(),
                            30.h.spaceH,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAuroraBackground() {
    return Stack(
      children: <Widget>[
        Positioned(
          top: -120.h,
          left: -60.w,
          child: Container(
            width: 360.w,
            height: 360.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF894BCD).withValues(alpha: 0.2),
            ),
          ),
        ),
        Positioned(
          top: 200.h,
          right: -120.w,
          child: Container(
            width: 320.w,
            height: 320.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF5271FF).withValues(alpha: 0.12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGlassOverlay() {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 78, sigmaY: 78),
        child: Container(color: Colors.white.withValues(alpha: 0.36)),
      ),
    );
  }

  Widget _topBar() {
    return Row(
      children: <Widget>[
        BaseButton(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.72),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1.2),
            ),
            child: Icon(
              Icons.arrow_back_rounded,
              color: primaryColor,
              size: 22.sp,
            ),
          ),
        ),
        12.w.spaceW,
        Expanded(
          child: LocaleKeys.subscription.tr().appText(
            fontWeight: FontWeight.w900,
            fontSize: 19.sp,
            color: Colors.black87,
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }

  Widget _heroCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFF894BCD), Color(0xFFB185DB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFF894BCD).withValues(alpha: 0.24),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          LocaleKeys.getMoreFromLovingBrain.tr().appText(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 20.sp,
          ),
          8.h.spaceH,
          LocaleKeys.unlockAllChallengesToolsAndInsightsForAMoreConfident
              .tr()
              .appText(
                color: Colors.white.withValues(alpha: 0.92),
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
                textAlign: TextAlign.start,
              ),
        ],
      ),
    );
  }

  Widget _planCard({required int index, required SubscriptionState state}) {
    final plan = state.subsProductDetails[index];
    final bool isSelected = state.selectedPlan == index;
    final bool isYearly = plan.id == yearly;
    final String title = isYearly
        ? LocaleKeys.premiumAnnual.tr()
        : LocaleKeys.premiumMonthly.tr();
    final String subtitle = isYearly
        ? LocaleKeys.unlimitedAccessToMoodBasedExercises.tr()
        : LocaleKeys.stayFlexibleWithMonthlyAccess.tr();
    final String cadence = isYearly ? "year" : "month";

    return BaseButton(
      onTap: () => context.read<SubscriptionCubit>().selectPlan(index),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            padding: EdgeInsets.all(18.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(
                color: isSelected ? primaryColor : Colors.white,
                width: isSelected ? 2 : 1.3,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: title.appText(
                        fontWeight: FontWeight.w800,
                        fontSize: 16.sp,
                        color: Colors.black87,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? primaryColor.withValues(alpha: 0.14)
                            : Colors.grey.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(99.r),
                      ),
                      child: "${plan.price}/$cadence".appText(
                        fontWeight: FontWeight.w800,
                        fontSize: 11.sp,
                        color: isSelected ? primaryColor : Colors.black87,
                      ),
                    ),
                  ],
                ),
                8.h.spaceH,
                subtitle.appText(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                  textAlign: TextAlign.start,
                ),
                if (isYearly) ...<Widget>[
                  10.h.spaceH,
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF17B26A).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(99.r),
                    ),
                    child: "Best value".appText(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0E9F6E),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _comingSoonButton() {
    return Container(
      width: double.infinity,
      height: 56.h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[primaryColor, blueColor2],
        ),
        borderRadius: BorderRadius.circular(100.r),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: blueColor2.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: "Subscriptions coming soon".appText(
        color: Colors.white,
        fontSize: 16.sp,
        fontWeight: FontWeight.w900,
      ),
    );
  }

  Widget _stripeInfoTag() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: "Static plans for now. Stripe checkout will be integrated soon."
          .appText(
            textAlign: TextAlign.center,
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
    );
  }

  Widget _termsAndConditions() {
    final TextStyle defaultStyle = getTextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w700,
      color: Colors.black87,
    );
    final TextStyle linkStyle = getTextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w700,
      color: blueColor2,
    );

    return Column(
      children: <Widget>[
        Text.rich(
          textAlign: TextAlign.center,
          TextSpan(
            children: <InlineSpan>[
              TextSpan(
                text: LocaleKeys.forMoreInformationPleaseVisitOur.tr(),
                style: defaultStyle,
              ),
              TextSpan(
                text: LocaleKeys.termsOfUse.tr(),
                style: linkStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    if (!await launchUrl(Uri.parse(termsOfUseWebUrl))) {
                      showSnackBar(
                        message: LocaleKeys.somethingWentWrong.tr(),
                        type: SnackBarType.ERROR,
                      );
                    }
                  },
              ),
              TextSpan(text: " ${LocaleKeys.and.tr()} ", style: defaultStyle),
              TextSpan(
                text: LocaleKeys.privacyPolicy.tr(),
                style: linkStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    if (!await launchUrl(Uri.parse(privacyPolicyUrl))) {
                      showSnackBar(
                        message: LocaleKeys.somethingWentWrong.tr(),
                        type: SnackBarType.ERROR,
                      );
                    }
                  },
              ),
              TextSpan(text: ".", style: defaultStyle),
            ],
          ),
        ),
      ],
    ).appPadding(left: 8.w, right: 8.w);
  }
}
