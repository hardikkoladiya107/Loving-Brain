// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_shared_event_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AddSharedEventState {

 UserModel? get userModel; String get title; String get note; DateTime? get selectedDate; DateTime? get startTime; DateTime? get endTime; String get selectedChild; String get assignedTo; String get titleError; String get noteError; String get dateError; String get startTimeError; String get endTimeError; bool get requiredApproval; String get selectedChildError; String get assignedToError; ApiResultStatus get requestApprovalApiResultStatus; ApiResultStatus get getChildApiResultStatus; ApiResultStatus get getCoParentApiResultStatus;
/// Create a copy of AddSharedEventState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddSharedEventStateCopyWith<AddSharedEventState> get copyWith => _$AddSharedEventStateCopyWithImpl<AddSharedEventState>(this as AddSharedEventState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddSharedEventState&&(identical(other.userModel, userModel) || other.userModel == userModel)&&(identical(other.title, title) || other.title == title)&&(identical(other.note, note) || other.note == note)&&(identical(other.selectedDate, selectedDate) || other.selectedDate == selectedDate)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.selectedChild, selectedChild) || other.selectedChild == selectedChild)&&(identical(other.assignedTo, assignedTo) || other.assignedTo == assignedTo)&&(identical(other.titleError, titleError) || other.titleError == titleError)&&(identical(other.noteError, noteError) || other.noteError == noteError)&&(identical(other.dateError, dateError) || other.dateError == dateError)&&(identical(other.startTimeError, startTimeError) || other.startTimeError == startTimeError)&&(identical(other.endTimeError, endTimeError) || other.endTimeError == endTimeError)&&(identical(other.requiredApproval, requiredApproval) || other.requiredApproval == requiredApproval)&&(identical(other.selectedChildError, selectedChildError) || other.selectedChildError == selectedChildError)&&(identical(other.assignedToError, assignedToError) || other.assignedToError == assignedToError)&&(identical(other.requestApprovalApiResultStatus, requestApprovalApiResultStatus) || other.requestApprovalApiResultStatus == requestApprovalApiResultStatus)&&(identical(other.getChildApiResultStatus, getChildApiResultStatus) || other.getChildApiResultStatus == getChildApiResultStatus)&&(identical(other.getCoParentApiResultStatus, getCoParentApiResultStatus) || other.getCoParentApiResultStatus == getCoParentApiResultStatus));
}


@override
int get hashCode => Object.hashAll([runtimeType,userModel,title,note,selectedDate,startTime,endTime,selectedChild,assignedTo,titleError,noteError,dateError,startTimeError,endTimeError,requiredApproval,selectedChildError,assignedToError,requestApprovalApiResultStatus,getChildApiResultStatus,getCoParentApiResultStatus]);

@override
String toString() {
  return 'AddSharedEventState(userModel: $userModel, title: $title, note: $note, selectedDate: $selectedDate, startTime: $startTime, endTime: $endTime, selectedChild: $selectedChild, assignedTo: $assignedTo, titleError: $titleError, noteError: $noteError, dateError: $dateError, startTimeError: $startTimeError, endTimeError: $endTimeError, requiredApproval: $requiredApproval, selectedChildError: $selectedChildError, assignedToError: $assignedToError, requestApprovalApiResultStatus: $requestApprovalApiResultStatus, getChildApiResultStatus: $getChildApiResultStatus, getCoParentApiResultStatus: $getCoParentApiResultStatus)';
}


}

/// @nodoc
abstract mixin class $AddSharedEventStateCopyWith<$Res>  {
  factory $AddSharedEventStateCopyWith(AddSharedEventState value, $Res Function(AddSharedEventState) _then) = _$AddSharedEventStateCopyWithImpl;
@useResult
$Res call({
 UserModel? userModel, String title, String note, DateTime? selectedDate, DateTime? startTime, DateTime? endTime, String selectedChild, String assignedTo, String titleError, String noteError, String dateError, String startTimeError, String endTimeError, bool requiredApproval, String selectedChildError, String assignedToError, ApiResultStatus requestApprovalApiResultStatus, ApiResultStatus getChildApiResultStatus, ApiResultStatus getCoParentApiResultStatus
});


$ApiResultStatusCopyWith<dynamic, $Res> get requestApprovalApiResultStatus;$ApiResultStatusCopyWith<dynamic, $Res> get getChildApiResultStatus;$ApiResultStatusCopyWith<dynamic, $Res> get getCoParentApiResultStatus;

}
/// @nodoc
class _$AddSharedEventStateCopyWithImpl<$Res>
    implements $AddSharedEventStateCopyWith<$Res> {
  _$AddSharedEventStateCopyWithImpl(this._self, this._then);

  final AddSharedEventState _self;
  final $Res Function(AddSharedEventState) _then;

/// Create a copy of AddSharedEventState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userModel = freezed,Object? title = null,Object? note = null,Object? selectedDate = freezed,Object? startTime = freezed,Object? endTime = freezed,Object? selectedChild = null,Object? assignedTo = null,Object? titleError = null,Object? noteError = null,Object? dateError = null,Object? startTimeError = null,Object? endTimeError = null,Object? requiredApproval = null,Object? selectedChildError = null,Object? assignedToError = null,Object? requestApprovalApiResultStatus = null,Object? getChildApiResultStatus = null,Object? getCoParentApiResultStatus = null,}) {
  return _then(_self.copyWith(
userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,selectedDate: freezed == selectedDate ? _self.selectedDate : selectedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime?,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime?,selectedChild: null == selectedChild ? _self.selectedChild : selectedChild // ignore: cast_nullable_to_non_nullable
as String,assignedTo: null == assignedTo ? _self.assignedTo : assignedTo // ignore: cast_nullable_to_non_nullable
as String,titleError: null == titleError ? _self.titleError : titleError // ignore: cast_nullable_to_non_nullable
as String,noteError: null == noteError ? _self.noteError : noteError // ignore: cast_nullable_to_non_nullable
as String,dateError: null == dateError ? _self.dateError : dateError // ignore: cast_nullable_to_non_nullable
as String,startTimeError: null == startTimeError ? _self.startTimeError : startTimeError // ignore: cast_nullable_to_non_nullable
as String,endTimeError: null == endTimeError ? _self.endTimeError : endTimeError // ignore: cast_nullable_to_non_nullable
as String,requiredApproval: null == requiredApproval ? _self.requiredApproval : requiredApproval // ignore: cast_nullable_to_non_nullable
as bool,selectedChildError: null == selectedChildError ? _self.selectedChildError : selectedChildError // ignore: cast_nullable_to_non_nullable
as String,assignedToError: null == assignedToError ? _self.assignedToError : assignedToError // ignore: cast_nullable_to_non_nullable
as String,requestApprovalApiResultStatus: null == requestApprovalApiResultStatus ? _self.requestApprovalApiResultStatus : requestApprovalApiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,getChildApiResultStatus: null == getChildApiResultStatus ? _self.getChildApiResultStatus : getChildApiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,getCoParentApiResultStatus: null == getCoParentApiResultStatus ? _self.getCoParentApiResultStatus : getCoParentApiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,
  ));
}
/// Create a copy of AddSharedEventState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get requestApprovalApiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.requestApprovalApiResultStatus, (value) {
    return _then(_self.copyWith(requestApprovalApiResultStatus: value));
  });
}/// Create a copy of AddSharedEventState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get getChildApiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.getChildApiResultStatus, (value) {
    return _then(_self.copyWith(getChildApiResultStatus: value));
  });
}/// Create a copy of AddSharedEventState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get getCoParentApiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.getCoParentApiResultStatus, (value) {
    return _then(_self.copyWith(getCoParentApiResultStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [AddSharedEventState].
extension AddSharedEventStatePatterns on AddSharedEventState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AddSharedEventState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddSharedEventState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AddSharedEventState value)  $default,){
final _that = this;
switch (_that) {
case _AddSharedEventState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AddSharedEventState value)?  $default,){
final _that = this;
switch (_that) {
case _AddSharedEventState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UserModel? userModel,  String title,  String note,  DateTime? selectedDate,  DateTime? startTime,  DateTime? endTime,  String selectedChild,  String assignedTo,  String titleError,  String noteError,  String dateError,  String startTimeError,  String endTimeError,  bool requiredApproval,  String selectedChildError,  String assignedToError,  ApiResultStatus requestApprovalApiResultStatus,  ApiResultStatus getChildApiResultStatus,  ApiResultStatus getCoParentApiResultStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AddSharedEventState() when $default != null:
return $default(_that.userModel,_that.title,_that.note,_that.selectedDate,_that.startTime,_that.endTime,_that.selectedChild,_that.assignedTo,_that.titleError,_that.noteError,_that.dateError,_that.startTimeError,_that.endTimeError,_that.requiredApproval,_that.selectedChildError,_that.assignedToError,_that.requestApprovalApiResultStatus,_that.getChildApiResultStatus,_that.getCoParentApiResultStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UserModel? userModel,  String title,  String note,  DateTime? selectedDate,  DateTime? startTime,  DateTime? endTime,  String selectedChild,  String assignedTo,  String titleError,  String noteError,  String dateError,  String startTimeError,  String endTimeError,  bool requiredApproval,  String selectedChildError,  String assignedToError,  ApiResultStatus requestApprovalApiResultStatus,  ApiResultStatus getChildApiResultStatus,  ApiResultStatus getCoParentApiResultStatus)  $default,) {final _that = this;
switch (_that) {
case _AddSharedEventState():
return $default(_that.userModel,_that.title,_that.note,_that.selectedDate,_that.startTime,_that.endTime,_that.selectedChild,_that.assignedTo,_that.titleError,_that.noteError,_that.dateError,_that.startTimeError,_that.endTimeError,_that.requiredApproval,_that.selectedChildError,_that.assignedToError,_that.requestApprovalApiResultStatus,_that.getChildApiResultStatus,_that.getCoParentApiResultStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UserModel? userModel,  String title,  String note,  DateTime? selectedDate,  DateTime? startTime,  DateTime? endTime,  String selectedChild,  String assignedTo,  String titleError,  String noteError,  String dateError,  String startTimeError,  String endTimeError,  bool requiredApproval,  String selectedChildError,  String assignedToError,  ApiResultStatus requestApprovalApiResultStatus,  ApiResultStatus getChildApiResultStatus,  ApiResultStatus getCoParentApiResultStatus)?  $default,) {final _that = this;
switch (_that) {
case _AddSharedEventState() when $default != null:
return $default(_that.userModel,_that.title,_that.note,_that.selectedDate,_that.startTime,_that.endTime,_that.selectedChild,_that.assignedTo,_that.titleError,_that.noteError,_that.dateError,_that.startTimeError,_that.endTimeError,_that.requiredApproval,_that.selectedChildError,_that.assignedToError,_that.requestApprovalApiResultStatus,_that.getChildApiResultStatus,_that.getCoParentApiResultStatus);case _:
  return null;

}
}

}

/// @nodoc


class _AddSharedEventState implements AddSharedEventState {
  const _AddSharedEventState({this.userModel, this.title = "", this.note = "", this.selectedDate, this.startTime, this.endTime, this.selectedChild = "", this.assignedTo = "", this.titleError = "", this.noteError = "", this.dateError = "", this.startTimeError = "", this.endTimeError = "", this.requiredApproval = false, this.selectedChildError = "", this.assignedToError = "", this.requestApprovalApiResultStatus = const ApiResultStatus.initial(), this.getChildApiResultStatus = const ApiResultStatus.initial(), this.getCoParentApiResultStatus = const ApiResultStatus.initial()});
  

@override final  UserModel? userModel;
@override@JsonKey() final  String title;
@override@JsonKey() final  String note;
@override final  DateTime? selectedDate;
@override final  DateTime? startTime;
@override final  DateTime? endTime;
@override@JsonKey() final  String selectedChild;
@override@JsonKey() final  String assignedTo;
@override@JsonKey() final  String titleError;
@override@JsonKey() final  String noteError;
@override@JsonKey() final  String dateError;
@override@JsonKey() final  String startTimeError;
@override@JsonKey() final  String endTimeError;
@override@JsonKey() final  bool requiredApproval;
@override@JsonKey() final  String selectedChildError;
@override@JsonKey() final  String assignedToError;
@override@JsonKey() final  ApiResultStatus requestApprovalApiResultStatus;
@override@JsonKey() final  ApiResultStatus getChildApiResultStatus;
@override@JsonKey() final  ApiResultStatus getCoParentApiResultStatus;

/// Create a copy of AddSharedEventState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddSharedEventStateCopyWith<_AddSharedEventState> get copyWith => __$AddSharedEventStateCopyWithImpl<_AddSharedEventState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddSharedEventState&&(identical(other.userModel, userModel) || other.userModel == userModel)&&(identical(other.title, title) || other.title == title)&&(identical(other.note, note) || other.note == note)&&(identical(other.selectedDate, selectedDate) || other.selectedDate == selectedDate)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.selectedChild, selectedChild) || other.selectedChild == selectedChild)&&(identical(other.assignedTo, assignedTo) || other.assignedTo == assignedTo)&&(identical(other.titleError, titleError) || other.titleError == titleError)&&(identical(other.noteError, noteError) || other.noteError == noteError)&&(identical(other.dateError, dateError) || other.dateError == dateError)&&(identical(other.startTimeError, startTimeError) || other.startTimeError == startTimeError)&&(identical(other.endTimeError, endTimeError) || other.endTimeError == endTimeError)&&(identical(other.requiredApproval, requiredApproval) || other.requiredApproval == requiredApproval)&&(identical(other.selectedChildError, selectedChildError) || other.selectedChildError == selectedChildError)&&(identical(other.assignedToError, assignedToError) || other.assignedToError == assignedToError)&&(identical(other.requestApprovalApiResultStatus, requestApprovalApiResultStatus) || other.requestApprovalApiResultStatus == requestApprovalApiResultStatus)&&(identical(other.getChildApiResultStatus, getChildApiResultStatus) || other.getChildApiResultStatus == getChildApiResultStatus)&&(identical(other.getCoParentApiResultStatus, getCoParentApiResultStatus) || other.getCoParentApiResultStatus == getCoParentApiResultStatus));
}


@override
int get hashCode => Object.hashAll([runtimeType,userModel,title,note,selectedDate,startTime,endTime,selectedChild,assignedTo,titleError,noteError,dateError,startTimeError,endTimeError,requiredApproval,selectedChildError,assignedToError,requestApprovalApiResultStatus,getChildApiResultStatus,getCoParentApiResultStatus]);

@override
String toString() {
  return 'AddSharedEventState(userModel: $userModel, title: $title, note: $note, selectedDate: $selectedDate, startTime: $startTime, endTime: $endTime, selectedChild: $selectedChild, assignedTo: $assignedTo, titleError: $titleError, noteError: $noteError, dateError: $dateError, startTimeError: $startTimeError, endTimeError: $endTimeError, requiredApproval: $requiredApproval, selectedChildError: $selectedChildError, assignedToError: $assignedToError, requestApprovalApiResultStatus: $requestApprovalApiResultStatus, getChildApiResultStatus: $getChildApiResultStatus, getCoParentApiResultStatus: $getCoParentApiResultStatus)';
}


}

/// @nodoc
abstract mixin class _$AddSharedEventStateCopyWith<$Res> implements $AddSharedEventStateCopyWith<$Res> {
  factory _$AddSharedEventStateCopyWith(_AddSharedEventState value, $Res Function(_AddSharedEventState) _then) = __$AddSharedEventStateCopyWithImpl;
@override @useResult
$Res call({
 UserModel? userModel, String title, String note, DateTime? selectedDate, DateTime? startTime, DateTime? endTime, String selectedChild, String assignedTo, String titleError, String noteError, String dateError, String startTimeError, String endTimeError, bool requiredApproval, String selectedChildError, String assignedToError, ApiResultStatus requestApprovalApiResultStatus, ApiResultStatus getChildApiResultStatus, ApiResultStatus getCoParentApiResultStatus
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get requestApprovalApiResultStatus;@override $ApiResultStatusCopyWith<dynamic, $Res> get getChildApiResultStatus;@override $ApiResultStatusCopyWith<dynamic, $Res> get getCoParentApiResultStatus;

}
/// @nodoc
class __$AddSharedEventStateCopyWithImpl<$Res>
    implements _$AddSharedEventStateCopyWith<$Res> {
  __$AddSharedEventStateCopyWithImpl(this._self, this._then);

  final _AddSharedEventState _self;
  final $Res Function(_AddSharedEventState) _then;

/// Create a copy of AddSharedEventState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userModel = freezed,Object? title = null,Object? note = null,Object? selectedDate = freezed,Object? startTime = freezed,Object? endTime = freezed,Object? selectedChild = null,Object? assignedTo = null,Object? titleError = null,Object? noteError = null,Object? dateError = null,Object? startTimeError = null,Object? endTimeError = null,Object? requiredApproval = null,Object? selectedChildError = null,Object? assignedToError = null,Object? requestApprovalApiResultStatus = null,Object? getChildApiResultStatus = null,Object? getCoParentApiResultStatus = null,}) {
  return _then(_AddSharedEventState(
userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,selectedDate: freezed == selectedDate ? _self.selectedDate : selectedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime?,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime?,selectedChild: null == selectedChild ? _self.selectedChild : selectedChild // ignore: cast_nullable_to_non_nullable
as String,assignedTo: null == assignedTo ? _self.assignedTo : assignedTo // ignore: cast_nullable_to_non_nullable
as String,titleError: null == titleError ? _self.titleError : titleError // ignore: cast_nullable_to_non_nullable
as String,noteError: null == noteError ? _self.noteError : noteError // ignore: cast_nullable_to_non_nullable
as String,dateError: null == dateError ? _self.dateError : dateError // ignore: cast_nullable_to_non_nullable
as String,startTimeError: null == startTimeError ? _self.startTimeError : startTimeError // ignore: cast_nullable_to_non_nullable
as String,endTimeError: null == endTimeError ? _self.endTimeError : endTimeError // ignore: cast_nullable_to_non_nullable
as String,requiredApproval: null == requiredApproval ? _self.requiredApproval : requiredApproval // ignore: cast_nullable_to_non_nullable
as bool,selectedChildError: null == selectedChildError ? _self.selectedChildError : selectedChildError // ignore: cast_nullable_to_non_nullable
as String,assignedToError: null == assignedToError ? _self.assignedToError : assignedToError // ignore: cast_nullable_to_non_nullable
as String,requestApprovalApiResultStatus: null == requestApprovalApiResultStatus ? _self.requestApprovalApiResultStatus : requestApprovalApiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,getChildApiResultStatus: null == getChildApiResultStatus ? _self.getChildApiResultStatus : getChildApiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,getCoParentApiResultStatus: null == getCoParentApiResultStatus ? _self.getCoParentApiResultStatus : getCoParentApiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,
  ));
}

/// Create a copy of AddSharedEventState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get requestApprovalApiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.requestApprovalApiResultStatus, (value) {
    return _then(_self.copyWith(requestApprovalApiResultStatus: value));
  });
}/// Create a copy of AddSharedEventState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get getChildApiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.getChildApiResultStatus, (value) {
    return _then(_self.copyWith(getChildApiResultStatus: value));
  });
}/// Create a copy of AddSharedEventState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get getCoParentApiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.getCoParentApiResultStatus, (value) {
    return _then(_self.copyWith(getCoParentApiResultStatus: value));
  });
}
}

// dart format on
