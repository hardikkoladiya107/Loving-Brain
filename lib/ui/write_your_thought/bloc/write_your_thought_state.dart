import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/user_model.dart';

import '../../../model/journal_model.dart';

part 'write_your_thought_state.freezed.dart';

@freezed
abstract class WriteYourThoughtState with _$WriteYourThoughtState {
  const factory WriteYourThoughtState({
    UserModel? userModel,
    @Default(ApiResultStatus.initial()) ApiResultStatus apiResultStatus,
    @Default("") String thoughtsText,
    @Default("") String thoughtsErrorText,
    @Default([]) List<JournalModel> journalList,
  }) = _WriteYourThoughtState;
}
