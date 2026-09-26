import 'package:freezed_annotation/freezed_annotation.dart';

part 'shared_child_summary_state.freezed.dart';

@freezed
abstract class SharedChildSummaryState with _$SharedChildSummaryState {
  const factory SharedChildSummaryState() = _SharedChildSummaryState;
}
