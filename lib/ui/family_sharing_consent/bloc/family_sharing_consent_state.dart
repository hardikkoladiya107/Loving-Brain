import 'package:freezed_annotation/freezed_annotation.dart';

part 'family_sharing_consent_state.freezed.dart';

/// State for Screen 74 (Family Sharing Consent Explainer).
/// Conforms to AGENTS.md §4.1 and v2-doc/04_DATABASE_SCHEMA_AND_OFFLINE_RULES.md.
@freezed
abstract class FamilySharingConsentState with _$FamilySharingConsentState {
  const factory FamilySharingConsentState({
    @Default('your child') String childName,
    @Default(false) bool isConsentGiven,
  }) = _FamilySharingConsentState;
}
