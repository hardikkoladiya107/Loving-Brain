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

 bool get isLoading; bool get isPlanStarted; bool get isAudioPlaying;
/// Create a copy of TonightsPlanState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TonightsPlanStateCopyWith<TonightsPlanState> get copyWith => _$TonightsPlanStateCopyWithImpl<TonightsPlanState>(this as TonightsPlanState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TonightsPlanState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TonightsPlanState&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.isPlanStarted, _this.isPlanStarted) || other.isPlanStarted == _this.isPlanStarted)&&(identical(other.isAudioPlaying, _this.isAudioPlaying) || other.isAudioPlaying == _this.isAudioPlaying));
}


@override
int get hashCode {
  final _this = this as TonightsPlanState;
  return Object.hash(runtimeType,_this.isLoading,_this.isPlanStarted,_this.isAudioPlaying);
}

@override
String toString() {
  final _this = this as TonightsPlanState;
  return 'TonightsPlanState(isLoading: ${_this.isLoading}, isPlanStarted: ${_this.isPlanStarted}, isAudioPlaying: ${_this.isAudioPlaying})';
}


}

/// @nodoc
abstract mixin class $TonightsPlanStateCopyWith<$Res>  {
  factory $TonightsPlanStateCopyWith(TonightsPlanState value, $Res Function(TonightsPlanState) _then) = _$TonightsPlanStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool isPlanStarted, bool isAudioPlaying
});




}
/// @nodoc
class _$TonightsPlanStateCopyWithImpl<$Res>
    implements $TonightsPlanStateCopyWith<$Res> {
  _$TonightsPlanStateCopyWithImpl(this._self, this._then);

  final TonightsPlanState _self;
  final $Res Function(TonightsPlanState) _then;

/// Create a copy of TonightsPlanState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? isPlanStarted = null,Object? isAudioPlaying = null,}) {
  return _then(TonightsPlanState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isPlanStarted: null == isPlanStarted ? _self.isPlanStarted : isPlanStarted // ignore: cast_nullable_to_non_nullable
as bool,isAudioPlaying: null == isAudioPlaying ? _self.isAudioPlaying : isAudioPlaying // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TonightsPlanState].
extension TonightsPlanStatePatterns on TonightsPlanState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TonightsPlanState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TonightsPlanState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TonightsPlanState value)  $default,){
final _that = this;
switch (_that) {
case _TonightsPlanState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TonightsPlanState value)?  $default,){
final _that = this;
switch (_that) {
case _TonightsPlanState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool isPlanStarted,  bool isAudioPlaying)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TonightsPlanState() when $default != null:
return $default(_that.isLoading,_that.isPlanStarted,_that.isAudioPlaying);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool isPlanStarted,  bool isAudioPlaying)  $default,) {final _that = this;
switch (_that) {
case _TonightsPlanState():
return $default(_that.isLoading,_that.isPlanStarted,_that.isAudioPlaying);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool isPlanStarted,  bool isAudioPlaying)?  $default,) {final _that = this;
switch (_that) {
case _TonightsPlanState() when $default != null:
return $default(_that.isLoading,_that.isPlanStarted,_that.isAudioPlaying);case _:
  return null;

}
}

}

/// @nodoc


class _TonightsPlanState implements TonightsPlanState {
  const _TonightsPlanState({this.isLoading = false, this.isPlanStarted = false, this.isAudioPlaying = false});
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isPlanStarted;
@override@JsonKey() final  bool isAudioPlaying;

/// Create a copy of TonightsPlanState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TonightsPlanStateCopyWith<_TonightsPlanState> get copyWith => __$TonightsPlanStateCopyWithImpl<_TonightsPlanState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TonightsPlanState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isPlanStarted, isPlanStarted) || other.isPlanStarted == isPlanStarted)&&(identical(other.isAudioPlaying, isAudioPlaying) || other.isAudioPlaying == isAudioPlaying));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isLoading,isPlanStarted,isAudioPlaying);
}

@override
String toString() {
    return 'TonightsPlanState(isLoading: $isLoading, isPlanStarted: $isPlanStarted, isAudioPlaying: $isAudioPlaying)';
}


}

/// @nodoc
abstract mixin class _$TonightsPlanStateCopyWith<$Res> implements $TonightsPlanStateCopyWith<$Res> {
  factory _$TonightsPlanStateCopyWith(_TonightsPlanState value, $Res Function(_TonightsPlanState) _then) = __$TonightsPlanStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool isPlanStarted, bool isAudioPlaying
});




}
/// @nodoc
class __$TonightsPlanStateCopyWithImpl<$Res>
    implements _$TonightsPlanStateCopyWith<$Res> {
  __$TonightsPlanStateCopyWithImpl(this._self, this._then);

  final _TonightsPlanState _self;
  final $Res Function(_TonightsPlanState) _then;

/// Create a copy of TonightsPlanState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? isPlanStarted = null,Object? isAudioPlaying = null,}) {
  return _then(_TonightsPlanState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isPlanStarted: null == isPlanStarted ? _self.isPlanStarted : isPlanStarted // ignore: cast_nullable_to_non_nullable
as bool,isAudioPlaying: null == isAudioPlaying ? _self.isAudioPlaying : isAudioPlaying // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
