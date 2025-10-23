// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'propose_change_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProposeChangeState {

 String get dateError; String get startTimeError; String get endTimeError; String get noteForCoParent; ApiResultStatus get sendProposalApiResultStatus; SharedEventModel? get sharedEvent; DateTime? get endTime; DateTime? get startTime; DateTime? get selectedDate;
/// Create a copy of ProposeChangeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProposeChangeStateCopyWith<ProposeChangeState> get copyWith => _$ProposeChangeStateCopyWithImpl<ProposeChangeState>(this as ProposeChangeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProposeChangeState&&(identical(other.dateError, dateError) || other.dateError == dateError)&&(identical(other.startTimeError, startTimeError) || other.startTimeError == startTimeError)&&(identical(other.endTimeError, endTimeError) || other.endTimeError == endTimeError)&&(identical(other.noteForCoParent, noteForCoParent) || other.noteForCoParent == noteForCoParent)&&(identical(other.sendProposalApiResultStatus, sendProposalApiResultStatus) || other.sendProposalApiResultStatus == sendProposalApiResultStatus)&&(identical(other.sharedEvent, sharedEvent) || other.sharedEvent == sharedEvent)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.selectedDate, selectedDate) || other.selectedDate == selectedDate));
}


@override
int get hashCode => Object.hash(runtimeType,dateError,startTimeError,endTimeError,noteForCoParent,sendProposalApiResultStatus,sharedEvent,endTime,startTime,selectedDate);

@override
String toString() {
  return 'ProposeChangeState(dateError: $dateError, startTimeError: $startTimeError, endTimeError: $endTimeError, noteForCoParent: $noteForCoParent, sendProposalApiResultStatus: $sendProposalApiResultStatus, sharedEvent: $sharedEvent, endTime: $endTime, startTime: $startTime, selectedDate: $selectedDate)';
}


}

/// @nodoc
abstract mixin class $ProposeChangeStateCopyWith<$Res>  {
  factory $ProposeChangeStateCopyWith(ProposeChangeState value, $Res Function(ProposeChangeState) _then) = _$ProposeChangeStateCopyWithImpl;
@useResult
$Res call({
 String dateError, String startTimeError, String endTimeError, String noteForCoParent, ApiResultStatus sendProposalApiResultStatus, SharedEventModel? sharedEvent, DateTime? endTime, DateTime? startTime, DateTime? selectedDate
});


$ApiResultStatusCopyWith<dynamic, $Res> get sendProposalApiResultStatus;

}
/// @nodoc
class _$ProposeChangeStateCopyWithImpl<$Res>
    implements $ProposeChangeStateCopyWith<$Res> {
  _$ProposeChangeStateCopyWithImpl(this._self, this._then);

  final ProposeChangeState _self;
  final $Res Function(ProposeChangeState) _then;

/// Create a copy of ProposeChangeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dateError = null,Object? startTimeError = null,Object? endTimeError = null,Object? noteForCoParent = null,Object? sendProposalApiResultStatus = null,Object? sharedEvent = freezed,Object? endTime = freezed,Object? startTime = freezed,Object? selectedDate = freezed,}) {
  return _then(_self.copyWith(
dateError: null == dateError ? _self.dateError : dateError // ignore: cast_nullable_to_non_nullable
as String,startTimeError: null == startTimeError ? _self.startTimeError : startTimeError // ignore: cast_nullable_to_non_nullable
as String,endTimeError: null == endTimeError ? _self.endTimeError : endTimeError // ignore: cast_nullable_to_non_nullable
as String,noteForCoParent: null == noteForCoParent ? _self.noteForCoParent : noteForCoParent // ignore: cast_nullable_to_non_nullable
as String,sendProposalApiResultStatus: null == sendProposalApiResultStatus ? _self.sendProposalApiResultStatus : sendProposalApiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,sharedEvent: freezed == sharedEvent ? _self.sharedEvent : sharedEvent // ignore: cast_nullable_to_non_nullable
as SharedEventModel?,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime?,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime?,selectedDate: freezed == selectedDate ? _self.selectedDate : selectedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of ProposeChangeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get sendProposalApiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.sendProposalApiResultStatus, (value) {
    return _then(_self.copyWith(sendProposalApiResultStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProposeChangeState].
extension ProposeChangeStatePatterns on ProposeChangeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProposeChangeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProposeChangeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProposeChangeState value)  $default,){
final _that = this;
switch (_that) {
case _ProposeChangeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProposeChangeState value)?  $default,){
final _that = this;
switch (_that) {
case _ProposeChangeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String dateError,  String startTimeError,  String endTimeError,  String noteForCoParent,  ApiResultStatus sendProposalApiResultStatus,  SharedEventModel? sharedEvent,  DateTime? endTime,  DateTime? startTime,  DateTime? selectedDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProposeChangeState() when $default != null:
return $default(_that.dateError,_that.startTimeError,_that.endTimeError,_that.noteForCoParent,_that.sendProposalApiResultStatus,_that.sharedEvent,_that.endTime,_that.startTime,_that.selectedDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String dateError,  String startTimeError,  String endTimeError,  String noteForCoParent,  ApiResultStatus sendProposalApiResultStatus,  SharedEventModel? sharedEvent,  DateTime? endTime,  DateTime? startTime,  DateTime? selectedDate)  $default,) {final _that = this;
switch (_that) {
case _ProposeChangeState():
return $default(_that.dateError,_that.startTimeError,_that.endTimeError,_that.noteForCoParent,_that.sendProposalApiResultStatus,_that.sharedEvent,_that.endTime,_that.startTime,_that.selectedDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String dateError,  String startTimeError,  String endTimeError,  String noteForCoParent,  ApiResultStatus sendProposalApiResultStatus,  SharedEventModel? sharedEvent,  DateTime? endTime,  DateTime? startTime,  DateTime? selectedDate)?  $default,) {final _that = this;
switch (_that) {
case _ProposeChangeState() when $default != null:
return $default(_that.dateError,_that.startTimeError,_that.endTimeError,_that.noteForCoParent,_that.sendProposalApiResultStatus,_that.sharedEvent,_that.endTime,_that.startTime,_that.selectedDate);case _:
  return null;

}
}

}

/// @nodoc


class _ProposeChangeState implements ProposeChangeState {
  const _ProposeChangeState({this.dateError = "", this.startTimeError = "", this.endTimeError = "", this.noteForCoParent = "", this.sendProposalApiResultStatus = const ApiResultStatus.initial(), this.sharedEvent, this.endTime, this.startTime, this.selectedDate});
  

@override@JsonKey() final  String dateError;
@override@JsonKey() final  String startTimeError;
@override@JsonKey() final  String endTimeError;
@override@JsonKey() final  String noteForCoParent;
@override@JsonKey() final  ApiResultStatus sendProposalApiResultStatus;
@override final  SharedEventModel? sharedEvent;
@override final  DateTime? endTime;
@override final  DateTime? startTime;
@override final  DateTime? selectedDate;

/// Create a copy of ProposeChangeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProposeChangeStateCopyWith<_ProposeChangeState> get copyWith => __$ProposeChangeStateCopyWithImpl<_ProposeChangeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProposeChangeState&&(identical(other.dateError, dateError) || other.dateError == dateError)&&(identical(other.startTimeError, startTimeError) || other.startTimeError == startTimeError)&&(identical(other.endTimeError, endTimeError) || other.endTimeError == endTimeError)&&(identical(other.noteForCoParent, noteForCoParent) || other.noteForCoParent == noteForCoParent)&&(identical(other.sendProposalApiResultStatus, sendProposalApiResultStatus) || other.sendProposalApiResultStatus == sendProposalApiResultStatus)&&(identical(other.sharedEvent, sharedEvent) || other.sharedEvent == sharedEvent)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.selectedDate, selectedDate) || other.selectedDate == selectedDate));
}


@override
int get hashCode => Object.hash(runtimeType,dateError,startTimeError,endTimeError,noteForCoParent,sendProposalApiResultStatus,sharedEvent,endTime,startTime,selectedDate);

@override
String toString() {
  return 'ProposeChangeState(dateError: $dateError, startTimeError: $startTimeError, endTimeError: $endTimeError, noteForCoParent: $noteForCoParent, sendProposalApiResultStatus: $sendProposalApiResultStatus, sharedEvent: $sharedEvent, endTime: $endTime, startTime: $startTime, selectedDate: $selectedDate)';
}


}

/// @nodoc
abstract mixin class _$ProposeChangeStateCopyWith<$Res> implements $ProposeChangeStateCopyWith<$Res> {
  factory _$ProposeChangeStateCopyWith(_ProposeChangeState value, $Res Function(_ProposeChangeState) _then) = __$ProposeChangeStateCopyWithImpl;
@override @useResult
$Res call({
 String dateError, String startTimeError, String endTimeError, String noteForCoParent, ApiResultStatus sendProposalApiResultStatus, SharedEventModel? sharedEvent, DateTime? endTime, DateTime? startTime, DateTime? selectedDate
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get sendProposalApiResultStatus;

}
/// @nodoc
class __$ProposeChangeStateCopyWithImpl<$Res>
    implements _$ProposeChangeStateCopyWith<$Res> {
  __$ProposeChangeStateCopyWithImpl(this._self, this._then);

  final _ProposeChangeState _self;
  final $Res Function(_ProposeChangeState) _then;

/// Create a copy of ProposeChangeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dateError = null,Object? startTimeError = null,Object? endTimeError = null,Object? noteForCoParent = null,Object? sendProposalApiResultStatus = null,Object? sharedEvent = freezed,Object? endTime = freezed,Object? startTime = freezed,Object? selectedDate = freezed,}) {
  return _then(_ProposeChangeState(
dateError: null == dateError ? _self.dateError : dateError // ignore: cast_nullable_to_non_nullable
as String,startTimeError: null == startTimeError ? _self.startTimeError : startTimeError // ignore: cast_nullable_to_non_nullable
as String,endTimeError: null == endTimeError ? _self.endTimeError : endTimeError // ignore: cast_nullable_to_non_nullable
as String,noteForCoParent: null == noteForCoParent ? _self.noteForCoParent : noteForCoParent // ignore: cast_nullable_to_non_nullable
as String,sendProposalApiResultStatus: null == sendProposalApiResultStatus ? _self.sendProposalApiResultStatus : sendProposalApiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,sharedEvent: freezed == sharedEvent ? _self.sharedEvent : sharedEvent // ignore: cast_nullable_to_non_nullable
as SharedEventModel?,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime?,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime?,selectedDate: freezed == selectedDate ? _self.selectedDate : selectedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of ProposeChangeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get sendProposalApiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.sendProposalApiResultStatus, (value) {
    return _then(_self.copyWith(sendProposalApiResultStatus: value));
  });
}
}

// dart format on
