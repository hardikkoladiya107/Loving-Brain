import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/ui/parent_profile_v2/bloc/parent_profile_v2_cubit.dart';
import 'package:loving_brain/ui/parent_profile_v2/bloc/parent_profile_v2_state.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/editable_field_card.dart';
import 'package:loving_brain/ui/widget/info_box.dart';

class ParentProfileScreen extends StatelessWidget {
  const ParentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ParentProfileV2Cubit()..init(),
      child: const _ParentProfileView(),
    );
  }
}

class _ParentProfileView extends StatelessWidget {
  const _ParentProfileView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ParentProfileV2Cubit, ParentProfileV2State>(
      listener: (context, state) {
        state.saveStatus.whenOrNull(
          loading: () => EasyLoading.show(status: 'Saving...'),
          data: (String message) {
            EasyLoading.dismiss();
            showSnackBar(message: message, type: SnackBarType.SUCCESS);
          },
          error: (Exception exception) {
            EasyLoading.dismiss();
            showSnackBar(
              message: exception.toString().replaceAll('Exception: ', ''),
              type: SnackBarType.ERROR,
            );
          },
        );

        state.logoutStatus.whenOrNull(
          loading: () => EasyLoading.show(),
          data: (_) {
            EasyLoading.dismiss();
            context.go(RoutePaths.welcome);
          },
          error: (Exception exception) {
            EasyLoading.dismiss();
            context.go(RoutePaths.welcome);
          },
        );

        state.deleteAccountStatus.whenOrNull(
          loading: () => EasyLoading.show(),
          data: (_) {
            EasyLoading.dismiss();
            context.go(RoutePaths.welcome);
          },
          error: (Exception exception) {
            EasyLoading.dismiss();
            context.go(RoutePaths.welcome);
          },
        );
      },
      builder: (context, state) {
        final cubit = context.read<ParentProfileV2Cubit>();
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
                              child: "Your profile".appText(
                                fontSize: 24.sp,
                                color: greyColor9,
                                fraunces: true,
                              ),
                            ),
                          ),
                          PopupMenuButton<String>(
                            icon: Icon(
                              Icons.more_vert,
                              color: darkBlue,
                              size: 24.sp,
                            ),
                            onSelected: (value) {
                              if (value == 'logout') {
                                _showLogoutDialog(context);
                              } else if (value == 'delete') {
                                _showDeleteAccountDialog(context);
                              }
                            },
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<String>>[
                                  const PopupMenuItem<String>(
                                    value: 'logout',
                                    child: Text('Log out'),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'delete',
                                    child: Text(
                                      'Delete Account',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
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
                            label: "YOUR NAME",
                            value: state.name,
                            onChanged: (v) => cubit.updateField(name: v),
                            onEdit: () {},
                          ),
                          12.spaceH,
                          EditableFieldCard(
                            label: "YOUR EMAIL",
                            value: state.user?.email ?? "",
                            readOnly: true,
                          ),
                          12.spaceH,
                          EditableFieldCard(
                            label: "PREFERRED LANGUAGE",
                            value: state.language,
                            onChanged: (v) => cubit.updateField(language: v),
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
                          InfoBox.orange(
                            iconData: null,
                            body:
                                "Your time zone is used to work out sleep windows, so it's worth updating if you travel for a while.",
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
            context.read<ParentProfileV2Cubit>().saveProfile();
          },
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final ParentProfileV2Cubit cubit = context.read<ParentProfileV2Cubit>();
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Log out?'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                cubit.logout();
              },
              child: const Text('Log out'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    final ParentProfileV2Cubit cubit = context.read<ParentProfileV2Cubit>();
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Account?'),
          content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                cubit.deleteAccount();
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
