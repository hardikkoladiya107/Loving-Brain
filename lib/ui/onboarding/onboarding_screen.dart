import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:intl/intl.dart';
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
  late final TextEditingController _childNameController;

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

  static const List<String> _genders = <String>[
    'Boy',
    'Girl',
    'Prefer not to say',
  ];

  static const List<String> _nightWakingsOptions = <String>[
    'None',
    '1-2',
    '3+',
    'Varies',
  ];

  static const List<String> _difficultTimes = <String>[
    'Before meals',
    'Bedtime',
    'Transitions',
    'Public outings',
    'Morning rush',
  ];

  static const List<String> _possibleTriggers = <String>[
    'Tiredness',
    'Hunger',
    'Overstimulation',
    'Routine change',
    'Not sure yet',
  ];

  String? _activeTimeField = 'wake'; // 'wake' or 'bed'

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _nameController = TextEditingController(
      text: context.read<OnboardingCubit>().state.parentName,
    );
    _childNameController = TextEditingController(
      text: context.read<OnboardingCubit>().state.childName,
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
    _childNameController.dispose();
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
  // Page 2: "What brings you to LovingBrain?" (matches screenshot design)
  // ---------------------------------------------------------------------------
  Widget _buildPage2(OnboardingState state) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Main Headline
          "What brings you to\nLovingBrain?"
              .appText2(fontSize: 26, textAlign: TextAlign.start)
              .appPadding(left: 20.r, right: 20.r),
          8.spaceH,

          // Subtitle
          "Pick the one that feels biggest right now. You can change this later."
              .appText(
                textAlign: TextAlign.start,
                fontSize: 14,
                color: greyColor,
                height: 1.35,
              )
              .appPadding(left: 20.r, right: 20.r),
          22.spaceH,

          // 2x2 Grid of Concern Cards
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.r),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    _buildGridCard(
                      title: "Sleep",
                      subtitle: "Bedtime, naps, night waking",
                      isSelected: state.concerns.contains("Sleep"),
                      onTap: () => context
                          .read<OnboardingCubit>()
                          .selectConcern("Sleep"),
                      iconPlaceholder: Assets.v2.icons.icSleep.image(
                        width: 44.r,
                        height: 44.r,
                      ),
                    ),
                    12.spaceW,
                    _buildGridCard(
                      title: "Tantrums",
                      subtitle: "Big feelings, hard moments",
                      isSelected: state.concerns.contains("Tantrums"),
                      onTap: () => context
                          .read<OnboardingCubit>()
                          .selectConcern("Tantrums"),
                      iconPlaceholder: Assets.v2.icons.icTantrums.image(
                        width: 44.r,
                        height: 44.r,
                      ),
                    ),
                  ],
                ),
                12.spaceH,
                Row(
                  children: <Widget>[
                    _buildGridCard(
                      title: "Routine",
                      subtitle: "Days feel unpredictable",
                      isSelected: state.concerns.contains("Routine"),
                      onTap: () => context
                          .read<OnboardingCubit>()
                          .selectConcern("Routine"),
                      iconPlaceholder: Assets.v2.icons.icRoutine.image(
                        width: 44.r,
                        height: 44.r,
                      ),
                    ),
                    12.spaceW,
                    _buildGridCard(
                      title: "Parenting stress",
                      subtitle: "Support for you, too",
                      isSelected: state.concerns.contains("Parenting stress"),
                      onTap: () => context
                          .read<OnboardingCubit>()
                          .selectConcern("Parenting stress"),
                      iconPlaceholder: Assets.v2.icons.icParentingStress.image(
                        width: 44.r,
                        height: 44.r,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          16.spaceH,

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.r),
            child: BaseButton(
              onTap: () {
                context.read<OnboardingCubit>().toggleMoreThanOne();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 52.h,
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                decoration: BoxDecoration(
                  color: state.isMoreThanOneSelected
                      ? const Color(0xFFF3F2FE)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: state.isMoreThanOneSelected
                        ? _accentPurple
                        : Colors.transparent,
                    width: 1.5,
                  ),
                  boxShadow: state.isMoreThanOneSelected
                      ? null
                      : <BoxShadow>[
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                ),
                child: Row(
                  children: <Widget>[
                    Assets.v2.icons.icMoreThanOne.image(
                      width: 24.r,
                      height: 24.r,
                    ),
                    12.spaceW,
                    "More than one".appText(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF252360),
                    ),
                  ],
                ),
              ),
            ),
          ),
          20.spaceH,
        ],
      ),
    );
  }

  Widget _buildGridCard({
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
    required Widget iconPlaceholder,
  }) {
    return Expanded(
      child: BaseButton(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 152.h,
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFF3F2FE) : Colors.white,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: isSelected ? _accentPurple : Colors.transparent,
              width: 1.5,
            ),
            boxShadow: isSelected
                ? null
                : <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              iconPlaceholder,
              const Spacer(),
              title.appText(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF212529),
                textAlign: TextAlign.start,
              ),
              4.spaceH,
              subtitle.appText(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: greyColor3,
                textAlign: TextAlign.start,
                height: 1.25,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Page 3: "What would feel like a win?" (matches screenshot design)
  // ---------------------------------------------------------------------------
  Widget _buildPage3(OnboardingState state) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Main Headline
          "What would feel\nlike a win?"
              .appText2(fontSize: 26, textAlign: TextAlign.start)
              .appPadding(left: 20.r, right: 20.r),
          8.spaceH,

          // Subtitle
          "We’ll shape your weekly focus around this."
              .appText(
                textAlign: TextAlign.start,
                fontSize: 14,
                color: greyColor,
                height: 1.35,
              )
              .appPadding(left: 20.r, right: 20.r),
          24.spaceH,

          // 2x2 Grid of Goal Cards
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.r),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    _buildGridCard(
                      title: "Easier bedtimes",
                      subtitle: "Less resistance, calmer nights",
                      isSelected: state.successGoal == "Easier bedtimes",
                      onTap: () => context
                          .read<OnboardingCubit>()
                          .selectSuccessGoal("Easier bedtimes"),
                      iconPlaceholder: Assets.v2.icons.icEasierBedtimes.image(
                        width: 44.r,
                        height: 44.r,
                      ),
                    ),
                    12.spaceW,
                    _buildGridCard(
                      title: "Calmer tantrums",
                      subtitle: "Shorter, less intense",
                      isSelected: state.successGoal == "Calmer tantrums",
                      onTap: () => context
                          .read<OnboardingCubit>()
                          .selectSuccessGoal("Calmer tantrums"),
                      iconPlaceholder: Assets.v2.icons.icCalmerTantrums.image(
                        width: 44.r,
                        height: 44.r,
                      ),
                    ),
                  ],
                ),
                12.spaceH,
                Row(
                  children: <Widget>[
                    _buildGridCard(
                      title: "More confidence",
                      subtitle: "Knowing what to try",
                      isSelected: state.successGoal == "More confidence",
                      onTap: () => context
                          .read<OnboardingCubit>()
                          .selectSuccessGoal("More confidence"),
                      iconPlaceholder: Assets.v2.icons.icMoreConfident.image(
                        width: 44.r,
                        height: 44.r,
                      ),
                    ),
                    12.spaceW,
                    _buildGridCard(
                      title: "Teamwork",
                      subtitle: "Same page as my partner",
                      isSelected: state.successGoal == "Teamwork",
                      onTap: () => context
                          .read<OnboardingCubit>()
                          .selectSuccessGoal("Teamwork"),
                      iconPlaceholder: Assets.v2.icons.icTeamwork.image(
                        width: 44.r,
                        height: 44.r,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          20.spaceH,
        ],
      ),
    );
  }

  Future<void> _pickChildDob(BuildContext context) async {
    final OnboardingCubit cubit = context.read<OnboardingCubit>();
    final DateTime initialDate = DateTime(2024, 3, 14);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: cubit.state.childDob ?? initialDate,
      firstDate: DateTime(2015),
      lastDate: DateTime.now(),
      builder: (BuildContext ctx, Widget? child) {
        return Theme(
          data: Theme.of(ctx).copyWith(
            colorScheme: const ColorScheme.light(
              primary: _accentPurple,
              onPrimary: Colors.white,
              onSurface: Color(0xFF212529),
            ),
          ),
          child: child ?? const SizedBox(),
        );
      },
    );

    if (picked != null) {
      final String formatted = DateFormat('d MMMM yyyy').format(picked);
      cubit.updateChildDob(formattedDate: formatted, dob: picked);
    }
  }

  Future<void> _pickTime({
    required BuildContext context,
    required bool isWakeTime,
  }) async {
    setState(() {
      _activeTimeField = isWakeTime ? 'wake' : 'bed';
    });

    final OnboardingCubit cubit = context.read<OnboardingCubit>();
    final TimeOfDay initial = isWakeTime
        ? const TimeOfDay(hour: 6, minute: 45)
        : const TimeOfDay(hour: 20, minute: 15);

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (BuildContext ctx, Widget? child) {
        return Theme(
          data: Theme.of(ctx).copyWith(
            colorScheme: const ColorScheme.light(
              primary: _accentPurple,
              onPrimary: Colors.white,
              onSurface: Color(0xFF212529),
            ),
          ),
          child: child ?? const SizedBox(),
        );
      },
    );

    if (picked != null && mounted) {
      final MaterialLocalizations localizations = MaterialLocalizations.of(
        context,
      );
      final String formatted = localizations.formatTimeOfDay(
        picked,
        alwaysUse24HourFormat: false,
      );
      if (isWakeTime) {
        cubit.updateWakeTime(formatted);
      } else {
        cubit.updateBedtime(formatted);
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Page 5: "How does a usual day look?" (matches screenshot design)
  // ---------------------------------------------------------------------------
  Widget _buildPage5(OnboardingState state) {
    final bool isWakeSelected = _activeTimeField == 'wake';
    final bool isBedSelected = _activeTimeField == 'bed';

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Main Headline
          "How does a usual\nday look?"
              .appText2(fontSize: 26, textAlign: TextAlign.start)
              .appPadding(left: 20.r, right: 20.r),
          8.spaceH,

          // Subtitle
          "Rough answers are fine we’ll refine these as you go."
              .appText(
                textAlign: TextAlign.start,
                fontSize: 14,
                color: greyColor,
                height: 1.35,
              )
              .appPadding(left: 20.r, right: 20.r),
          22.spaceH,

          // Card 1: USUAL WAKE TIME
          BaseButton(
            onTap: () => _pickTime(context: context, isWakeTime: true),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.r),
                border: isWakeSelected
                    ? Border.all(color: _accentPurple, width: 1.2)
                    : null,
                boxShadow: isWakeSelected
                    ? null
                    : <BoxShadow>[
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        "USUAL WAKE TIME".appText(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFADB5BD),
                          letterSpacing: 0.8,
                          textAlign: TextAlign.start,
                        ),
                        4.spaceH,
                        state.usualWakeTime.appText(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF212529),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                  10.spaceW,
                  // TODO: Add clock icon here
                  Assets.v2.icons.icClock.svg(width: 24.r, height: 24.r),
                ],
              ),
            ),
          ).appPadding(left: 20.r, right: 20.r),
          14.spaceH,

          // Card 2: USUAL BEDTIME
          BaseButton(
            onTap: () => _pickTime(context: context, isWakeTime: false),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.r),
                border: isBedSelected
                    ? Border.all(color: _accentPurple, width: 1.2)
                    : null,
                boxShadow: isBedSelected
                    ? null
                    : <BoxShadow>[
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        "USUAL BEDTIME".appText(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFADB5BD),
                          letterSpacing: 0.8,
                          textAlign: TextAlign.start,
                        ),
                        4.spaceH,
                        state.usualBedtime.appText(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF212529),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                  10.spaceW,
                  // TODO: Add clock icon here
                  Assets.v2.icons.icClock.svg(width: 24.r, height: 24.r),
                ],
              ),
            ),
          ).appPadding(left: 20.r, right: 20.r),
          14.spaceH,

          // Card 3: Naps per day with Stepper
          Container(
            padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                "Naps per day".appText(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF212529),
                  textAlign: TextAlign.start,
                ),
                // Stepper control: [ -  2  + ]
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: _chipSelectedBg,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      BaseButton(
                        onTap: () {
                          context.read<OnboardingCubit>().updateUsualNaps(-1);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          child: const Icon(
                            Icons.remove,
                            size: 16,
                            color: Color(0xFF212529),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: "${state.usualNaps}".appText(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF212529),
                        ),
                      ),
                      BaseButton(
                        onTap: () {
                          context.read<OnboardingCubit>().updateUsualNaps(1);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          child: const Icon(
                            Icons.add,
                            size: 16,
                            color: Color(0xFF212529),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).appPadding(left: 20.r, right: 20.r),
          20.spaceH,

          // Section 4: NIGHT WAKINGS label
          "NIGHT WAKINGS"
              .appText(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: _accentPurple,
                letterSpacing: 0.8,
                textAlign: TextAlign.start,
              )
              .appPadding(left: 20.r, right: 20.r),
          10.spaceH,

          // 4 Night Wakings Chips: None, 1-2, 3+, Varies
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.r),
            child: Row(
              children: <Widget>[
                for (
                  int i = 0;
                  i < _nightWakingsOptions.length;
                  i++
                ) ...<Widget>[
                  if (i > 0) 10.spaceW,
                  _buildChip(
                    label: _nightWakingsOptions[i],
                    isSelected: state.nightWakings == _nightWakingsOptions[i],
                    onTap: () {
                      context.read<OnboardingCubit>().selectNightWakings(
                        _nightWakingsOptions[i],
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
          20.spaceH,
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Page 4: "Now, about your little one" (matches screenshot design)
  // ---------------------------------------------------------------------------
  Widget _buildPage4(OnboardingState state) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Main Headline
          "Now, about your\nlittle one"
              .appText2(fontSize: 26, textAlign: TextAlign.start)
              .appPadding(left: 20.r, right: 20.r),
          8.spaceH,

          // Subtitle
          "Age is what shapes most of our guidance."
              .appText(
                textAlign: TextAlign.start,
                fontSize: 14,
                color: greyColor,
                height: 1.35,
              )
              .appPadding(left: 20.r, right: 20.r),
          20.spaceH,

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Assets.v2.icons.icChild.image(width: 100.r, height: 100.r),
            ],
          ),
          24.spaceH,

          // Field 1: CHILD'S NAME
          AppTextField(
            controller: _childNameController,
            title: "Child's name",
            hint: "Ingredia Nutrisha",
            border: Border.all(color: _accentPurple, width: 1.2),
            borderRadius: BorderRadius.circular(24.r),
            onChanged: (String value) {
              context.read<OnboardingCubit>().updateChildName(value);
            },
          ).appPadding(left: 20.r, right: 20.r),
          16.spaceH,

          // Field 2: DATE OF BIRTH
          BaseButton(
            onTap: () => _pickChildDob(context),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.r),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        "DATE OF BIRTH".appText(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFADB5BD),
                          letterSpacing: 0.8,
                          textAlign: TextAlign.start,
                        ),
                        4.spaceH,
                        state.dateOfBirth.appText(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF212529),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                  10.spaceW,
                  // TODO: Add calendar icon here
                  const SizedBox(
                    width: 26,
                    height: 26,
                    // Calendar icon placeholder
                  ),
                ],
              ),
            ),
          ).appPadding(left: 20.r, right: 20.r),
          20.spaceH,

          // GENDER label
          "GENDER"
              .appText(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: _accentPurple,
                letterSpacing: 0.8,
                textAlign: TextAlign.start,
              )
              .appPadding(left: 20.r, right: 20.r),
          10.spaceH,

          // 3 Gender Pill Chips: Boy, Girl, Prefer not to say
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.r),
            child: Row(
              children: <Widget>[
                for (int i = 0; i < _genders.length; i++) ...<Widget>[
                  if (i > 0) 10.spaceW,
                  _buildChip(
                    label: _genders[i],
                    isSelected: state.childGender == _genders[i],
                    onTap: () {
                      context.read<OnboardingCubit>().selectChildGender(
                        _genders[i],
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
          20.spaceH,
        ],
      ),
    );
  }

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

  // ---------------------------------------------------------------------------
  // Page 6: "When are things hardest?" (matches screenshot design)
  // ---------------------------------------------------------------------------
  Widget _buildPage6(OnboardingState state) {
    final String childDisplayName = state.childName.trim().isNotEmpty
        ? state.childName.trim()
        : "Ira";

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Main Headline
          "When are things\nhardest?"
              .appText2(fontSize: 26, textAlign: TextAlign.start)
              .appPadding(left: 20.r, right: 20.r),
          8.spaceH,

          // Subtitle
          "Choose any that apply. This helps us spot patterns sooner."
              .appText(
                textAlign: TextAlign.start,
                fontSize: 14,
                color: greyColor,
                height: 1.35,
              )
              .appPadding(left: 20.r, right: 20.r),
          22.spaceH,

          // Section 1: DIFFICULT TIMES label
          "DIFFICULT TIMES"
              .appText(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: _accentPurple,
                letterSpacing: 0.8,
                textAlign: TextAlign.start,
              )
              .appPadding(left: 20.r, right: 20.r),
          12.spaceH,

          // Difficult times chips
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.r),
            child: Wrap(
              spacing: 8.w,
              runSpacing: 10.h,
              children: <Widget>[
                for (final String time in _difficultTimes)
                  _buildChip(
                    label: time,
                    isSelected: state.difficultTimes.contains(time),
                    onTap: () {
                      context.read<OnboardingCubit>().toggleDifficultTime(time);
                    },
                  ),
              ],
            ),
          ),
          22.spaceH,

          // Section 2: POSSIBLE TRIGGERS label
          "POSSIBLE TRIGGERS"
              .appText(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: _accentPurple,
                letterSpacing: 0.8,
                textAlign: TextAlign.start,
              )
              .appPadding(left: 20.r, right: 20.r),
          12.spaceH,

          // Possible triggers chips
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.r),
            child: Wrap(
              spacing: 8.w,
              runSpacing: 10.h,
              children: <Widget>[
                for (final String trigger in _possibleTriggers)
                  _buildChip(
                    label: trigger,
                    isSelected: state.possibleTriggers.contains(trigger),
                    onTap: () {
                      context.read<OnboardingCubit>().togglePossibleTrigger(
                        trigger,
                      );
                    },
                  ),
              ],
            ),
          ),
          26.spaceH,

          // Info Banner Note
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3EA),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Assets.v2.icons.icInfo.svg(width: 16.r, height: 16.r),
                8.spaceW,
                Flexible(
                  child:
                      "You can add or change these any time from $childDisplayName’s profile."
                          .appText(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF8E8E93),
                            textAlign: TextAlign.start,
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
                    controller: _pageController,
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
                        _buildPage2(state),
                        _buildPage3(state),
                        _buildPage4(state),
                        _buildPage5(state),
                        _buildPage6(state),
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
