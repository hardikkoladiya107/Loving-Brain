// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tonights_plan_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TonightsPlanState {
  bool get isLoading;
  bool get isPlanStarted;
  bool get isAudioPlaying;
  String get childName;

  /// Create a copy of TonightsPlanState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TonightsPlanStateCopyWith<TonightsPlanState> get copyWith =>
      _$TonightsPlanStateCopyWithImpl<TonightsPlanState>(
          this as TonightsPlanState, _$identity);

  @override
  bool operator ==(Object other) {
    final _this = this as TonightsPlanState;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TonightsPlanState &&
            (identical(other.isLoading, _this.isLoading) ||
                other.isLoading == _this.isLoading) &&
            (identical(other.isPlanStarted, _this.isPlanStarted) ||
                other.isPlanStarted == _this.isPlanStarted) &&
            (identical(other.isAudioPlaying, _this.isAudioPlaying) ||
                other.isAudioPlaying == _this.isAudioPlaying) &&
            (identical(other.childName, _this.childName) ||
                other.childName == _this.childName));
  }

  @override
  int get hashCode {
    final _this = this as TonightsPlanState;
    return Object.hash(runtimeType, _this.isLoading, _this.isPlanStarted,
        _this.isAudioPlaying, _this.childName);
  }

  @override
  String toString() {
    final _this = this as TonightsPlanState;
    return 'TonightsPlanState(isLoading: ${_this.isLoading}, isPlanStarted: ${_this.isPlanStarted}, isAudioPlaying: ${_this.isAudioPlaying}, childName: ${_this.childName})';
  }
}

/// @nodoc
abstract mixin class $TonightsPlanStateCopyWith<$Res> {
  factory $TonightsPlanStateCopyWith(
          TonightsPlanState value, $Res Function(TonightsPlanState) _then) =
      _$TonightsPlanStateCopyWithImpl;
  @useResult
  $Res call(
      {bool isLoading,
      bool isPlanStarted,
      bool isAudioPlaying,
      String childName});
}

/// @nodoc
class _$TonightsPlanStateCopyWithImpl<$Res>
    implements $TonightsPlanStateCopyWith<$Res> {
  _$TonightsPlanStateCopyWithImpl(this._self, this._then);

  final TonightsPlanState _self;
  final $Res Function(TonightsPlanState) _then;

  /// Create a copy of TonightsPlanState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isPlanStarted = null,
    Object? isAudioPlaying = null,
    Object? childName = null,
  }) {
    return _then(TonightsPlanState(
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isPlanStarted: null == isPlanStarted
          ? _self.isPlanStarted
          : isPlanStarted // ignore: cast_nullable_to_non_nullable
              as bool,
      isAudioPlaying: null == isAudioPlaying
          ? _self.isAudioPlaying
          : isAudioPlaying // ignore: cast_nullable_to_non_nullable
              as bool,
      childName: null == childName
          ? _self.childName
          : childName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [TonightsPlanState].
extension TonightsPlanStatePatterns on TonightsPlanState {
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_TonightsPlanState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TonightsPlanState() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_TonightsPlanState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TonightsPlanState():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_TonightsPlanState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TonightsPlanState() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(bool isLoading, bool isPlanStarted, bool isAudioPlaying,
            String childName)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TonightsPlanState() when $default != null:
        return $default(_that.isLoading, _that.isPlanStarted,
            _that.isAudioPlaying, _that.childName);
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(bool isLoading, bool isPlanStarted, bool isAudioPlaying,
            String childName)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TonightsPlanState():
        return $default(_that.isLoading, _that.isPlanStarted,
            _that.isAudioPlaying, _that.childName);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(bool isLoading, bool isPlanStarted, bool isAudioPlaying,
            String childName)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TonightsPlanState() when $default != null:
        return $default(_that.isLoading, _that.isPlanStarted,
            _that.isAudioPlaying, _that.childName);
      case _:
        return null;
    }
  }
}

/// @nodoc
class _TonightsPlanState implements TonightsPlanState {
  const _TonightsPlanState({
    this.isLoading = false,
    this.isPlanStarted = false,
    this.isAudioPlaying = false,
    this.childName = 'your child',
  });

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isPlanStarted;
  @override
  @JsonKey()
  final bool isAudioPlaying;
  @override
  @JsonKey()
  final String childName;

  /// Create a copy of TonightsPlanState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TonightsPlanStateCopyWith<_TonightsPlanState> get copyWith =>
      __$TonightsPlanStateCopyWithImpl<_TonightsPlanState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TonightsPlanState &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isPlanStarted, isPlanStarted) ||
                other.isPlanStarted == isPlanStarted) &&
            (identical(other.isAudioPlaying, isAudioPlaying) ||
                other.isAudioPlaying == isAudioPlaying) &&
            (identical(other.childName, childName) ||
                other.childName == childName));
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType, isLoading, isPlanStarted, isAudioPlaying, childName);
  }

  @override
  String toString() {
    return 'TonightsPlanState(isLoading: $isLoading, isPlanStarted: $isPlanStarted, isAudioPlaying: $isAudioPlaying, childName: $childName)';
  }
}

/// @nodoc
abstract mixin class _$TonightsPlanStateCopyWith<$Res>
    implements $TonightsPlanStateCopyWith<$Res> {
  factory _$TonightsPlanStateCopyWith(
          _TonightsPlanState value, $Res Function(_TonightsPlanState) _then) =
      __$TonightsPlanStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      bool isPlanStarted,
      bool isAudioPlaying,
      String childName});
}

/// @nodoc
class __$TonightsPlanStateCopyWithImpl<$Res>
    implements _$TonightsPlanStateCopyWith<$Res> {
  __$TonightsPlanStateCopyWithImpl(this._self, this._then);

  final _TonightsPlanState _self;
  final $Res Function(_TonightsPlanState) _then;

  /// Create a copy of TonightsPlanState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isLoading = null,
    Object? isPlanStarted = null,
    Object? isAudioPlaying = null,
    Object? childName = null,
  }) {
    return _then(_TonightsPlanState(
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isPlanStarted: null == isPlanStarted
          ? _self.isPlanStarted
          : isPlanStarted // ignore: cast_nullable_to_non_nullable
              as bool,
      isAudioPlaying: null == isAudioPlaying
          ? _self.isAudioPlaying
          : isAudioPlaying // ignore: cast_nullable_to_non_nullable
              as bool,
      childName: null == childName
          ? _self.childName
          : childName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
