import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/mentorship_models.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/router/route_paths.dart';

import 'bloc/guide_list_cubit.dart';
import 'bloc/guide_list_state.dart';

/// Multi-guide results after Choose Support when more than one match exists.
class GuideListScreen extends StatefulWidget {
  final String supportArea;
  final List<GuideProfileModel>? guides;

  const GuideListScreen({super.key, required this.supportArea, this.guides});

  @override
  State<GuideListScreen> createState() => _GuideListScreenState();
}

class _GuideListScreenState extends State<GuideListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GuideListCubit>().init(
        supportArea: widget.supportArea,
        guides: widget.guides,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GuideListCubit, GuideListState>(
      listener: (BuildContext context, GuideListState state) {
        final ApiResultStatus status = state.fetchStatus;
        if (status is Loging) {
          EasyLoading.show();
        } else if (status is Data) {
          EasyLoading.dismiss();
        } else if (status is Error) {
          EasyLoading.dismiss();
          showSnackBar(
            message: status.error.toString().replaceAll('Exception: ', ''),
            type: SnackBarType.ERROR,
          );
        }
      },
      builder: (BuildContext context, GuideListState state) {
        return Scaffold(
          backgroundColor: const Color(0xFFFEF8F4),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 8.h,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () => context.pop(),
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
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: "Available guides".appText(
                    fontSize: 32.sp,
                    color: greyColor9,
                    fraunces: true,
                  ),
                ),
                8.spaceH,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: widget.supportArea.appText(
                    fontSize: 14.sp,
                    color: greyColor,
                  ),
                ),
                24.spaceH,
                Expanded(
                  child: state.guides.isEmpty
                      ? Center(
                          child: "No guides available right now.".appText(
                            fontSize: 16.sp,
                            color: greyColor,
                            textAlign: TextAlign.center,
                          ),
                        )
                      : ListView.separated(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 8.h,
                          ),
                          itemCount: state.guides.length,
                          separatorBuilder: (BuildContext context, int index) =>
                              12.spaceH,
                          itemBuilder: (BuildContext context, int index) {
                            final GuideProfileModel guide = state.guides[index];
                            return _GuideCard(
                              guide: guide,
                              onTap: () {
                                context.push(
                                  RoutePaths.guideProfile,
                                  extra: <String, dynamic>{'guideId': guide.id},
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _GuideCard extends StatelessWidget {
  final GuideProfileModel guide;
  final VoidCallback onTap;

  const _GuideCard({required this.guide, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: greyColor.withValues(alpha: 0.12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: guide.name.appText(
                    fontSize: 18.sp,
                    color: greyColor9,
                    fraunces: true,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (guide.isVerified)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: const Color(0xFF43A047),
                          size: 14.sp,
                        ),
                        4.spaceW,
                        "Verified".appText(
                          fontSize: 11.sp,
                          color: const Color(0xFF43A047),
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            8.spaceH,
            guide.title.appText(fontSize: 13.sp, color: greyColor),
            12.spaceH,
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: <Widget>[
                ...guide.languages.map((String lang) => _chip(lang)),
                ...guide.supportAreas.map((String area) => _chip(area)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF8F4),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: greyColor.withValues(alpha: 0.15)),
      ),
      child: text.appText(fontSize: 12.sp, color: greyColor9),
    );
  }
}
