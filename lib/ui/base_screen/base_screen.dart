import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/brainy_home/brainy_home_screen.dart';
import 'package:loving_brain/ui/journey/journey_screen.dart';
import 'package:loving_brain/ui/today_screen/today_screen.dart';

import '../../other/app_color.dart';
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BaseCubit, BaseState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          // Match primary tabs so any gap under transparent layers is neutral.
          backgroundColor: Colors.white,
          // Lets tab bodies paint under the nav slot; removes the full-width white
          // â€œplateâ€ behind the pillâ€™s transparent margins (Scaffold Material is full-screen).
          extendBody: true,
          body: IndexedStack(
            index: state.bottomNavigationIndex,
            children: const [
              TodayScreen(),
              BrainyHomeScreen(),
              JourneyScreen(),
            ],
          ),
          bottomNavigationBar: _floatingBottomNavigation(context, state),
        );
      },
    );
  }

  Widget _floatingBottomNavigation(BuildContext context, BaseState state) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(0, -5),
            blurRadius: 30,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 12.h,
        bottom: MediaQuery.of(context).padding.bottom + 12.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _animatedNavItem(
            index: 0,
            selectedIndex: state.bottomNavigationIndex,
            iconPath: "assets/v2/icons/ic_today.svg",
            title: "Today",
            onTap: () =>
                context.read<BaseCubit>().changeProps(bottomNavigationIndex: 0),
          ),
          _animatedNavItem(
            index: 1,
            selectedIndex: state.bottomNavigationIndex,
            iconPath: "assets/v2/icons/ic_brainy.svg",
            title: "Brainy AI",
            onTap: () =>
                context.read<BaseCubit>().changeProps(bottomNavigationIndex: 1),
          ),
          _animatedNavItem(
            index: 2,
            selectedIndex: state.bottomNavigationIndex,
            iconPath: "assets/v2/icons/ic_journey.svg",
            title: "Journey",
            onTap: () =>
                context.read<BaseCubit>().changeProps(bottomNavigationIndex: 2),
          ),
        ],
      ),
    );
  }

  Widget _animatedNavItem({
    required int index,
    required int selectedIndex,
    required String iconPath,
    required String title,
    required VoidCallback onTap,
  }) {
    final bool isSelected = index == selectedIndex;
    final Color activeColor = primaryColor;
    final Color inactiveColor = greyColor1.withValues(alpha: 0.5);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutQuint,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: isSelected
                  ? activeColor.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(100.r),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, anim) =>
                  ScaleTransition(scale: anim, child: child),
              child: SvgPicture.asset(
                iconPath,
                key: ValueKey(isSelected),
                colorFilter: ColorFilter.mode(
                  isSelected ? activeColor : inactiveColor,
                  BlendMode.srcIn,
                ),
                width: 24.w,
                height: 24.w,
              ),
            ),
          ),
          SizedBox(height: 4.h),
          title.appText(
            color: isSelected ? activeColor : inactiveColor,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 12.sp,
          ),
        ],
      ),
    );
  }
}
