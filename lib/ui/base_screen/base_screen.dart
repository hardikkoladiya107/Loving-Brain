import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/home/home_screen.dart';
import 'package:loving_brain/ui/profile/profile_screen.dart';
import 'package:loving_brain/ui/schedule/schedule_screen.dart';

import '../../manager/deep_link/deep_link_manager.dart';
import '../../other/app_color.dart';
import '../ai_chat/ai_chat_screen.dart';
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
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<BaseCubit>().init();
      DeepLinkManager.instance.listenToLinks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BaseCubit, BaseState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          extendBody: false, // Prevents content from rendering under the nav bar
          body: IndexedStack(
            index: state.bottomNavigationIndex,
            children: const [
              HomeScreen(),
              ScheduleScreen(),
              AiChatScreen(),
              WriteYourThoughtScreen(),
              ProfileScreen(),
            ],
          ),
          bottomNavigationBar: _floatingBottomNavigation(context, state),
        );
      },
    );
  }

  Widget _floatingBottomNavigation(BuildContext context, BaseState state) {
    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.only(
          left: 20.w,
          right: 20.w,
          bottom: MediaQuery.of(context).padding.bottom + 16.h,
        ),
        child: Container(
          height: 68.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100.r), // pill shaped
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                offset: const Offset(0, 15),
                blurRadius: 30,
                spreadRadius: 2,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                offset: const Offset(0, 5),
                blurRadius: 10,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _animatedNavItem(
                index: 0,
                selectedIndex: state.bottomNavigationIndex,
                icon: Icons.home_rounded,
                title: "Home",
                onTap: () =>
                    context.read<BaseCubit>().changeProps(bottomNavigationIndex: 0),
              ),
              _animatedNavItem(
                index: 1,
                selectedIndex: state.bottomNavigationIndex,
                icon: Icons.calendar_month_rounded,
                title: "Schedules",
                onTap: () =>
                    context.read<BaseCubit>().changeProps(bottomNavigationIndex: 1),
              ),
              _animatedNavItem(
                index: 2,
                selectedIndex: state.bottomNavigationIndex,
                icon: Icons.auto_awesome_rounded,
                title: "Brain AI",
                onTap: () =>
                    context.read<BaseCubit>().changeProps(bottomNavigationIndex: 2),
              ),
              _animatedNavItem(
                index: 3,
                selectedIndex: state.bottomNavigationIndex,
                icon: Icons.menu_book_rounded,
                title: "Journal",
                onTap: () =>
                    context.read<BaseCubit>().changeProps(bottomNavigationIndex: 3),
              ),
              _animatedNavItem(
                index: 4,
                selectedIndex: state.bottomNavigationIndex,
                icon: Icons.account_circle_rounded,
                title: "Profile",
                onTap: () =>
                    context.read<BaseCubit>().changeProps(bottomNavigationIndex: 4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _animatedNavItem({
    required int index,
    required int selectedIndex,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final bool isSelected = index == selectedIndex;
    final Color activeColor = primaryColor;
    final Color inactiveColor = greyColor1.withValues(alpha: 0.5);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutQuint,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16.w : 10.w,
          vertical: 12.h,
        ),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(100.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
              child: Icon(
                icon,
                key: ValueKey(isSelected),
                color: isSelected ? activeColor : inactiveColor,
                size: 26.sp,
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutQuint,
              alignment: Alignment.centerLeft,
              child: isSelected
                  ? Padding(
                      padding: EdgeInsets.only(left: 6.w),
                      child: title.appText(
                        color: activeColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 13.sp,
                        letterSpacing: 0.2,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
