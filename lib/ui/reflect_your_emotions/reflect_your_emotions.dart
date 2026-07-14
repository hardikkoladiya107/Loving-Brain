import 'package:easy_localization/easy_localization.dart';
import '../../generated/locale_keys.g.dart';
import 'package:go_router/go_router.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/mood_log_model.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/reflect_your_emotions/bloc/reflect_emotion_cubit.dart';
import 'package:loving_brain/ui/reflect_your_emotions/bloc/reflect_emotion_state.dart';
import 'package:loving_brain/ui/widget/app_bar_graph.dart';
import 'package:loving_brain/ui/widget/base_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReflectYourEmotions extends StatefulWidget {
  const ReflectYourEmotions({super.key});

  @override
  State<ReflectYourEmotions> createState() => _ReflectYourEmotionsState();
}

class _ReflectYourEmotionsState extends State<ReflectYourEmotions> {
  @override
  void initState() {
    context.read<ReflectEmotionCubit>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: calmCornerBgColor,
      body: SafeArea(
        child: Column(
          children: [
            _appBar(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: BlocConsumer<ReflectEmotionCubit, ReflectEmotionState>(
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LocaleKeys.reflectYourEmotions.tr().appText(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        16.verticalSpace,
                        _buildChildSection(state),
                        16.verticalSpace,
                        _buildParentSection(state),
                        30.verticalSpace,
                      ],
                    );
                  },
                  listener: (BuildContext context, state) {
                    state.emotionsLogApiResult.whenOrNull(
                      data: (data) => EasyLoading.dismiss(),
                      loading: () => EasyLoading.show(),
                      error: (error) => EasyLoading.dismiss(),
                      initial: () => EasyLoading.dismiss(),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _appBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BaseButton(
            child: Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Assets.icons.icBackIcon.image(height: 20.w, width: 20.w),
            ),
            onTap: () => context.pop(),
          ),
          // Can add a help or settings icon here if needed
        ],
      ),
    );
  }

  Widget _buildChildSection(ReflectEmotionState state) {
    List<MoodLogModel> logs = context
        .read<ReflectEmotionCubit>()
        .getLogsForWeek();

    return _EmotionSummaryCard(
      title: "Child's Moods",
      subtitle:
          "This Week Mood Count for ${state.childModel?.childName ?? 'Child'}",
      moodCounts: {
        "Calm": logs.where((e) => e.childMood == 'CALM').length,
        "Happy": logs.where((e) => e.childMood == 'HAPPY').length,
        "Worried": logs.where((e) => e.childMood == 'WORRIED').length,
        "Sad": logs.where((e) => e.childMood == 'SAD').length,
        "Mad": logs.where((e) => e.childMood == 'MAD').length,
      },
      chartData: context.read<ReflectEmotionCubit>().countMoodLogsByDay(),
      weekRange: state.selectedWeek,
      onNextWeek: () => context.read<ReflectEmotionCubit>().nextWeek(),
      onPrevWeek: () => context.read<ReflectEmotionCubit>().previousWeek(),
    );
  }

  Widget _buildParentSection(ReflectEmotionState state) {
    List<MoodLogModel> logs = context
        .read<ReflectEmotionCubit>()
        .getLogsForWeek();

    return _EmotionSummaryCard(
      title: "Parent's Moods",
      subtitle:
          "This Week Mood Count for ${state.userModel?.parentName ?? 'You'}",
      moodCounts: {
        "Calm": logs.where((e) => e.parentMood == 'CALM').length,
        "Happy": logs.where((e) => e.parentMood == 'HAPPY').length,
        "Worried": logs.where((e) => e.parentMood == 'WORRIED').length,
        "Sad": logs.where((e) => e.parentMood == 'SAD').length,
        "Mad": logs.where((e) => e.parentMood == 'MAD').length,
      },
      chartData: context.read<ReflectEmotionCubit>().countMoodLogsByDay(),
      weekRange: state.selectedWeek,
      onNextWeek: () => context.read<ReflectEmotionCubit>().nextWeek(),
      onPrevWeek: () => context.read<ReflectEmotionCubit>().previousWeek(),
    );
  }
}

class _EmotionSummaryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Map<String, int> moodCounts;
  final List<double> chartData;
  final WeekRange? weekRange;
  final VoidCallback onNextWeek;
  final VoidCallback onPrevWeek;

  const _EmotionSummaryCard({
    required this.title,
    required this.subtitle,
    required this.moodCounts,
    required this.chartData,
    this.weekRange,
    required this.onNextWeek,
    required this.onPrevWeek,
  });

  @override
  Widget build(BuildContext context) {
    final days = ['SUN', 'MON', 'TUES', 'WED', 'THUR', 'FRI', 'SAT'];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4.w,
                height: 20.h,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              8.horizontalSpace,
              title.appText(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ],
          ),
          8.verticalSpace,
          subtitle.appText(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
          16.verticalSpace,
          _buildMoodRow(moodCounts),
          16.verticalSpace,
          Container(
            height: 1,
            decoration: DottedDecoration(
              shape: Shape.line,
              color: Colors.grey.withValues(alpha: 0.3),
              strokeWidth: 1.5,
              dash: const [4, 4],
            ),
          ),
          16.verticalSpace,
          _buildChartSection(days),
        ],
      ),
    );
  }

  Widget _buildMoodRow(Map<String, int> counts) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: counts.entries.map((entry) {
        return Expanded(
          child: _MoodItem(mood: entry.key, count: entry.value),
        );
      }).toList(),
    );
  }

  Widget _buildChartSection(List<String> days) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LocaleKeys.moodActivity.tr().appText(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                if (weekRange != null)
                  weekRange!.getFormattedRange.appText(
                    fontSize: 10.sp,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
              ],
            ),
            Container(
              height: 32.h,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                color: buttonColor2,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.chevron_left,
                      size: 18.sp,
                      color: Colors.black87,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: onPrevWeek,
                  ),
                  Container(
                    width: 1,
                    height: 14.h,
                    color: Colors.grey.withValues(alpha: 0.3),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.chevron_right,
                      size: 18.sp,
                      color: Colors.black87,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: onNextWeek,
                  ),
                ],
              ),
            ),
          ],
        ),
        16.verticalSpace,
        AppBarGraph(
          height: 180.h,
          titles: days,
          values: chartData,
          showBest: true,
          showTitles: false,
        ),
      ],
    );
  }
}

class _MoodItem extends StatelessWidget {
  final String mood;
  final int count;

  const _MoodItem({required this.mood, required this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(6.r),
          decoration: BoxDecoration(
            color: _getMoodColorRaw(mood).withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: _getMoodImage(mood).image(height: 28.w, width: 28.w),
        ),
        6.verticalSpace,
        mood.appText(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: Colors.black54,
        ),
        2.verticalSpace,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: count.toString().appText(
            fontSize: 9.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  AssetGenImage _getMoodImage(String mood) {
    switch (mood.toUpperCase()) {
      case 'CALM':
        return Assets.images.imgMoodCalm;
      case 'HAPPY':
        return Assets.images.imgMoodHappy;
      case 'WORRIED':
        return Assets.images.imgMoodWorried;
      case 'SAD':
        return Assets.images.imgMoodSad;
      case 'MAD':
        return Assets.images.imgMoodMad;
      default:
        return Assets.images.imgMoodCalm;
    }
  }

  Color _getMoodColorRaw(String mood) {
    switch (mood.toUpperCase()) {
      case 'CALM':
        return Colors.blue;
      case 'HAPPY':
        return Colors.orange;
      case 'WORRIED':
        return Colors.purple;
      case 'SAD':
        return Colors.grey;
      case 'MAD':
        return Colors.red;
      default:
        return Colors.green;
    }
  }
}
