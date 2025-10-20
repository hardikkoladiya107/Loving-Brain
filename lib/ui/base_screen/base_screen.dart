import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/home/home_screen.dart';
import 'package:loving_brain/ui/profile/profile_screen.dart';
import 'package:loving_brain/ui/schedule/schedule_screen.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

import '../../gen/assets.gen.dart';
import '../../manager/deep_link/deep_link_manager.dart';
import '../ai_chat/ai_chat_screen.dart';
import '../daily_routine/daily_routine_screen.dart';
import '../write_your_thought/write_your_thought_screen.dart';
import 'bloc/base_cubit.dart';
import 'bloc/base_state.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<BaseCubit>().init();
      DeepLinkManager.instance.listenToLinks();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BaseCubit, BaseState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Expanded(
                child: IndexedStack(
                  index: state.bottomNavigationIndex,
                  children: [
                    HomeScreen(),
                    // DailyRoutineScreen(),
                    ScheduleScreen(),
                    AiChatScreen(),
                    WriteYourThoughtScreen(),
                    ProfileScreen(),
                  ],
                ),
              ),
              _bottomNavigation(),
            ],
          ),
        );
      },
      listener: (context, state) {},
    );
  }

  Widget _bottomNavigationItem({
    required String title,
    required AssetGenImage asset,
    required GestureTapCallback? onTap,
    double height = 30,
    double width = 30,
  }) {
    return BaseButton(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          asset.image(height: height.h, width: width.w),
          title.appText(fontSize: 14),
        ],
      ),
    );
  }

  Widget _bottomNavigation() {
    return SafeArea(
      top: false,
      child: Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              offset: Offset(1, -4),
              spreadRadius: 3,
              blurRadius: 3,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _bottomNavigationItem(
              title: "Home",
              asset: Assets.icons.icHomeIcon,
              onTap: () {
                context.read<BaseCubit>().changeProps(bottomNavigationIndex: 0);
              },
            ),
            _bottomNavigationItem(
              title: "Schedules",
              asset: Assets.icons.icScheduleIcon,
              onTap: () {
                context.read<BaseCubit>().changeProps(bottomNavigationIndex: 1);
              },
            ),
            _bottomNavigationItem(
              title: "Brain AI",
              asset: Assets.icons.icBrainAi,
              onTap: () {
                context.read<BaseCubit>().changeProps(bottomNavigationIndex: 2);
              },
            ),
            _bottomNavigationItem(
              title: "Journal",
              asset: Assets.icons.icJournalIcon,
              onTap: () {
                context.read<BaseCubit>().changeProps(bottomNavigationIndex: 3);
              },
            ),
            _bottomNavigationItem(
              title: "Profile",
              asset: Assets.icons.icProfileIcon,
              onTap: () {
                context.read<BaseCubit>().changeProps(bottomNavigationIndex: 4);
              },
            ),
          ],
        ),
      ),
    );
  }
}
