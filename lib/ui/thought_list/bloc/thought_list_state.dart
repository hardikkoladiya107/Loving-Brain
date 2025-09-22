import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../model/api_result_status.dart';
import '../../../model/journal_model.dart';
import '../../../model/user_model.dart';

part 'thought_list_state.freezed.dart';

@freezed
abstract class ThoughtListState with _$ThoughtListState {
  const factory ThoughtListState({
    UserModel? userModel,
    @Default([]) List<JournalModel> journalList,
  }) = _ThoughtListState;
}
