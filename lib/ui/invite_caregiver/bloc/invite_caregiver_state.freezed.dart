// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invite_caregiver_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InviteCaregiverState {
  String get selectedRole;
  String get childName;

  /// Create a copy of InviteCaregiverState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $InviteCaregiverStateCopyWith<InviteCaregiverState> get copyWith =>
      _$InviteCaregiverStateCopyWithImpl<InviteCaregiverState>(
          this as InviteCaregiverState, _$identity);

  @override
  bool operator ==(Object other) {
    final _this = this as InviteCaregiverState;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is InviteCaregiverState &&
            (identical(other.selectedRole, _this.selectedRole) ||
                other.selectedRole == _this.selectedRole) &&
            (identical(other.childName, _this.childName) ||
                other.childName == _this.childName));
  }

  @override
  int get hashCode {
    final _this = this as InviteCaregiverState;
    return Object.hash(runtimeType, _this.selectedRole, _this.childName);
  }

  @override
  String toString() {
    final _this = this as InviteCaregiverState;
    return 'InviteCaregiverState(selectedRole: ${_this.selectedRole}, childName: ${_this.childName})';
  }
}

/// @nodoc
abstract mixin class $InviteCaregiverStateCopyWith<$Res> {
  factory $InviteCaregiverStateCopyWith(InviteCaregiverState value,
          $Res Function(InviteCaregiverState) _then) =
      _$InviteCaregiverStateCopyWithImpl;
  @useResult
  $Res call({String selectedRole, String childName});
}

/// @nodoc
class _$InviteCaregiverStateCopyWithImpl<$Res>
    implements $InviteCaregiverStateCopyWith<$Res> {
  _$InviteCaregiverStateCopyWithImpl(this._self, this._then);

  final InviteCaregiverState _self;
  final $Res Function(InviteCaregiverState) _then;

  /// Create a copy of InviteCaregiverState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedRole = null,
    Object? childName = null,
  }) {
    return _then(InviteCaregiverState(
      selectedRole: null == selectedRole
          ? _self.selectedRole
          : selectedRole // ignore: cast_nullable_to_non_nullable
              as String,
      childName: null == childName
          ? _self.childName
          : childName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [InviteCaregiverState].
extension InviteCaregiverStatePatterns on InviteCaregiverState {
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_InviteCaregiverState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _InviteCaregiverState() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_InviteCaregiverState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InviteCaregiverState():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_InviteCaregiverState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InviteCaregiverState() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String selectedRole, String childName)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _InviteCaregiverState() when $default != null:
        return $default(_that.selectedRole, _that.childName);
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String selectedRole, String childName) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InviteCaregiverState():
        return $default(_that.selectedRole, _that.childName);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String selectedRole, String childName)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InviteCaregiverState() when $default != null:
        return $default(_that.selectedRole, _that.childName);
      case _:
        return null;
    }
  }
}

/// @nodoc
class _InviteCaregiverState implements InviteCaregiverState {
  const _InviteCaregiverState({
    this.selectedRole = 'Grandparent',
    this.childName = 'your child',
  });

  @override
  @JsonKey()
  final String selectedRole;
  @override
  @JsonKey()
  final String childName;

  /// Create a copy of InviteCaregiverState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$InviteCaregiverStateCopyWith<_InviteCaregiverState> get copyWith =>
      __$InviteCaregiverStateCopyWithImpl<_InviteCaregiverState>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _InviteCaregiverState &&
            (identical(other.selectedRole, selectedRole) ||
                other.selectedRole == selectedRole) &&
            (identical(other.childName, childName) ||
                other.childName == childName));
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, selectedRole, childName);
  }

  @override
  String toString() {
    return 'InviteCaregiverState(selectedRole: $selectedRole, childName: $childName)';
  }
}

/// @nodoc
abstract mixin class _$InviteCaregiverStateCopyWith<$Res>
    implements $InviteCaregiverStateCopyWith<$Res> {
  factory _$InviteCaregiverStateCopyWith(_InviteCaregiverState value,
          $Res Function(_InviteCaregiverState) _then) =
      __$InviteCaregiverStateCopyWithImpl;
  @override
  @useResult
  $Res call({String selectedRole, String childName});
}

/// @nodoc
class __$InviteCaregiverStateCopyWithImpl<$Res>
    implements _$InviteCaregiverStateCopyWith<$Res> {
  __$InviteCaregiverStateCopyWithImpl(this._self, this._then);

  final _InviteCaregiverState _self;
  final $Res Function(_InviteCaregiverState) _then;

  /// Create a copy of InviteCaregiverState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? selectedRole = null,
    Object? childName = null,
  }) {
    return _then(_InviteCaregiverState(
      selectedRole: null == selectedRole
          ? _self.selectedRole
          : selectedRole // ignore: cast_nullable_to_non_nullable
              as String,
      childName: null == childName
          ? _self.childName
          : childName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
