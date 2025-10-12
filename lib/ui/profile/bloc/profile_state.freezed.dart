// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfileState {

 bool get getReminderNotification; bool get dailyEmotionCheck; bool get todaysPlayIdea; bool get scheduleReminder; ApiResultStatus get logoutApiResultStatus; ApiResultStatus get deleteAccountApiResultStatus; UserModel? get userModel;
/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileStateCopyWith<ProfileState> get copyWith => _$ProfileStateCopyWithImpl<ProfileState>(this as ProfileState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileState&&(identical(other.getReminderNotification, getReminderNotification) || other.getReminderNotification == getReminderNotification)&&(identical(other.dailyEmotionCheck, dailyEmotionCheck) || other.dailyEmotionCheck == dailyEmotionCheck)&&(identical(other.todaysPlayIdea, todaysPlayIdea) || other.todaysPlayIdea == todaysPlayIdea)&&(identical(other.scheduleReminder, scheduleReminder) || other.scheduleReminder == scheduleReminder)&&(identical(other.logoutApiResultStatus, logoutApiResultStatus) || other.logoutApiResultStatus == logoutApiResultStatus)&&(identical(other.deleteAccountApiResultStatus, deleteAccountApiResultStatus) || other.deleteAccountApiResultStatus == deleteAccountApiResultStatus)&&(identical(other.userModel, userModel) || other.userModel == userModel));
}


@override
int get hashCode => Object.hash(runtimeType,getReminderNotification,dailyEmotionCheck,todaysPlayIdea,scheduleReminder,logoutApiResultStatus,deleteAccountApiResultStatus,userModel);

@override
String toString() {
  return 'ProfileState(getReminderNotification: $getReminderNotification, dailyEmotionCheck: $dailyEmotionCheck, todaysPlayIdea: $todaysPlayIdea, scheduleReminder: $scheduleReminder, logoutApiResultStatus: $logoutApiResultStatus, deleteAccountApiResultStatus: $deleteAccountApiResultStatus, userModel: $userModel)';
}


}

/// @nodoc
abstract mixin class $ProfileStateCopyWith<$Res>  {
  factory $ProfileStateCopyWith(ProfileState value, $Res Function(ProfileState) _then) = _$ProfileStateCopyWithImpl;
@useResult
$Res call({
 bool getReminderNotification, bool dailyEmotionCheck, bool todaysPlayIdea, bool scheduleReminder, ApiResultStatus logoutApiResultStatus, ApiResultStatus deleteAccountApiResultStatus, UserModel? userModel
});


$ApiResultStatusCopyWith<dynamic, $Res> get logoutApiResultStatus;$ApiResultStatusCopyWith<dynamic, $Res> get deleteAccountApiResultStatus;

}
/// @nodoc
class _$ProfileStateCopyWithImpl<$Res>
    implements $ProfileStateCopyWith<$Res> {
  _$ProfileStateCopyWithImpl(this._self, this._then);

  final ProfileState _self;
  final $Res Function(ProfileState) _then;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? getReminderNotification = null,Object? dailyEmotionCheck = null,Object? todaysPlayIdea = null,Object? scheduleReminder = null,Object? logoutApiResultStatus = null,Object? deleteAccountApiResultStatus = null,Object? userModel = freezed,}) {
  return _then(_self.copyWith(
getReminderNotification: null == getReminderNotification ? _self.getReminderNotification : getReminderNotification // ignore: cast_nullable_to_non_nullable
as bool,dailyEmotionCheck: null == dailyEmotionCheck ? _self.dailyEmotionCheck : dailyEmotionCheck // ignore: cast_nullable_to_non_nullable
as bool,todaysPlayIdea: null == todaysPlayIdea ? _self.todaysPlayIdea : todaysPlayIdea // ignore: cast_nullable_to_non_nullable
as bool,scheduleReminder: null == scheduleReminder ? _self.scheduleReminder : scheduleReminder // ignore: cast_nullable_to_non_nullable
as bool,logoutApiResultStatus: null == logoutApiResultStatus ? _self.logoutApiResultStatus : logoutApiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,deleteAccountApiResultStatus: null == deleteAccountApiResultStatus ? _self.deleteAccountApiResultStatus : deleteAccountApiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,
  ));
}
/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get logoutApiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.logoutApiResultStatus, (value) {
    return _then(_self.copyWith(logoutApiResultStatus: value));
  });
}/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get deleteAccountApiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.deleteAccountApiResultStatus, (value) {
    return _then(_self.copyWith(deleteAccountApiResultStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProfileState].
extension ProfileStatePatterns on ProfileState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileState value)  $default,){
final _that = this;
switch (_that) {
case _ProfileState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileState value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool getReminderNotification,  bool dailyEmotionCheck,  bool todaysPlayIdea,  bool scheduleReminder,  ApiResultStatus logoutApiResultStatus,  ApiResultStatus deleteAccountApiResultStatus,  UserModel? userModel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileState() when $default != null:
return $default(_that.getReminderNotification,_that.dailyEmotionCheck,_that.todaysPlayIdea,_that.scheduleReminder,_that.logoutApiResultStatus,_that.deleteAccountApiResultStatus,_that.userModel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool getReminderNotification,  bool dailyEmotionCheck,  bool todaysPlayIdea,  bool scheduleReminder,  ApiResultStatus logoutApiResultStatus,  ApiResultStatus deleteAccountApiResultStatus,  UserModel? userModel)  $default,) {final _that = this;
switch (_that) {
case _ProfileState():
return $default(_that.getReminderNotification,_that.dailyEmotionCheck,_that.todaysPlayIdea,_that.scheduleReminder,_that.logoutApiResultStatus,_that.deleteAccountApiResultStatus,_that.userModel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool getReminderNotification,  bool dailyEmotionCheck,  bool todaysPlayIdea,  bool scheduleReminder,  ApiResultStatus logoutApiResultStatus,  ApiResultStatus deleteAccountApiResultStatus,  UserModel? userModel)?  $default,) {final _that = this;
switch (_that) {
case _ProfileState() when $default != null:
return $default(_that.getReminderNotification,_that.dailyEmotionCheck,_that.todaysPlayIdea,_that.scheduleReminder,_that.logoutApiResultStatus,_that.deleteAccountApiResultStatus,_that.userModel);case _:
  return null;

}
}

}

/// @nodoc


class _ProfileState implements ProfileState {
  const _ProfileState({this.getReminderNotification = false, this.dailyEmotionCheck = false, this.todaysPlayIdea = false, this.scheduleReminder = false, this.logoutApiResultStatus = const ApiResultStatus.initial(), this.deleteAccountApiResultStatus = const ApiResultStatus.initial(), this.userModel});
  

@override@JsonKey() final  bool getReminderNotification;
@override@JsonKey() final  bool dailyEmotionCheck;
@override@JsonKey() final  bool todaysPlayIdea;
@override@JsonKey() final  bool scheduleReminder;
@override@JsonKey() final  ApiResultStatus logoutApiResultStatus;
@override@JsonKey() final  ApiResultStatus deleteAccountApiResultStatus;
@override final  UserModel? userModel;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileStateCopyWith<_ProfileState> get copyWith => __$ProfileStateCopyWithImpl<_ProfileState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileState&&(identical(other.getReminderNotification, getReminderNotification) || other.getReminderNotification == getReminderNotification)&&(identical(other.dailyEmotionCheck, dailyEmotionCheck) || other.dailyEmotionCheck == dailyEmotionCheck)&&(identical(other.todaysPlayIdea, todaysPlayIdea) || other.todaysPlayIdea == todaysPlayIdea)&&(identical(other.scheduleReminder, scheduleReminder) || other.scheduleReminder == scheduleReminder)&&(identical(other.logoutApiResultStatus, logoutApiResultStatus) || other.logoutApiResultStatus == logoutApiResultStatus)&&(identical(other.deleteAccountApiResultStatus, deleteAccountApiResultStatus) || other.deleteAccountApiResultStatus == deleteAccountApiResultStatus)&&(identical(other.userModel, userModel) || other.userModel == userModel));
}


@override
int get hashCode => Object.hash(runtimeType,getReminderNotification,dailyEmotionCheck,todaysPlayIdea,scheduleReminder,logoutApiResultStatus,deleteAccountApiResultStatus,userModel);

@override
String toString() {
  return 'ProfileState(getReminderNotification: $getReminderNotification, dailyEmotionCheck: $dailyEmotionCheck, todaysPlayIdea: $todaysPlayIdea, scheduleReminder: $scheduleReminder, logoutApiResultStatus: $logoutApiResultStatus, deleteAccountApiResultStatus: $deleteAccountApiResultStatus, userModel: $userModel)';
}


}

/// @nodoc
abstract mixin class _$ProfileStateCopyWith<$Res> implements $ProfileStateCopyWith<$Res> {
  factory _$ProfileStateCopyWith(_ProfileState value, $Res Function(_ProfileState) _then) = __$ProfileStateCopyWithImpl;
@override @useResult
$Res call({
 bool getReminderNotification, bool dailyEmotionCheck, bool todaysPlayIdea, bool scheduleReminder, ApiResultStatus logoutApiResultStatus, ApiResultStatus deleteAccountApiResultStatus, UserModel? userModel
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get logoutApiResultStatus;@override $ApiResultStatusCopyWith<dynamic, $Res> get deleteAccountApiResultStatus;

}
/// @nodoc
class __$ProfileStateCopyWithImpl<$Res>
    implements _$ProfileStateCopyWith<$Res> {
  __$ProfileStateCopyWithImpl(this._self, this._then);

  final _ProfileState _self;
  final $Res Function(_ProfileState) _then;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? getReminderNotification = null,Object? dailyEmotionCheck = null,Object? todaysPlayIdea = null,Object? scheduleReminder = null,Object? logoutApiResultStatus = null,Object? deleteAccountApiResultStatus = null,Object? userModel = freezed,}) {
  return _then(_ProfileState(
getReminderNotification: null == getReminderNotification ? _self.getReminderNotification : getReminderNotification // ignore: cast_nullable_to_non_nullable
as bool,dailyEmotionCheck: null == dailyEmotionCheck ? _self.dailyEmotionCheck : dailyEmotionCheck // ignore: cast_nullable_to_non_nullable
as bool,todaysPlayIdea: null == todaysPlayIdea ? _self.todaysPlayIdea : todaysPlayIdea // ignore: cast_nullable_to_non_nullable
as bool,scheduleReminder: null == scheduleReminder ? _self.scheduleReminder : scheduleReminder // ignore: cast_nullable_to_non_nullable
as bool,logoutApiResultStatus: null == logoutApiResultStatus ? _self.logoutApiResultStatus : logoutApiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,deleteAccountApiResultStatus: null == deleteAccountApiResultStatus ? _self.deleteAccountApiResultStatus : deleteAccountApiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,
  ));
}

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get logoutApiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.logoutApiResultStatus, (value) {
    return _then(_self.copyWith(logoutApiResultStatus: value));
  });
}/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get deleteAccountApiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.deleteAccountApiResultStatus, (value) {
    return _then(_self.copyWith(deleteAccountApiResultStatus: value));
  });
}
}

// dart format on
