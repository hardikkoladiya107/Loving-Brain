import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/brainy_ai/sheets/brainy_voice_sheet.dart';
import 'package:loving_brain/ui/brainy_conversation/brainy_conversation_screen.dart';
import 'package:loving_brain/ui/brainy_history/brainy_history_screen.dart';
import 'package:loving_brain/ui/brainy_saved_guidance/brainy_saved_guidance_screen.dart';
import 'package:loving_brain/ui/widget/app_text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/brainy_home_cubit.dart';
import 'bloc/brainy_home_state.dart';

class BrainyHomeScreen extends StatelessWidget {
  const BrainyHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BrainyHomeCubit(),
      child: BlocBuilder<BrainyHomeCubit, BrainyHomeState>(
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
                      _buildTopBar(context),
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          children: [
                            16.spaceH,
                            Row(
                              children: [
                                Container(
                                  width: 80.w,
                                  height: 80.w,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                        Assets.v2.images.imgBrainyHome.path,
                                      ),
                                    ),
                                  ),
                                ),
                                16.spaceW,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      "Hi Asha, I'm Brainy".appText(
                                        fontSize: 24.sp,
                                        fraunces: true,
                                        color: darkBlue,
                                        textAlign: TextAlign.start,
                                        height: 1.2,
                                      ),
                                      12.spaceH,
                                      "I know Ira's age, her recent\nsleep and what you're\nworking on."
                                          .appText(
                                            fontSize: 14.sp,
                                            color: greyColor,
                                            textAlign: TextAlign.start,
                                            height: 1.4,
                                          ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            32.spaceH,
                            "TOPICS".appText(
                              fontSize: 12.sp,
                              color: secondaryColor,
                              fontWeight: FontWeight.w700,
                              textAlign: TextAlign.start,
                            ),
                            12.spaceH,
                            Wrap(
                              spacing: 8.w,
                              runSpacing: 12.h,
                              children: [
                                _buildTopicChip(context, state, "Sleep"),
                                _buildTopicChip(context, state, "Behaviour"),
                                _buildTopicChip(context, state, "Mood"),
                                _buildTopicChip(context, state, "Health"),
                                _buildTopicChip(context, state, "General"),
                              ],
                            ),
                            32.spaceH,
                            "SUGGESTED FOR TODAY".appText(
                              fontSize: 12.sp,
                              color: greyColor4,
                              fontWeight: FontWeight.w700,
                              textAlign: TextAlign.start,
                            ),
                            12.spaceH,
                            _buildSuggestedCard(
                              context,
                              "Why is bedtime harder lately?",
                            ),
                            12.spaceH,
                            _buildSuggestedCard(
                              context,
                              "What can I try tonight?",
                            ),
                            120.spaceH,
                          ],
                        ),
                      ),
                      _buildBottomInputAndNav(context),
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

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Material(
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
                  child: Icon(Icons.arrow_back, color: darkBlue, size: 24.sp),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Material(
                color: Colors.transparent,
                child: Ink(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BrainyHistoryScreen(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      child: "History".appText(
                        fontSize: 14.sp,
                        color: greyColor9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              8.spaceW,
              Material(
                color: Colors.transparent,
                child: Ink(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BrainySavedGuidanceScreen(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      child: "Saved".appText(
                        fontSize: 14.sp,
                        color: greyColor9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopicChip(
    BuildContext context,
    BrainyHomeState state,
    String title,
  ) {
    bool isSelected = title == state.selectedTopic;
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: isSelected ? indigoLight : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? secondaryColor : Colors.transparent,
            width: 1,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => context.read<BrainyHomeCubit>().setTopic(title),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: title.appText(
              fontSize: 14.sp,
              color: isSelected ? secondaryColor : greyColor9,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestedCard(BuildContext context, String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Material(
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
                  builder: (_) => const BrainyConversationScreen(),
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: text.appText(
                fontSize: 14.sp,
                color: greyColor9,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.start,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomInputAndNav(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0.h),
          child: Row(
            children: [
              Expanded(
                child: AppTextField(
                  hint: "Ask Brainy anything...",
                  tfType: TFTYPE.FILLED,
                  filled: true,
                  fillColor: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  contentPadding: EdgeInsets.only(
                    left: 20.w,
                    right: 20.w,
                    top: 0.h,
                    bottom: 6.h,
                  ),
                ),
              ),
              12.spaceW,
              Material(
                color: Colors.transparent,
                child: Ink(
                  decoration: const BoxDecoration(
                    color: secondaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => const BrainyVoiceSheet(),
                      );
                    },
                    child: SizedBox(
                      width: 56.w,
                      height: 56.w,
                      child: Icon(Icons.mic, color: Colors.white, size: 28.sp),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 90.h,
        ), // padding so it floats above the actual base_screen navigation bar
      ],
    );
  }
}
