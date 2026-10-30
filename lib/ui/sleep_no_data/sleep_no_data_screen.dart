import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/ui/today_screen/sheets/add_sleep_update_sheet.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/person_card.dart';

import 'bloc/sleep_no_data_cubit.dart';
import 'bloc/sleep_no_data_state.dart';

/// Screen 64: No Sleep Data Yet.
/// Conforms to AGENTS.md §5.1, §6.1, and §6.3.
class SleepNoDataScreen extends StatefulWidget {
  const SleepNoDataScreen({super.key});

  @override
  State<SleepNoDataScreen> createState() => _SleepNoDataScreenState();
}

class _SleepNoDataScreenState extends State<SleepNoDataScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SleepNoDataCubit>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SleepNoDataCubit, SleepNoDataState>(
      listener: (BuildContext context, SleepNoDataState state) {},
      builder: (BuildContext context, SleepNoDataState state) {
        final String cName = state.childName;
        final String cAge = state.childAge;

        return Scaffold(
          backgroundColor: const Color(0xFFFEF8F4),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: const BackButton(color: Color(0xFF1E293B)),
            title: "Sleep".appText(
              color: const Color(0xFF1E293B),
              fontSize: 28,
              fraunces: true,
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.info,
                              color: const Color(0xFFD97706),
                              size: 16.sp,
                            ),
                            6.spaceW,
                            "No sleep data yet".appText(
                              color: const Color(0xFFD97706),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                      ),
                      24.spaceH,
                      "Typical for $cAge: bedtime around 8 PM".appText(
                        fontSize: 24,
                        color: const Color(0xFF1E293B),
                        fraunces: true,
                        height: 1.2,
                      ),
                      12.spaceH,
                      "This is a general guide, not $cName's own pattern. One update starts personalising it."
                          .appText(
                            fontSize: 16,
                            color: const Color(0xFF64748B),
                            height: 1.4,
                          ),
                      16.spaceH,
                      PersonCard(
                        avatar: Image.asset(Assets.v2.images.imgHealth.path),
                        name: cName,
                        subtitle: "$cAge old",
                        onTap: () {
                          context.push(
                            RoutePaths.childProfilePath(
                              preferences.getUserModel()?.uid ?? '',
                            ),
                          );
                        },
                      ),
                      24.spaceH,
                      AppButton(
                        title: "Add a sleep update",
                        onTap: () {
                          showAddSleepUpdateSheet(context);
                        },
                      ),
                    ],
                  ),
                ),
                16.spaceH,
                Container(
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child:
                      "Two or three updates is usually enough for us to show $cName's own window."
                          .appText(
                            fontSize: 16,
                            color: const Color(0xFF1E293B),
                            height: 1.4,
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
