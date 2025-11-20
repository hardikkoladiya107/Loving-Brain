import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/mood_log_model.dart';
import 'package:loving_brain/repo/mood_repo.dart';
import 'package:loving_brain/ui/daily_mood_log/bloc/daily_mood_log_state.dart';

import '../../../model/api_result_status.dart';
import '../../../model/user_model.dart';
import '../../../other/preferances.dart';

class DailyMoodLogCubit extends Cubit<DailyMoodLogState> {
  DailyMoodLogCubit() : super(DailyMoodLogState());

  void init() {
    emit(DailyMoodLogState(userModel: preferences.getUserModel()));
    _fetchLogs();
  }

  void changeProps({
    UserModel? userModel,
    ChildModel? childModel,
    ApiResultStatus? addMoodLogApiResult,
    List<MoodLogModel>? logs,
    ApiResultStatus? apiResultStatus,
    ApiResultStatus? logsApiResultStatus,
  }) {
    emit(
      state.copyWith(
        userModel: userModel ?? state.userModel,
        logs: logs ?? state.logs,
        apiResultStatus: apiResultStatus ?? ApiResultStatus.initial(),
        logsApiResultStatus: logsApiResultStatus ?? ApiResultStatus.initial(),
      ),
    );
  }

  Future<void> _fetchLogs() async {
    changeProps(logsApiResultStatus: ApiResultStatus.loading());
    var apiResultStatus = await MoodRepo.instance.fetchAllMoodLogs();
    changeProps(logsApiResultStatus: apiResultStatus);
    apiResultStatus.whenOrNull(
      data: (data) {
        if (data is List<MoodLogModel>) {
          changeProps(logs: data);
        }
      },
    );
  }
}
