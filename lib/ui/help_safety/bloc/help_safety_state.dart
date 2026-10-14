import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/api_result_status.dart';

part 'help_safety_state.freezed.dart';

/// State for Screen 63 (Help & Safety).
/// Conforms to AGENTS.md §4.1.
@freezed
abstract class HelpSafetyState with _$HelpSafetyState {
  const factory HelpSafetyState({
    @Default(false) bool isLoading,
    @Default('support@lovingbrain.com') String supportEmail,
    @Default('https://lovingbrain.com/faq') String faqUrl,
    @Default('tel:911') String emergencyPhone,
    @Default(ApiResultStatus.initial()) ApiResultStatus actionStatus,
  }) = _HelpSafetyState;
}
