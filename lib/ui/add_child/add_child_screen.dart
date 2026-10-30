import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/editable_field_card.dart';
import 'package:loving_brain/ui/widget/info_box.dart';
import 'package:loving_brain/ui/widget/location_picker_sheet.dart';

import 'bloc/add_child_cubit.dart';
import 'bloc/add_child_state.dart';

class AddChildScreen extends StatefulWidget {
  const AddChildScreen({super.key});

  @override
  State<AddChildScreen> createState() => _AddChildScreenState();
}

class _AddChildScreenState extends State<AddChildScreen> {
  static const List<String> _suggestedConcerns = <String>[
    'Bedtime resistance',
    'Night wakings',
    'Short naps',
    'Tantrums',
    'Nap transitions',
    'Early rising',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddChildCubit>().init();
    });
  }

  Future<void> _pickDob(
    BuildContext context,
    AddChildCubit cubit,
    DateTime? currentDob,
  ) async {
    final DateTime now = DateTime.now();
    final DateTime defaultToddler = DateTime(now.year - 2, now.month, now.day);
    final DateTime initialDate = currentDob ?? defaultToddler;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate.isAfter(now) ? now : initialDate,
      firstDate: DateTime(now.year - 18, 1, 1),
      lastDate: now,
      initialDatePickerMode: DatePickerMode.year,
    );
    if (picked != null) {
      cubit.updateDob(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddChildCubit, AddChildState>(
      listener: (BuildContext context, AddChildState state) {
        state.saveStatus.whenOrNull(
          loading: () => EasyLoading.show(status: 'Adding child...'),
          data: (dynamic message) {
            EasyLoading.dismiss();
            showSnackBar(
              message: message?.toString() ?? 'Child added successfully',
              type: SnackBarType.SUCCESS,
            );
            if (Navigator.canPop(context)) {
              Navigator.pop(context, true);
            }
          },
          error: (Exception exception) {
            EasyLoading.dismiss();
            showSnackBar(
              message: exception.toString().replaceAll('Exception: ', ''),
              type: SnackBarType.ERROR,
            );
          },
        );
      },
      builder: (BuildContext context, AddChildState state) {
        final AddChildCubit cubit = context.read<AddChildCubit>();
        final bool isKeyboardOpen =
            MediaQuery.of(context).viewInsets.bottom > 0;

        return Scaffold(
          backgroundColor: const Color(0xFFFEF8F4),
          body: Stack(
            children: <Widget>[
              // Top Left Glow
              Positioned(
                left: -150.w,
                top: -150.h,
                child: Container(
                  width: 400.w,
                  height: 400.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: <Color>[
                        const Color(0xFFFFD4C8).withValues(alpha: 0.8),
                        const Color(0xFFFFD4C8).withValues(alpha: 0.0),
                      ],
                      stops: const <double>[0.0, 1.0],
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
                  height: 400.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: <Color>[
                        const Color(0xFFFFD4C8).withValues(alpha: 0.8),
                        const Color(0xFFFFD4C8).withValues(alpha: 0.0),
                      ],
                      stops: const <double>[0.0, 1.0],
                    ),
                  ),
                ),
              ),
              SafeArea(
                bottom: false,
                child: Column(
                  children: <Widget>[
                    // Header Bar
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 8.h,
                      ),
                      child: Row(
                        children: <Widget>[
                          InkWell(
                            borderRadius: BorderRadius.circular(24.r),
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
                          Expanded(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(right: 40.w),
                                child: "Add another child".appText(
                                  fontSize: 22.sp,
                                  color: greyColor9,
                                  fraunces: true,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        children: <Widget>[
                          16.spaceH,
                          Center(
                            child: Container(
                              width: 80.w,
                              height: 80.w,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFDC21A),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.child_care_rounded,
                                size: 48.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          12.spaceH,
                          "Create a new profile to personalize sleep, behaviour, and daily guidance."
                              .appText(
                                fontSize: 13.sp,
                                color: greyColor,
                                textAlign: TextAlign.center,
                              ),
                          24.spaceH,

                          // Child's Name
                          EditableFieldCard(
                            label: "CHILD'S NAME",
                            value: state.name,
                            hintText: "Enter child's name",
                            maxLength: 50,
                            onChanged: cubit.updateName,
                            onEdit: () {},
                          ),
                          12.spaceH,

                          // Date of Birth
                          EditableFieldCard(
                            label: "DATE OF BIRTH",
                            value: state.dob,
                            hintText: "Select date of birth",
                            readOnly: true,
                            onTap: () =>
                                _pickDob(context, cubit, state.childDob),
                            onEdit: () =>
                                _pickDob(context, cubit, state.childDob),
                          ),
                          16.spaceH,

                          // Primary Concerns & Focus
                          "COMMON ROUTINES & CONCERNS".appText(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            color: greyColor,
                            textAlign: TextAlign.start,
                          ),
                          8.spaceH,
                          Wrap(
                            spacing: 8.w,
                            runSpacing: 8.h,
                            children: _suggestedConcerns.map((String concern) {
                              final bool isSelected = state.selectedConcerns
                                  .contains(concern);
                              return GestureDetector(
                                onTap: () => cubit.toggleConcern(concern),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 14.w,
                                    vertical: 8.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFFFFF0EC)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(20.r),
                                    border: Border.all(
                                      color: isSelected
                                          ? primaryColor
                                          : const Color(0xFFE9E2DC),
                                      width: isSelected ? 1.5 : 1.0,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      if (isSelected) ...<Widget>[
                                        Icon(
                                          Icons.check_rounded,
                                          size: 16.sp,
                                          color: primaryColor,
                                        ),
                                        4.spaceW,
                                      ],
                                      concern.appText(
                                        fontSize: 13.sp,
                                        fontWeight: isSelected
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                        color: isSelected
                                            ? primaryColor
                                            : greyColor9,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          14.spaceH,

                          // Additional Concerns Text
                          EditableFieldCard(
                            label: "CUSTOM NOTES & ROUTINES",
                            value: state.concerns,
                            hintText: "Optional routines or specific concerns",
                            onChanged: cubit.updateCustomConcerns,
                            onEdit: () {},
                          ),
                          12.spaceH,

                          // Location / Time Zone
                          EditableFieldCard(
                            label: "LOCATION / TIME ZONE",
                            value: state.location,
                            hintText: "Select location & time zone",
                            readOnly: true,
                            onTap: () => showLocationPickerSheet(
                              context,
                              initialLocation: state.location,
                              initialLocationData: cubit.locationData,
                              onLocationSelected: cubit.updateLocationData,
                            ),
                            onEdit: () => showLocationPickerSheet(
                              context,
                              initialLocation: state.location,
                              initialLocationData: cubit.locationData,
                              onLocationSelected: cubit.updateLocationData,
                            ),
                          ),
                          20.spaceH,

                          InfoBox.orange(
                            iconData: null,
                            body:
                                "Loving Brain uses age and date of birth to calculate developmentally accurate sleep windows and guidance.",
                          ),
                          110.spaceH,
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Fixed Bottom Submit Button
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.only(
                    top: isKeyboardOpen ? 10.h : 20.h,
                    bottom: isKeyboardOpen
                        ? 10.h
                        : (20.h + MediaQuery.of(context).padding.bottom),
                    left: 20.w,
                    right: 20.w,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        const Color(0xFFFEF8F4).withValues(alpha: 0.0),
                        const Color(0xFFFEF8F4),
                        const Color(0xFFFEF8F4),
                      ],
                      stops: const <double>[0.0, 0.4, 1.0],
                    ),
                  ),
                  child: AppButton(
                    title: "Add child",
                    height: 52.h,
                    padding: EdgeInsets.zero,
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      cubit.submit();
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
