import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/repo/mentorship_repo.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/ui/guide_list/guide_list_screen.dart';
import 'package:loving_brain/ui/guide_profile/guide_profile_screen.dart';
import 'package:loving_brain/ui/mentorship_unavailable/mentorship_unavailable_screen.dart';
import 'package:loving_brain/ui/widget/app_button.dart';

import 'bloc/choose_support_area_cubit.dart';
import 'bloc/choose_support_area_state.dart';

/// Screen 45: Choose a Support Area.
/// Conforms strictly to AGENTS.md Rules 3, 5, and 6.
class ChooseSupportAreaScreen extends StatefulWidget {
  final String? initialArea;

  const ChooseSupportAreaScreen({super.key, this.initialArea});

  @override
  State<ChooseSupportAreaScreen> createState() =>
      _ChooseSupportAreaScreenState();
}

class _ChooseSupportAreaScreenState extends State<ChooseSupportAreaScreen> {
  final List<Map<String, dynamic>> _options = <Map<String, dynamic>>[
    <String, dynamic>{
      "icon": Assets.v2.images.imgSleep.path,
      "bg": const Color(0xFFFEF0E8),
      "title": "Sleep guidance",
      "subtitle": "Bedtime, naps, night waking",
    },
    <String, dynamic>{
      "icon": Assets.v2.icons.icTantrums.path,
      "bg": const Color(0xFFF1EEFF),
      "title": "Tantrum & behaviour",
      "subtitle": "Big feelings, hitting, refusing",
    },
    <String, dynamic>{
      "icon": Assets.v2.images.imgHealth.path,
      "bg": const Color(0xFFE8F7EC),
      "title": "Eating & nutrition",
      "subtitle": "Picky eating, mealtime stress",
    },
    <String, dynamic>{
      "icon": Assets.v2.icons.icMoreConfident.path,
      "bg": const Color(0xFFFFF2D9),
      "title": "Parental confidence",
      "subtitle": "Anxiety, feeling overwhelmed",
    },
    <String, dynamic>{
      "icon": Assets.v2.icons.icTeamwork.path,
      "bg": const Color(0xFFFDECEF),
      "title": "Co-parenting",
      "subtitle": "Getting on the same page",
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChooseSupportAreaCubit>().init(
        initialArea: widget.initialArea,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChooseSupportAreaCubit, ChooseSupportAreaState>(
      listener: (BuildContext context, ChooseSupportAreaState state) {},
      builder: (BuildContext context, ChooseSupportAreaState state) {
        return Scaffold(
          backgroundColor: const Color(0xFFFEF8F4),
          body: Stack(
            children: [
              // Top Left Glow
              Positioned(
                left: -150.w,
                top: -150.h,
                child: Container(
                  width: 400.w,
                  height: 400.h,
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
              SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 8.h,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: EdgeInsets.all(8.r),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_back,
                              color: darkBlue,
                              size: 24.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        children: [
                          16.spaceH,
                          "What kind of support?".appText(
                            fontSize: 32.sp,
                            color: greyColor9,
                            fraunces: true,
                            textAlign: TextAlign.start,
                          ),
                          8.spaceH,
                          "Pick the one closest to what you need right now."
                              .appText(
                                fontSize: 14.sp,
                                color: greyColor9,
                                textAlign: TextAlign.start,
                              ),
                          24.spaceH,
                          ...List.generate(_options.length, (int index) {
                            final Map<String, dynamic> item = _options[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: _buildOptionCard(
                                context: context,
                                index: index,
                                iconPath: item["icon"] as String,
                                bgColor: item["bg"] as Color,
                                title: item["title"] as String,
                                subtitle: item["subtitle"] as String,
                                isSelected: index == state.selectedIndex,
                              ),
                            );
                          }),
                          140.spaceH,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _buildBottomActions(context, state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionCard({
    required BuildContext context,
    required int index,
    required String iconPath,
    required Color bgColor,
    required String title,
    required String subtitle,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        context.read<ChooseSupportAreaCubit>().selectArea(index);
      },
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.transparent,
            width: 2.w,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Center(
                child: Image.asset(
                  iconPath,
                  width: 32.w,
                  height: 32.w,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            16.spaceW,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title.appText(
                    fontSize: 16.sp,
                    color: darkBlue,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.start,
                  ),
                  4.spaceH,
                  subtitle.appText(
                    fontSize: 14.sp,
                    color: greyColor,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            16.spaceW,
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? primaryColor : const Color(0xFFE5E7EB),
                  width: isSelected ? 7.w : 2.w,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions(
    BuildContext context,
    ChooseSupportAreaState state,
  ) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        top: false,
        child: Container(
          padding: EdgeInsets.only(
            top: 40.h,
            bottom: 32.h,
            left: 20.w,
            right: 20.w,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFFFEF8F4).withValues(alpha: 0.0),
                const Color(0xFFFEF8F4),
                const Color(0xFFFEF8F4),
              ],
              stops: const [0.0, 0.4, 1.0],
            ),
          ),
          child: AppButton(
            title: "Continue",
            onTap: () async {
              if (state.selectedIndex < 0 ||
                  state.selectedIndex >= _options.length) {
                showSnackBar(
                  message: "Please choose an area of support to continue",
                  type: SnackBarType.ERROR,
                );
                return;
              }
              final String selectedTitle =
                  _options[state.selectedIndex]['title'] as String;
              EasyLoading.show();
              final ApiResultStatus<GuideAreaMatch> result = await context
                  .read<ChooseSupportAreaCubit>()
                  .matchSupportArea(selectedTitle);
              EasyLoading.dismiss();
              if (!context.mounted) {
                return;
              }
              if (result is Loging) {
                return;
              }
              if (result is Error<GuideAreaMatch>) {
                showSnackBar(
                  message: result.error.toString().replaceAll(
                    'Exception: ',
                    '',
                  ),
                  type: SnackBarType.ERROR,
                );
                return;
              }
              if (result is! Data<GuideAreaMatch>) {
                return;
              }
              final GuideAreaMatch match = result.data;
              if (match.guides.isEmpty) {
                final String detail = match.fullyBooked
                    ? "Guides for $selectedTitle are fully booked right now. Nothing has been charged."
                    : "No guides are available for $selectedTitle yet.";
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => MentorshipUnavailableScreen(detail: detail),
                  ),
                );
                return;
              }
              if (match.guides.length == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) =>
                        GuideProfileScreen(guideId: match.guides.first.id),
                  ),
                );
                return;
              }
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => GuideListScreen(
                    supportArea: selectedTitle,
                    guides: match.guides,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
