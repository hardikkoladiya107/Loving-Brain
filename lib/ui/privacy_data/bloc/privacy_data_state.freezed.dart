// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'privacy_data_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PrivacyDataState {
  String get childName;
  bool get isDeletingAccount;
  bool get isAccountDeleted;
  String get errorMessage;

  /// Create a copy of PrivacyDataState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PrivacyDataStateCopyWith<PrivacyDataState> get copyWith =>
      _$PrivacyDataStateCopyWithImpl<PrivacyDataState>(
          this as PrivacyDataState, _$identity);

  @override
  bool operator ==(Object other) {
    final _this = this as PrivacyDataState;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PrivacyDataState &&
            (identical(other.childName, _this.childName) ||
                other.childName == _this.childName) &&
            (identical(other.isDeletingAccount, _this.isDeletingAccount) ||
                other.isDeletingAccount == _this.isDeletingAccount) &&
            (identical(other.isAccountDeleted, _this.isAccountDeleted) ||
                other.isAccountDeleted == _this.isAccountDeleted) &&
            (identical(other.errorMessage, _this.errorMessage) ||
                other.errorMessage == _this.errorMessage));
  }

  @override
  int get hashCode {
    final _this = this as PrivacyDataState;
    return Object.hash(runtimeType, _this.childName, _this.isDeletingAccount,
        _this.isAccountDeleted, _this.errorMessage);
  }

  @override
  String toString() {
    final _this = this as PrivacyDataState;
    return 'PrivacyDataState(childName: ${_this.childName}, isDeletingAccount: ${_this.isDeletingAccount}, isAccountDeleted: ${_this.isAccountDeleted}, errorMessage: ${_this.errorMessage})';
  }
}

/// @nodoc
abstract mixin class $PrivacyDataStateCopyWith<$Res> {
  factory $PrivacyDataStateCopyWith(
          PrivacyDataState value, $Res Function(PrivacyDataState) _then) =
      _$PrivacyDataStateCopyWithImpl;
  @useResult
  $Res call(
      {String childName,
      bool isDeletingAccount,
      bool isAccountDeleted,
      String errorMessage});
}

/// @nodoc
class _$PrivacyDataStateCopyWithImpl<$Res>
    implements $PrivacyDataStateCopyWith<$Res> {
  _$PrivacyDataStateCopyWithImpl(this._self, this._then);

  final PrivacyDataState _self;
  final $Res Function(PrivacyDataState) _then;

  /// Create a copy of PrivacyDataState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? childName = null,
    Object? isDeletingAccount = null,
    Object? isAccountDeleted = null,
    Object? errorMessage = null,
  }) {
    return _then(PrivacyDataState(
      childName: null == childName
          ? _self.childName
          : childName // ignore: cast_nullable_to_non_nullable
              as String,
      isDeletingAccount: null == isDeletingAccount
          ? _self.isDeletingAccount
          : isDeletingAccount // ignore: cast_nullable_to_non_nullable
              as bool,
      isAccountDeleted: null == isAccountDeleted
          ? _self.isAccountDeleted
          : isAccountDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: null == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [PrivacyDataState].
extension PrivacyDataStatePatterns on PrivacyDataState {
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_PrivacyDataState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PrivacyDataState() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_PrivacyDataState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PrivacyDataState():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_PrivacyDataState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PrivacyDataState() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String childName, bool isDeletingAccount,
            bool isAccountDeleted, String errorMessage)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PrivacyDataState() when $default != null:
        return $default(_that.childName, _that.isDeletingAccount,
            _that.isAccountDeleted, _that.errorMessage);
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String childName, bool isDeletingAccount,
            bool isAccountDeleted, String errorMessage)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PrivacyDataState():
        return $default(_that.childName, _that.isDeletingAccount,
            _that.isAccountDeleted, _that.errorMessage);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String childName, bool isDeletingAccount,
            bool isAccountDeleted, String errorMessage)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PrivacyDataState() when $default != null:
        return $default(_that.childName, _that.isDeletingAccount,
            _that.isAccountDeleted, _that.errorMessage);
      case _:
        return null;
    }
  }
}

/// @nodoc
class _PrivacyDataState implements PrivacyDataState {
  const _PrivacyDataState({
    this.childName = 'your child',
    this.isDeletingAccount = false,
    this.isAccountDeleted = false,
    this.errorMessage = '',
  });

  @override
  @JsonKey()
  final String childName;
  @override
  @JsonKey()
  final bool isDeletingAccount;
  @override
  @JsonKey()
  final bool isAccountDeleted;
  @override
  @JsonKey()
  final String errorMessage;

  /// Create a copy of PrivacyDataState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PrivacyDataStateCopyWith<_PrivacyDataState> get copyWith =>
      __$PrivacyDataStateCopyWithImpl<_PrivacyDataState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PrivacyDataState &&
            (identical(other.childName, childName) ||
                other.childName == childName) &&
            (identical(other.isDeletingAccount, isDeletingAccount) ||
                other.isDeletingAccount == isDeletingAccount) &&
            (identical(other.isAccountDeleted, isAccountDeleted) ||
                other.isAccountDeleted == isAccountDeleted) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType, childName, isDeletingAccount, isAccountDeleted, errorMessage);
  }

  @override
  String toString() {
    return 'PrivacyDataState(childName: $childName, isDeletingAccount: $isDeletingAccount, isAccountDeleted: $isAccountDeleted, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class _$PrivacyDataStateCopyWith<$Res>
    implements $PrivacyDataStateCopyWith<$Res> {
  factory _$PrivacyDataStateCopyWith(
          _PrivacyDataState value, $Res Function(_PrivacyDataState) _then) =
      __$PrivacyDataStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String childName,
      bool isDeletingAccount,
      bool isAccountDeleted,
      String errorMessage});
}

/// @nodoc
class __$PrivacyDataStateCopyWithImpl<$Res>
    implements _$PrivacyDataStateCopyWith<$Res> {
  __$PrivacyDataStateCopyWithImpl(this._self, this._then);

  final _PrivacyDataState _self;
  final $Res Function(_PrivacyDataState) _then;

  /// Create a copy of PrivacyDataState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? childName = null,
    Object? isDeletingAccount = null,
    Object? isAccountDeleted = null,
    Object? errorMessage = null,
  }) {
    return _then(_PrivacyDataState(
      childName: null == childName
          ? _self.childName
          : childName // ignore: cast_nullable_to_non_nullable
              as String,
      isDeletingAccount: null == isDeletingAccount
          ? _self.isDeletingAccount
          : isDeletingAccount // ignore: cast_nullable_to_non_nullable
              as bool,
      isAccountDeleted: null == isAccountDeleted
          ? _self.isAccountDeleted
          : isAccountDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: null == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
