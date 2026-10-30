import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/api_result_status.dart';

part 'add_child_state.freezed.dart';

@freezed
abstract class AddChildState with _$AddChildState {
  const factory AddChildState({
    @Default('') String name,
    @Default('') String dob,
    DateTime? childDob,
    @Default('') String concerns,
    @Default('') String location,
    @Default(<String>[]) List<String> selectedConcerns,
    @Default(ApiResultStatus.initial()) ApiResultStatus saveStatus,
  }) = _AddChildState;
}
