import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/info_box.dart';

import 'bloc/mentorship_unavailable_cubit.dart';
import 'bloc/mentorship_unavailable_state.dart';

/// Screen 71: Mentor Service Unavailable / Waitlist.
/// Conforms to AGENTS.md §5.1, §6.1, and §9.
class MentorshipUnavailableScreen extends StatefulWidget {
  const MentorshipUnavailableScreen({super.key});

  @override
  State<MentorshipUnavailableScreen> createState() =>
      _MentorshipUnavailableScreenState();
}

class _MentorshipUnavailableScreenState
    extends State<MentorshipUnavailableScreen> {
  late final MentorshipUnavailableCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = MentorshipUnavailableCubit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.init();
    });
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<MentorshipUnavailableCubit, MentorshipUnavailableState>(
        bloc: _cubit,
        listener: (BuildContext context, MentorshipUnavailableState state) {
          state.waitlistStatus.whenOrNull(
            data: (_) {
              showSnackBar(
                message:
                    "You have joined the waitlist! We'll notify you as soon as a slot opens.",
                type: SnackBarType.SUCCESS,
              );
            },
          );
        },
        builder: (BuildContext context, MentorshipUnavailableState state) {
          return Scaffold(
            backgroundColor: const Color(0xFFFEF8F4),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: const BackButton(color: Color(0xFF1E293B)),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  16.spaceH,
                  "Available guides".appText(
                    fontSize: 32.sp,
                    color: const Color(0xFF1E293B),
                    fraunces: true,
                  ),
                  24.spaceH,
                  Container(
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InfoBox(
                          title: "Fully booked",
                          body:
                              "Our sleep guides are booked for the next two weeks. We’ll let you know as soon as something opens up.",
                          backgroundColor: lightYellowColor,
                          textColor: yellowColor1,
                          iconColor: yellowColor1,
                        ),
                        24.spaceH,
                        "No suitable times right now".appText(
                          fontSize: 20.sp,
                          color: const Color(0xFF1E293B),
                          fraunces: true,
                          height: 1.2,
                        ),
                        12.spaceH,
                        "Our sleep guides are booked for the next two weeks. We'll let you know as soon as something opens up."
                            .appText(
                              fontSize: 16.sp,
                              color: const Color(0xFF64748B),
                              height: 1.4,
                            ),
                      ],
                    ),
                  ),
                  16.spaceH,
                  Container(
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const InfoBox(
                          body: "",
                          title: "Another option",
                          backgroundColor: Color(0xFFD1FAE5),
                          textColor: Color(0xFF059669),
                          iconColor: Color(0xFF059669),
                        ),
                        24.spaceH,
                        "Two guides cover behaviour and general parenting"
                            .appText(
                              fontSize: 20.sp,
                              color: const Color(0xFF1E293B),
                              fraunces: true,
                              height: 1.2,
                            ),
                        12.spaceH,
                        "They can still help with evening routines.".appText(
                          fontSize: 16.sp,
                          color: const Color(0xFF64748B),
                          height: 1.4,
                        ),
                      ],
                    ),
                  ),
                  16.spaceH,
                  Container(
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F3FF),
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child:
                        "Nothing has been charged, and joining the waitlist doesn't commit you to anything."
                            .appText(
                              fontSize: 16.sp,
                              color: const Color(0xFF1E293B),
                              height: 1.4,
                            ),
                  ),
                  32.spaceH,
                  AppButton(
                    title: state.isWaitlistJoined
                        ? "Waitlist joined"
                        : "Join the waitlist",
                    backgroundColor: state.isWaitlistJoined
                        ? const Color(0xFFD1FAE5)
                        : primaryColor,
                    textColor: state.isWaitlistJoined
                        ? const Color(0xFF059669)
                        : Colors.white,
                    borderColor: state.isWaitlistJoined
                        ? const Color(0xFF059669)
                        : primaryColor,
                    onTap: state.isWaitlistJoined
                        ? null
                        : () => _cubit.joinWaitlist(),
                  ),
                  12.spaceH,
                  AppButton(
                    title: "See other guides",
                    backgroundColor: Colors.transparent,
                    textColor: const Color(0xFF1E293B),
                    borderColor: const Color(0xFFE2E8F0),
                    onTap: () => Navigator.pop(context),
                  ),
                  16.spaceH,
                  Center(
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Padding(
                        padding: EdgeInsets.all(8.w),
                        child: "Ask Brainy instead".appText(
                          fontSize: 16.sp,
                          color: const Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  40.spaceH,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
