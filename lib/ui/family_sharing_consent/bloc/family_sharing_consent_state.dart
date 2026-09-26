import 'package:freezed_annotation/freezed_annotation.dart';

part 'family_sharing_consent_state.freezed.dart';

@freezed
abstract class FamilySharingConsentState with _$FamilySharingConsentState {
  const factory FamilySharingConsentState() = _FamilySharingConsentState;
}
