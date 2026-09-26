import 'package:freezed_annotation/freezed_annotation.dart';

part 'weekly_family_review_state.freezed.dart';

@freezed
abstract class WeeklyFamilyReviewState with _$WeeklyFamilyReviewState {
  const factory WeeklyFamilyReviewState() = _WeeklyFamilyReviewState;
}
