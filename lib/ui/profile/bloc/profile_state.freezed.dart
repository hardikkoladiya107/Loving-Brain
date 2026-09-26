// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfileState {

 bool get isNotification; bool get dailyEmotionCheck; bool get todaysPlayIdea; bool get scheduleReminder; ApiResultStatus<dynamic> get logoutApiResultStatus; ApiResultStatus<dynamic> get deleteAccountApiResultStatus; UserModel? get userModel; ApiResultStatus<dynamic> get uploadFileApiResultStatus;
/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileStateCopyWith<ProfileState> get copyWith => _$ProfileStateCopyWithImpl<ProfileState>(this as ProfileState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ProfileState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileState&&(identical(other.isNotification, _this.isNotification) || other.isNotification == _this.isNotification)&&(identical(other.dailyEmotionCheck, _this.dailyEmotionCheck) || other.dailyEmotionCheck == _this.dailyEmotionCheck)&&(identical(other.todaysPlayIdea, _this.todaysPlayIdea) || other.todaysPlayIdea == _this.todaysPlayIdea)&&(identical(other.scheduleReminder, _this.scheduleReminder) || other.scheduleReminder == _this.scheduleReminder)&&(identical(other.logoutApiResultStatus, _this.logoutApiResultStatus) || other.logoutApiResultStatus == _this.logoutApiResultStatus)&&(identical(other.deleteAccountApiResultStatus, _this.deleteAccountApiResultStatus) || other.deleteAccountApiResultStatus == _this.deleteAccountApiResultStatus)&&(identical(other.userModel, _this.userModel) || other.userModel == _this.userModel)&&(identical(other.uploadFileApiResultStatus, _this.uploadFileApiResultStatus) || other.uploadFileApiResultStatus == _this.uploadFileApiResultStatus));
}


@override
int get hashCode {
  final _this = this as ProfileState;
  return Object.hash(runtimeType,_this.isNotification,_this.dailyEmotionCheck,_this.todaysPlayIdea,_this.scheduleReminder,_this.logoutApiResultStatus,_this.deleteAccountApiResultStatus,_this.userModel,_this.uploadFileApiResultStatus);
}

@override
String toString() {
  final _this = this as ProfileState;
  return 'ProfileState(isNotification: ${_this.isNotification}, dailyEmotionCheck: ${_this.dailyEmotionCheck}, todaysPlayIdea: ${_this.todaysPlayIdea}, scheduleReminder: ${_this.scheduleReminder}, logoutApiResultStatus: ${_this.logoutApiResultStatus}, deleteAccountApiResultStatus: ${_this.deleteAccountApiResultStatus}, userModel: ${_this.userModel}, uploadFileApiResultStatus: ${_this.uploadFileApiResultStatus})';
}


}

/// @nodoc
abstract mixin class $ProfileStateCopyWith<$Res>  {
  factory $ProfileStateCopyWith(ProfileState value, $Res Function(ProfileState) _then) = _$ProfileStateCopyWithImpl;
@useResult
$Res call({
 bool isNotification, bool dailyEmotionCheck, bool todaysPlayIdea, bool scheduleReminder, ApiResultStatus<dynamic> logoutApiResultStatus, ApiResultStatus<dynamic> deleteAccountApiResultStatus, UserModel? userModel, ApiResultStatus<dynamic> uploadFileApiResultStatus
});


$ApiResultStatusCopyWith<dynamic, $Res> get logoutApiResultStatus;$ApiResultStatusCopyWith<dynamic, $Res> get deleteAccountApiResultStatus;$ApiResultStatusCopyWith<dynamic, $Res> get uploadFileApiResultStatus;

}
/// @nodoc
class _$ProfileStateCopyWithImpl<$Res>
    implements $ProfileStateCopyWith<$Res> {
  _$ProfileStateCopyWithImpl(this._self, this._then);

  final ProfileState _self;
  final $Res Function(ProfileState) _then;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isNotification = null,Object? dailyEmotionCheck = null,Object? todaysPlayIdea = null,Object? scheduleReminder = null,Object? logoutApiResultStatus = null,Object? deleteAccountApiResultStatus = null,Object? userModel = freezed,Object? uploadFileApiResultStatus = null,}) {
  return _then(ProfileState(
isNotification: null == isNotification ? _self.isNotification : isNotification // ignore: cast_nullable_to_non_nullable
as bool,dailyEmotionCheck: null == dailyEmotionCheck ? _self.dailyEmotionCheck : dailyEmotionCheck // ignore: cast_nullable_to_non_nullable
as bool,todaysPlayIdea: null == todaysPlayIdea ? _self.todaysPlayIdea : todaysPlayIdea // ignore: cast_nullable_to_non_nullable
as bool,scheduleReminder: null == scheduleReminder ? _self.scheduleReminder : scheduleReminder // ignore: cast_nullable_to_non_nullable
as bool,logoutApiResultStatus: null == logoutApiResultStatus ? _self.logoutApiResultStatus : logoutApiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,deleteAccountApiResultStatus: null == deleteAccountApiResultStatus ? _self.deleteAccountApiResultStatus : deleteAccountApiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,uploadFileApiResultStatus: null == uploadFileApiResultStatus ? _self.uploadFileApiResultStatus : uploadFileApiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
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
}/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get uploadFileApiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.uploadFileApiResultStatus, (value) {
    return _then(_self.copyWith(uploadFileApiResultStatus: value));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isNotification,  bool dailyEmotionCheck,  bool todaysPlayIdea,  bool scheduleReminder,  ApiResultStatus<dynamic> logoutApiResultStatus,  ApiResultStatus<dynamic> deleteAccountApiResultStatus,  UserModel? userModel,  ApiResultStatus<dynamic> uploadFileApiResultStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileState() when $default != null:
return $default(_that.isNotification,_that.dailyEmotionCheck,_that.todaysPlayIdea,_that.scheduleReminder,_that.logoutApiResultStatus,_that.deleteAccountApiResultStatus,_that.userModel,_that.uploadFileApiResultStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isNotification,  bool dailyEmotionCheck,  bool todaysPlayIdea,  bool scheduleReminder,  ApiResultStatus<dynamic> logoutApiResultStatus,  ApiResultStatus<dynamic> deleteAccountApiResultStatus,  UserModel? userModel,  ApiResultStatus<dynamic> uploadFileApiResultStatus)  $default,) {final _that = this;
switch (_that) {
case _ProfileState():
return $default(_that.isNotification,_that.dailyEmotionCheck,_that.todaysPlayIdea,_that.scheduleReminder,_that.logoutApiResultStatus,_that.deleteAccountApiResultStatus,_that.userModel,_that.uploadFileApiResultStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isNotification,  bool dailyEmotionCheck,  bool todaysPlayIdea,  bool scheduleReminder,  ApiResultStatus<dynamic> logoutApiResultStatus,  ApiResultStatus<dynamic> deleteAccountApiResultStatus,  UserModel? userModel,  ApiResultStatus<dynamic> uploadFileApiResultStatus)?  $default,) {final _that = this;
switch (_that) {
case _ProfileState() when $default != null:
return $default(_that.isNotification,_that.dailyEmotionCheck,_that.todaysPlayIdea,_that.scheduleReminder,_that.logoutApiResultStatus,_that.deleteAccountApiResultStatus,_that.userModel,_that.uploadFileApiResultStatus);case _:
  return null;

}
}

}

/// @nodoc


class _ProfileState implements ProfileState {
  const _ProfileState({this.isNotification = false, this.dailyEmotionCheck = false, this.todaysPlayIdea = false, this.scheduleReminder = false, this.logoutApiResultStatus = const ApiResultStatus.initial(), this.deleteAccountApiResultStatus = const ApiResultStatus.initial(), this.userModel, this.uploadFileApiResultStatus = const ApiResultStatus.initial()});
  

@override@JsonKey() final  bool isNotification;
@override@JsonKey() final  bool dailyEmotionCheck;
@override@JsonKey() final  bool todaysPlayIdea;
@override@JsonKey() final  bool scheduleReminder;
@override@JsonKey() final  ApiResultStatus<dynamic> logoutApiResultStatus;
@override@JsonKey() final  ApiResultStatus<dynamic> deleteAccountApiResultStatus;
@override final  UserModel? userModel;
@override@JsonKey() final  ApiResultStatus<dynamic> uploadFileApiResultStatus;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileStateCopyWith<_ProfileState> get copyWith => __$ProfileStateCopyWithImpl<_ProfileState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileState&&(identical(other.isNotification, isNotification) || other.isNotification == isNotification)&&(identical(other.dailyEmotionCheck, dailyEmotionCheck) || other.dailyEmotionCheck == dailyEmotionCheck)&&(identical(other.todaysPlayIdea, todaysPlayIdea) || other.todaysPlayIdea == todaysPlayIdea)&&(identical(other.scheduleReminder, scheduleReminder) || other.scheduleReminder == scheduleReminder)&&(identical(other.logoutApiResultStatus, logoutApiResultStatus) || other.logoutApiResultStatus == logoutApiResultStatus)&&(identical(other.deleteAccountApiResultStatus, deleteAccountApiResultStatus) || other.deleteAccountApiResultStatus == deleteAccountApiResultStatus)&&(identical(other.userModel, userModel) || other.userModel == userModel)&&(identical(other.uploadFileApiResultStatus, uploadFileApiResultStatus) || other.uploadFileApiResultStatus == uploadFileApiResultStatus));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isNotification,dailyEmotionCheck,todaysPlayIdea,scheduleReminder,logoutApiResultStatus,deleteAccountApiResultStatus,userModel,uploadFileApiResultStatus);
}

@override
String toString() {
    return 'ProfileState(isNotification: $isNotification, dailyEmotionCheck: $dailyEmotionCheck, todaysPlayIdea: $todaysPlayIdea, scheduleReminder: $scheduleReminder, logoutApiResultStatus: $logoutApiResultStatus, deleteAccountApiResultStatus: $deleteAccountApiResultStatus, userModel: $userModel, uploadFileApiResultStatus: $uploadFileApiResultStatus)';
}


}

/// @nodoc
abstract mixin class _$ProfileStateCopyWith<$Res> implements $ProfileStateCopyWith<$Res> {
  factory _$ProfileStateCopyWith(_ProfileState value, $Res Function(_ProfileState) _then) = __$ProfileStateCopyWithImpl;
@override @useResult
$Res call({
 bool isNotification, bool dailyEmotionCheck, bool todaysPlayIdea, bool scheduleReminder, ApiResultStatus<dynamic> logoutApiResultStatus, ApiResultStatus<dynamic> deleteAccountApiResultStatus, UserModel? userModel, ApiResultStatus<dynamic> uploadFileApiResultStatus
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get logoutApiResultStatus;@override $ApiResultStatusCopyWith<dynamic, $Res> get deleteAccountApiResultStatus;@override $ApiResultStatusCopyWith<dynamic, $Res> get uploadFileApiResultStatus;

}
/// @nodoc
class __$ProfileStateCopyWithImpl<$Res>
    implements _$ProfileStateCopyWith<$Res> {
  __$ProfileStateCopyWithImpl(this._self, this._then);

  final _ProfileState _self;
  final $Res Function(_ProfileState) _then;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isNotification = null,Object? dailyEmotionCheck = null,Object? todaysPlayIdea = null,Object? scheduleReminder = null,Object? logoutApiResultStatus = null,Object? deleteAccountApiResultStatus = null,Object? userModel = freezed,Object? uploadFileApiResultStatus = null,}) {
  return _then(_ProfileState(
isNotification: null == isNotification ? _self.isNotification : isNotification // ignore: cast_nullable_to_non_nullable
as bool,dailyEmotionCheck: null == dailyEmotionCheck ? _self.dailyEmotionCheck : dailyEmotionCheck // ignore: cast_nullable_to_non_nullable
as bool,todaysPlayIdea: null == todaysPlayIdea ? _self.todaysPlayIdea : todaysPlayIdea // ignore: cast_nullable_to_non_nullable
as bool,scheduleReminder: null == scheduleReminder ? _self.scheduleReminder : scheduleReminder // ignore: cast_nullable_to_non_nullable
as bool,logoutApiResultStatus: null == logoutApiResultStatus ? _self.logoutApiResultStatus : logoutApiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,deleteAccountApiResultStatus: null == deleteAccountApiResultStatus ? _self.deleteAccountApiResultStatus : deleteAccountApiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,uploadFileApiResultStatus: null == uploadFileApiResultStatus ? _self.uploadFileApiResultStatus : uploadFileApiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
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
}/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get uploadFileApiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.uploadFileApiResultStatus, (value) {
    return _then(_self.copyWith(uploadFileApiResultStatus: value));
  });
}
}

// dart format on
