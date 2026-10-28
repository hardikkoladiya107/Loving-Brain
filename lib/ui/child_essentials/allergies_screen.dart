import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/app_text_field.dart';

import 'bloc/child_essentials_cubit.dart';
import 'bloc/child_essentials_state.dart';

/// Screen for managing Child Allergies.
/// Conforms to AGENTS.md Rules 3, 5, and 6.
class AllergiesScreen extends StatefulWidget {
  const AllergiesScreen({super.key});

  @override
  State<AllergiesScreen> createState() => _AllergiesScreenState();
}

class _AllergiesScreenState extends State<AllergiesScreen> {
  Future<void> _showAddAllergyDialog(BuildContext context) async {
    final TextEditingController textController = TextEditingController();
    String? localError;

    await showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext ctx, StateSetter setState) {
            return Dialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 20.h),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          "Add allergy".appText(
                            fontSize: 20.sp,
                            fraunces: true,
                            color: greyColor9,
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(dialogContext),
                            child: Icon(
                              Icons.close_rounded,
                              color: greyColor,
                              size: 24.sp,
                            ),
                          ),
                        ],
                      ),
                      8.spaceH,
                      "Record any allergy, sensitivity, or reaction to avoid."
                          .appText(
                            fontSize: 13.sp,
                            color: greyColor,
                            textAlign: TextAlign.start,
                          ),
                      20.spaceH,
                      AppTextField(
                        controller: textController,
                        hint: "e.g., Peanuts, Dairy, Penicillin...",
                        onChanged: (_) {
                          if (localError != null) {
                            setState(() => localError = null);
                          }
                        },
                        onSubmitted: (String val) {
                          if (val.trim().isNotEmpty) {
                            context.read<ChildEssentialsCubit>().addAllergy(
                              val.trim(),
                            );
                            Navigator.pop(dialogContext);
                          } else {
                            setState(
                              () => localError = "Please enter an allergy name",
                            );
                          }
                        },
                      ),
                      if (localError != null) ...[
                        6.spaceH,
                        localError!.appText(
                          fontSize: 12.sp,
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                      24.spaceH,
                      Row(
                        children: [
                          Expanded(
                            child: AppButton(
                              height: 48.h,
                              padding: EdgeInsets.zero,
                              title: 'Cancel',
                              backgroundColor: const Color(0xFFF8F5F2),
                              borderColor: const Color(0xFFE9E2DC),
                              textColor: greyColor9,
                              onTap: () => Navigator.pop(dialogContext),
                            ),
                          ),
                          12.spaceW,
                          Expanded(
                            child: AppButton(
                              height: 48.h,
                              padding: EdgeInsets.zero,
                              title: 'Add',
                              backgroundColor: primaryColor,
                              borderColor: primaryColor,
                              textColor: Colors.white,
                              onTap: () {
                                final String val = textController.text.trim();
                                if (val.isNotEmpty) {
                                  context
                                      .read<ChildEssentialsCubit>()
                                      .addAllergy(val);
                                  Navigator.pop(dialogContext);
                                } else {
                                  setState(
                                    () => localError =
                                        "Please enter an allergy name",
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showEditAllergyDialog(
    BuildContext context,
    int index,
    String currentName,
  ) async {
    final TextEditingController textController = TextEditingController(
      text: currentName,
    );
    String? localError;

    await showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext ctx, StateSetter setState) {
            return Dialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 20.h),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          "Edit allergy".appText(
                            fontSize: 20.sp,
                            fraunces: true,
                            color: greyColor9,
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(dialogContext),
                            child: Icon(
                              Icons.close_rounded,
                              color: greyColor,
                              size: 24.sp,
                            ),
                          ),
                        ],
                      ),
                      8.spaceH,
                      "Update allergy or sensitivity detail.".appText(
                        fontSize: 13.sp,
                        color: greyColor,
                        textAlign: TextAlign.start,
                      ),
                      20.spaceH,
                      AppTextField(
                        controller: textController,
                        hint: "e.g., Peanuts, Dairy, Penicillin...",
                        onChanged: (_) {
                          if (localError != null) {
                            setState(() => localError = null);
                          }
                        },
                        onSubmitted: (String val) {
                          if (val.trim().isNotEmpty) {
                            context.read<ChildEssentialsCubit>().updateAllergy(
                              index,
                              val.trim(),
                            );
                            Navigator.pop(dialogContext);
                          } else {
                            setState(
                              () => localError = "Please enter an allergy name",
                            );
                          }
                        },
                      ),
                      if (localError != null) ...[
                        6.spaceH,
                        localError!.appText(
                          fontSize: 12.sp,
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                      24.spaceH,
                      Row(
                        children: [
                          Expanded(
                            child: AppButton(
                              height: 48.h,
                              padding: EdgeInsets.zero,
                              title: 'Cancel',
                              backgroundColor: const Color(0xFFF8F5F2),
                              borderColor: const Color(0xFFE9E2DC),
                              textColor: greyColor9,
                              onTap: () => Navigator.pop(dialogContext),
                            ),
                          ),
                          12.spaceW,
                          Expanded(
                            child: AppButton(
                              height: 48.h,
                              padding: EdgeInsets.zero,
                              title: 'Save',
                              backgroundColor: primaryColor,
                              borderColor: primaryColor,
                              textColor: Colors.white,
                              onTap: () {
                                final String val = textController.text.trim();
                                if (val.isNotEmpty) {
                                  context
                                      .read<ChildEssentialsCubit>()
                                      .updateAllergy(index, val);
                                  Navigator.pop(dialogContext);
                                } else {
                                  setState(
                                    () => localError =
                                        "Please enter an allergy name",
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _confirmDeleteAllergy(
    BuildContext context,
    int index,
    String allergy,
  ) async {
    await showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.r),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 24.h),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 56.w,
                    height: 56.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFEBEE),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.delete_outline_rounded,
                      color: Color(0xFFD84315),
                      size: 28.sp,
                    ),
                  ),
                  18.spaceH,
                  "Remove allergy?".appText(
                    fontSize: 22.sp,
                    color: greyColor9,
                    fraunces: true,
                  ),
                  10.spaceH,
                  "Are you sure you want to remove \"$allergy\" from your child's allergies list?"
                      .appText(
                        fontSize: 14.sp,
                        color: greyColor,
                        height: 1.4,
                        textAlign: TextAlign.center,
                      ),
                  24.spaceH,
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          height: 48.h,
                          padding: EdgeInsets.zero,
                          title: 'Cancel',
                          backgroundColor: const Color(0xFFF8F5F2),
                          borderColor: const Color(0xFFE9E2DC),
                          textColor: greyColor9,
                          onTap: () => Navigator.pop(dialogContext),
                        ),
                      ),
                      12.spaceW,
                      Expanded(
                        child: AppButton(
                          height: 48.h,
                          padding: EdgeInsets.zero,
                          title: 'Remove',
                          backgroundColor: const Color(0xFFE53935),
                          borderColor: const Color(0xFFE53935),
                          textColor: Colors.white,
                          onTap: () {
                            Navigator.pop(dialogContext);
                            context.read<ChildEssentialsCubit>().removeAllergy(
                              index,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChildEssentialsCubit, ChildEssentialsState>(
      listener: (BuildContext context, ChildEssentialsState state) {},
      builder: (BuildContext context, ChildEssentialsState state) {
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
              // Bottom Right Glow
              Positioned(
                right: -150.w,
                bottom: 0,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 8.h,
                      ),
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
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        children: [
                          16.spaceH,
                          "Allergies".appText(
                            fontSize: 32.sp,
                            color: greyColor9,
                            fraunces: true,
                            textAlign: TextAlign.start,
                          ),
                          8.spaceH,
                          "The few allergies someone would need to know in a hurry."
                              .appText(
                                fontSize: 14.sp,
                                color: greyColor,
                                textAlign: TextAlign.start,
                              ),
                          24.spaceH,
                          if (state.allergies.isEmpty)
                            Container(
                              padding: EdgeInsets.all(28.r),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    width: 60.w,
                                    height: 60.w,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFFCE4EC),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Image.asset(
                                        Assets.v2.icons.icAllergies.path,
                                        width: 28.sp,
                                        height: 28.sp,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  16.spaceH,
                                  "No allergies recorded yet".appText(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: greyColor9,
                                  ),
                                  8.spaceH,
                                  "Add any food, medicine, or environmental allergies to keep carers and family informed."
                                      .appText(
                                        fontSize: 13.sp,
                                        color: greyColor,
                                        textAlign: TextAlign.center,
                                        height: 1.4,
                                      ),
                                ],
                              ),
                            )
                          else
                            ...state.allergies.asMap().entries.map((
                              MapEntry<int, String> entry,
                            ) {
                              final int index = entry.key;
                              final String allergy = entry.value;
                              return GestureDetector(
                                onTap: () => _showEditAllergyDialog(
                                  context,
                                  index,
                                  allergy,
                                ),
                                behavior: HitTestBehavior.opaque,
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 12.h),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 14.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 40.w,
                                        height: 40.w,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFCE4EC),
                                          borderRadius: BorderRadius.circular(
                                            12.r,
                                          ),
                                        ),
                                        child: Center(
                                          child: Image.asset(
                                            Assets.v2.icons.icAllergies.path,
                                            width: 20.sp,
                                            height: 20.sp,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      14.spaceW,
                                      Expanded(
                                        child: allergy.appText(
                                          fontSize: 16.sp,
                                          color: greyColor9,
                                          fontWeight: FontWeight.w500,
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => _showEditAllergyDialog(
                                          context,
                                          index,
                                          allergy,
                                        ),
                                        behavior: HitTestBehavior.opaque,
                                        child: Padding(
                                          padding: EdgeInsets.all(6.r),
                                          child: Icon(
                                            Icons.edit_outlined,
                                            color: greyColor,
                                            size: 20.sp,
                                          ),
                                        ),
                                      ),
                                      8.spaceW,
                                      GestureDetector(
                                        onTap: () => _confirmDeleteAllergy(
                                          context,
                                          index,
                                          allergy,
                                        ),
                                        behavior: HitTestBehavior.opaque,
                                        child: Padding(
                                          padding: EdgeInsets.all(6.r),
                                          child: Icon(
                                            Icons.delete_outline_rounded,
                                            color: Colors.redAccent,
                                            size: 22.sp,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          20.spaceH,
                          AppButton(
                            onTap: () => _showAddAllergyDialog(context),
                            padding: EdgeInsets.zero,
                            backgroundColor: Colors.transparent,
                            borderColor: greyColor.withValues(alpha: 0.3),
                            widget: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  color: greyColor14,
                                  size: 20.sp,
                                ),
                                8.spaceW,
                                "Add allergy".appText(
                                  fontSize: 16.sp,
                                  color: greyColor14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                          ),
                          100.spaceH,
                        ],
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
}
