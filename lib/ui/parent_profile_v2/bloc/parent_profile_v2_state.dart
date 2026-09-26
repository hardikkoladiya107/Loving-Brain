import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/model/api_result_status.dart';

part 'parent_profile_v2_state.freezed.dart';

@freezed
abstract class ParentProfileV2State with _$ParentProfileV2State {
  const factory ParentProfileV2State({
    UserModel? user,
    @Default('') String name,
    @Default('') String relationship,
    @Default('') String dob,
    @Default('') String gender,
    @Default('') String language,
    @Default('') String location,
    @Default(ApiResultStatus<String>.initial()) ApiResultStatus<String> saveStatus,
  }) = _ParentProfileV2State;
}
