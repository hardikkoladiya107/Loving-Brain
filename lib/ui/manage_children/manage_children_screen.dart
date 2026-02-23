import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/ui/child_profile/child_profile_screen.dart';
import 'package:loving_brain/ui/widget/app_dialogs.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../other/preferances.dart';
import 'bloc/manage_children_cubit.dart';
import 'bloc/manage_children_state.dart';

class ManageChildrenScreen extends StatefulWidget {
  const ManageChildrenScreen({super.key});

  @override
  State<ManageChildrenScreen> createState() => _ManageChildrenScreenState();
}

class _ManageChildrenScreenState extends State<ManageChildrenScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ManageChildrenCubit>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ManageChildrenCubit, ManageChildrenState>(
      listener: (context, state) {
        state.setDefaultStatus.whenOrNull(
          loading: () => EasyLoading.show(),
          data: (_) {
            EasyLoading.dismiss();
            showSnackBar(
              message: LocaleKeys.successMessage.tr(),
              type: SnackBarType.SUCCESS,
            );
          },
          error: (Exception e) {
            EasyLoading.dismiss();
            showSnackBar(
              message: e.toString().replaceAll('Exception: ', ''),
              type: SnackBarType.ERROR,
            );
          },
        );
        state.deleteChildStatus.whenOrNull(
          loading: () => EasyLoading.show(),
          data: (_) {
            EasyLoading.dismiss();
            showSnackBar(
              message: LocaleKeys.successMessage.tr(),
              type: SnackBarType.SUCCESS,
            );
          },
          error: (Exception e) {
            EasyLoading.dismiss();
            showSnackBar(
              message: e.toString().replaceAll('Exception: ', ''),
              type: SnackBarType.ERROR,
            );
          },
        );
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                20.h.spaceH,
                _appBar(context),
                20.h.spaceH,
                Expanded(
                  child: _buildBody(context, state),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _appBar(BuildContext context) {
    return Row(
      children: [
        BaseButton(
          onTap: () => Navigator.of(context).pop(),
          child: Assets.icons.icBackIcon.image(height: 36.h, width: 36.w),
        ),
        12.w.spaceW,
        LocaleKeys.children.tr().appText(
          fontWeight: FontWeight.w700,
          fontSize: 20.sp,
          color: Colors.black,
        ),
      ],
    ).appPadding(left: 20.w);
  }

  Widget _buildBody(BuildContext context, ManageChildrenState state) {
    final bool isLoading = state.loadStatus.maybeMap(
          loading: (_) => true,
          initial: (_) => true,
          orElse: () => false,
        );
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: primaryColor),
      );
    }
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _addChildCard(context),
          24.h.spaceH,
          LocaleKeys.manageYourChildren.tr().appText(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
          16.h.spaceH,
          state.children.isEmpty
              ? _emptyState(context)
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.children.length,
                  separatorBuilder: (_, __) => 14.h.spaceH,
                  itemBuilder: (context, index) {
                    final ChildModel child = state.children[index];
                    final bool isDefault =
                        context.read<ManageChildrenCubit>().isDefaultChild(child);
                    return _childCard(
                      context: context,
                      child: child,
                      isDefault: isDefault,
                    );
                  },
                ),
          32.h.spaceH,
        ],
      ),
    );
  }

  Widget _addChildCard(BuildContext context) {
    return BaseButton(
      onTap: () => _openAddChild(context),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.3),
              blurRadius: 12.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_rounded, color: Colors.white, size: 24.sp),
            10.w.spaceW,
            LocaleKeys.addChild.tr().appText(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 24.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(
            Icons.child_care_rounded,
            size: 48.sp,
            color: primaryColor.withValues(alpha: 0.7),
          ),
          16.h.spaceH,
          LocaleKeys.noChildrenYet.tr().appText(
            fontWeight: FontWeight.w700,
            fontSize: 16.sp,
            color: Colors.black87,
          ),
          8.h.spaceH,
          LocaleKeys.addYourFirstChild.tr().appText(
            fontSize: 14.sp,
            color: Colors.black54,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _childCard({
    required BuildContext context,
    required ChildModel child,
    required bool isDefault,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDefault ? primaryColor.withValues(alpha: 0.4) : greyColor,
          width: isDefault ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52.w,
            height: 52.w,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person_rounded, color: primaryColor, size: 28.sp),
          ),
          14.w.spaceW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (child.childName ?? '').appText(
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                  color: Colors.black87,
                ),
                4.h.spaceH,
                if (child.childAge != null && child.childAge!.isNotEmpty)
                  (child.childAge ?? '').appText(
                    fontSize: 13.sp,
                    color: Colors.black54,
                  ),
                if (child.relationshipToChild != null &&
                    child.relationshipToChild!.isNotEmpty)
                  (child.relationshipToChild ?? '').appText(
                    fontSize: 12.sp,
                    color: Colors.black45,
                  ),
              ],
            ),
          ),
          if (isDefault)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: LocaleKeys.defaultChild.tr().appText(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: primaryColor,
              ),
            )
          else ...[
            BaseButton(
              onTap: () {
                context.read<ManageChildrenCubit>().setDefaultChild(child);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                child: LocaleKeys.setAsDefault.tr().appText(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                ),
              ),
            ),
            8.w.spaceW,
            BaseButton(
              onTap: () => _showRemoveChildDialog(context, child),
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Icon(
                  Icons.delete_outline_rounded,
                  size: 22.sp,
                  color: redColor,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showRemoveChildDialog(BuildContext context, ChildModel child) {
    showAppDialog(
      child: (dialogContext) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                "${'removeChild'.tr()}?".appText(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                ),
                16.h.spaceH,
                'areYouSureYouWantToRemoveChild'.tr().appText(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                ),
                28.h.spaceH,
                Row(
                  children: [
                    Expanded(
                      child: BaseButton(
                        onTap: () => Navigator.pop(dialogContext),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          decoration: BoxDecoration(
                            color: greyColor,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: LocaleKeys.cancel.tr().appText(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                    ),
                    12.w.spaceW,
                    Expanded(
                      child: BaseButton(
                        onTap: () {
                          Navigator.pop(dialogContext);
                          context.read<ManageChildrenCubit>().deleteChild(child);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          decoration: BoxDecoration(
                            color: redColor,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: LocaleKeys.delete.tr().appText(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _openAddChild(BuildContext context) async {
    final String? uid = preferences.getUserModel()?.uid;
    if (uid == null || uid.isEmpty) return;
    final bool? added = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (context) => ChildProfileScreen(
          userId: uid,
          fromManageChildren: true,
        ),
      ),
    );
    if (added == true && mounted) {
      context.read<ManageChildrenCubit>().init();
    }
  }
}
