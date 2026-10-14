// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mentorship_unavailable_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MentorshipUnavailableState {

 bool get isWaitlistJoined; bool get isLoading; ApiResultStatus<dynamic> get waitlistStatus;
/// Create a copy of MentorshipUnavailableState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MentorshipUnavailableStateCopyWith<MentorshipUnavailableState> get copyWith => _$MentorshipUnavailableStateCopyWithImpl<MentorshipUnavailableState>(this as MentorshipUnavailableState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MentorshipUnavailableState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MentorshipUnavailableState&&(identical(other.isWaitlistJoined, _this.isWaitlistJoined) || other.isWaitlistJoined == _this.isWaitlistJoined)&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.waitlistStatus, _this.waitlistStatus) || other.waitlistStatus == _this.waitlistStatus));
}


@override
int get hashCode {
  final _this = this as MentorshipUnavailableState;
  return Object.hash(runtimeType,_this.isWaitlistJoined,_this.isLoading,_this.waitlistStatus);
}

@override
String toString() {
  final _this = this as MentorshipUnavailableState;
  return 'MentorshipUnavailableState(isWaitlistJoined: ${_this.isWaitlistJoined}, isLoading: ${_this.isLoading}, waitlistStatus: ${_this.waitlistStatus})';
}


}

/// @nodoc
abstract mixin class $MentorshipUnavailableStateCopyWith<$Res>  {
  factory $MentorshipUnavailableStateCopyWith(MentorshipUnavailableState value, $Res Function(MentorshipUnavailableState) _then) = _$MentorshipUnavailableStateCopyWithImpl;
@useResult
$Res call({
 bool isWaitlistJoined, bool isLoading, ApiResultStatus<dynamic> waitlistStatus
});


$ApiResultStatusCopyWith<dynamic, $Res> get waitlistStatus;

}
/// @nodoc
class _$MentorshipUnavailableStateCopyWithImpl<$Res>
    implements $MentorshipUnavailableStateCopyWith<$Res> {
  _$MentorshipUnavailableStateCopyWithImpl(this._self, this._then);

  final MentorshipUnavailableState _self;
  final $Res Function(MentorshipUnavailableState) _then;

/// Create a copy of MentorshipUnavailableState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isWaitlistJoined = null,Object? isLoading = null,Object? waitlistStatus = null,}) {
  return _then(MentorshipUnavailableState(
isWaitlistJoined: null == isWaitlistJoined ? _self.isWaitlistJoined : isWaitlistJoined // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,waitlistStatus: null == waitlistStatus ? _self.waitlistStatus : waitlistStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}
/// Create a copy of MentorshipUnavailableState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get waitlistStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.waitlistStatus, (value) {
    return _then(_self.copyWith(waitlistStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [MentorshipUnavailableState].
extension MentorshipUnavailableStatePatterns on MentorshipUnavailableState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MentorshipUnavailableState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MentorshipUnavailableState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MentorshipUnavailableState value)  $default,){
final _that = this;
switch (_that) {
case _MentorshipUnavailableState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MentorshipUnavailableState value)?  $default,){
final _that = this;
switch (_that) {
case _MentorshipUnavailableState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isWaitlistJoined,  bool isLoading,  ApiResultStatus<dynamic> waitlistStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MentorshipUnavailableState() when $default != null:
return $default(_that.isWaitlistJoined,_that.isLoading,_that.waitlistStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isWaitlistJoined,  bool isLoading,  ApiResultStatus<dynamic> waitlistStatus)  $default,) {final _that = this;
switch (_that) {
case _MentorshipUnavailableState():
return $default(_that.isWaitlistJoined,_that.isLoading,_that.waitlistStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isWaitlistJoined,  bool isLoading,  ApiResultStatus<dynamic> waitlistStatus)?  $default,) {final _that = this;
switch (_that) {
case _MentorshipUnavailableState() when $default != null:
return $default(_that.isWaitlistJoined,_that.isLoading,_that.waitlistStatus);case _:
  return null;

}
}

}

/// @nodoc


class _MentorshipUnavailableState implements MentorshipUnavailableState {
  const _MentorshipUnavailableState({this.isWaitlistJoined = false, this.isLoading = false, this.waitlistStatus = const ApiResultStatus.initial()});
  

@override@JsonKey() final  bool isWaitlistJoined;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  ApiResultStatus<dynamic> waitlistStatus;

/// Create a copy of MentorshipUnavailableState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MentorshipUnavailableStateCopyWith<_MentorshipUnavailableState> get copyWith => __$MentorshipUnavailableStateCopyWithImpl<_MentorshipUnavailableState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MentorshipUnavailableState&&(identical(other.isWaitlistJoined, isWaitlistJoined) || other.isWaitlistJoined == isWaitlistJoined)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.waitlistStatus, waitlistStatus) || other.waitlistStatus == waitlistStatus));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isWaitlistJoined,isLoading,waitlistStatus);
}

@override
String toString() {
    return 'MentorshipUnavailableState(isWaitlistJoined: $isWaitlistJoined, isLoading: $isLoading, waitlistStatus: $waitlistStatus)';
}


}

/// @nodoc
abstract mixin class _$MentorshipUnavailableStateCopyWith<$Res> implements $MentorshipUnavailableStateCopyWith<$Res> {
  factory _$MentorshipUnavailableStateCopyWith(_MentorshipUnavailableState value, $Res Function(_MentorshipUnavailableState) _then) = __$MentorshipUnavailableStateCopyWithImpl;
@override @useResult
$Res call({
 bool isWaitlistJoined, bool isLoading, ApiResultStatus<dynamic> waitlistStatus
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get waitlistStatus;

}
/// @nodoc
class __$MentorshipUnavailableStateCopyWithImpl<$Res>
    implements _$MentorshipUnavailableStateCopyWith<$Res> {
  __$MentorshipUnavailableStateCopyWithImpl(this._self, this._then);

  final _MentorshipUnavailableState _self;
  final $Res Function(_MentorshipUnavailableState) _then;

/// Create a copy of MentorshipUnavailableState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isWaitlistJoined = null,Object? isLoading = null,Object? waitlistStatus = null,}) {
  return _then(_MentorshipUnavailableState(
isWaitlistJoined: null == isWaitlistJoined ? _self.isWaitlistJoined : isWaitlistJoined // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,waitlistStatus: null == waitlistStatus ? _self.waitlistStatus : waitlistStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}

/// Create a copy of MentorshipUnavailableState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get waitlistStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.waitlistStatus, (value) {
    return _then(_self.copyWith(waitlistStatus: value));
  });
}
}

// dart format on
