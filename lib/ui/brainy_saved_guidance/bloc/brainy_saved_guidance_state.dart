import 'package:freezed_annotation/freezed_annotation.dart';

part 'brainy_saved_guidance_state.freezed.dart';

class BrainySavedItem {
  final String title;
  final String subtitle;
  final String imagePath;
  final int imageBgColorValue;

  BrainySavedItem({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.imageBgColorValue,
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
