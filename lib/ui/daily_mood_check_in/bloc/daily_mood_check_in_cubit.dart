import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/other/preferances.dart';

import '../../../generated/locale_keys.g.dart';
import '../../../model/api_result_status.dart';
import '../../../model/user_model.dart';
import '../../../repo/mood_repo.dart';
import 'daily_mood_check_in_state.dart';

class DailyMoodCheckInCubit extends Cubit<DailyMoodCheckInState> {
  DailyMoodCheckInCubit() : super(DailyMoodCheckInState());

  void init() {
    emit(DailyMoodCheckInState(userModel: preferences.getUserModel()));
  }

  void changeProps({
    UserModel? userModel,
    ApiResultStatus? apiResultStatus,
    String? childMood,
    String? parentMood,
  }) {
    emit(
      state.copyWith(
        userModel: userModel ?? state.userModel,
        apiResultStatus: apiResultStatus ?? ApiResultStatus.initial(),
        childMood: childMood ?? state.childMood,
        parentMood: parentMood ?? state.parentMood,
      ),
    );
  }

  Future<void> logMoods() async {
    if (_isValidate()) {
      changeProps(apiResultStatus: ApiResultStatus.loading());
      var apiResultStatus = await MoodRepo.instance.addMood(
        date: DateTime.now().microsecondsSinceEpoch.toString(),
        request: {
          "child_mood": state.childMood,
          "parent_mood": state.parentMood,
          "log_time": DateTime.now(),
        },
      );
      changeProps(apiResultStatus: apiResultStatus);
    }
  }

  bool _isValidate() {
    if ((state.childMood ?? "").isEmpty || (state.parentMood ?? "").isEmpty) {
      if ((state.childMood ?? "").isEmpty) {
        changeProps(
          apiResultStatus: ApiResultStatus.error(
            error: Exception(LocaleKeys.pleaseEnterChildMood.tr()),
          ),
        );
        return false;
      }
      if ((state.parentMood ?? "").isEmpty) {
        changeProps(
          apiResultStatus: ApiResultStatus.error(
            error: Exception(LocaleKeys.pleaseEnterParentMood.tr()),
          ),
        );
        return false;
      }
      return false;
    }
    return true;
  }
}
