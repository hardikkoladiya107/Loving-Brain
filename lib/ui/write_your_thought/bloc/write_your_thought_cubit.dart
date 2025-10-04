import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/journal_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/ui/write_your_thought/bloc/write_your_thought_state.dart';

import '../../../generated/locale_keys.g.dart';
import '../../../model/api_result_status.dart';
import '../../../model/user_model.dart';
import '../../../repo/auth_repo.dart';
import '../../../repo/mood_repo.dart';

class WriteYourThoughtCubit extends Cubit<WriteYourThoughtState> {
  WriteYourThoughtCubit() : super(WriteYourThoughtState());

  void init() {
    emit(WriteYourThoughtState(userModel: preferences.getUserModel()));
    _getThoughts();
  }

  void changeProps({
    UserModel? userModel,
    ApiResultStatus? apiResultStatus,
    String? thoughtsText,
    String? thoughtsErrorText,
    List<JournalModel>? journalList,
  }) {
    emit(
      state.copyWith(
        userModel: userModel ?? state.userModel,
        apiResultStatus: apiResultStatus ?? ApiResultStatus.initial(),
        thoughtsText: thoughtsText ?? state.thoughtsText,
        thoughtsErrorText: thoughtsErrorText ?? state.thoughtsErrorText,
        journalList: journalList ?? state.journalList,
      ),
    );
  }

  StreamSubscription? journalsSubscription;

  void _getThoughts() {
    if (state.userModel?.uid != null) {
      journalsSubscription?.cancel();
      journalsSubscription = AuthRepo.instance.userCollection
          .doc(state.userModel!.uid)
          .collection("journals")
          .snapshots()
          .listen((event) {
            changeProps(
              journalList: event.docs
                  .map((e) => JournalModel.fromJson(e.data()))
                  .toList(),
            );
          });
    }
  }

  void dispose() {
    journalsSubscription?.cancel();
  }

  Future<void> logThought() async {
    if (isValidate()) {
      changeProps(apiResultStatus: ApiResultStatus.loading());
      var apiResultStatus = await MoodRepo.instance.addJournal(
        request: {
          "thought_text": state.thoughtsText,
          "log_time": DateTime.now(),
        },
      );
      changeProps(apiResultStatus: apiResultStatus);
    }
  }

  bool isValidate() {
    if (state.thoughtsText.isEmpty) {
      changeProps(thoughtsErrorText: LocaleKeys.pleaseEnterYourThoughts.tr());
      return false;
    }
    changeProps(thoughtsErrorText: "");
    return true;
  }


}
