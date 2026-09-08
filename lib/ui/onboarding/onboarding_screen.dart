import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/app_text_field.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

import 'bloc/onboarding_cubit.dart';
import 'bloc/onboarding_state.dart';
import 'widgets/onboarding_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;
  late final TextEditingController _nameController;

  static const int _totalPages = 6;
  static const Color _accentPurple = Color(0xFF6560CA);
  static const Color _chipSelectedBg = Color(0xFFEAE9FD);
  static const Color _chipUnselectedText = Color(0xFFA1A6AB);

  static const List<String> _roles = <String>[
    'Mother',
    'Father',
    'Guardian',
    'Caregiver',
  ];

  static const List<String> _languages = <String>['English', 'Hindi', 'Other'];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _nameController = TextEditingController(
      text: context.read<OnboardingCubit>().state.parentName,
    );

    WidgetsBinding.instance.addPostFrameCallback((Duration _) {
      if (!mounted) return;
      context.read<OnboardingCubit>().init();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _onNextTap(OnboardingState state) {
    if (state.currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOut,
      );
    } else {
      context.read<OnboardingCubit>().completeOnboarding();
    }
  }

  void _onBackTap(OnboardingState state) {
    if (state.currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOut,
      );
    } else if (context.canPop()) {
      context.pop();
    }
  }

  void _showChangeLocationSheet(BuildContext context, String currentLocation) {
    final TextEditingController locationController = TextEditingController(
      text: currentLocation,
    );
    final OnboardingCubit cubit = context.read<OnboardingCubit>();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      builder: (BuildContext ctx) {
        final List<String> quickLocations = <String>[
          'Chennai, India (GMT+5:30)',
          'Mumbai, India (GMT+5:30)',
          'New Delhi, India (GMT+5:30)',
          'London, UK (GMT+0:00)',
          'New York, US (GMT-5:00)',
          'San Francisco, US (GMT-8:00)',
          'Sydney, Australia (GMT+11:00)',
        ];

        return Padding(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 20.h,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: greyColor2,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
              16.spaceH,
              "Change Location".appText2(
                fontSize: 22,
                textAlign: TextAlign.start,
              ),
              6.spaceH,
              "Enter your city and timezone to receive timely suggestions."
                  .appText(
                    fontSize: 13,
                    color: greyColor,
                    textAlign: TextAlign.start,
                  ),
              20.spaceH,
              AppTextField(
                controller: locationController,
                title: "Location & Timezone",
                hint: "City, Country (GMT offset)",
                border: Border.all(color: _accentPurple, width: 1.2),
                borderRadius: BorderRadius.circular(20.r),
              ),
              16.spaceH,
              "Common Locations".appText(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: greyColor,
              ),
              10.spaceH,
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: quickLocations.map((String loc) {
                  return BaseButton(
                    onTap: () {
                      locationController.text = loc;
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: greyColor2),
                      ),
                      child: loc.appText(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF495057),
                      ),
                    ),
                  );
                }).toList(),
              ),
              24.spaceH,
              AppButton(
                padding: EdgeInsets.zero,
                onTap: () {
                  final String trimmed = locationController.text.trim();
                  if (trimmed.isNotEmpty) {
                    cubit.updateLocation(trimmed);
                  }
                  Navigator.of(ctx).pop();
                },
                title: "Save Location",
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return BaseButton(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? _chipSelectedBg : Colors.white,
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(
            color: isSelected ? _accentPurple : Colors.transparent,
            width: 1.2,
          ),
        ),
        child: label.appText(
          textAlign: TextAlign.center,
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          color: isSelected ? _accentPurple : _chipUnselectedText,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Page 1: "First, a little about you" (matches screenshot design)
  // ---------------------------------------------------------------------------
  Widget _buildPage1(OnboardingState state) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Main Headline
          "First, a little about you"
              .appText2(fontSize: 26, textAlign: TextAlign.start)
              .appPadding(left: 20.r, right: 20.r),
          8.spaceH,

          // Subtitle
          "This helps us speak to you in the right language and time zone."
              .appText(
                textAlign: TextAlign.start,
                fontSize: 14,
                color: greyColor,
                height: 1.35,
              )
              .appPadding(left: 20.r, right: 20.r),
          22.spaceH,

          // Input Field: YOUR NAME
          AppTextField(
            controller: _nameController,
            title: "Your name",
            hint: "Russell Sprout",
            border: Border.all(color: _accentPurple, width: 1.2),
            borderRadius: BorderRadius.circular(24.r),
            onChanged: (String value) {
              context.read<OnboardingCubit>().updateParentName(value);
            },
          ).appPadding(left: 20.r, right: 20.r),
          22.spaceH,

          // Section 2: "You are the child’s"
          "You are the child’s"
              .appText2(fontSize: 20, textAlign: TextAlign.start)
              .appPadding(left: 20.r, right: 20.r),
          12.spaceH,

          // 4 Relationship chips: Mother, Father, Guardian, Caregiver
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: <Widget>[
                for (int i = 0; i < _roles.length; i++) ...<Widget>[
                  if (i > 0) 8.spaceW,
                  _buildChip(
                    label: _roles[i],
                    isSelected: state.parentRole == _roles[i],
                    onTap: () {
                      context.read<OnboardingCubit>().selectParentRole(
                        _roles[i],
                      );
                    },
                  ),
                ],
              ],
            ),
          ).appPadding(left: 20.r, right: 20.r),
          22.spaceH,

          // Section 3: "Preferred Language"
          "Preferred Language"
              .appText2(fontSize: 20, textAlign: TextAlign.start)
              .appPadding(left: 20.r, right: 20.r),
          12.spaceH,

          // 3 Language chips: English, Hindi, Other
          Row(
            children: <Widget>[
              for (int i = 0; i < _languages.length; i++) ...<Widget>[
                if (i > 0) 10.spaceW,
                _buildChip(
                  label: _languages[i],
                  isSelected: state.preferredLanguage == _languages[i],
                  onTap: () {
                    context.read<OnboardingCubit>().selectPreferredLanguage(
                      _languages[i],
                    );
                  },
                ),
              ],
            ],
          ).appPadding(left: 20.r, right: 20.r),
          22.spaceH,

          // Section 4: Location card with "Change" button
          Container(
            padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(color: _accentPurple, width: 1.2),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      "LOCATION".appText(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFADB5BD),
                        letterSpacing: 0.8,
                        textAlign: TextAlign.start,
                      ),
                      4.spaceH,
                      state.location.appText(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF212529),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
                10.spaceW,
                BaseButton(
                  onTap: () =>
                      _showChangeLocationSheet(context, state.location),
                  child: "Change".appText(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _accentPurple,
                  ),
                ),
              ],
            ),
          ).appPadding(left: 20.r, right: 20.r),
          20.spaceH,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingCubit, OnboardingState>(
      listener: (BuildContext context, OnboardingState state) {
        state.completeStatus.whenOrNull(
          data: (dynamic _) {
            context.go(RoutePaths.base);
          },
        );
      },
      builder: (BuildContext context, OnboardingState state) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(Assets.v2.images.imgBg.path),
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Top navigation row with back button
                  BaseButton(
                    child: Assets.v2.icons.icBack.svg(),
                    onTap: () => _onBackTap(state),
                  ),
                  10.spaceH,

                  // 6-segment linear progress indicator
                  OnboardingPageIndicator(
                    totalPages: _totalPages,
                    currentPage: state.currentPage,
                    activeColor: _accentPurple,
                    onSegmentTap: (int index) {
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 320),
                        curve: Curves.easeOut,
                      );
                    },
                  ).appPadding(left: 20.r, right: 20.r),
                  20.spaceH,

                  // PageView with 6 pages (Page 1 implemented, other 5 empty as requested)
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics: const BouncingScrollPhysics(),
                      onPageChanged: (int index) {
                        context.read<OnboardingCubit>().onPageChanged(index);
                      },
                      children: <Widget>[
                        _buildPage1(state),
                        const SizedBox(),
                        const SizedBox(),
                        const SizedBox(),
                        const SizedBox(),
                        const SizedBox(),
                      ],
                    ),
                  ),

                  // Bottom Action Button: Continue
                  16.spaceH,
                  AppButton(onTap: () => _onNextTap(state), title: "Continue"),
                  32.spaceH,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
