import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/model/mentorship_models.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/onboarding/widgets/info_chip.dart';
import 'package:loving_brain/ui/parent_success_guide/parent_success_guide_screen.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/base_button.dart';
import 'package:loving_brain/ui/widget/common_info_card.dart';

import 'bloc/post_session_plan_cubit.dart';
import 'bloc/post_session_plan_state.dart';

/// Screen 50: Post-Session Plan.
/// Conforms strictly to AGENTS.md Rules 3, 5, and 6.
class PostSessionPlanScreen extends StatefulWidget {
  const PostSessionPlanScreen({super.key});

  @override
  State<PostSessionPlanScreen> createState() => _PostSessionPlanScreenState();
}

class _PostSessionPlanScreenState extends State<PostSessionPlanScreen> {
  late final PostSessionPlanCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = PostSessionPlanCubit();
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
    return BlocProvider<PostSessionPlanCubit>.value(
      value: _cubit,
      child: BlocConsumer<PostSessionPlanCubit, PostSessionPlanState>(
        listener: (BuildContext context, PostSessionPlanState state) {},
        builder: (BuildContext context, PostSessionPlanState state) {
          final PostSessionPlanModel plan =
              state.plan ??
              const PostSessionPlanModel(
                id: 'plan_default',
                guideName: 'Priya',
                tasks: <PlanTaskItem>[
                  PlanTaskItem(
                    id: 'task_1',
                    title: 'Move the nap 15 minutes earlier',
                    subtitle: 'Done Tuesday',
                    isCompleted: true,
                  ),
                  PlanTaskItem(
                    id: 'task_2',
                    title: 'Keep the bedtime routine to 20 minutes',
                    subtitle: 'Ongoing this week',
                    isCompleted: false,
                  ),
                  PlanTaskItem(
                    id: 'task_3',
                    title: 'Log three nights this week',
                    subtitle: 'One logged so far',
                    isCompleted: false,
                  ),
                ],
                negativeGuidanceTitle: 'No screen time before bed',
                negativeGuidanceSubtitle: 'Just while the nap change settles.',
              );

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
                            "Your plan".appText(
                              fontSize: 32.sp,
                              color: greyColor9,
                              fraunces: true,
                              textAlign: TextAlign.start,
                            ),
                            24.spaceH,
                            _buildPlanCard(plan),
                            16.spaceH,
                            _buildNegativeGuidanceCard(plan),
                            160.spaceH,
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
      ),
    );
  }

  Widget _buildPlanCard(PostSessionPlanModel plan) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoChip(
            chipTitle: "Agreed with ${plan.guideName.toLowerCase()}",
            iconData: Icons.stars,
            color: secondaryColor,
            bgColor: const Color(0xFFF1EEFF),
          ),
          24.spaceH,
          ...plan.tasks.map((PlanTaskItem task) {
            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: _buildChecklistItem(
                taskId: task.id,
                title: task.title,
                subtitle: task.subtitle,
                isChecked: task.isCompleted,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildChecklistItem({
    required String taskId,
    required String title,
    required String subtitle,
    required bool isChecked,
  }) {
    return InkWell(
      onTap: () {
        context.read<PostSessionPlanCubit>().toggleTask(taskId);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24.w,
            height: 24.w,
            decoration: BoxDecoration(
              color: isChecked ? secondaryColor : indigoLight,
              border: Border.all(color: secondaryColor),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check,
              size: 16.sp,
              color: isChecked ? Colors.white : Colors.transparent,
            ),
          ),
          12.spaceW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title.appText(
                  fontSize: 16.sp,
                  color: greyColor9,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.start,
                  height: 1.3,
                ),
                4.spaceH,
                subtitle.appText(
                  fontSize: 12.sp,
                  color: greyColor,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNegativeGuidanceCard(PostSessionPlanModel plan) {
    return CommonInfoCard(
      chipTitle: 'In the meantime',
      chipIcon: Icons.cancel,
      chipColor: primaryColor,
      chipBgColor: orangeLightColor,
      title: plan.negativeGuidanceTitle,
      titleFontSize: 20.sp,
      subtitle: plan.negativeGuidanceSubtitle,
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppButton(
              title: "Back to Journey",
              onTap: () {
                Navigator.pop(context);
              },
            ),
            16.spaceH,
            BaseButton(
              child: "View your request".appText(
                fontSize: 14.sp,
                color: greyColor,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.center,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ParentSuccessGuideScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
