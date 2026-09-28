import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/brainy_conversation/brainy_conversation_screen.dart';

import 'bloc/brainy_saved_guidance_cubit.dart';
import 'bloc/brainy_saved_guidance_state.dart';

class BrainySavedGuidanceScreen extends StatelessWidget {
  const BrainySavedGuidanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BrainySavedGuidanceCubit()..init(),
      child: BlocBuilder<BrainySavedGuidanceCubit, BrainySavedGuidanceState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xFFFEF8F4),
            body: Stack(
              children: [
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
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    children: [
                      16.spaceH,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Material(
                          color: Colors.transparent,
                          child: Ink(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(24),
                              onTap: () => Navigator.pop(context),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Icon(
                                  Icons.arrow_back,
                                  color: darkBlue,
                                  size: 24.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      32.spaceH,
                      "Saved Guidance".appText(
                        fontSize: 28.sp,
                        color: darkBlue,
                        fraunces: true,
                        textAlign: TextAlign.start,
                      ),
                      32.spaceH,
                      _buildSectionTitle("SLEEP"),
                      12.spaceH,
                      ...state.sleepItems.map((item) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: _buildGuidanceItem(context, item: item),
                        );
                      }),
                      32.spaceH,
                      _buildSectionTitle("BEHAVIOUR", color: greyColor11),
                      12.spaceH,
                      ...state.behaviourItems.map((item) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: _buildGuidanceItem(context, item: item),
                        );
                      }),
                      32.spaceH,
                      _buildSectionTitle("PARENT WELLBEING"),
                      12.spaceH,
                      ...state.parentWellbeingItems.map((item) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: _buildGuidanceItem(context, item: item),
                        );
                      }),
                      32.spaceH,
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title, {Color color = secondaryColor}) {
    return title.appText(
      fontSize: 12.sp,
      color: color,
      fontWeight: FontWeight.w700,
      textAlign: TextAlign.start,
    );
  }

  Widget _buildGuidanceItem(
    BuildContext context, {
    required BrainySavedItem item,
  }) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BrainyConversationScreen(
                  conversationId: item.conversationId,
                  initialChat: item.title,
                  topic: item.topic,
                ),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                Container(
                  width: 56.w,
                  height: 56.w,
                  decoration: BoxDecoration(
                    color: Color(item.imageBgColorValue),
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(item.imagePath),
                    ),
                  ),
                ),
                16.spaceW,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      item.title.appText(
                        fontSize: 14.sp,
                        color: greyColor9,
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.start,
                      ),
                      4.spaceH,
                      item.subtitle.appText(
                        fontSize: 12.sp,
                        color: greyColor4,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: greyColor4, size: 20.sp),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
