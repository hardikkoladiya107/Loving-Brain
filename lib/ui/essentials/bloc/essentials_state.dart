import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../model/api_result_status.dart';
import '../../../model/child_model.dart';
import '../../../model/user_model.dart';

part 'essentials_state.freezed.dart';

@freezed
abstract class EssentialsState with _$EssentialsState {
  const factory EssentialsState({
    @Default("") String xyz,
    @Default("") String titleError,
    @Default("") String descriptionError,
    UserModel? userModel,
    ChildModel? childModel,
    @Default([]) List<String> documentsList,
    @Default(ApiResultStatus.initial()) ApiResultStatus addEssentialsApiResult,
    @Default(ApiResultStatus.initial())
    ApiResultStatus uploadDocumentApiResultStatus,
  }) = _EssentialsState;
}
