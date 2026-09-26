import 'package:freezed_annotation/freezed_annotation.dart';

part 'family_menu_state.freezed.dart';

@freezed
abstract class FamilyMenuState with _$FamilyMenuState {
  const factory FamilyMenuState() = _FamilyMenuState;
}
