// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'play_and_connect_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlayAndConnectState {

 String get message;
/// Create a copy of PlayAndConnectState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayAndConnectStateCopyWith<PlayAndConnectState> get copyWith => _$PlayAndConnectStateCopyWithImpl<PlayAndConnectState>(this as PlayAndConnectState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayAndConnectState&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'PlayAndConnectState(message: $message)';
}


}

/// @nodoc
abstract mixin class $PlayAndConnectStateCopyWith<$Res>  {
  factory $PlayAndConnectStateCopyWith(PlayAndConnectState value, $Res Function(PlayAndConnectState) _then) = _$PlayAndConnectStateCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$PlayAndConnectStateCopyWithImpl<$Res>
    implements $PlayAndConnectStateCopyWith<$Res> {
  _$PlayAndConnectStateCopyWithImpl(this._self, this._then);

  final PlayAndConnectState _self;
  final $Res Function(PlayAndConnectState) _then;

/// Create a copy of PlayAndConnectState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PlayAndConnectState].
extension PlayAndConnectStatePatterns on PlayAndConnectState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlayAndConnectState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlayAndConnectState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlayAndConnectState value)  $default,){
final _that = this;
switch (_that) {
case _PlayAndConnectState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlayAndConnectState value)?  $default,){
final _that = this;
switch (_that) {
case _PlayAndConnectState() when $default != null:
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
case _PlayAndConnectState() when $default != null:
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
case _PlayAndConnectState():
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
case _PlayAndConnectState() when $default != null:
return $default(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _PlayAndConnectState implements PlayAndConnectState {
  const _PlayAndConnectState({this.message = "message"});
  

@override@JsonKey() final  String message;

/// Create a copy of PlayAndConnectState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayAndConnectStateCopyWith<_PlayAndConnectState> get copyWith => __$PlayAndConnectStateCopyWithImpl<_PlayAndConnectState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayAndConnectState&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'PlayAndConnectState(message: $message)';
}


}

/// @nodoc
abstract mixin class _$PlayAndConnectStateCopyWith<$Res> implements $PlayAndConnectStateCopyWith<$Res> {
  factory _$PlayAndConnectStateCopyWith(_PlayAndConnectState value, $Res Function(_PlayAndConnectState) _then) = __$PlayAndConnectStateCopyWithImpl;
@override @useResult
$Res call({
 String message
});




}
/// @nodoc
class __$PlayAndConnectStateCopyWithImpl<$Res>
    implements _$PlayAndConnectStateCopyWith<$Res> {
  __$PlayAndConnectStateCopyWithImpl(this._self, this._then);

  final _PlayAndConnectState _self;
  final $Res Function(_PlayAndConnectState) _then;

/// Create a copy of PlayAndConnectState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_PlayAndConnectState(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
