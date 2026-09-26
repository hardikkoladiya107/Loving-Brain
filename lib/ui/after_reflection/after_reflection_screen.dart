import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/success_screen/success_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/after_reflection_cubit.dart';
import 'bloc/after_reflection_state.dart';

class AfterReflectionScreen extends StatelessWidget {
  const AfterReflectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AfterReflectionCubit()..init(),
      child: BlocBuilder<AfterReflectionCubit, AfterReflectionState>(
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
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          borderRadius: BorderRadius.circular(24),
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
                      24.spaceH,
                      "How did it go?".appText(
                        fontSize: 28.sp,
                        color: greyColor9,
                        fraunces: true,
                        textAlign: TextAlign.start,
                      ),
                      8.spaceH,
                      "No wrong answers whatever you remember is enough."
                          .appText(
                            fontSize: 14.sp,
                            color: greyColor,
                            height: 1.5,
                            textAlign: TextAlign.start,
                          ),
                      24.spaceH,
                      _buildInputField(
                        label: "WHAT HAPPENED BEFORE",
                        hint: "E.g. She was asked to put her shoes on",
                      ),
                      12.spaceH,
                      _buildInputField(
                        label: "HOW LONG IT LASTED",
                        hint: "E.g. About 10 minutes",
                      ),
                      24.spaceH,
                      _buildSectionTitle("INTENSITY"),
                      16.spaceH,
                      Slider(
                        value: state.intensityValue,
                        onChanged: (value) => context
                            .read<AfterReflectionCubit>()
                            .setIntensity(value),
                        activeColor: secondaryColor,
                        inactiveColor: const Color(0xFFE5E7EB),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          "Mild".appText(fontSize: 12.sp, color: greyColor),
                          "Intense".appText(fontSize: 12.sp, color: greyColor),
                        ],
                      ),
                      24.spaceH,
                      _buildSectionTitle("WHAT HELPED"),
                      12.spaceH,
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 12.h,
                        children: [
                          _buildChip(
                            context,
                            "Distraction",
                            state.selectedHelped,
                            (v) => context
                                .read<AfterReflectionCubit>()
                                .setHelped(v),
                          ),
                          _buildChip(
                            context,
                            "Holding close",
                            state.selectedHelped,
                            (v) => context
                                .read<AfterReflectionCubit>()
                                .setHelped(v),
                          ),
                          _buildChip(
                            context,
                            "Quiet space",
                            state.selectedHelped,
                            (v) => context
                                .read<AfterReflectionCubit>()
                                .setHelped(v),
                          ),
                          _buildChip(
                            context,
                            "Waiting it out",
                            state.selectedHelped,
                            (v) => context
                                .read<AfterReflectionCubit>()
                                .setHelped(v),
                          ),
                        ],
                      ),
                      24.spaceH,
                      _buildSectionTitle("AND HOW ARE YOU FEELING?"),
                      12.spaceH,
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 12.h,
                        children: [
                          _buildChip(
                            context,
                            "Calm",
                            state.selectedFeeling,
                            (v) => context
                                .read<AfterReflectionCubit>()
                                .setFeeling(v),
                          ),
                          _buildChip(
                            context,
                            "Tired",
                            state.selectedFeeling,
                            (v) => context
                                .read<AfterReflectionCubit>()
                                .setFeeling(v),
                          ),
                          _buildChip(
                            context,
                            "Frustrated",
                            state.selectedFeeling,
                            (v) => context
                                .read<AfterReflectionCubit>()
                                .setFeeling(v),
                          ),
                          _buildChip(
                            context,
                            "Okay",
                            state.selectedFeeling,
                            (v) => context
                                .read<AfterReflectionCubit>()
                                .setFeeling(v),
                          ),
                        ],
                      ),
                      32.spaceH,
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: Container(
              padding: EdgeInsets.only(
                top: 12.h,
                bottom: 20.h,
                left: 20.w,
                right: 20.w,
              ),
              decoration: const BoxDecoration(color: Color(0xffFEF2EA)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppButton(
                    title: "Save reflection",
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SucessScreen(
                            successText: "Check-in Complete!",
                          ),
                        ),
                        (route) => route.isFirst,
                      );
                    },
                    backgroundColor: primaryColor,
                    textColor: Colors.white,
                  ),
                  16.spaceH,
                  TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SucessScreen(
                            successText: "Check-in Complete!",
                          ),
                        ),
                        (route) => route.isFirst,
                      );
                    },
                    child: "Skip".appText(
                      fontSize: 16.sp,
                      color: greyColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return title.appText(
      fontSize: 16.sp,
      color: greyColor11,
      fontWeight: FontWeight.w600,
      textAlign: TextAlign.start,
    );
  }

  Widget _buildInputField({required String label, required String hint}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.transparent, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                label.appText(
                  fontSize: 12.sp,
                  color: greyColor11,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.start,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                      fontSize: 14.sp,
                      color: greyColor4,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.only(top: 4.h, bottom: 4.h),
                  ),
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: greyColor9,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.access_time_filled, color: primaryColor, size: 20.sp),
        ],
      ),
    );
  }

  Widget _buildChip(
    BuildContext context,
    String label,
    String selectedValue,
    Function(String) onSelect,
  ) {
    final isSelected = selectedValue == label;
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? secondaryColor : Colors.transparent,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => onSelect(label),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: label.appText(
              color: isSelected ? secondaryColor : greyColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
