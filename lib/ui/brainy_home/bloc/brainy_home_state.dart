import 'package:freezed_annotation/freezed_annotation.dart';

part 'brainy_home_state.freezed.dart';

@freezed
abstract class BrainyHomeState with _$BrainyHomeState {
  const factory BrainyHomeState({
    @Default('Behaviour') String selectedTopic,
    @Default('Parent') String parentName,
    @Default('your child') String childName,
    @Default('') String chatText,
    @Default([
      'Why is bedtime harder lately?',
      'What can I try tonight?',
    ])
    List<String> suggestedQuestions,
  }) = _BrainyHomeState;
}
