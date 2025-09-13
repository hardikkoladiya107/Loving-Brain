import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_detail_state.freezed.dart';

@freezed
abstract class EventDetailState with _$EventDetailState {
  const factory EventDetailState({@Default("") String message}) =
      _EventDetailState;
}
