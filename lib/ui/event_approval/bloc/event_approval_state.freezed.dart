// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_approval_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EventApprovalState {

 String get message;
/// Create a copy of EventApprovalState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventApprovalStateCopyWith<EventApprovalState> get copyWith => _$EventApprovalStateCopyWithImpl<EventApprovalState>(this as EventApprovalState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventApprovalState&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'EventApprovalState(message: $message)';
}


}

/// @nodoc
abstract mixin class $EventApprovalStateCopyWith<$Res>  {
  factory $EventApprovalStateCopyWith(EventApprovalState value, $Res Function(EventApprovalState) _then) = _$EventApprovalStateCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$EventApprovalStateCopyWithImpl<$Res>
    implements $EventApprovalStateCopyWith<$Res> {
  _$EventApprovalStateCopyWithImpl(this._self, this._then);

  final EventApprovalState _self;
  final $Res Function(EventApprovalState) _then;

/// Create a copy of EventApprovalState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [EventApprovalState].
extension EventApprovalStatePatterns on EventApprovalState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventApprovalState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventApprovalState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventApprovalState value)  $default,){
final _that = this;
switch (_that) {
case _EventApprovalState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventApprovalState value)?  $default,){
final _that = this;
switch (_that) {
case _EventApprovalState() when $default != null:
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
case _EventApprovalState() when $default != null:
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
case _EventApprovalState():
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
case _EventApprovalState() when $default != null:
return $default(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _EventApprovalState implements EventApprovalState {
  const _EventApprovalState({this.message = ""});
  

@override@JsonKey() final  String message;

/// Create a copy of EventApprovalState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventApprovalStateCopyWith<_EventApprovalState> get copyWith => __$EventApprovalStateCopyWithImpl<_EventApprovalState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventApprovalState&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'EventApprovalState(message: $message)';
}


}

/// @nodoc
abstract mixin class _$EventApprovalStateCopyWith<$Res> implements $EventApprovalStateCopyWith<$Res> {
  factory _$EventApprovalStateCopyWith(_EventApprovalState value, $Res Function(_EventApprovalState) _then) = __$EventApprovalStateCopyWithImpl;
@override @useResult
$Res call({
 String message
});




}
/// @nodoc
class __$EventApprovalStateCopyWithImpl<$Res>
    implements _$EventApprovalStateCopyWith<$Res> {
  __$EventApprovalStateCopyWithImpl(this._self, this._then);

  final _EventApprovalState _self;
  final $Res Function(_EventApprovalState) _then;

/// Create a copy of EventApprovalState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_EventApprovalState(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
