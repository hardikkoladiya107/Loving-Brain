import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/programme_detail/programme_detail_screen.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/choose_support_area_cubit.dart';
import 'bloc/choose_support_area_state.dart';

class ChooseSupportAreaScreen extends StatelessWidget {
  ChooseSupportAreaScreen({super.key});

  final List<Map<String, dynamic>> _options = [
    {
      "icon": Assets.v2.images.imgSleep.path,
      "bg": const Color(0xFFFEF0E8), // soft peach
      "title": "Sleep guidance",
      "subtitle": "Bedtime, naps, night waking",
    },
    {
      "icon": Assets.v2.icons.icTantrums.path,
      "bg": const Color(0xFFF1EEFF), // soft purple
      "title": "Tantrum & behaviour",
      "subtitle": "Big feelings, hitting, refusing",
    },
    {
      "icon": Assets.v2.images.imgHealth.path,
      "bg": const Color(0xFFE8F7EC), // soft green
      "title": "Eating & nutrition",
      "subtitle": "Picky eating, mealtime stress",
    },
    {
      "icon": Assets.v2.icons.icMoreConfident.path,
      "bg": const Color(0xFFFFF2D9), // soft yellow
      "title": "Parental confidence",
      "subtitle": "Anxiety, feeling overwhelmed",
    },
    {
      "icon": Assets.v2.icons.icTeamwork.path,
      "bg": const Color(0xFFFDECEF), // soft pink
      "title": "Co-parenting",
      "subtitle": "Getting on the same page",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChooseSupportAreaCubit(),
      child: BlocBuilder<ChooseSupportAreaCubit, ChooseSupportAreaState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xFFFEF8F4),
            body: Stack(
              children: [
                // Top Left Glow
                Positioned(
                  left: -150,
                  top: -150,
                  child: Container(
                    width: 400,
                    height: 400,
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
                              padding: const EdgeInsets.all(8),
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
                            ...List.generate(_options.length, (index) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 12.h),
                                child: _buildOptionCard(
                                  context: context,
                                  index: index,
                                  iconPath: _options[index]["icon"],
                                  bgColor: _options[index]["bg"],
                                  title: _options[index]["title"],
                                  subtitle: _options[index]["subtitle"],
                                  isSelected: index == state.selectedIndex,
                                ),
                              );
                            }),
                            120.spaceH,
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                _buildBottomActions(context),
              ],
            ),
          );
        },
      ),
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
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(16),
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
                  width: isSelected ? 7 : 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProgrammeDetailScreen()),
            );
          },
        ),
      ),
    );
  }
}
