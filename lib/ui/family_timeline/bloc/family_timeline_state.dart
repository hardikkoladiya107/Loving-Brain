import 'package:freezed_annotation/freezed_annotation.dart';

part 'family_timeline_state.freezed.dart';

class TimelineEvent {
  final String title;
  final String? subtitle;
  TimelineEvent({required this.title, this.subtitle});
}

@freezed
abstract class FamilyTimelineState with _$FamilyTimelineState {
  const factory FamilyTimelineState({@Default([]) List<TimelineEvent> events}) =
      _FamilyTimelineState;
}
