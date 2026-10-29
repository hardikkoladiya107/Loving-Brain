import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/mentorship_models.dart';

part 'guide_list_state.freezed.dart';

@freezed
abstract class GuideListState with _$GuideListState {
  const factory GuideListState({
    @Default(false) bool isLoading,
    @Default('') String supportArea,
    @Default([]) List<GuideProfileModel> guides,
    @Default(ApiResultStatus.initial()) ApiResultStatus fetchStatus,
  }) = _GuideListState;
}
