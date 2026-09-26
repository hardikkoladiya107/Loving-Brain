import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_session_plan_state.freezed.dart';

@freezed
abstract class PostSessionPlanState with _$PostSessionPlanState {
  const factory PostSessionPlanState() = _PostSessionPlanState;
}
