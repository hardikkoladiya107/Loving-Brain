import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/repo/child_repo.dart';
import 'package:loving_brain/ui/add_child/add_child_screen.dart';
import 'package:loving_brain/ui/child_profile_v2/child_profile_screen.dart';
import 'package:loving_brain/ui/today_screen/bloc/today_cubit.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/app_loading_indicator.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

Future<void> showChildSwitcherSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
    ),
    builder: (BuildContext sheetContext) => const ChildSwitcherSheet(),
  );
}

class ChildSwitcherSheet extends StatefulWidget {
  const ChildSwitcherSheet({super.key});

  @override
  State<ChildSwitcherSheet> createState() => _ChildSwitcherSheetState();
}

class _ChildSwitcherSheetState extends State<ChildSwitcherSheet> {
  bool _isLoading = true;
  List<ChildModel> _children = <ChildModel>[];

  @override
  void initState() {
    super.initState();
    _loadChildren();
  }

  Future<void> _loadChildren() async {
    final UserModel? user = preferences.getUserModel();
    if (user == null) {
      final List<ChildModel> loaded = <ChildModel>[];
      final ChildModel? activeChild = preferences.getChildModel();
      if (activeChild != null) {
        loaded.add(activeChild);
      }
      if (mounted) {
        setState(() {
          _children = loaded;
          _isLoading = false;
        });
      }
      return;
    }

    try {
      final ApiResultStatus<List<ChildModel>> result = await ChildRepo.instance
          .getAllChildren(user);

      if (!mounted) return;

      final List<ChildModel> loaded = <ChildModel>[];
      result.whenOrNull(
        data: (List<ChildModel> data) {
          loaded.addAll(data);
        },
      );

      // If repo returns empty but we have an active child in preferences, include it
      if (loaded.isEmpty) {
        final ChildModel? activeChild = preferences.getChildModel();
        if (activeChild != null) {
          loaded.add(activeChild);
        }
      }

      setState(() {
        _children = loaded;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      final List<ChildModel> loaded = <ChildModel>[];
      final ChildModel? activeChild = preferences.getChildModel();
      if (activeChild != null) {
        loaded.add(activeChild);
      }
      setState(() {
        _children = loaded;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ChildModel? activeChild = preferences.getChildModel();
    final String activeId = activeChild?.reference?.id ?? '';
    final UserModel? user = preferences.getUserModel();
    final String currentUid = user?.uid ?? '';

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.8,
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Drag Handle
              Center(
                child: Container(
                  width: 44.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: greyColor7,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              18.spaceH,

              // Header
              "Switch child profile".appText(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                fraunces: true,
                color: greyColor9,
                textAlign: TextAlign.start,
              ),
              4.spaceH,
              "Choose which profile to view or log updates for.".appText(
                fontSize: 13.sp,
                color: greyColor,
                textAlign: TextAlign.start,
              ),
              20.spaceH,

              if (_isLoading)
                const Center(child: AppLoadingIndicator())
              else if (_children.isEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.r),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF8F4),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: const Color(0xFFF3ECE6)),
                  ),
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.child_care_rounded,
                        size: 40.sp,
                        color: primaryColor,
                      ),
                      12.spaceH,
                      "No children added yet".appText(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: greyColor9,
                      ),
                    ],
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _children.length,
                  separatorBuilder: (_, _) => 10.spaceH,
                  itemBuilder: (BuildContext ctx, int index) {
                    final ChildModel child = _children[index];
                    final String childId = child.reference?.id ?? '';
                    final bool isActive = childId == activeId;
                    final bool isPrimary =
                        child.parentReferenceIds?.isNotEmpty == true &&
                        child.parentReferenceIds!.first == currentUid;
                    final String childName =
                        child.childName?.trim().isNotEmpty == true
                        ? child.childName!.trim()
                        : 'Child';

                    return BaseButton(
                      onTap: () async {
                        if (isActive) {
                          Navigator.pop(context);
                          return;
                        }
                        final TodayCubit todayCubit = context
                            .read<TodayCubit>();
                        Navigator.pop(context);
                        await todayCubit.switchActiveChild(child);
                        showSnackBar(
                          message: "Switched to $childName",
                          type: SnackBarType.SUCCESS,
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFFFFF7F4)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: isActive
                                ? primaryColor
                                : const Color(0xFFE9E2DC),
                            width: isActive ? 1.5 : 1.0,
                          ),
                          boxShadow: <BoxShadow>[
                            if (isActive)
                              BoxShadow(
                                color: primaryColor.withValues(alpha: 0.08),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                          ],
                        ),
                        child: Row(
                          children: <Widget>[
                            CircleAvatar(
                              radius: 22.r,
                              backgroundColor: isActive
                                  ? primaryColor
                                  : const Color(0xFFF0EBE6),
                              child: Icon(
                                Icons.face,
                                size: 26.sp,
                                color: isActive ? Colors.white : greyColor,
                              ),
                            ),
                            14.spaceW,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  childName.appText(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700,
                                    color: greyColor9,
                                    textAlign: TextAlign.start,
                                  ),
                                  4.spaceH,
                                  "${child.childAge ?? 'Age not set'} · ${isPrimary ? 'Primary child' : 'Shared with you'}"
                                      .appText(
                                        fontSize: 12.sp,
                                        color: greyColor,
                                        textAlign: TextAlign.start,
                                      ),
                                ],
                              ),
                            ),
                            if (isActive)
                              Icon(
                                Icons.check_circle_rounded,
                                color: primaryColor,
                                size: 24.sp,
                              )
                            else
                              Icon(
                                Icons.radio_button_unchecked_rounded,
                                color: greyColor7,
                                size: 24.sp,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

              20.spaceH,

              // Action: Add another child
              AppButton(
                title: "+ Add another child",
                padding: EdgeInsets.zero,
                height: 52.h,
                backgroundColor: Colors.white,
                borderColor: const Color(0xFFE9E2DC),
                textColor: greyColor9,
                widget: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.add_circle_outline_rounded,
                      size: 20.sp,
                      color: primaryColor,
                    ),
                    8.spaceW,
                    Flexible(
                      child: "+ Add another child".appText(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: greyColor9,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                onTap: () async {
                  final NavigatorState navigator = Navigator.of(context);
                  final TodayCubit todayCubit = context.read<TodayCubit>();
                  navigator.pop();
                  final dynamic created = await navigator.push<dynamic>(
                    MaterialPageRoute<dynamic>(
                      builder: (_) => const AddChildScreen(),
                    ),
                  );
                  if (created == true) {
                    todayCubit.init();
                  }
                },
              ),

              if (activeChild != null) ...<Widget>[
                12.spaceH,
                // Action: Edit active child profile
                AppButton(
                  title: "Edit active child profile",
                  padding: EdgeInsets.zero,
                  height: 52.h,
                  backgroundColor: const Color(0xFFFFF7F4),
                  borderColor: const Color(0xFFFCDFD7),
                  textColor: primaryColor,
                  widget: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.edit_outlined,
                        size: 20.sp,
                        color: primaryColor,
                      ),
                      8.spaceW,
                      Flexible(
                        child: "Edit active child profile".appText(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  onTap: () async {
                    final NavigatorState navigator = Navigator.of(context);
                    final TodayCubit todayCubit = context.read<TodayCubit>();
                    navigator.pop();
                    await navigator.push(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            const ChildProfileScreen(fromManageChildren: false),
                      ),
                    );
                    todayCubit.init();
                  },
                ),
              ],
              8.spaceH,
            ],
          ),
        ),
      ),
    );
  }
}
