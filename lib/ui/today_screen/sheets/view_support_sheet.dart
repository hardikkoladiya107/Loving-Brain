import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/repo/mentorship_repo.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/ui/today_screen/bloc/today_cubit.dart';
import 'package:loving_brain/ui/widget/app_button.dart';

void showViewSupportSheet(BuildContext context, {int daysCount = 0}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xFFF7F7F7),
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height * 0.7,
    ),
    builder: (BuildContext context) => ViewSupportSheet(daysCount: daysCount),
  );
}

class ViewSupportSheet extends StatelessWidget {
  const ViewSupportSheet({super.key, this.daysCount = 0});

  final int daysCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 2,
                width: 80.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: greyColor7,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              Container(
                height: 180.h,
                width: 190.w,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(Assets.v2.images.imgLuma.path),
                  ),
                ),
              ).appPadding(top: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Column(
                  children: [
                    'A guided sleep journey may help'.appText(
                      fontSize: 28.sp,
                      fraunces: true,
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 8.h),
                    (daysCount >= 3
                            ? 'Sleep has been inconsistent for $daysCount days · a guided sleep journey may help you build a more consistent routine.'
                            : 'A guided sleep journey can help support your child\'s emerging sleep rhythm and build a calm, consistent routine.')
                        .appText(
                          fontSize: 12.sp,
                          color: greyColor6,
                          height: 1.4,
                          textAlign: TextAlign.start,
                        ),
                  ],
                ).appPadding(all: 16),
              ).appPadding(all: 16),
              12.spaceH,
              AppButton(
                title: 'View support',
                onTap: () {
                  Navigator.pop(context);
                  context.push(RoutePaths.programRecommendation);
                },
              ),
              12.spaceH,
              AppButton(
                title: 'Join waitlist',
                onTap: () async {
                  final TodayCubit cubit = context.read<TodayCubit>();
                  final String userId = preferences.getUserModel()?.uid ?? '';
                  final String childId = cubit.state.activeChildId;
                  Navigator.pop(context);
                  if (userId.isNotEmpty && childId.isNotEmpty) {
                    await MentorshipRepo.instance.joinWaitlist(
                      userId: userId,
                      childId: childId,
                      supportArea: 'Sleep',
                    );
                  }
                  // Same cooling-off as "Not now" so the offer does not reappear
                  // on every Today open after joining (Screen 15).
                  await cubit.dismissSupportOffer();
                  showSnackBar(
                    message:
                        'You have joined the waitlist. We\'ll let you know when a guided sleep journey opens.',
                    type: SnackBarType.SUCCESS,
                  );
                },
                backgroundColor: Colors.white,
                textColor: greyColor9,
              ),
              AppButton(
                title: 'Not now',
                onTap: () async {
                  final TodayCubit cubit = context.read<TodayCubit>();
                  await cubit.dismissSupportOffer();
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                backgroundColor: Colors.transparent,
                textColor: greyColor8,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
