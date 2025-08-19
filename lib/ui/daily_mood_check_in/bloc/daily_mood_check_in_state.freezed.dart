// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_mood_check_in_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DailyMoodCheckInState {

 String get message;
/// Create a copy of DailyMoodCheckInState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyMoodCheckInStateCopyWith<DailyMoodCheckInState> get copyWith => _$DailyMoodCheckInStateCopyWithImpl<DailyMoodCheckInState>(this as DailyMoodCheckInState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyMoodCheckInState&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'DailyMoodCheckInState(message: $message)';
}


}

/// @nodoc
abstract mixin class $DailyMoodCheckInStateCopyWith<$Res>  {
  factory $DailyMoodCheckInStateCopyWith(DailyMoodCheckInState value, $Res Function(DailyMoodCheckInState) _then) = _$DailyMoodCheckInStateCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$DailyMoodCheckInStateCopyWithImpl<$Res>
    implements $DailyMoodCheckInStateCopyWith<$Res> {
  _$DailyMoodCheckInStateCopyWithImpl(this._self, this._then);

  final DailyMoodCheckInState _self;
  final $Res Function(DailyMoodCheckInState) _then;

/// Create a copy of DailyMoodCheckInState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyMoodCheckInState].
extension DailyMoodCheckInStatePatterns on DailyMoodCheckInState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyMoodCheckInState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyMoodCheckInState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyMoodCheckInState value)  $default,){
final _that = this;
switch (_that) {
case _DailyMoodCheckInState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyMoodCheckInState value)?  $default,){
final _that = this;
switch (_that) {
case _DailyMoodCheckInState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyMoodCheckInState() when $default != null:
return $default(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String message)  $default,) {final _that = this;
switch (_that) {
case _DailyMoodCheckInState():
return $default(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String message)?  $default,) {final _that = this;
switch (_that) {
case _DailyMoodCheckInState() when $default != null:
return $default(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _DailyMoodCheckInState implements DailyMoodCheckInState {
  const _DailyMoodCheckInState({this.message = ""});
  

@override@JsonKey() final  String message;

/// Create a copy of DailyMoodCheckInState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyMoodCheckInStateCopyWith<_DailyMoodCheckInState> get copyWith => __$DailyMoodCheckInStateCopyWithImpl<_DailyMoodCheckInState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyMoodCheckInState&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'DailyMoodCheckInState(message: $message)';
}


}

/// @nodoc
abstract mixin class _$DailyMoodCheckInStateCopyWith<$Res> implements $DailyMoodCheckInStateCopyWith<$Res> {
  factory _$DailyMoodCheckInStateCopyWith(_DailyMoodCheckInState value, $Res Function(_DailyMoodCheckInState) _then) = __$DailyMoodCheckInStateCopyWithImpl;
@override @useResult
$Res call({
 String message
});




}
/// @nodoc
class __$DailyMoodCheckInStateCopyWithImpl<$Res>
    implements _$DailyMoodCheckInStateCopyWith<$Res> {
  __$DailyMoodCheckInStateCopyWithImpl(this._self, this._then);

  final _DailyMoodCheckInState _self;
  final $Res Function(_DailyMoodCheckInState) _then;

/// Create a copy of DailyMoodCheckInState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_DailyMoodCheckInState(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
