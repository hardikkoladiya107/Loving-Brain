import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../model/api_result_status.dart';

part 'onboarding_state.freezed.dart';

@freezed
abstract class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    @Default(0) int currentPage,
    @Default(6) int totalPages,
    @Default('') String parentName,
    @Default('') String parentNameError,
    @Default('') String parentRole,
    @Default('') String parentRoleError,
    @Default('') String preferredLanguage,
    @Default('') String preferredLanguageError,
    @Default('') String location,
    @Default('') String locationError,
    @Default('') String primaryConcern,
    @Default(<String>[]) List<String> concerns,
    @Default('') String concernsError,
    @Default(false) bool isMoreThanOneSelected,
    @Default('') String successGoal,
    @Default('') String successGoalError,
    @Default('') String childName,
    @Default('') String childNameError,
    @Default('') String dateOfBirth,
    @Default('') String dateOfBirthError,
    DateTime? childDob,
    @Default('') String childGender,
    @Default('') String childGenderError,
    @Default('') String usualWakeTime,
    @Default('') String usualWakeTimeError,
    @Default('') String usualBedtime,
    @Default('') String usualBedtimeError,
    @Default(0) int usualNaps,
    @Default('') String nightWakings,
    @Default('') String nightWakingsError,
    @Default(<String>[]) List<String> difficultTimes,
    @Default('') String difficultTimesError,
    @Default(<String>[]) List<String> possibleTriggers,
    @Default('') String possibleTriggersError,
    @Default(ApiResultStatus.initial()) ApiResultStatus completeStatus,
  }) = _OnboardingState;
}
