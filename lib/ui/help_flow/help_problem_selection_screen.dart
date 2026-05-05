import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/model/child_state_model.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/ui/help_flow/bloc/help_flow_cubit.dart';
import 'package:loving_brain/ui/help_flow/bloc/help_flow_state.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

class HelpProblemSelectionScreen extends StatefulWidget {
  const HelpProblemSelectionScreen({super.key});

  @override
  State<HelpProblemSelectionScreen> createState() =>
      _HelpProblemSelectionScreenState();
}

class _HelpProblemSelectionScreenState
    extends State<HelpProblemSelectionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HelpFlowCubit>().init();
      final ChildState? suggested = context
          .read<HelpFlowCubit>()
          .state
          .childState;
      if (suggested == ChildState.fussy) {
        context.read<HelpFlowCubit>().selectProblem('too_fussy');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HelpFlowCubit, HelpFlowState>(
      listener: (BuildContext context, HelpFlowState state) {},
      builder: (BuildContext context, HelpFlowState state) {
        final String childName = state.childModel?.childName ?? 'Child';
        return Scaffold(
          backgroundColor: const Color(0xFFF8F7FC),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: const Color(0xFF2F2A44),
            title: 'Help'.appText(
              fontWeight: FontWeight.w900,
              fontSize: 18.sp,
              color: const Color(0xFF2F2A44),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  'What is happening with $childName right now?'.appText(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF2F2A44),
                    textAlign: TextAlign.start,
                  ),
                  14.h.spaceH,
                  _problemCard(
                    icon: Icons.child_care_rounded,
                    title: 'Crying',
                    subtitle: 'Crying continuously and hard to settle.',
                    onTap: () => _goToGuidance('crying'),
                  ),
                  10.h.spaceH,
                  _problemCard(
                    icon: Icons.bedtime_rounded,
                    title: "Won't sleep",
                    subtitle: 'Tired but resisting sleep right now.',
                    onTap: () => _goToGuidance('wont_sleep'),
                  ),
                  10.h.spaceH,
                  _problemCard(
                    icon: Icons.restaurant_rounded,
                    title: 'Feeding issue',
                    subtitle: 'Difficulty feeding or refusing feed.',
                    onTap: () => _goToGuidance('feeding_issue'),
                  ),
                  10.h.spaceH,
                  _problemCard(
                    icon: Icons.sentiment_dissatisfied_rounded,
                    title: 'Too fussy',
                    subtitle: 'Unsettled, irritable, and hard to soothe.',
                    onTap: () => _goToGuidance('too_fussy'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _problemCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return BaseButton(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFECE8F8), width: 1.2),
        ),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF1ECFF),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: const Color(0xFF6A24B8), size: 22.sp),
            ),
            10.w.spaceW,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  title.appText(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF2F2A44),
                    textAlign: TextAlign.start,
                  ),
                  4.h.spaceH,
                  subtitle.appText(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF5B5571),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: const Color(0xFF6A24B8),
              size: 22.sp,
            ),
          ],
        ),
      ),
    );
  }

  void _goToGuidance(String problemType) {
    context.read<HelpFlowCubit>().selectProblem(problemType);
    context.push(RoutePaths.helpGuidance);
  }
}
