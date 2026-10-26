import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/ui/success_screen/success_screen.dart';
import 'package:loving_brain/ui/widget/app_button.dart';

import 'bloc/after_reflection_cubit.dart';
import 'bloc/after_reflection_state.dart';

class AfterReflectionScreen extends StatefulWidget {
  const AfterReflectionScreen({super.key});

  @override
  State<AfterReflectionScreen> createState() => _AfterReflectionScreenState();
}

class _AfterReflectionScreenState extends State<AfterReflectionScreen> {
  late final TextEditingController _beforeController;
  late final TextEditingController _durationController;

  @override
  void initState() {
    super.initState();
    _beforeController = TextEditingController();
    _durationController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AfterReflectionCubit>().init();
    });
  }

  @override
  void dispose() {
    _beforeController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AfterReflectionCubit, AfterReflectionState>(
      listener: (BuildContext context, AfterReflectionState state) {
        state.saveStatus.whenOrNull(
          loading: () => EasyLoading.show(),
          data: (_) {
            EasyLoading.dismiss();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    const SucessScreen(successText: "Check-in Complete!"),
              ),
              (Route<dynamic> route) => route.isFirst,
            );
          },
          error: (Exception error) {
            EasyLoading.dismiss();
            showSnackBar(
              message: error.toString().replaceAll('Exception: ', ''),
              type: SnackBarType.ERROR,
            );
          },
        );
      },
      builder: (BuildContext context, AfterReflectionState state) {
        return Scaffold(
          backgroundColor: const Color(0xFFFEF8F4),
          body: Stack(
            children: [
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
              Positioned.fill(
                child: SafeArea(
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 80.h),
                    children: [
                      16.spaceH,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          borderRadius: BorderRadius.circular(24.r),
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
                        controller: _beforeController,
                        label: "WHAT HAPPENED BEFORE",
                        hint: "E.g. She was asked to put her shoes on",
                        onChanged: (String v) => context
                            .read<AfterReflectionCubit>()
                            .setBeforeEvent(v),
                      ),
                      12.spaceH,
                      _buildInputField(
                        controller: _durationController,
                        label: "HOW LONG IT LASTED",
                        hint: "E.g. About 10 minutes",
                        onChanged: (String v) =>
                            context.read<AfterReflectionCubit>().setDuration(v),
                      ),
                      24.spaceH,
                      _buildSectionTitle("INTENSITY"),
                      16.spaceH,
                      Slider(
                        value: state.intensityValue,
                        onChanged: (double value) => context
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
                            (String v) => context
                                .read<AfterReflectionCubit>()
                                .setHelped(v),
                          ),
                          _buildChip(
                            context,
                            "Holding close",
                            state.selectedHelped,
                            (String v) => context
                                .read<AfterReflectionCubit>()
                                .setHelped(v),
                          ),
                          _buildChip(
                            context,
                            "Quiet space",
                            state.selectedHelped,
                            (String v) => context
                                .read<AfterReflectionCubit>()
                                .setHelped(v),
                          ),
                          _buildChip(
                            context,
                            "Waiting it out",
                            state.selectedHelped,
                            (String v) => context
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
                            (String v) => context
                                .read<AfterReflectionCubit>()
                                .setFeeling(v),
                          ),
                          _buildChip(
                            context,
                            "Tired",
                            state.selectedFeeling,
                            (String v) => context
                                .read<AfterReflectionCubit>()
                                .setFeeling(v),
                          ),
                          _buildChip(
                            context,
                            "Frustrated",
                            state.selectedFeeling,
                            (String v) => context
                                .read<AfterReflectionCubit>()
                                .setFeeling(v),
                          ),
                          _buildChip(
                            context,
                            "Okay",
                            state.selectedFeeling,
                            (String v) => context
                                .read<AfterReflectionCubit>()
                                .setFeeling(v),
                          ),
                        ],
                      ),
                      32.spaceH,
                    ],
                  ),
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
                    context.read<AfterReflectionCubit>().saveReflection();
                  },
                  backgroundColor: primaryColor,
                  textColor: Colors.white,
                ),
                16.spaceH,
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
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

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
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
                  controller: controller,
                  onChanged: onChanged,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: getTextStyle(
                      fontSize: 14.sp,
                      color: greyColor4,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.only(top: 4.h, bottom: 4.h),
                  ),
                  style: getTextStyle(
                    fontSize: 14.sp,
                    color: greyColor9,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.edit_note, color: primaryColor, size: 20.sp),
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
    final bool isSelected = selectedValue == label;
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? secondaryColor : Colors.transparent,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20.r),
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
