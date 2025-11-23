// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sleep_summary_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SleepSummaryState {

 DateTime? get selectedDate; DateTime? get selectedBedTime; DateTime? get selectedWakeTime; String? get notes; String? get bedTimeError; String? get selectedDateError; String? get wakeUpTimeError; String? get notesError; UserModel? get userModel; ChildModel? get childModel; WeekRange? get selectedWeek; List<ChildModel> get childList; List<WeekRange> get weeks; List<SleepLogModel> get sleepLogs; ApiResultStatus get emotionsLogApiResult; ApiResultStatus get childrenListApiResult; ApiResultStatus get addSleepLogApiResult; ApiResultStatus get getSleepLogsApiResult; ApiResultStatus get apiResultStatus;
/// Create a copy of SleepSummaryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SleepSummaryStateCopyWith<SleepSummaryState> get copyWith => _$SleepSummaryStateCopyWithImpl<SleepSummaryState>(this as SleepSummaryState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SleepSummaryState&&(identical(other.selectedDate, selectedDate) || other.selectedDate == selectedDate)&&(identical(other.selectedBedTime, selectedBedTime) || other.selectedBedTime == selectedBedTime)&&(identical(other.selectedWakeTime, selectedWakeTime) || other.selectedWakeTime == selectedWakeTime)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.bedTimeError, bedTimeError) || other.bedTimeError == bedTimeError)&&(identical(other.selectedDateError, selectedDateError) || other.selectedDateError == selectedDateError)&&(identical(other.wakeUpTimeError, wakeUpTimeError) || other.wakeUpTimeError == wakeUpTimeError)&&(identical(other.notesError, notesError) || other.notesError == notesError)&&(identical(other.userModel, userModel) || other.userModel == userModel)&&(identical(other.childModel, childModel) || other.childModel == childModel)&&(identical(other.selectedWeek, selectedWeek) || other.selectedWeek == selectedWeek)&&const DeepCollectionEquality().equals(other.childList, childList)&&const DeepCollectionEquality().equals(other.weeks, weeks)&&const DeepCollectionEquality().equals(other.sleepLogs, sleepLogs)&&(identical(other.emotionsLogApiResult, emotionsLogApiResult) || other.emotionsLogApiResult == emotionsLogApiResult)&&(identical(other.childrenListApiResult, childrenListApiResult) || other.childrenListApiResult == childrenListApiResult)&&(identical(other.addSleepLogApiResult, addSleepLogApiResult) || other.addSleepLogApiResult == addSleepLogApiResult)&&(identical(other.getSleepLogsApiResult, getSleepLogsApiResult) || other.getSleepLogsApiResult == getSleepLogsApiResult)&&(identical(other.apiResultStatus, apiResultStatus) || other.apiResultStatus == apiResultStatus));
}


@override
int get hashCode => Object.hashAll([runtimeType,selectedDate,selectedBedTime,selectedWakeTime,notes,bedTimeError,selectedDateError,wakeUpTimeError,notesError,userModel,childModel,selectedWeek,const DeepCollectionEquality().hash(childList),const DeepCollectionEquality().hash(weeks),const DeepCollectionEquality().hash(sleepLogs),emotionsLogApiResult,childrenListApiResult,addSleepLogApiResult,getSleepLogsApiResult,apiResultStatus]);

@override
String toString() {
  return 'SleepSummaryState(selectedDate: $selectedDate, selectedBedTime: $selectedBedTime, selectedWakeTime: $selectedWakeTime, notes: $notes, bedTimeError: $bedTimeError, selectedDateError: $selectedDateError, wakeUpTimeError: $wakeUpTimeError, notesError: $notesError, userModel: $userModel, childModel: $childModel, selectedWeek: $selectedWeek, childList: $childList, weeks: $weeks, sleepLogs: $sleepLogs, emotionsLogApiResult: $emotionsLogApiResult, childrenListApiResult: $childrenListApiResult, addSleepLogApiResult: $addSleepLogApiResult, getSleepLogsApiResult: $getSleepLogsApiResult, apiResultStatus: $apiResultStatus)';
}


}

/// @nodoc
abstract mixin class $SleepSummaryStateCopyWith<$Res>  {
  factory $SleepSummaryStateCopyWith(SleepSummaryState value, $Res Function(SleepSummaryState) _then) = _$SleepSummaryStateCopyWithImpl;
@useResult
$Res call({
 DateTime? selectedDate, DateTime? selectedBedTime, DateTime? selectedWakeTime, String? notes, String? bedTimeError, String? selectedDateError, String? wakeUpTimeError, String? notesError, UserModel? userModel, ChildModel? childModel, WeekRange? selectedWeek, List<ChildModel> childList, List<WeekRange> weeks, List<SleepLogModel> sleepLogs, ApiResultStatus emotionsLogApiResult, ApiResultStatus childrenListApiResult, ApiResultStatus addSleepLogApiResult, ApiResultStatus getSleepLogsApiResult, ApiResultStatus apiResultStatus
});


$ApiResultStatusCopyWith<dynamic, $Res> get emotionsLogApiResult;$ApiResultStatusCopyWith<dynamic, $Res> get childrenListApiResult;$ApiResultStatusCopyWith<dynamic, $Res> get addSleepLogApiResult;$ApiResultStatusCopyWith<dynamic, $Res> get getSleepLogsApiResult;$ApiResultStatusCopyWith<dynamic, $Res> get apiResultStatus;

}
/// @nodoc
class _$SleepSummaryStateCopyWithImpl<$Res>
    implements $SleepSummaryStateCopyWith<$Res> {
  _$SleepSummaryStateCopyWithImpl(this._self, this._then);

  final SleepSummaryState _self;
  final $Res Function(SleepSummaryState) _then;

/// Create a copy of SleepSummaryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selectedDate = freezed,Object? selectedBedTime = freezed,Object? selectedWakeTime = freezed,Object? notes = freezed,Object? bedTimeError = freezed,Object? selectedDateError = freezed,Object? wakeUpTimeError = freezed,Object? notesError = freezed,Object? userModel = freezed,Object? childModel = freezed,Object? selectedWeek = freezed,Object? childList = null,Object? weeks = null,Object? sleepLogs = null,Object? emotionsLogApiResult = null,Object? childrenListApiResult = null,Object? addSleepLogApiResult = null,Object? getSleepLogsApiResult = null,Object? apiResultStatus = null,}) {
  return _then(_self.copyWith(
selectedDate: freezed == selectedDate ? _self.selectedDate : selectedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,selectedBedTime: freezed == selectedBedTime ? _self.selectedBedTime : selectedBedTime // ignore: cast_nullable_to_non_nullable
as DateTime?,selectedWakeTime: freezed == selectedWakeTime ? _self.selectedWakeTime : selectedWakeTime // ignore: cast_nullable_to_non_nullable
as DateTime?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,bedTimeError: freezed == bedTimeError ? _self.bedTimeError : bedTimeError // ignore: cast_nullable_to_non_nullable
as String?,selectedDateError: freezed == selectedDateError ? _self.selectedDateError : selectedDateError // ignore: cast_nullable_to_non_nullable
as String?,wakeUpTimeError: freezed == wakeUpTimeError ? _self.wakeUpTimeError : wakeUpTimeError // ignore: cast_nullable_to_non_nullable
as String?,notesError: freezed == notesError ? _self.notesError : notesError // ignore: cast_nullable_to_non_nullable
as String?,userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,childModel: freezed == childModel ? _self.childModel : childModel // ignore: cast_nullable_to_non_nullable
as ChildModel?,selectedWeek: freezed == selectedWeek ? _self.selectedWeek : selectedWeek // ignore: cast_nullable_to_non_nullable
as WeekRange?,childList: null == childList ? _self.childList : childList // ignore: cast_nullable_to_non_nullable
as List<ChildModel>,weeks: null == weeks ? _self.weeks : weeks // ignore: cast_nullable_to_non_nullable
as List<WeekRange>,sleepLogs: null == sleepLogs ? _self.sleepLogs : sleepLogs // ignore: cast_nullable_to_non_nullable
as List<SleepLogModel>,emotionsLogApiResult: null == emotionsLogApiResult ? _self.emotionsLogApiResult : emotionsLogApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,childrenListApiResult: null == childrenListApiResult ? _self.childrenListApiResult : childrenListApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,addSleepLogApiResult: null == addSleepLogApiResult ? _self.addSleepLogApiResult : addSleepLogApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,getSleepLogsApiResult: null == getSleepLogsApiResult ? _self.getSleepLogsApiResult : getSleepLogsApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,apiResultStatus: null == apiResultStatus ? _self.apiResultStatus : apiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,
  ));
}
/// Create a copy of SleepSummaryState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get emotionsLogApiResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.emotionsLogApiResult, (value) {
    return _then(_self.copyWith(emotionsLogApiResult: value));
  });
}/// Create a copy of SleepSummaryState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get childrenListApiResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.childrenListApiResult, (value) {
    return _then(_self.copyWith(childrenListApiResult: value));
  });
}/// Create a copy of SleepSummaryState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get addSleepLogApiResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.addSleepLogApiResult, (value) {
    return _then(_self.copyWith(addSleepLogApiResult: value));
  });
}/// Create a copy of SleepSummaryState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get getSleepLogsApiResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.getSleepLogsApiResult, (value) {
    return _then(_self.copyWith(getSleepLogsApiResult: value));
  });
}/// Create a copy of SleepSummaryState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get apiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.apiResultStatus, (value) {
    return _then(_self.copyWith(apiResultStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [SleepSummaryState].
extension SleepSummaryStatePatterns on SleepSummaryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SleepSummaryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SleepSummaryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SleepSummaryState value)  $default,){
final _that = this;
switch (_that) {
case _SleepSummaryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SleepSummaryState value)?  $default,){
final _that = this;
switch (_that) {
case _SleepSummaryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime? selectedDate,  DateTime? selectedBedTime,  DateTime? selectedWakeTime,  String? notes,  String? bedTimeError,  String? selectedDateError,  String? wakeUpTimeError,  String? notesError,  UserModel? userModel,  ChildModel? childModel,  WeekRange? selectedWeek,  List<ChildModel> childList,  List<WeekRange> weeks,  List<SleepLogModel> sleepLogs,  ApiResultStatus emotionsLogApiResult,  ApiResultStatus childrenListApiResult,  ApiResultStatus addSleepLogApiResult,  ApiResultStatus getSleepLogsApiResult,  ApiResultStatus apiResultStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SleepSummaryState() when $default != null:
return $default(_that.selectedDate,_that.selectedBedTime,_that.selectedWakeTime,_that.notes,_that.bedTimeError,_that.selectedDateError,_that.wakeUpTimeError,_that.notesError,_that.userModel,_that.childModel,_that.selectedWeek,_that.childList,_that.weeks,_that.sleepLogs,_that.emotionsLogApiResult,_that.childrenListApiResult,_that.addSleepLogApiResult,_that.getSleepLogsApiResult,_that.apiResultStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime? selectedDate,  DateTime? selectedBedTime,  DateTime? selectedWakeTime,  String? notes,  String? bedTimeError,  String? selectedDateError,  String? wakeUpTimeError,  String? notesError,  UserModel? userModel,  ChildModel? childModel,  WeekRange? selectedWeek,  List<ChildModel> childList,  List<WeekRange> weeks,  List<SleepLogModel> sleepLogs,  ApiResultStatus emotionsLogApiResult,  ApiResultStatus childrenListApiResult,  ApiResultStatus addSleepLogApiResult,  ApiResultStatus getSleepLogsApiResult,  ApiResultStatus apiResultStatus)  $default,) {final _that = this;
switch (_that) {
case _SleepSummaryState():
return $default(_that.selectedDate,_that.selectedBedTime,_that.selectedWakeTime,_that.notes,_that.bedTimeError,_that.selectedDateError,_that.wakeUpTimeError,_that.notesError,_that.userModel,_that.childModel,_that.selectedWeek,_that.childList,_that.weeks,_that.sleepLogs,_that.emotionsLogApiResult,_that.childrenListApiResult,_that.addSleepLogApiResult,_that.getSleepLogsApiResult,_that.apiResultStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime? selectedDate,  DateTime? selectedBedTime,  DateTime? selectedWakeTime,  String? notes,  String? bedTimeError,  String? selectedDateError,  String? wakeUpTimeError,  String? notesError,  UserModel? userModel,  ChildModel? childModel,  WeekRange? selectedWeek,  List<ChildModel> childList,  List<WeekRange> weeks,  List<SleepLogModel> sleepLogs,  ApiResultStatus emotionsLogApiResult,  ApiResultStatus childrenListApiResult,  ApiResultStatus addSleepLogApiResult,  ApiResultStatus getSleepLogsApiResult,  ApiResultStatus apiResultStatus)?  $default,) {final _that = this;
switch (_that) {
case _SleepSummaryState() when $default != null:
return $default(_that.selectedDate,_that.selectedBedTime,_that.selectedWakeTime,_that.notes,_that.bedTimeError,_that.selectedDateError,_that.wakeUpTimeError,_that.notesError,_that.userModel,_that.childModel,_that.selectedWeek,_that.childList,_that.weeks,_that.sleepLogs,_that.emotionsLogApiResult,_that.childrenListApiResult,_that.addSleepLogApiResult,_that.getSleepLogsApiResult,_that.apiResultStatus);case _:
  return null;

}
}

}

/// @nodoc


class _SleepSummaryState implements SleepSummaryState {
  const _SleepSummaryState({this.selectedDate, this.selectedBedTime, this.selectedWakeTime, this.notes = "", this.bedTimeError = "", this.selectedDateError = "", this.wakeUpTimeError = "", this.notesError = "", this.userModel, this.childModel, this.selectedWeek, final  List<ChildModel> childList = const [], final  List<WeekRange> weeks = const [], final  List<SleepLogModel> sleepLogs = const [], this.emotionsLogApiResult = const ApiResultStatus.initial(), this.childrenListApiResult = const ApiResultStatus.initial(), this.addSleepLogApiResult = const ApiResultStatus.initial(), this.getSleepLogsApiResult = const ApiResultStatus.initial(), this.apiResultStatus = const ApiResultStatus.initial()}): _childList = childList,_weeks = weeks,_sleepLogs = sleepLogs;
  

@override final  DateTime? selectedDate;
@override final  DateTime? selectedBedTime;
@override final  DateTime? selectedWakeTime;
@override@JsonKey() final  String? notes;
@override@JsonKey() final  String? bedTimeError;
@override@JsonKey() final  String? selectedDateError;
@override@JsonKey() final  String? wakeUpTimeError;
@override@JsonKey() final  String? notesError;
@override final  UserModel? userModel;
@override final  ChildModel? childModel;
@override final  WeekRange? selectedWeek;
 final  List<ChildModel> _childList;
@override@JsonKey() List<ChildModel> get childList {
  if (_childList is EqualUnmodifiableListView) return _childList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_childList);
}

 final  List<WeekRange> _weeks;
@override@JsonKey() List<WeekRange> get weeks {
  if (_weeks is EqualUnmodifiableListView) return _weeks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weeks);
}

 final  List<SleepLogModel> _sleepLogs;
@override@JsonKey() List<SleepLogModel> get sleepLogs {
  if (_sleepLogs is EqualUnmodifiableListView) return _sleepLogs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sleepLogs);
}

@override@JsonKey() final  ApiResultStatus emotionsLogApiResult;
@override@JsonKey() final  ApiResultStatus childrenListApiResult;
@override@JsonKey() final  ApiResultStatus addSleepLogApiResult;
@override@JsonKey() final  ApiResultStatus getSleepLogsApiResult;
@override@JsonKey() final  ApiResultStatus apiResultStatus;

/// Create a copy of SleepSummaryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SleepSummaryStateCopyWith<_SleepSummaryState> get copyWith => __$SleepSummaryStateCopyWithImpl<_SleepSummaryState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SleepSummaryState&&(identical(other.selectedDate, selectedDate) || other.selectedDate == selectedDate)&&(identical(other.selectedBedTime, selectedBedTime) || other.selectedBedTime == selectedBedTime)&&(identical(other.selectedWakeTime, selectedWakeTime) || other.selectedWakeTime == selectedWakeTime)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.bedTimeError, bedTimeError) || other.bedTimeError == bedTimeError)&&(identical(other.selectedDateError, selectedDateError) || other.selectedDateError == selectedDateError)&&(identical(other.wakeUpTimeError, wakeUpTimeError) || other.wakeUpTimeError == wakeUpTimeError)&&(identical(other.notesError, notesError) || other.notesError == notesError)&&(identical(other.userModel, userModel) || other.userModel == userModel)&&(identical(other.childModel, childModel) || other.childModel == childModel)&&(identical(other.selectedWeek, selectedWeek) || other.selectedWeek == selectedWeek)&&const DeepCollectionEquality().equals(other._childList, _childList)&&const DeepCollectionEquality().equals(other._weeks, _weeks)&&const DeepCollectionEquality().equals(other._sleepLogs, _sleepLogs)&&(identical(other.emotionsLogApiResult, emotionsLogApiResult) || other.emotionsLogApiResult == emotionsLogApiResult)&&(identical(other.childrenListApiResult, childrenListApiResult) || other.childrenListApiResult == childrenListApiResult)&&(identical(other.addSleepLogApiResult, addSleepLogApiResult) || other.addSleepLogApiResult == addSleepLogApiResult)&&(identical(other.getSleepLogsApiResult, getSleepLogsApiResult) || other.getSleepLogsApiResult == getSleepLogsApiResult)&&(identical(other.apiResultStatus, apiResultStatus) || other.apiResultStatus == apiResultStatus));
}


@override
int get hashCode => Object.hashAll([runtimeType,selectedDate,selectedBedTime,selectedWakeTime,notes,bedTimeError,selectedDateError,wakeUpTimeError,notesError,userModel,childModel,selectedWeek,const DeepCollectionEquality().hash(_childList),const DeepCollectionEquality().hash(_weeks),const DeepCollectionEquality().hash(_sleepLogs),emotionsLogApiResult,childrenListApiResult,addSleepLogApiResult,getSleepLogsApiResult,apiResultStatus]);

@override
String toString() {
  return 'SleepSummaryState(selectedDate: $selectedDate, selectedBedTime: $selectedBedTime, selectedWakeTime: $selectedWakeTime, notes: $notes, bedTimeError: $bedTimeError, selectedDateError: $selectedDateError, wakeUpTimeError: $wakeUpTimeError, notesError: $notesError, userModel: $userModel, childModel: $childModel, selectedWeek: $selectedWeek, childList: $childList, weeks: $weeks, sleepLogs: $sleepLogs, emotionsLogApiResult: $emotionsLogApiResult, childrenListApiResult: $childrenListApiResult, addSleepLogApiResult: $addSleepLogApiResult, getSleepLogsApiResult: $getSleepLogsApiResult, apiResultStatus: $apiResultStatus)';
}


}

/// @nodoc
abstract mixin class _$SleepSummaryStateCopyWith<$Res> implements $SleepSummaryStateCopyWith<$Res> {
  factory _$SleepSummaryStateCopyWith(_SleepSummaryState value, $Res Function(_SleepSummaryState) _then) = __$SleepSummaryStateCopyWithImpl;
@override @useResult
$Res call({
 DateTime? selectedDate, DateTime? selectedBedTime, DateTime? selectedWakeTime, String? notes, String? bedTimeError, String? selectedDateError, String? wakeUpTimeError, String? notesError, UserModel? userModel, ChildModel? childModel, WeekRange? selectedWeek, List<ChildModel> childList, List<WeekRange> weeks, List<SleepLogModel> sleepLogs, ApiResultStatus emotionsLogApiResult, ApiResultStatus childrenListApiResult, ApiResultStatus addSleepLogApiResult, ApiResultStatus getSleepLogsApiResult, ApiResultStatus apiResultStatus
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get emotionsLogApiResult;@override $ApiResultStatusCopyWith<dynamic, $Res> get childrenListApiResult;@override $ApiResultStatusCopyWith<dynamic, $Res> get addSleepLogApiResult;@override $ApiResultStatusCopyWith<dynamic, $Res> get getSleepLogsApiResult;@override $ApiResultStatusCopyWith<dynamic, $Res> get apiResultStatus;

}
/// @nodoc
class __$SleepSummaryStateCopyWithImpl<$Res>
    implements _$SleepSummaryStateCopyWith<$Res> {
  __$SleepSummaryStateCopyWithImpl(this._self, this._then);

  final _SleepSummaryState _self;
  final $Res Function(_SleepSummaryState) _then;

/// Create a copy of SleepSummaryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectedDate = freezed,Object? selectedBedTime = freezed,Object? selectedWakeTime = freezed,Object? notes = freezed,Object? bedTimeError = freezed,Object? selectedDateError = freezed,Object? wakeUpTimeError = freezed,Object? notesError = freezed,Object? userModel = freezed,Object? childModel = freezed,Object? selectedWeek = freezed,Object? childList = null,Object? weeks = null,Object? sleepLogs = null,Object? emotionsLogApiResult = null,Object? childrenListApiResult = null,Object? addSleepLogApiResult = null,Object? getSleepLogsApiResult = null,Object? apiResultStatus = null,}) {
  return _then(_SleepSummaryState(
selectedDate: freezed == selectedDate ? _self.selectedDate : selectedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,selectedBedTime: freezed == selectedBedTime ? _self.selectedBedTime : selectedBedTime // ignore: cast_nullable_to_non_nullable
as DateTime?,selectedWakeTime: freezed == selectedWakeTime ? _self.selectedWakeTime : selectedWakeTime // ignore: cast_nullable_to_non_nullable
as DateTime?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,bedTimeError: freezed == bedTimeError ? _self.bedTimeError : bedTimeError // ignore: cast_nullable_to_non_nullable
as String?,selectedDateError: freezed == selectedDateError ? _self.selectedDateError : selectedDateError // ignore: cast_nullable_to_non_nullable
as String?,wakeUpTimeError: freezed == wakeUpTimeError ? _self.wakeUpTimeError : wakeUpTimeError // ignore: cast_nullable_to_non_nullable
as String?,notesError: freezed == notesError ? _self.notesError : notesError // ignore: cast_nullable_to_non_nullable
as String?,userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,childModel: freezed == childModel ? _self.childModel : childModel // ignore: cast_nullable_to_non_nullable
as ChildModel?,selectedWeek: freezed == selectedWeek ? _self.selectedWeek : selectedWeek // ignore: cast_nullable_to_non_nullable
as WeekRange?,childList: null == childList ? _self._childList : childList // ignore: cast_nullable_to_non_nullable
as List<ChildModel>,weeks: null == weeks ? _self._weeks : weeks // ignore: cast_nullable_to_non_nullable
as List<WeekRange>,sleepLogs: null == sleepLogs ? _self._sleepLogs : sleepLogs // ignore: cast_nullable_to_non_nullable
as List<SleepLogModel>,emotionsLogApiResult: null == emotionsLogApiResult ? _self.emotionsLogApiResult : emotionsLogApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,childrenListApiResult: null == childrenListApiResult ? _self.childrenListApiResult : childrenListApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,addSleepLogApiResult: null == addSleepLogApiResult ? _self.addSleepLogApiResult : addSleepLogApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,getSleepLogsApiResult: null == getSleepLogsApiResult ? _self.getSleepLogsApiResult : getSleepLogsApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,apiResultStatus: null == apiResultStatus ? _self.apiResultStatus : apiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,
  ));
}

/// Create a copy of SleepSummaryState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get emotionsLogApiResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.emotionsLogApiResult, (value) {
    return _then(_self.copyWith(emotionsLogApiResult: value));
  });
}/// Create a copy of SleepSummaryState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get childrenListApiResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.childrenListApiResult, (value) {
    return _then(_self.copyWith(childrenListApiResult: value));
  });
}/// Create a copy of SleepSummaryState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get addSleepLogApiResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.addSleepLogApiResult, (value) {
    return _then(_self.copyWith(addSleepLogApiResult: value));
  });
}/// Create a copy of SleepSummaryState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get getSleepLogsApiResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.getSleepLogsApiResult, (value) {
    return _then(_self.copyWith(getSleepLogsApiResult: value));
  });
}/// Create a copy of SleepSummaryState
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
