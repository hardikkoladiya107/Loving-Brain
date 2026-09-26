import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/api_result_status.dart';

part 'child_profile_v2_state.freezed.dart';

@freezed
abstract class ChildProfileV2State with _$ChildProfileV2State {
  const factory ChildProfileV2State({
    ChildModel? childModel,
    @Default('') String name,
    @Default('') String age,
    @Default('') String conditions,
    @Default('') String dob,
    @Default('') String concerns,
    @Default('') String location,
    @Default(ApiResultStatus<String>.initial()) ApiResultStatus<String> saveStatus,
  }) = _ChildProfileV2State;
}
