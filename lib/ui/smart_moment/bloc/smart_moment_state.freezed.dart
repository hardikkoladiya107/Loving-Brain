// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'smart_moment_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SmartMomentState {

 UserModel? get userModel; ChildModel? get childModel; ChildState? get stateAtTime; String get activityTitle; String get subtitle; String get message; List<String> get steps; ApiResultStatus get saveApiResultStatus;
/// Create a copy of SmartMomentState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SmartMomentStateCopyWith<SmartMomentState> get copyWith => _$SmartMomentStateCopyWithImpl<SmartMomentState>(this as SmartMomentState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SmartMomentState&&(identical(other.userModel, userModel) || other.userModel == userModel)&&(identical(other.childModel, childModel) || other.childModel == childModel)&&(identical(other.stateAtTime, stateAtTime) || other.stateAtTime == stateAtTime)&&(identical(other.activityTitle, activityTitle) || other.activityTitle == activityTitle)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.steps, steps)&&(identical(other.saveApiResultStatus, saveApiResultStatus) || other.saveApiResultStatus == saveApiResultStatus));
}


@override
int get hashCode => Object.hash(runtimeType,userModel,childModel,stateAtTime,activityTitle,subtitle,message,const DeepCollectionEquality().hash(steps),saveApiResultStatus);

@override
String toString() {
  return 'SmartMomentState(userModel: $userModel, childModel: $childModel, stateAtTime: $stateAtTime, activityTitle: $activityTitle, subtitle: $subtitle, message: $message, steps: $steps, saveApiResultStatus: $saveApiResultStatus)';
}


}

/// @nodoc
abstract mixin class $SmartMomentStateCopyWith<$Res>  {
  factory $SmartMomentStateCopyWith(SmartMomentState value, $Res Function(SmartMomentState) _then) = _$SmartMomentStateCopyWithImpl;
@useResult
$Res call({
 UserModel? userModel, ChildModel? childModel, ChildState? stateAtTime, String activityTitle, String subtitle, String message, List<String> steps, ApiResultStatus saveApiResultStatus
});


$ApiResultStatusCopyWith<dynamic, $Res> get saveApiResultStatus;

}
/// @nodoc
class _$SmartMomentStateCopyWithImpl<$Res>
    implements $SmartMomentStateCopyWith<$Res> {
  _$SmartMomentStateCopyWithImpl(this._self, this._then);

  final SmartMomentState _self;
  final $Res Function(SmartMomentState) _then;

/// Create a copy of SmartMomentState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userModel = freezed,Object? childModel = freezed,Object? stateAtTime = freezed,Object? activityTitle = null,Object? subtitle = null,Object? message = null,Object? steps = null,Object? saveApiResultStatus = null,}) {
  return _then(_self.copyWith(
userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,childModel: freezed == childModel ? _self.childModel : childModel // ignore: cast_nullable_to_non_nullable
as ChildModel?,stateAtTime: freezed == stateAtTime ? _self.stateAtTime : stateAtTime // ignore: cast_nullable_to_non_nullable
as ChildState?,activityTitle: null == activityTitle ? _self.activityTitle : activityTitle // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as List<String>,saveApiResultStatus: null == saveApiResultStatus ? _self.saveApiResultStatus : saveApiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,
  ));
}
/// Create a copy of SmartMomentState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get saveApiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.saveApiResultStatus, (value) {
    return _then(_self.copyWith(saveApiResultStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [SmartMomentState].
extension SmartMomentStatePatterns on SmartMomentState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SmartMomentState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SmartMomentState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SmartMomentState value)  $default,){
final _that = this;
switch (_that) {
case _SmartMomentState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SmartMomentState value)?  $default,){
final _that = this;
switch (_that) {
case _SmartMomentState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UserModel? userModel,  ChildModel? childModel,  ChildState? stateAtTime,  String activityTitle,  String subtitle,  String message,  List<String> steps,  ApiResultStatus saveApiResultStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SmartMomentState() when $default != null:
return $default(_that.userModel,_that.childModel,_that.stateAtTime,_that.activityTitle,_that.subtitle,_that.message,_that.steps,_that.saveApiResultStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UserModel? userModel,  ChildModel? childModel,  ChildState? stateAtTime,  String activityTitle,  String subtitle,  String message,  List<String> steps,  ApiResultStatus saveApiResultStatus)  $default,) {final _that = this;
switch (_that) {
case _SmartMomentState():
return $default(_that.userModel,_that.childModel,_that.stateAtTime,_that.activityTitle,_that.subtitle,_that.message,_that.steps,_that.saveApiResultStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UserModel? userModel,  ChildModel? childModel,  ChildState? stateAtTime,  String activityTitle,  String subtitle,  String message,  List<String> steps,  ApiResultStatus saveApiResultStatus)?  $default,) {final _that = this;
switch (_that) {
case _SmartMomentState() when $default != null:
return $default(_that.userModel,_that.childModel,_that.stateAtTime,_that.activityTitle,_that.subtitle,_that.message,_that.steps,_that.saveApiResultStatus);case _:
  return null;

}
}

}

/// @nodoc


class _SmartMomentState implements SmartMomentState {
  const _SmartMomentState({this.userModel, this.childModel, this.stateAtTime, this.activityTitle = '', this.subtitle = '', this.message = '', final  List<String> steps = const <String>[], this.saveApiResultStatus = const ApiResultStatus.initial()}): _steps = steps;
  

@override final  UserModel? userModel;
@override final  ChildModel? childModel;
@override final  ChildState? stateAtTime;
@override@JsonKey() final  String activityTitle;
@override@JsonKey() final  String subtitle;
@override@JsonKey() final  String message;
 final  List<String> _steps;
@override@JsonKey() List<String> get steps {
  if (_steps is EqualUnmodifiableListView) return _steps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_steps);
}

@override@JsonKey() final  ApiResultStatus saveApiResultStatus;

/// Create a copy of SmartMomentState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SmartMomentStateCopyWith<_SmartMomentState> get copyWith => __$SmartMomentStateCopyWithImpl<_SmartMomentState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SmartMomentState&&(identical(other.userModel, userModel) || other.userModel == userModel)&&(identical(other.childModel, childModel) || other.childModel == childModel)&&(identical(other.stateAtTime, stateAtTime) || other.stateAtTime == stateAtTime)&&(identical(other.activityTitle, activityTitle) || other.activityTitle == activityTitle)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._steps, _steps)&&(identical(other.saveApiResultStatus, saveApiResultStatus) || other.saveApiResultStatus == saveApiResultStatus));
}


@override
int get hashCode => Object.hash(runtimeType,userModel,childModel,stateAtTime,activityTitle,subtitle,message,const DeepCollectionEquality().hash(_steps),saveApiResultStatus);

@override
String toString() {
  return 'SmartMomentState(userModel: $userModel, childModel: $childModel, stateAtTime: $stateAtTime, activityTitle: $activityTitle, subtitle: $subtitle, message: $message, steps: $steps, saveApiResultStatus: $saveApiResultStatus)';
}


}

/// @nodoc
abstract mixin class _$SmartMomentStateCopyWith<$Res> implements $SmartMomentStateCopyWith<$Res> {
  factory _$SmartMomentStateCopyWith(_SmartMomentState value, $Res Function(_SmartMomentState) _then) = __$SmartMomentStateCopyWithImpl;
@override @useResult
$Res call({
 UserModel? userModel, ChildModel? childModel, ChildState? stateAtTime, String activityTitle, String subtitle, String message, List<String> steps, ApiResultStatus saveApiResultStatus
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get saveApiResultStatus;

}
/// @nodoc
class __$SmartMomentStateCopyWithImpl<$Res>
    implements _$SmartMomentStateCopyWith<$Res> {
  __$SmartMomentStateCopyWithImpl(this._self, this._then);

  final _SmartMomentState _self;
  final $Res Function(_SmartMomentState) _then;

/// Create a copy of SmartMomentState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userModel = freezed,Object? childModel = freezed,Object? stateAtTime = freezed,Object? activityTitle = null,Object? subtitle = null,Object? message = null,Object? steps = null,Object? saveApiResultStatus = null,}) {
  return _then(_SmartMomentState(
userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,childModel: freezed == childModel ? _self.childModel : childModel // ignore: cast_nullable_to_non_nullable
as ChildModel?,stateAtTime: freezed == stateAtTime ? _self.stateAtTime : stateAtTime // ignore: cast_nullable_to_non_nullable
as ChildState?,activityTitle: null == activityTitle ? _self.activityTitle : activityTitle // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,steps: null == steps ? _self._steps : steps // ignore: cast_nullable_to_non_nullable
as List<String>,saveApiResultStatus: null == saveApiResultStatus ? _self.saveApiResultStatus : saveApiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,
  ));
}

/// Create a copy of SmartMomentState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get saveApiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.saveApiResultStatus, (value) {
    return _then(_self.copyWith(saveApiResultStatus: value));
  });
}
}

// dart format on
