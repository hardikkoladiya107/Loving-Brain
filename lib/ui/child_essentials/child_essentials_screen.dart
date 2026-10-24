import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/app_button.dart';

import 'bloc/child_essentials_cubit.dart';
import 'bloc/child_essentials_state.dart';

/// Screen 53: Child Essentials.
/// Conforms strictly to AGENTS.md Rules 3, 5, and 6.
class ChildEssentialsScreen extends StatefulWidget {
  const ChildEssentialsScreen({super.key});

  @override
  State<ChildEssentialsScreen> createState() => _ChildEssentialsScreenState();
}

class _ChildEssentialsScreenState extends State<ChildEssentialsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChildEssentialsCubit>().init();
    });
  }

  Future<void> _showAddItemDialog(BuildContext context) async {
    final TextEditingController textController = TextEditingController();
    String selectedCategory = "Allergies";

    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext ctx, StateSetter setModalState) {
            return AlertDialog(
              backgroundColor: const Color(0xFFFEF8F4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              title: "Add Essential Item".appText(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: darkBlue,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  "Select category:".appText(fontSize: 14.sp, color: greyColor),
                  8.spaceH,
                  Row(
                    children: [
                      ChoiceChip(
                        label: Text(
                          "Allergy",
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 12.sp,
                          ),
                        ),
                        selected: selectedCategory == "Allergies",
                        selectedColor: orangeLightColor,
                        onSelected: (bool selected) {
                          setModalState(() => selectedCategory = "Allergies");
                        },
                      ),
                      8.spaceW,
                      ChoiceChip(
                        label: Text(
                          "Medication",
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 12.sp,
                          ),
                        ),
                        selected: selectedCategory == "Medications",
                        selectedColor: const Color(0xFFF1EEFF),
                        onSelected: (bool selected) {
                          setModalState(() => selectedCategory = "Medications");
                        },
                      ),
                    ],
                  ),
                  16.spaceH,
                  TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: "e.g., Peanuts, Ibuprofen 5ml",
                      hintStyle: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 14.sp,
                        color: greyColor,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: greyColor.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: "Cancel".appText(fontSize: 14.sp, color: greyColor),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  onPressed: () {
                    final String val = textController.text.trim();
                    if (val.isNotEmpty) {
                      if (selectedCategory == "Allergies") {
                        context.read<ChildEssentialsCubit>().addAllergy(val);
                      } else {
                        context.read<ChildEssentialsCubit>().addMedication(val);
                      }
                    }
                    Navigator.pop(dialogContext);
                  },
                  child: "Add".appText(
                    fontSize: 14.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChildEssentialsCubit, ChildEssentialsState>(
      listener: (BuildContext context, ChildEssentialsState state) {},
      builder: (BuildContext context, ChildEssentialsState state) {
        final String allergiesSubtitle = state.allergies.isEmpty
            ? "None recorded"
            : state.allergies.join(", ");
        final String medicationsSubtitle = state.medications.isEmpty
            ? "None recorded"
            : state.medications.join(", ");

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
                          "Child essentials".appText(
                            fontSize: 32.sp,
                            color: greyColor9,
                            fraunces: true,
                            textAlign: TextAlign.start,
                          ),
                          8.spaceH,
                          "The few things someone would need in a hurry."
                              .appText(
                                fontSize: 14.sp,
                                color: greyColor,
                                textAlign: TextAlign.start,
                              ),
                          24.spaceH,
                          _buildListItem(
                            iconPath: Assets.v2.icons.icAllergies.path,
                            iconBgColor: const Color(0xFFFCE4EC),
                            iconColor: const Color(0xFFE91E63),
                            title: "Allergies",
                            subtitle: allergiesSubtitle,
                          ),
                          12.spaceH,
                          _buildListItem(
                            iconPath: Assets.v2.icons.icMedications.path,
                            iconBgColor: orangeLightColor,
                            iconColor: primaryColor,
                            title: "Medications",
                            subtitle: medicationsSubtitle,
                          ),
                          16.spaceH,
                          AppButton(
                            onTap: () => _showAddItemDialog(context),
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
                                "Add another item".appText(
                                  fontSize: 18.sp,
                                  color: greyColor14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                          ),
                          24.spaceH,
                          Container(
                            padding: EdgeInsets.all(20.r),
                            decoration: BoxDecoration(
                              color: softPeachOrange,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.info,
                                      color: greyColor9,
                                      size: 20.sp,
                                    ),
                                    8.spaceW,
                                    "Who can see this".appText(
                                      fontSize: 14.sp,
                                      color: greyColor9,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ],
                                ),
                                8.spaceH,
                                "Ravi, and anyone else you give access to. Keep it to what a carer or clinician would need quickly not a full medical record."
                                    .appText(
                                      fontSize: 14.sp,
                                      color: greyColor9,
                                      textAlign: TextAlign.start,
                                      height: 1.4,
                                    ),
                              ],
                            ),
                          ),
                          140.spaceH,
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
    );
  }

  Widget _buildListItem({
    IconData? iconData,
    String? iconPath,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Center(
              child: iconPath != null
                  ? Image.asset(
                      iconPath,
                      width: 24.sp,
                      height: 24.sp,
                      fit: BoxFit.contain,
                    )
                  : Icon(iconData, color: iconColor, size: 24.sp),
            ),
          ),
          16.spaceW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title.appText(
                  fontSize: 16.sp,
                  color: greyColor9,
                  fontWeight: FontWeight.w500,
                ),
                4.spaceH,
                subtitle.appText(fontSize: 14.sp, color: greyColor),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: greyColor, size: 24.sp),
        ],
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
          top: 32.h,
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
          title: "Add item",
          onTap: () => _showAddItemDialog(context),
        ),
      ),
    );
  }
}
