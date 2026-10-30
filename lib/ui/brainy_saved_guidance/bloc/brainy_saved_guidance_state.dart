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
  final String? whatMayBeHappeningHeadline;
  final String? whatMayBeHappeningSubtext;
  final String? whatToTryNowHeadline;
  final String? whatToTryNowSubtext;
  final String? whenToGetHelpHeadline;
  final String? whenToGetHelpSubtext;

  BrainySavedItem({
    this.id,
    this.conversationId,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.imageBgColorValue,
    this.topic,
    this.whatMayBeHappeningHeadline,
    this.whatMayBeHappeningSubtext,
    this.whatToTryNowHeadline,
    this.whatToTryNowSubtext,
    this.whenToGetHelpHeadline,
    this.whenToGetHelpSubtext,
  });

  bool get hasStoredAnswerParts =>
      (whatMayBeHappeningHeadline ?? '').trim().isNotEmpty ||
      (whatToTryNowHeadline ?? '').trim().isNotEmpty ||
      (whenToGetHelpHeadline ?? '').trim().isNotEmpty;
}

@freezed
abstract class BrainySavedGuidanceState with _$BrainySavedGuidanceState {
  const factory BrainySavedGuidanceState({
    @Default([]) List<BrainySavedItem> sleepItems,
    @Default([]) List<BrainySavedItem> behaviourItems,
    @Default([]) List<BrainySavedItem> parentWellbeingItems,
    @Default(false) bool hasLoadError,
  }) = _BrainySavedGuidanceState;
}
