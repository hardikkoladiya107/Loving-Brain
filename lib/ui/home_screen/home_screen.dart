import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/home_screen/pages/home_page.dart';
import 'package:loving_brain/ui/home_screen/pages/journal_page.dart';
import 'package:loving_brain/ui/home_screen/pages/profile_page.dart';
import 'package:loving_brain/ui/schedule/schedule_screen.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

import '../../gen/assets.gen.dart';
import '../ai_chat/ai_chat_screen.dart';
import 'bloc/home_cubit.dart';
import 'bloc/home_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    context.read<HomeCubit>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
          body: Column(
            children: [
              Expanded(
                child: IndexedStack(
                  index: state.bottomNavigationIndex,
                  children: [
                    HomePage(),
                    ScheduleScreen(),
                    AiChatScreen(),
                    JournalPage(),
                    ProfilePage(),
                  ],
                ),
              ),
              Container(
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
                        context.read<HomeCubit>().changeProps(
                          bottomNavigationIndex: 0,
                        );
                      },
                    ),
                    _bottomNavigationItem(
                      title: "Schedules",
                      asset: Assets.icons.icScheduleIcon,
                      onTap: () {
                        context.read<HomeCubit>().changeProps(
                          bottomNavigationIndex: 1,
                        );
                      },
                    ),
                    _bottomNavigationItem(
                      title: "Hugs AI",
                      asset: Assets.icons.icAiIcon,
                      onTap: () {
                        context.read<HomeCubit>().changeProps(
                          bottomNavigationIndex: 2,
                        );
                      },
                    ),
                    _bottomNavigationItem(
                      title: "Journal",
                      asset: Assets.icons.icJournalIcon,
                      onTap: () {
                        context.read<HomeCubit>().changeProps(
                          bottomNavigationIndex: 3,
                        );
                      },
                    ),
                    _bottomNavigationItem(
                      title: "Aswin",
                      asset: Assets.icons.icProfileIcon,
                      onTap: () {
                        context.read<HomeCubit>().changeProps(
                          bottomNavigationIndex: 4,
                        );
                      },
                    ),
                  ],
                ),
              ),
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
  }) {
    return BaseButton(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          asset.image(height: 30.h, width: 30.w),
          title.appText(fontSize: 14),
        ],
      ),
    );
  }
}
