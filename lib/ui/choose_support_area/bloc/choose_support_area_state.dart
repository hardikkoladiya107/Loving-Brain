import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/mentorship_models.dart';

part 'choose_support_area_state.freezed.dart';

@freezed
abstract class ChooseSupportAreaState with _$ChooseSupportAreaState {
  const factory ChooseSupportAreaState({
    @Default(-1) int selectedIndex,
    @Default(<String>[
      'Sleep guidance',
      'Tantrum & behaviour',
      'Eating & nutrition',
      'Parental confidence',
      'Co-parenting',
    ])
    List<String> areas,
    @Default([]) List<GuideProfileModel> matchedGuides,
    @Default(ApiResultStatus.initial()) ApiResultStatus matchStatus,
  }) = _ChooseSupportAreaState;
}
