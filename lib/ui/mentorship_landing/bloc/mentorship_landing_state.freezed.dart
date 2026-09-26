// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mentorship_landing_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MentorshipLandingState {

 bool get isAvailable;
/// Create a copy of MentorshipLandingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MentorshipLandingStateCopyWith<MentorshipLandingState> get copyWith => _$MentorshipLandingStateCopyWithImpl<MentorshipLandingState>(this as MentorshipLandingState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MentorshipLandingState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MentorshipLandingState&&(identical(other.isAvailable, _this.isAvailable) || other.isAvailable == _this.isAvailable));
}


@override
int get hashCode {
  final _this = this as MentorshipLandingState;
  return Object.hash(runtimeType,_this.isAvailable);
}

@override
String toString() {
  final _this = this as MentorshipLandingState;
  return 'MentorshipLandingState(isAvailable: ${_this.isAvailable})';
}


}

/// @nodoc
abstract mixin class $MentorshipLandingStateCopyWith<$Res>  {
  factory $MentorshipLandingStateCopyWith(MentorshipLandingState value, $Res Function(MentorshipLandingState) _then) = _$MentorshipLandingStateCopyWithImpl;
@useResult
$Res call({
 bool isAvailable
});




}
/// @nodoc
class _$MentorshipLandingStateCopyWithImpl<$Res>
    implements $MentorshipLandingStateCopyWith<$Res> {
  _$MentorshipLandingStateCopyWithImpl(this._self, this._then);

  final MentorshipLandingState _self;
  final $Res Function(MentorshipLandingState) _then;

/// Create a copy of MentorshipLandingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isAvailable = null,}) {
  return _then(MentorshipLandingState(
isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MentorshipLandingState].
extension MentorshipLandingStatePatterns on MentorshipLandingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MentorshipLandingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MentorshipLandingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MentorshipLandingState value)  $default,){
final _that = this;
switch (_that) {
case _MentorshipLandingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MentorshipLandingState value)?  $default,){
final _that = this;
switch (_that) {
case _MentorshipLandingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isAvailable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MentorshipLandingState() when $default != null:
return $default(_that.isAvailable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isAvailable)  $default,) {final _that = this;
switch (_that) {
case _MentorshipLandingState():
return $default(_that.isAvailable);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isAvailable)?  $default,) {final _that = this;
switch (_that) {
case _MentorshipLandingState() when $default != null:
return $default(_that.isAvailable);case _:
  return null;

}
}

}

/// @nodoc


class _MentorshipLandingState implements MentorshipLandingState {
  const _MentorshipLandingState({this.isAvailable = true});
  

@override@JsonKey() final  bool isAvailable;

/// Create a copy of MentorshipLandingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MentorshipLandingStateCopyWith<_MentorshipLandingState> get copyWith => __$MentorshipLandingStateCopyWithImpl<_MentorshipLandingState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MentorshipLandingState&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isAvailable);
}

@override
String toString() {
    return 'MentorshipLandingState(isAvailable: $isAvailable)';
}


}

/// @nodoc
abstract mixin class _$MentorshipLandingStateCopyWith<$Res> implements $MentorshipLandingStateCopyWith<$Res> {
  factory _$MentorshipLandingStateCopyWith(_MentorshipLandingState value, $Res Function(_MentorshipLandingState) _then) = __$MentorshipLandingStateCopyWithImpl;
@override @useResult
$Res call({
 bool isAvailable
});




}
/// @nodoc
class __$MentorshipLandingStateCopyWithImpl<$Res>
    implements _$MentorshipLandingStateCopyWith<$Res> {
  __$MentorshipLandingStateCopyWithImpl(this._self, this._then);

  final _MentorshipLandingState _self;
  final $Res Function(_MentorshipLandingState) _then;

/// Create a copy of MentorshipLandingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isAvailable = null,}) {
  return _then(_MentorshipLandingState(
isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
