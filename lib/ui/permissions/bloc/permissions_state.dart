import 'package:freezed_annotation/freezed_annotation.dart';

part 'permissions_state.freezed.dart';

@freezed
abstract class PermissionsState with _$PermissionsState {
  const factory PermissionsState() = _PermissionsState;
}
