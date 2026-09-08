import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../model/api_result_status.dart';

part 'onboarding_state.freezed.dart';

@freezed
abstract class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    @Default(0) int currentPage,
    @Default(6) int totalPages,
    @Default('Russell Sprout') String parentName,
    @Default('Mother') String parentRole,
    @Default('English') String preferredLanguage,
    @Default('Chennai, India (GMT+5:30)') String location,
    @Default('Sleep') String primaryConcern,
    @Default(<String>['Sleep']) List<String> concerns,
    @Default(false) bool isMoreThanOneSelected,
    @Default('Easier bedtimes') String successGoal,
    @Default('Ingredia Nutrisha') String childName,
    @Default('14 March 2024') String dateOfBirth,
    DateTime? childDob,
    @Default('Girl') String childGender,
    @Default('6:45 AM') String usualWakeTime,
    @Default('8:15 PM') String usualBedtime,
    @Default(2) int usualNaps,
    @Default('1-2') String nightWakings,
    @Default(<String>['Before meals', 'Bedtime']) List<String> difficultTimes,
    @Default(<String>['Tiredness', 'Overstimulation'])
    List<String> possibleTriggers,
    @Default(ApiResultStatus.initial()) ApiResultStatus completeStatus,
  }) = _OnboardingState;
}
