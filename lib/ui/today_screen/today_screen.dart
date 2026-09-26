import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/today_cubit.dart';
import 'bloc/today_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/ui/today_screen/sheets/add_behaviour_sheet.dart';
// Import sheets
import 'package:loving_brain/ui/today_screen/sheets/view_support_sheet.dart';
import 'package:loving_brain/ui/today_screen/widgets/action_grid.dart';
import 'package:loving_brain/ui/today_screen/widgets/add_sleep_card.dart';
import 'package:loving_brain/ui/today_screen/widgets/heads_up_card.dart';
import 'package:loving_brain/ui/today_screen/widgets/main_card.dart';
import 'package:loving_brain/ui/today_screen/widgets/nice_work_card.dart';
import 'package:loving_brain/ui/today_screen/widgets/noticed_row.dart';
// Import widgets
import 'package:loving_brain/ui/today_screen/widgets/today_header.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/sleep_forecast/sleep_forecast_screen.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodayCubit()..init(),
      child: Builder(
        builder: (context) {
          final state = context.watch<TodayCubit>().state;
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Colors.transparent,
            ),
            child: Scaffold(
              backgroundColor: const Color(0xFFFEF8F4),
              body: Stack(
                children: [
                  Positioned(
                    left: -283,
                    top: -283,
                    child: Container(
                      width: 450,
                      height: 450,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            cardColor4.withValues(alpha: 0.5),
                            cardColor4.withValues(alpha: 0.0),
                          ],
                          stops: const [0.0, 1.0],
                        ),
                      ),
                    ),
                  ),
                  SafeArea(
                    bottom: false,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 16.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TodayHeader(),
                          SizedBox(height: 24.h),
                          if (state.mode == TodayMode.normal) ...[
                            const MainCard(),
                            SizedBox(height: 24.h),
                            const NoticedRow(),
                            SizedBox(height: 24.h),
                            const NiceWorkCard(),
                            SizedBox(height: 24.h),
                            const ActionGrid(),
                          ] else if (state.mode == TodayMode.newParent) ...[
                            const AddSleepCard(),
                            SizedBox(height: 16.h),
                            AppButton(
                              title: "Add behaviour update",
                              onTap: () {
                                showAddBehaviourSheet(context);
                              },
                              backgroundColor: Colors.white,
                              textColor: greyColor9,
                            ),
                            SizedBox(height: 16.h),
                            Row(
                              children: [
                                Expanded(
                                  child: AppButton(
                                    title: "Daily quick log",
                                    onTap: () {},
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h),
                            const HeadsUpCard(),
                            SizedBox(height: 16.h),
                            AppButton(
                              title: "Play audio",
                              onTap: () {
                                showViewSupportSheet(context);
                              },
                              backgroundColor: Colors.white,
                              textColor: greyColor9,
                            ),
                            SizedBox(height: 16.h),
                            AppButton(
                              title: "Ask Brainy",
                              onTap: () {},
                              backgroundColor: Colors.transparent,
                              textColor: greyColor9,
                            ),
                          ],
                          SizedBox(height: 100.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
