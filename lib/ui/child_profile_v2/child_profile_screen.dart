import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/ui/child_essentials/child_essentials_screen.dart';
import 'package:loving_brain/ui/child_profile_v2/bloc/child_profile_v2_cubit.dart';
import 'package:loving_brain/ui/child_profile_v2/bloc/child_profile_v2_state.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/editable_field_card.dart';
import 'package:loving_brain/ui/widget/info_box.dart';

class ChildProfileScreen extends StatelessWidget {
  final String? userId;
  final bool fromManageChildren;
  const ChildProfileScreen({
    super.key,
    this.userId,
    this.fromManageChildren = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ChildProfileV2Cubit()..init(createNew: fromManageChildren),
      child: _ChildProfileView(fromManageChildren: fromManageChildren),
    );
  }
}

class _ChildProfileView extends StatelessWidget {
  final bool fromManageChildren;
  const _ChildProfileView({this.fromManageChildren = false});

  Future<void> _pickDob(
    BuildContext context,
    ChildProfileV2Cubit cubit,
    DateTime? currentDob,
  ) async {
    final DateTime now = DateTime.now();
    final DateTime initialDate =
        currentDob ?? DateTime(now.year - 1, now.month, now.day);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate.isAfter(now) ? now : initialDate,
      firstDate: DateTime(now.year - 18, 1, 1),
      lastDate: now,
    );
    if (picked != null) {
      cubit.updateDob(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChildProfileV2Cubit, ChildProfileV2State>(
      listener: (context, state) {
        state.saveStatus.whenOrNull(
          loading: () => EasyLoading.show(status: 'Saving...'),
          data: (String message) {
            EasyLoading.dismiss();
            showSnackBar(message: message, type: SnackBarType.SUCCESS);
            if (fromManageChildren && Navigator.canPop(context)) {
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
      builder: (context, state) {
        final cubit = context.read<ChildProfileV2Cubit>();
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
              // Bottom Right Glow
              Positioned(
                right: -150,
                bottom: 0,
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
                      child: Row(
                        children: [
                          InkWell(
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
                          Expanded(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(right: 40.w),
                                child: "Child profile".appText(
                                  fontSize: 24.sp,
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
                        children: [
                          24.spaceH,
                          Center(
                            child: Container(
                              width: 80.w,
                              height: 80.w,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFDC21A),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.face,
                                size: 48.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          32.spaceH,
                          EditableFieldCard(
                            label: "CHILD'S NAME",
                            value: state.name,
                            onChanged: (v) => cubit.updateField(name: v),
                            onEdit: () {},
                          ),
                          12.spaceH,
                          EditableFieldCard(
                            label: "DATE OF BIRTH",
                            value: state.dob,
                            hintText: "Select date of birth",
                            readOnly: true,
                            onTap: () => _pickDob(
                              context,
                              cubit,
                              state.childDob,
                            ),
                            onEdit: () => _pickDob(
                              context,
                              cubit,
                              state.childDob,
                            ),
                          ),
                          12.spaceH,
                          EditableFieldCard(
                            label: "ROUTINES & CONCERNS",
                            value: state.concerns,
                            onChanged: (v) => cubit.updateField(concerns: v),
                            onEdit: () {},
                          ),
                          12.spaceH,
                          EditableFieldCard(
                            label: "LOCATION / TIME ZONE",
                            value: state.location,
                            onChanged: (v) => cubit.updateField(location: v),
                            onEdit: () {},
                          ),
                          24.spaceH,
                          Center(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const ChildEssentialsScreen(),
                                  ),
                                );
                              },
                              child:
                                  "View / edit Child essentials allergies, medication"
                                      .appText(
                                        fontSize: 14.sp,
                                        color: const Color(0xFFE64A19),
                                        fontWeight: FontWeight.w500,
                                      ),
                            ),
                          ),
                          24.spaceH,
                          InfoBox.orange(
                            iconData: null,
                            body:
                                "Changing the date of birth will re-base age guidance from the next day.",
                          ),
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
          bottom: 40.h,
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
          title: "Save changes",
          onTap: () {
            FocusScope.of(context).unfocus();
            context.read<ChildProfileV2Cubit>().saveProfile();
          },
        ),
      ),
    );
  }
}
