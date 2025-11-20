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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            40.spaceH,
            _appBar(),
            BlocConsumer<ReflectEmotionCubit, ReflectEmotionState>(
              builder: (context, state) {
                return _reflectYourEmotionCard(state);
              },
              listener: (BuildContext context, state) {
                state.emotionsLogApiResult.whenOrNull(
                  data: (data) {
                    EasyLoading.dismiss();
                  },
                  loading: () {
                    EasyLoading.show();
                  },
                  error: (error) {
                    EasyLoading.dismiss();
                  },
                  initial: () {
                    EasyLoading.dismiss();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _appBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        20.spaceW,
        BaseButton(
          child: Assets.icons.icBackIcon.image(height: 36, width: 36),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget _reflectYourEmotionCard(ReflectEmotionState state) {
    List<MoodLogModel> logs = context
        .read<ReflectEmotionCubit>()
        .getLogsForWeek();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        "Reflect your emotions".appText(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        12.spaceH,
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: buttonColor2,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              8.spaceH,
              "This Week Mood Count for ${state.childModel?.childName}".appText(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              16.spaceH,
              Row(
                children: [
                  6.spaceW,
                  _moodWidget(
                    "Calm",
                    Assets.images.imgMoodCalm,
                    logs
                        .where((element) => element.childMood == 'CALM')
                        .toList()
                        .length,
                  ),
                  12.spaceW,
                  _moodWidget(
                    "Happy",
                    Assets.images.imgMoodHappy,
                    logs
                        .where((element) => element.childMood == 'HAPPY')
                        .toList()
                        .length,
                  ),
                  12.spaceW,
                  _moodWidget(
                    "Worried",
                    Assets.images.imgMoodWorried,
                    logs
                        .where((element) => element.childMood == 'WORRIED')
                        .toList()
                        .length,
                  ),
                  12.spaceW,
                  _moodWidget(
                    "Sad",
                    Assets.images.imgMoodSad,
                    logs
                        .where((element) => element.childMood == 'SAD')
                        .toList()
                        .length,
                  ),
                  12.spaceW,
                  _moodWidget(
                    "Mad",
                    Assets.images.imgMoodMad,
                    logs
                        .where((element) => element.childMood == 'MAD')
                        .toList()
                        .length,
                  ),
                  6.spaceW,
                ],
              ),
              16.spaceH,
              _dottedDivider(),
              16.spaceH,
              _happyMoodChartChild(state),
            ],
          ),
        ),
        20.spaceH,
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: buttonColor2,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              8.spaceH,
              "This Week Mood Count for ${state.userModel?.parentName}".appText(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              16.spaceH,
              Row(
                children: [
                  6.spaceW,
                  _moodWidget(
                    "Calm",
                    Assets.images.imgMoodCalm,
                    logs
                        .where((element) => element.parentMood == 'CALM')
                        .toList()
                        .length,
                  ),
                  12.spaceW,
                  _moodWidget(
                    "Happy",
                    Assets.images.imgMoodHappy,
                    logs
                        .where((element) => element.parentMood == 'HAPPY')
                        .toList()
                        .length,
                  ),
                  12.spaceW,
                  _moodWidget(
                    "Worried",
                    Assets.images.imgMoodWorried,
                    logs
                        .where((element) => element.parentMood == 'WORRIED')
                        .toList()
                        .length,
                  ),
                  12.spaceW,
                  _moodWidget(
                    "Sad",
                    Assets.images.imgMoodSad,
                    logs
                        .where((element) => element.parentMood == 'SAD')
                        .toList()
                        .length,
                  ),
                  12.spaceW,
                  _moodWidget(
                    "Mad",
                    Assets.images.imgMoodMad,
                    logs
                        .where((element) => element.parentMood == 'MAD')
                        .toList()
                        .length,
                  ),
                  6.spaceW,
                ],
              ),
              16.spaceH,
              _dottedDivider(),
              16.spaceH,
              _happyMoodChartChild(state),
            ],
          ),
        ),
      ],
    ).padding(all: 20);
  }

  Widget _dottedDivider() {
    return Container(
      height: 2,
      decoration: DottedDecoration(shape: Shape.line, color: Colors.grey),
    );
  }

  _moodWidget(String mood, AssetGenImage moodImage, int? count) {
    return Expanded(
      child: Column(
        children: [
          moodImage.image(),
          mood.appText(fontSize: 12),
          count.toString().appText(),
        ],
      ),
    );
  }

  _happyMoodChartChild(ReflectEmotionState state) {
    List<WeekRange> weeks = context.read<ReflectEmotionCubit>().getAllWeeks();
    final days = ['SUN', 'MON', 'TUES', 'WED', 'THUR', 'FRI', 'SAT'];
    final values = context.read<ReflectEmotionCubit>().countMoodLogsByDay();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BaseButton(
              child: Icon(Icons.arrow_back_ios),
              onTap: () {
                context.read<ReflectEmotionCubit>().previousWeek();
              },
            ),
            (state.selectedWeek?.getFormattedRange ?? "").appText(),
            BaseButton(
              child: Icon(Icons.arrow_forward_ios),
              onTap: () {
                context.read<ReflectEmotionCubit>().nextWeek();
              },
            ),
          ],
        ),
        6.spaceH,
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                "Happy Mood Chart".appText(fontSize: 18),
                if (state.selectedWeek != null)
                  state.selectedWeek!.getFormattedRange
                      .appText(fontSize: 10)
                      .padding(left: 6),
              ],
            ),
          ],
        ),
        AppBarGraph(
          height: 250,
          titles: days,
          values: values,
          showBest: true,
          showTitles: false,
        ),
      ],
    );
  }

  _happyMoodChartParent(ReflectEmotionState state) {
    List<WeekRange> weeks = context.read<ReflectEmotionCubit>().getAllWeeks();
    final days = ['SUN', 'MON', 'TUES', 'WED', 'THUR', 'FRI', 'SAT'];
    final values = context.read<ReflectEmotionCubit>().countMoodLogsByDay();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BaseButton(
              child: Icon(Icons.arrow_back_ios),
              onTap: () {
                context.read<ReflectEmotionCubit>().previousWeek();
              },
            ),
            (state.selectedWeek?.getFormattedRange ?? "").appText(),
            BaseButton(
              child: Icon(Icons.arrow_forward_ios),
              onTap: () {
                context.read<ReflectEmotionCubit>().nextWeek();
              },
            ),
          ],
        ),
        6.spaceH,
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                "Happy Mood Chart".appText(fontSize: 18),
                if (state.selectedWeek != null)
                  state.selectedWeek!.getFormattedRange
                      .appText(fontSize: 10)
                      .padding(left: 6),
              ],
            ),
          ],
        ),
        AppBarGraph(
          height: 250,
          titles: days,
          values: values,
          showBest: true,
          showTitles: false,
        ),
      ],
    );
  }
}
