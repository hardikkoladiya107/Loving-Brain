import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/mood_log_model.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/daily_mood_log/bloc/daily_mood_log_cubit.dart';
import 'package:loving_brain/ui/daily_mood_log/bloc/daily_mood_log_state.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

class DailyMoodLog extends StatefulWidget {
  const DailyMoodLog({super.key});

  @override
  State<DailyMoodLog> createState() => _DailyMoodLogState();
}

class _DailyMoodLogState extends State<DailyMoodLog> {
  @override
  void initState() {
    context.read<DailyMoodLogCubit>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget _appBar() {
      return Row(
        children: [
          20.spaceW,
          BaseButton(
            child: Assets.icons.icBackIcon.image(
              height: 36,
              width: 36,
              color: Colors.black.withValues(alpha: 0.8),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          12.w.spaceW,
          "Daily Mood Logs".appText(fontWeight: FontWeight.w700),
        ],
      );
    }

    return Scaffold(
      // backgroundColor: Colors.white,
      body: BlocConsumer<DailyMoodLogCubit, DailyMoodLogState>(
        listener: (BuildContext context, DailyMoodLogState state) {
          state.logsApiResultStatus.whenOrNull(
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
        builder: (context, state) {
          return Column(
            children: [40.spaceH, _appBar(), 12.spaceH, _logsList(state)],
          );
        },
      ),
    );
  }

  _logsList(DailyMoodLogState state) {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: state.logs.length,
        shrinkWrap: true,
        itemBuilder: (context, index) => _logTile(
          state.logs[index],
        ).appPadding(left: 16, right: 16, bottom: 8, top: 8),
      ),
    );
  }

  Widget _logTile(MoodLogModel log) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: yellowColor3.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.track_changes,
          size: 22,
          color: greenPlayButtonColor,
        ),
      ),
      title: ("Parent : ${log.parentMood.toLowerCase()}").appText(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        textAlign: TextAlign.start,
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: ("Child : ${log.parentMood.toLowerCase()}").appText(
          fontSize: 14,
          color: Colors.grey,
          textAlign: TextAlign.start,
        ),
      ),

      trailing: log.logTime.timeAgo().appText(),
      tileColor: Colors.white,
    );
  }
}
