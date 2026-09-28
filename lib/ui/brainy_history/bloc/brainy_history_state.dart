import 'package:freezed_annotation/freezed_annotation.dart';

part 'brainy_history_state.freezed.dart';

class BrainyHistoryItem {
  final String? conversationId;
  final String title;
  final String subtitle;
  final String? topic;

  BrainyHistoryItem({
    this.conversationId,
    required this.title,
    required this.subtitle,
    this.topic,
  });
}

@freezed
abstract class BrainyHistoryState with _$BrainyHistoryState {
  const factory BrainyHistoryState({
    @Default([]) List<BrainyHistoryItem> thisWeekHistory,
    @Default([]) List<BrainyHistoryItem> earlierHistory,
  }) = _BrainyHistoryState;
}
