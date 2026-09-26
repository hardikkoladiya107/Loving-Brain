// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_mood_log_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DailyMoodLogState {

 UserModel? get userModel; List<MoodLogModel> get logs; ApiResultStatus<dynamic> get apiResultStatus; ApiResultStatus<dynamic> get logsApiResultStatus;
/// Create a copy of DailyMoodLogState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyMoodLogStateCopyWith<DailyMoodLogState> get copyWith => _$DailyMoodLogStateCopyWithImpl<DailyMoodLogState>(this as DailyMoodLogState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DailyMoodLogState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyMoodLogState&&(identical(other.userModel, _this.userModel) || other.userModel == _this.userModel)&&const DeepCollectionEquality().equals(other.logs, _this.logs)&&(identical(other.apiResultStatus, _this.apiResultStatus) || other.apiResultStatus == _this.apiResultStatus)&&(identical(other.logsApiResultStatus, _this.logsApiResultStatus) || other.logsApiResultStatus == _this.logsApiResultStatus));
}


@override
int get hashCode {
  final _this = this as DailyMoodLogState;
  return Object.hash(runtimeType,_this.userModel,const DeepCollectionEquality().hash(_this.logs),_this.apiResultStatus,_this.logsApiResultStatus);
}

@override
String toString() {
  final _this = this as DailyMoodLogState;
  return 'DailyMoodLogState(userModel: ${_this.userModel}, logs: ${_this.logs}, apiResultStatus: ${_this.apiResultStatus}, logsApiResultStatus: ${_this.logsApiResultStatus})';
}


}

/// @nodoc
abstract mixin class $DailyMoodLogStateCopyWith<$Res>  {
  factory $DailyMoodLogStateCopyWith(DailyMoodLogState value, $Res Function(DailyMoodLogState) _then) = _$DailyMoodLogStateCopyWithImpl;
@useResult
$Res call({
 UserModel? userModel, List<MoodLogModel> logs, ApiResultStatus<dynamic> apiResultStatus, ApiResultStatus<dynamic> logsApiResultStatus
});


$ApiResultStatusCopyWith<dynamic, $Res> get apiResultStatus;$ApiResultStatusCopyWith<dynamic, $Res> get logsApiResultStatus;

}
/// @nodoc
class _$DailyMoodLogStateCopyWithImpl<$Res>
    implements $DailyMoodLogStateCopyWith<$Res> {
  _$DailyMoodLogStateCopyWithImpl(this._self, this._then);

  final DailyMoodLogState _self;
  final $Res Function(DailyMoodLogState) _then;

/// Create a copy of DailyMoodLogState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userModel = freezed,Object? logs = null,Object? apiResultStatus = null,Object? logsApiResultStatus = null,}) {
  return _then(DailyMoodLogState(
userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,logs: null == logs ? _self.logs : logs // ignore: cast_nullable_to_non_nullable
as List<MoodLogModel>,apiResultStatus: null == apiResultStatus ? _self.apiResultStatus : apiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,logsApiResultStatus: null == logsApiResultStatus ? _self.logsApiResultStatus : logsApiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}
/// Create a copy of DailyMoodLogState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get apiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.apiResultStatus, (value) {
    return _then(_self.copyWith(apiResultStatus: value));
  });
}/// Create a copy of DailyMoodLogState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get logsApiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.logsApiResultStatus, (value) {
    return _then(_self.copyWith(logsApiResultStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [DailyMoodLogState].
extension DailyMoodLogStatePatterns on DailyMoodLogState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyMoodLogState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyMoodLogState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyMoodLogState value)  $default,){
final _that = this;
switch (_that) {
case _DailyMoodLogState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyMoodLogState value)?  $default,){
final _that = this;
switch (_that) {
case _DailyMoodLogState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UserModel? userModel,  List<MoodLogModel> logs,  ApiResultStatus<dynamic> apiResultStatus,  ApiResultStatus<dynamic> logsApiResultStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyMoodLogState() when $default != null:
return $default(_that.userModel,_that.logs,_that.apiResultStatus,_that.logsApiResultStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UserModel? userModel,  List<MoodLogModel> logs,  ApiResultStatus<dynamic> apiResultStatus,  ApiResultStatus<dynamic> logsApiResultStatus)  $default,) {final _that = this;
switch (_that) {
case _DailyMoodLogState():
return $default(_that.userModel,_that.logs,_that.apiResultStatus,_that.logsApiResultStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UserModel? userModel,  List<MoodLogModel> logs,  ApiResultStatus<dynamic> apiResultStatus,  ApiResultStatus<dynamic> logsApiResultStatus)?  $default,) {final _that = this;
switch (_that) {
case _DailyMoodLogState() when $default != null:
return $default(_that.userModel,_that.logs,_that.apiResultStatus,_that.logsApiResultStatus);case _:
  return null;

}
}

}

/// @nodoc


class _DailyMoodLogState implements DailyMoodLogState {
  const _DailyMoodLogState({this.userModel,  List<MoodLogModel> logs = const [], this.apiResultStatus = const ApiResultStatus.initial(), this.logsApiResultStatus = const ApiResultStatus.initial()}): _logs = logs;
  

@override final  UserModel? userModel;
 final  List<MoodLogModel> _logs;
@override@JsonKey() List<MoodLogModel> get logs {
  if (_logs is EqualUnmodifiableListView) return _logs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_logs);
}

@override@JsonKey() final  ApiResultStatus<dynamic> apiResultStatus;
@override@JsonKey() final  ApiResultStatus<dynamic> logsApiResultStatus;

/// Create a copy of DailyMoodLogState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyMoodLogStateCopyWith<_DailyMoodLogState> get copyWith => __$DailyMoodLogStateCopyWithImpl<_DailyMoodLogState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyMoodLogState&&(identical(other.userModel, userModel) || other.userModel == userModel)&&const DeepCollectionEquality().equals(other.logs, _logs)&&(identical(other.apiResultStatus, apiResultStatus) || other.apiResultStatus == apiResultStatus)&&(identical(other.logsApiResultStatus, logsApiResultStatus) || other.logsApiResultStatus == logsApiResultStatus));
}


@override
int get hashCode {
    return Object.hash(runtimeType,userModel,const DeepCollectionEquality().hash(_logs),apiResultStatus,logsApiResultStatus);
}

@override
String toString() {
    return 'DailyMoodLogState(userModel: $userModel, logs: $logs, apiResultStatus: $apiResultStatus, logsApiResultStatus: $logsApiResultStatus)';
}


}

/// @nodoc
abstract mixin class _$DailyMoodLogStateCopyWith<$Res> implements $DailyMoodLogStateCopyWith<$Res> {
  factory _$DailyMoodLogStateCopyWith(_DailyMoodLogState value, $Res Function(_DailyMoodLogState) _then) = __$DailyMoodLogStateCopyWithImpl;
@override @useResult
$Res call({
 UserModel? userModel, List<MoodLogModel> logs, ApiResultStatus<dynamic> apiResultStatus, ApiResultStatus<dynamic> logsApiResultStatus
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get apiResultStatus;@override $ApiResultStatusCopyWith<dynamic, $Res> get logsApiResultStatus;

}
/// @nodoc
class __$DailyMoodLogStateCopyWithImpl<$Res>
    implements _$DailyMoodLogStateCopyWith<$Res> {
  __$DailyMoodLogStateCopyWithImpl(this._self, this._then);

  final _DailyMoodLogState _self;
  final $Res Function(_DailyMoodLogState) _then;

/// Create a copy of DailyMoodLogState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userModel = freezed,Object? logs = null,Object? apiResultStatus = null,Object? logsApiResultStatus = null,}) {
  return _then(_DailyMoodLogState(
userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,logs: null == logs ? _self._logs : logs // ignore: cast_nullable_to_non_nullable
as List<MoodLogModel>,apiResultStatus: null == apiResultStatus ? _self.apiResultStatus : apiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,logsApiResultStatus: null == logsApiResultStatus ? _self.logsApiResultStatus : logsApiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}

/// Create a copy of DailyMoodLogState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get apiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.apiResultStatus, (value) {
    return _then(_self.copyWith(apiResultStatus: value));
  });
}/// Create a copy of DailyMoodLogState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get logsApiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.logsApiResultStatus, (value) {
    return _then(_self.copyWith(logsApiResultStatus: value));
  });
}
}

// dart format on
