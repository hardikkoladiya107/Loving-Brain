import 'package:freezed_annotation/freezed_annotation.dart';

part 'programme_detail_state.freezed.dart';

@freezed
abstract class ProgrammeDetailState with _$ProgrammeDetailState {
  const factory ProgrammeDetailState() = _ProgrammeDetailState;
}
