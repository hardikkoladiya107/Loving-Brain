import 'package:freezed_annotation/freezed_annotation.dart';

part 'brainy_saved_guidance_state.freezed.dart';

class BrainySavedItem {
  final String? id;
  final String? conversationId;
  final String title;
  final String subtitle;
  final String imagePath;
  final int imageBgColorValue;
  final String? topic;

  BrainySavedItem({
    this.id,
    this.conversationId,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.imageBgColorValue,
    this.topic,
  });
}

@freezed
abstract class BrainySavedGuidanceState with _$BrainySavedGuidanceState {
  const factory BrainySavedGuidanceState({
    @Default([]) List<BrainySavedItem> sleepItems,
    @Default([]) List<BrainySavedItem> behaviourItems,
    @Default([]) List<BrainySavedItem> parentWellbeingItems,
  }) = _BrainySavedGuidanceState;
}
