// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'enrolled_journey_home_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EnrolledJourneyHomeState {

 bool get isLoading; EnrolledProgramModel? get program; bool get isEnrolled; ApiResultStatus<dynamic> get fetchStatus;
/// Create a copy of EnrolledJourneyHomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EnrolledJourneyHomeStateCopyWith<EnrolledJourneyHomeState> get copyWith => _$EnrolledJourneyHomeStateCopyWithImpl<EnrolledJourneyHomeState>(this as EnrolledJourneyHomeState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as EnrolledJourneyHomeState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EnrolledJourneyHomeState&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.program, _this.program) || other.program == _this.program)&&(identical(other.isEnrolled, _this.isEnrolled) || other.isEnrolled == _this.isEnrolled)&&(identical(other.fetchStatus, _this.fetchStatus) || other.fetchStatus == _this.fetchStatus));
}


@override
int get hashCode {
  final _this = this as EnrolledJourneyHomeState;
  return Object.hash(runtimeType,_this.isLoading,_this.program,_this.isEnrolled,_this.fetchStatus);
}

@override
String toString() {
  final _this = this as EnrolledJourneyHomeState;
  return 'EnrolledJourneyHomeState(isLoading: ${_this.isLoading}, program: ${_this.program}, isEnrolled: ${_this.isEnrolled}, fetchStatus: ${_this.fetchStatus})';
}


}

/// @nodoc
abstract mixin class $EnrolledJourneyHomeStateCopyWith<$Res>  {
  factory $EnrolledJourneyHomeStateCopyWith(EnrolledJourneyHomeState value, $Res Function(EnrolledJourneyHomeState) _then) = _$EnrolledJourneyHomeStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, EnrolledProgramModel? program, bool isEnrolled, ApiResultStatus<dynamic> fetchStatus
});


$ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus;

}
/// @nodoc
class _$EnrolledJourneyHomeStateCopyWithImpl<$Res>
    implements $EnrolledJourneyHomeStateCopyWith<$Res> {
  _$EnrolledJourneyHomeStateCopyWithImpl(this._self, this._then);

  final EnrolledJourneyHomeState _self;
  final $Res Function(EnrolledJourneyHomeState) _then;

/// Create a copy of EnrolledJourneyHomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? program = freezed,Object? isEnrolled = null,Object? fetchStatus = null,}) {
  return _then(EnrolledJourneyHomeState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,program: freezed == program ? _self.program : program // ignore: cast_nullable_to_non_nullable
as EnrolledProgramModel?,isEnrolled: null == isEnrolled ? _self.isEnrolled : isEnrolled // ignore: cast_nullable_to_non_nullable
as bool,fetchStatus: null == fetchStatus ? _self.fetchStatus : fetchStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}
/// Create a copy of EnrolledJourneyHomeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.fetchStatus, (value) {
    return _then(_self.copyWith(fetchStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [EnrolledJourneyHomeState].
extension EnrolledJourneyHomeStatePatterns on EnrolledJourneyHomeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EnrolledJourneyHomeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EnrolledJourneyHomeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EnrolledJourneyHomeState value)  $default,){
final _that = this;
switch (_that) {
case _EnrolledJourneyHomeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EnrolledJourneyHomeState value)?  $default,){
final _that = this;
switch (_that) {
case _EnrolledJourneyHomeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  EnrolledProgramModel? program,  bool isEnrolled,  ApiResultStatus<dynamic> fetchStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EnrolledJourneyHomeState() when $default != null:
return $default(_that.isLoading,_that.program,_that.isEnrolled,_that.fetchStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  EnrolledProgramModel? program,  bool isEnrolled,  ApiResultStatus<dynamic> fetchStatus)  $default,) {final _that = this;
switch (_that) {
case _EnrolledJourneyHomeState():
return $default(_that.isLoading,_that.program,_that.isEnrolled,_that.fetchStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  EnrolledProgramModel? program,  bool isEnrolled,  ApiResultStatus<dynamic> fetchStatus)?  $default,) {final _that = this;
switch (_that) {
case _EnrolledJourneyHomeState() when $default != null:
return $default(_that.isLoading,_that.program,_that.isEnrolled,_that.fetchStatus);case _:
  return null;

}
}

}

/// @nodoc


class _EnrolledJourneyHomeState implements EnrolledJourneyHomeState {
  const _EnrolledJourneyHomeState({this.isLoading = false, this.program, this.isEnrolled = false, this.fetchStatus = const ApiResultStatus.initial()});
  

@override@JsonKey() final  bool isLoading;
@override final  EnrolledProgramModel? program;
@override@JsonKey() final  bool isEnrolled;
@override@JsonKey() final  ApiResultStatus<dynamic> fetchStatus;

/// Create a copy of EnrolledJourneyHomeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EnrolledJourneyHomeStateCopyWith<_EnrolledJourneyHomeState> get copyWith => __$EnrolledJourneyHomeStateCopyWithImpl<_EnrolledJourneyHomeState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EnrolledJourneyHomeState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.program, program) || other.program == program)&&(identical(other.isEnrolled, isEnrolled) || other.isEnrolled == isEnrolled)&&(identical(other.fetchStatus, fetchStatus) || other.fetchStatus == fetchStatus));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isLoading,program,isEnrolled,fetchStatus);
}

@override
String toString() {
    return 'EnrolledJourneyHomeState(isLoading: $isLoading, program: $program, isEnrolled: $isEnrolled, fetchStatus: $fetchStatus)';
}


}

/// @nodoc
abstract mixin class _$EnrolledJourneyHomeStateCopyWith<$Res> implements $EnrolledJourneyHomeStateCopyWith<$Res> {
  factory _$EnrolledJourneyHomeStateCopyWith(_EnrolledJourneyHomeState value, $Res Function(_EnrolledJourneyHomeState) _then) = __$EnrolledJourneyHomeStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, EnrolledProgramModel? program, bool isEnrolled, ApiResultStatus<dynamic> fetchStatus
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus;

}
/// @nodoc
class __$EnrolledJourneyHomeStateCopyWithImpl<$Res>
    implements _$EnrolledJourneyHomeStateCopyWith<$Res> {
  __$EnrolledJourneyHomeStateCopyWithImpl(this._self, this._then);

  final _EnrolledJourneyHomeState _self;
  final $Res Function(_EnrolledJourneyHomeState) _then;

/// Create a copy of EnrolledJourneyHomeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? program = freezed,Object? isEnrolled = null,Object? fetchStatus = null,}) {
  return _then(_EnrolledJourneyHomeState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,program: freezed == program ? _self.program : program // ignore: cast_nullable_to_non_nullable
as EnrolledProgramModel?,isEnrolled: null == isEnrolled ? _self.isEnrolled : isEnrolled // ignore: cast_nullable_to_non_nullable
as bool,fetchStatus: null == fetchStatus ? _self.fetchStatus : fetchStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}

/// Create a copy of EnrolledJourneyHomeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.fetchStatus, (value) {
    return _then(_self.copyWith(fetchStatus: value));
  });
}
}

// dart format on
