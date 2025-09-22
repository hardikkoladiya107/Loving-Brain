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

 String get childMood; String get parentMood; UserModel? get userModel; ApiResultStatus get apiResultStatus;
/// Create a copy of DailyMoodCheckInState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyMoodCheckInStateCopyWith<DailyMoodCheckInState> get copyWith => _$DailyMoodCheckInStateCopyWithImpl<DailyMoodCheckInState>(this as DailyMoodCheckInState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyMoodCheckInState&&(identical(other.childMood, childMood) || other.childMood == childMood)&&(identical(other.parentMood, parentMood) || other.parentMood == parentMood)&&(identical(other.userModel, userModel) || other.userModel == userModel)&&(identical(other.apiResultStatus, apiResultStatus) || other.apiResultStatus == apiResultStatus));
}


@override
int get hashCode => Object.hash(runtimeType,childMood,parentMood,userModel,apiResultStatus);

@override
String toString() {
  return 'DailyMoodCheckInState(childMood: $childMood, parentMood: $parentMood, userModel: $userModel, apiResultStatus: $apiResultStatus)';
}


}

/// @nodoc
abstract mixin class $DailyMoodCheckInStateCopyWith<$Res>  {
  factory $DailyMoodCheckInStateCopyWith(DailyMoodCheckInState value, $Res Function(DailyMoodCheckInState) _then) = _$DailyMoodCheckInStateCopyWithImpl;
@useResult
$Res call({
 String childMood, String parentMood, UserModel? userModel, ApiResultStatus apiResultStatus
});


$ApiResultStatusCopyWith<dynamic, $Res> get apiResultStatus;

}
/// @nodoc
class _$DailyMoodCheckInStateCopyWithImpl<$Res>
    implements $DailyMoodCheckInStateCopyWith<$Res> {
  _$DailyMoodCheckInStateCopyWithImpl(this._self, this._then);

  final DailyMoodCheckInState _self;
  final $Res Function(DailyMoodCheckInState) _then;

/// Create a copy of DailyMoodCheckInState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? childMood = null,Object? parentMood = null,Object? userModel = freezed,Object? apiResultStatus = null,}) {
  return _then(_self.copyWith(
childMood: null == childMood ? _self.childMood : childMood // ignore: cast_nullable_to_non_nullable
as String,parentMood: null == parentMood ? _self.parentMood : parentMood // ignore: cast_nullable_to_non_nullable
as String,userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,apiResultStatus: null == apiResultStatus ? _self.apiResultStatus : apiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,
  ));
}
/// Create a copy of DailyMoodCheckInState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get apiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.apiResultStatus, (value) {
    return _then(_self.copyWith(apiResultStatus: value));
  });
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String childMood,  String parentMood,  UserModel? userModel,  ApiResultStatus apiResultStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyMoodCheckInState() when $default != null:
return $default(_that.childMood,_that.parentMood,_that.userModel,_that.apiResultStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String childMood,  String parentMood,  UserModel? userModel,  ApiResultStatus apiResultStatus)  $default,) {final _that = this;
switch (_that) {
case _DailyMoodCheckInState():
return $default(_that.childMood,_that.parentMood,_that.userModel,_that.apiResultStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String childMood,  String parentMood,  UserModel? userModel,  ApiResultStatus apiResultStatus)?  $default,) {final _that = this;
switch (_that) {
case _DailyMoodCheckInState() when $default != null:
return $default(_that.childMood,_that.parentMood,_that.userModel,_that.apiResultStatus);case _:
  return null;

}
}

}

/// @nodoc


class _DailyMoodCheckInState implements DailyMoodCheckInState {
  const _DailyMoodCheckInState({this.childMood = "", this.parentMood = "", this.userModel, this.apiResultStatus = const ApiResultStatus.initial()});
  

@override@JsonKey() final  String childMood;
@override@JsonKey() final  String parentMood;
@override final  UserModel? userModel;
@override@JsonKey() final  ApiResultStatus apiResultStatus;

/// Create a copy of DailyMoodCheckInState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyMoodCheckInStateCopyWith<_DailyMoodCheckInState> get copyWith => __$DailyMoodCheckInStateCopyWithImpl<_DailyMoodCheckInState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyMoodCheckInState&&(identical(other.childMood, childMood) || other.childMood == childMood)&&(identical(other.parentMood, parentMood) || other.parentMood == parentMood)&&(identical(other.userModel, userModel) || other.userModel == userModel)&&(identical(other.apiResultStatus, apiResultStatus) || other.apiResultStatus == apiResultStatus));
}


@override
int get hashCode => Object.hash(runtimeType,childMood,parentMood,userModel,apiResultStatus);

@override
String toString() {
  return 'DailyMoodCheckInState(childMood: $childMood, parentMood: $parentMood, userModel: $userModel, apiResultStatus: $apiResultStatus)';
}


}

/// @nodoc
abstract mixin class _$DailyMoodCheckInStateCopyWith<$Res> implements $DailyMoodCheckInStateCopyWith<$Res> {
  factory _$DailyMoodCheckInStateCopyWith(_DailyMoodCheckInState value, $Res Function(_DailyMoodCheckInState) _then) = __$DailyMoodCheckInStateCopyWithImpl;
@override @useResult
$Res call({
 String childMood, String parentMood, UserModel? userModel, ApiResultStatus apiResultStatus
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get apiResultStatus;

}
/// @nodoc
class __$DailyMoodCheckInStateCopyWithImpl<$Res>
    implements _$DailyMoodCheckInStateCopyWith<$Res> {
  __$DailyMoodCheckInStateCopyWithImpl(this._self, this._then);

  final _DailyMoodCheckInState _self;
  final $Res Function(_DailyMoodCheckInState) _then;

/// Create a copy of DailyMoodCheckInState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? childMood = null,Object? parentMood = null,Object? userModel = freezed,Object? apiResultStatus = null,}) {
  return _then(_DailyMoodCheckInState(
childMood: null == childMood ? _self.childMood : childMood // ignore: cast_nullable_to_non_nullable
as String,parentMood: null == parentMood ? _self.parentMood : parentMood // ignore: cast_nullable_to_non_nullable
as String,userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,apiResultStatus: null == apiResultStatus ? _self.apiResultStatus : apiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,
  ));
}

/// Create a copy of DailyMoodCheckInState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get apiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.apiResultStatus, (value) {
    return _then(_self.copyWith(apiResultStatus: value));
  });
}
}

// dart format on
