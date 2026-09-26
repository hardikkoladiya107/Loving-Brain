import 'package:freezed_annotation/freezed_annotation.dart';

part 'parent_success_guide_state.freezed.dart';

@freezed
abstract class ParentSuccessGuideState with _$ParentSuccessGuideState {
  const factory ParentSuccessGuideState() = _ParentSuccessGuideState;
}
