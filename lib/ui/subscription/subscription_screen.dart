import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../main.dart';
import '../../manager/subscription_manager/subscription_utils.dart';
import '../../other/app_color.dart';
import '../../other/snack_bar.dart';
import '../home/bloc/home_cubit.dart';
import '../widget/app_button.dart';
import '../widget/base_button.dart';
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
    context.read<SubscriptionCubit>().init();
    super.initState();
  }

  var scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubscriptionCubit, SubscriptionState>(
      builder: (context, state) {
        List<Widget> widgetsList = [];

        if ((state.products ?? []).isNotEmpty &&
            (state.userModel?.productId ?? "").isEmpty) {
          widgetsList.add(
            _subscriptionItem(
              isShow: true,
              isSubscribed: true,
              isSelected: true,
              title: LocaleKeys.free.tr(),
              price: "",
              description: LocaleKeys.oneExercisePerDay.tr(),
              onTap: () {
                context.read<SubscriptionCubit>().selectPlan(
                  selectedProduct: null,
                );
              },
              bgImage: Assets.images.imgMonthlyBg,
            ),
          );
        }

        for (int i = 0; i < (state.products ?? []).length; i++) {
          var product = state.products[i];
          widgetsList.add(
            _subscriptionItem(
              isShow:
                  (state.userModel?.productId ?? "").isEmpty ||
                  product.id == state.userModel?.productId,
              isSubscribed: product.id == state.userModel?.productId,
              isSelected:
                  (product.id == state.userModel?.productId) ||
                  state.selectedProduct?.id == product.id,
              title: product.id == monthlyPlan
                  ? LocaleKeys.premiumMonthly.tr()
                  : LocaleKeys.premiumAnnual.tr(),
              price:
                  "${product.price}/${product.id == monthlyPlan ? "month" : "year"}",
              description: product.id == monthlyPlan
                  ? LocaleKeys.stayFlexibleWithMonthlyAccess.tr()
                  : LocaleKeys.unlimitedAccessToMoodBasedExercises.tr(),
              onTap: () {
                context.read<SubscriptionCubit>().selectPlan(
                  selectedProduct: product,
                );
              },
              bgImage: Assets.images.imgYearlyBg,
            ).appPadding(top: 10.h),
          );
        }

        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Stack(
              children: [_backgroundImage(), _subscriptionWidget(widgetsList)],
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state.isLoading) {
          EasyLoading.show();
        } else {
          EasyLoading.dismiss();
        }

        if (state.message.isNotEmpty) {
          showSnackBar(message: state.message, type: SnackBarType.None);
        }
      },
    );
  }

  Widget _subscriptionWidget(List<Widget> widgetsList) {
    return SingleChildScrollView(
      child: Column(
        children: [
          45.h.spaceH,
          _appBar(),
          48.h.spaceH,
          _headerText(),
          26.h.spaceH,
          _headerDescription(),
          150.h.spaceH,
          ...widgetsList,
          // _subscriptionItem(
          //   isShow: true,
          //   isSubscribed: false,
          //   isSelected: false,
          //   title: LocaleKeys.premiumAnnual.tr(),
          //   price: "100\$/month",
          //   description: LocaleKeys.stayFlexibleWithMonthlyAccess.tr(),
          //   onTap: () {},
          //   bgImage: Assets.images.imgMonthlyBg,
          // ),
          // 16.h.spaceH,
          // _subscriptionItem(
          //   isShow: true,
          //   isSubscribed: true,
          //   isSelected: true,
          //   title: LocaleKeys.premiumAnnual.tr(),
          //   price: "100\$/month",
          //   description: LocaleKeys.stayFlexibleWithMonthlyAccess.tr(),
          //   onTap: () {},
          //   bgImage: Assets.images.imgYearlyBg,
          // ),
          32.h.spaceH,
          AppButton(
            onTap: () {
              context.read<SubscriptionCubit>().buyProduct();
            },
            title: LocaleKeys.subscribe.tr(),
            backgroundColor: blueButtonColor,
            height: 42.h,
          ),
          16.h.spaceH,
          BaseButton(
            child: LocaleKeys.restore.tr().appText(
              color: blueButtonColor,
              fontWeight: FontWeight.w800,
            ),
            onTap: () {},
          ),
          32.h.spaceH,
          termsAndConditionText(),
        ],
      ),
    );
  }

  Widget _subscriptionItem({
    required String title,
    required String description,
    required String price,
    required bool isSelected,
    required bool isSubscribed,
    required bool isShow,
    required GestureTapCallback? onTap,
    required AssetGenImage bgImage,
  }) {
    if (!isShow) {
      return Container();
    }
    return BaseButton(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            bgImage.image(height: 100.h, width: 350.w, fit: BoxFit.cover),
            Container(
              height: 100.h,
              width: 350.w,
              decoration: BoxDecoration(
                color: Colors.transparent,
                // color: isSubscribed
                //     ? Colors.green.withValues(alpha: 0.3)
                //     : cardColorPrimary,
                border: isSelected
                    ? Border.all(
                        color: appButtonColor,
                        width: isSubscribed ? 2.5 : 1.5,
                      )
                    : null,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  // BoxShadow(
                  //   color: Colors.grey.withValues(alpha: 0.3),
                  //   offset: Offset(1, 1),
                  //   blurRadius: 5,
                  //   spreadRadius: 1,
                  // ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      title.appText(fontSize: 16, fontWeight: FontWeight.w600),
                      Spacer(),
                      price.appText(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                  8.h.spaceH,
                  description.appText(fontSize: 12, textAlign: TextAlign.start),
                  4.h.spaceH,
                  if (isSubscribed)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.green.shade900,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: LocaleKeys.subscribed
                              .tr()
                              .appText(
                                fontSize: 11,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              )
                              .appPadding(left: 8, right: 8, top: 2, bottom: 2),
                        ),
                      ],
                    ),
                ],
              ).appPadding(left: 16, right: 16),
            ),
          ],
        ),
      ),
    ).appPadding(left: 20, right: 20);
  }

  Widget _appBar() {
    return Row(
      children: [
        BaseButton(
          child: Assets.icons.icBackIcon.image(height: 36, width: 36),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        12.w.spaceW,
        LocaleKeys.subscription.tr().appText(fontWeight: FontWeight.w700),
      ],
    ).appPadding(left: 20);
  }

  Widget termsAndConditionText() {
    return Column(
      children: [
        Text.rich(
          textAlign: TextAlign.center,
          TextSpan(
            children: <InlineSpan>[
              TextSpan(
                text: Platform.isIOS
                    ? LocaleKeys.subsTermsTextIOS.tr()
                    : LocaleKeys.subsTermsTextAndroid.tr(),
                style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        Text.rich(
          textAlign: TextAlign.center,
          TextSpan(
            children: <InlineSpan>[
              TextSpan(
                text: LocaleKeys.forMoreInformationPleaseVisitOur.tr(),
                style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              TextSpan(
                text: LocaleKeys.termsOfUse.tr(),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    if (!await launchUrl(Uri.parse(termsOfUseWebUrl))) {
                      throw Exception('Could not launch $termsOfUseWebUrl');
                    }
                  },
                style: getTextStyle(
                  fontSize: 14,
                  color: Colors.blue,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text: " ${LocaleKeys.and.tr()} ",
                style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              TextSpan(
                text: LocaleKeys.privacyPolicy.tr(),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    if (!await launchUrl(Uri.parse(privacyPolicyUrl))) {
                      throw Exception('Could not launch $privacyPolicyUrl');
                    }
                  },
                style: getTextStyle(
                  fontSize: 14,
                  color: Colors.blue,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text: ".",
                style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ],
    ).appPadding(left: 25, right: 25, bottom: 25);
  }

  Widget _backgroundImage() {
    return Column(
      children: [
        Assets.images.imgSubscriptionBg.image(height: context.height),
        Container(height: context.height / 2),
      ],
    );
  }

  Widget _headerText() {
    return LocaleKeys.getMoreFromLovingBrain
        .tr()
        .appText(
          fontWeight: FontWeight.w900,
          color: yellowTextColor3,
          fontSize: 20,
        )
        .appPadding(left: 20.w, right: 20.w);
  }

  Widget _headerDescription() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: LocaleKeys.unlockAllChallengesToolsAndInsightsForAMoreConfident
          .tr()
          .appText(fontSize: 12, fontWeight: FontWeight.w800),
    ).appPadding(left: 20.w, right: 20.w);
  }

  @override
  void dispose() {
    if (navigatorKey.currentContext != null) {
      navigatorKey.currentContext!.read<HomeCubit>().dispose();
    }
    super.dispose();
  }
}
