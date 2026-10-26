// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notifications_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NotificationsState {

 bool get sleepEnabled; bool get checkInEnabled; bool get mentorshipEnabled; bool get weeklyReviewEnabled; String get quietHoursStart; String get quietHoursEnd; int get maxDailyCap; bool get isPermissionDenied; ApiResultStatus<dynamic> get saveStatus;
/// Create a copy of NotificationsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationsStateCopyWith<NotificationsState> get copyWith => _$NotificationsStateCopyWithImpl<NotificationsState>(this as NotificationsState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as NotificationsState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationsState&&(identical(other.sleepEnabled, _this.sleepEnabled) || other.sleepEnabled == _this.sleepEnabled)&&(identical(other.checkInEnabled, _this.checkInEnabled) || other.checkInEnabled == _this.checkInEnabled)&&(identical(other.mentorshipEnabled, _this.mentorshipEnabled) || other.mentorshipEnabled == _this.mentorshipEnabled)&&(identical(other.weeklyReviewEnabled, _this.weeklyReviewEnabled) || other.weeklyReviewEnabled == _this.weeklyReviewEnabled)&&(identical(other.quietHoursStart, _this.quietHoursStart) || other.quietHoursStart == _this.quietHoursStart)&&(identical(other.quietHoursEnd, _this.quietHoursEnd) || other.quietHoursEnd == _this.quietHoursEnd)&&(identical(other.maxDailyCap, _this.maxDailyCap) || other.maxDailyCap == _this.maxDailyCap)&&(identical(other.isPermissionDenied, _this.isPermissionDenied) || other.isPermissionDenied == _this.isPermissionDenied)&&(identical(other.saveStatus, _this.saveStatus) || other.saveStatus == _this.saveStatus));
}


@override
int get hashCode {
  final _this = this as NotificationsState;
  return Object.hash(runtimeType,_this.sleepEnabled,_this.checkInEnabled,_this.mentorshipEnabled,_this.weeklyReviewEnabled,_this.quietHoursStart,_this.quietHoursEnd,_this.maxDailyCap,_this.isPermissionDenied,_this.saveStatus);
}

@override
String toString() {
  final _this = this as NotificationsState;
  return 'NotificationsState(sleepEnabled: ${_this.sleepEnabled}, checkInEnabled: ${_this.checkInEnabled}, mentorshipEnabled: ${_this.mentorshipEnabled}, weeklyReviewEnabled: ${_this.weeklyReviewEnabled}, quietHoursStart: ${_this.quietHoursStart}, quietHoursEnd: ${_this.quietHoursEnd}, maxDailyCap: ${_this.maxDailyCap}, isPermissionDenied: ${_this.isPermissionDenied}, saveStatus: ${_this.saveStatus})';
}


}

/// @nodoc
abstract mixin class $NotificationsStateCopyWith<$Res>  {
  factory $NotificationsStateCopyWith(NotificationsState value, $Res Function(NotificationsState) _then) = _$NotificationsStateCopyWithImpl;
@useResult
$Res call({
 bool sleepEnabled, bool checkInEnabled, bool mentorshipEnabled, bool weeklyReviewEnabled, String quietHoursStart, String quietHoursEnd, int maxDailyCap, bool isPermissionDenied, ApiResultStatus<dynamic> saveStatus
});


$ApiResultStatusCopyWith<dynamic, $Res> get saveStatus;

}
/// @nodoc
class _$NotificationsStateCopyWithImpl<$Res>
    implements $NotificationsStateCopyWith<$Res> {
  _$NotificationsStateCopyWithImpl(this._self, this._then);

  final NotificationsState _self;
  final $Res Function(NotificationsState) _then;

/// Create a copy of NotificationsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sleepEnabled = null,Object? checkInEnabled = null,Object? mentorshipEnabled = null,Object? weeklyReviewEnabled = null,Object? quietHoursStart = null,Object? quietHoursEnd = null,Object? maxDailyCap = null,Object? isPermissionDenied = null,Object? saveStatus = null,}) {
  return _then(NotificationsState(
sleepEnabled: null == sleepEnabled ? _self.sleepEnabled : sleepEnabled // ignore: cast_nullable_to_non_nullable
as bool,checkInEnabled: null == checkInEnabled ? _self.checkInEnabled : checkInEnabled // ignore: cast_nullable_to_non_nullable
as bool,mentorshipEnabled: null == mentorshipEnabled ? _self.mentorshipEnabled : mentorshipEnabled // ignore: cast_nullable_to_non_nullable
as bool,weeklyReviewEnabled: null == weeklyReviewEnabled ? _self.weeklyReviewEnabled : weeklyReviewEnabled // ignore: cast_nullable_to_non_nullable
as bool,quietHoursStart: null == quietHoursStart ? _self.quietHoursStart : quietHoursStart // ignore: cast_nullable_to_non_nullable
as String,quietHoursEnd: null == quietHoursEnd ? _self.quietHoursEnd : quietHoursEnd // ignore: cast_nullable_to_non_nullable
as String,maxDailyCap: null == maxDailyCap ? _self.maxDailyCap : maxDailyCap // ignore: cast_nullable_to_non_nullable
as int,isPermissionDenied: null == isPermissionDenied ? _self.isPermissionDenied : isPermissionDenied // ignore: cast_nullable_to_non_nullable
as bool,saveStatus: null == saveStatus ? _self.saveStatus : saveStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}
/// Create a copy of NotificationsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get saveStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.saveStatus, (value) {
    return _then(_self.copyWith(saveStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [NotificationsState].
extension NotificationsStatePatterns on NotificationsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationsState value)  $default,){
final _that = this;
switch (_that) {
case _NotificationsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationsState value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool sleepEnabled,  bool checkInEnabled,  bool mentorshipEnabled,  bool weeklyReviewEnabled,  String quietHoursStart,  String quietHoursEnd,  int maxDailyCap,  bool isPermissionDenied,  ApiResultStatus<dynamic> saveStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationsState() when $default != null:
return $default(_that.sleepEnabled,_that.checkInEnabled,_that.mentorshipEnabled,_that.weeklyReviewEnabled,_that.quietHoursStart,_that.quietHoursEnd,_that.maxDailyCap,_that.isPermissionDenied,_that.saveStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool sleepEnabled,  bool checkInEnabled,  bool mentorshipEnabled,  bool weeklyReviewEnabled,  String quietHoursStart,  String quietHoursEnd,  int maxDailyCap,  bool isPermissionDenied,  ApiResultStatus<dynamic> saveStatus)  $default,) {final _that = this;
switch (_that) {
case _NotificationsState():
return $default(_that.sleepEnabled,_that.checkInEnabled,_that.mentorshipEnabled,_that.weeklyReviewEnabled,_that.quietHoursStart,_that.quietHoursEnd,_that.maxDailyCap,_that.isPermissionDenied,_that.saveStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool sleepEnabled,  bool checkInEnabled,  bool mentorshipEnabled,  bool weeklyReviewEnabled,  String quietHoursStart,  String quietHoursEnd,  int maxDailyCap,  bool isPermissionDenied,  ApiResultStatus<dynamic> saveStatus)?  $default,) {final _that = this;
switch (_that) {
case _NotificationsState() when $default != null:
return $default(_that.sleepEnabled,_that.checkInEnabled,_that.mentorshipEnabled,_that.weeklyReviewEnabled,_that.quietHoursStart,_that.quietHoursEnd,_that.maxDailyCap,_that.isPermissionDenied,_that.saveStatus);case _:
  return null;

}
}

}

/// @nodoc


class _NotificationsState implements NotificationsState {
  const _NotificationsState({this.sleepEnabled = true, this.checkInEnabled = true, this.mentorshipEnabled = false, this.weeklyReviewEnabled = true, this.quietHoursStart = '21:00', this.quietHoursEnd = '07:00', this.maxDailyCap = 3, this.isPermissionDenied = false, this.saveStatus = const ApiResultStatus.initial()});
  

@override@JsonKey() final  bool sleepEnabled;
@override@JsonKey() final  bool checkInEnabled;
@override@JsonKey() final  bool mentorshipEnabled;
@override@JsonKey() final  bool weeklyReviewEnabled;
@override@JsonKey() final  String quietHoursStart;
@override@JsonKey() final  String quietHoursEnd;
@override@JsonKey() final  int maxDailyCap;
@override@JsonKey() final  bool isPermissionDenied;
@override@JsonKey() final  ApiResultStatus<dynamic> saveStatus;

/// Create a copy of NotificationsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationsStateCopyWith<_NotificationsState> get copyWith => __$NotificationsStateCopyWithImpl<_NotificationsState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationsState&&(identical(other.sleepEnabled, sleepEnabled) || other.sleepEnabled == sleepEnabled)&&(identical(other.checkInEnabled, checkInEnabled) || other.checkInEnabled == checkInEnabled)&&(identical(other.mentorshipEnabled, mentorshipEnabled) || other.mentorshipEnabled == mentorshipEnabled)&&(identical(other.weeklyReviewEnabled, weeklyReviewEnabled) || other.weeklyReviewEnabled == weeklyReviewEnabled)&&(identical(other.quietHoursStart, quietHoursStart) || other.quietHoursStart == quietHoursStart)&&(identical(other.quietHoursEnd, quietHoursEnd) || other.quietHoursEnd == quietHoursEnd)&&(identical(other.maxDailyCap, maxDailyCap) || other.maxDailyCap == maxDailyCap)&&(identical(other.isPermissionDenied, isPermissionDenied) || other.isPermissionDenied == isPermissionDenied)&&(identical(other.saveStatus, saveStatus) || other.saveStatus == saveStatus));
}


@override
int get hashCode {
    return Object.hash(runtimeType,sleepEnabled,checkInEnabled,mentorshipEnabled,weeklyReviewEnabled,quietHoursStart,quietHoursEnd,maxDailyCap,isPermissionDenied,saveStatus);
}

@override
String toString() {
    return 'NotificationsState(sleepEnabled: $sleepEnabled, checkInEnabled: $checkInEnabled, mentorshipEnabled: $mentorshipEnabled, weeklyReviewEnabled: $weeklyReviewEnabled, quietHoursStart: $quietHoursStart, quietHoursEnd: $quietHoursEnd, maxDailyCap: $maxDailyCap, isPermissionDenied: $isPermissionDenied, saveStatus: $saveStatus)';
}


}

/// @nodoc
abstract mixin class _$NotificationsStateCopyWith<$Res> implements $NotificationsStateCopyWith<$Res> {
  factory _$NotificationsStateCopyWith(_NotificationsState value, $Res Function(_NotificationsState) _then) = __$NotificationsStateCopyWithImpl;
@override @useResult
$Res call({
 bool sleepEnabled, bool checkInEnabled, bool mentorshipEnabled, bool weeklyReviewEnabled, String quietHoursStart, String quietHoursEnd, int maxDailyCap, bool isPermissionDenied, ApiResultStatus<dynamic> saveStatus
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get saveStatus;

}
/// @nodoc
class __$NotificationsStateCopyWithImpl<$Res>
    implements _$NotificationsStateCopyWith<$Res> {
  __$NotificationsStateCopyWithImpl(this._self, this._then);

  final _NotificationsState _self;
  final $Res Function(_NotificationsState) _then;

/// Create a copy of NotificationsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sleepEnabled = null,Object? checkInEnabled = null,Object? mentorshipEnabled = null,Object? weeklyReviewEnabled = null,Object? quietHoursStart = null,Object? quietHoursEnd = null,Object? maxDailyCap = null,Object? isPermissionDenied = null,Object? saveStatus = null,}) {
  return _then(_NotificationsState(
sleepEnabled: null == sleepEnabled ? _self.sleepEnabled : sleepEnabled // ignore: cast_nullable_to_non_nullable
as bool,checkInEnabled: null == checkInEnabled ? _self.checkInEnabled : checkInEnabled // ignore: cast_nullable_to_non_nullable
as bool,mentorshipEnabled: null == mentorshipEnabled ? _self.mentorshipEnabled : mentorshipEnabled // ignore: cast_nullable_to_non_nullable
as bool,weeklyReviewEnabled: null == weeklyReviewEnabled ? _self.weeklyReviewEnabled : weeklyReviewEnabled // ignore: cast_nullable_to_non_nullable
as bool,quietHoursStart: null == quietHoursStart ? _self.quietHoursStart : quietHoursStart // ignore: cast_nullable_to_non_nullable
as String,quietHoursEnd: null == quietHoursEnd ? _self.quietHoursEnd : quietHoursEnd // ignore: cast_nullable_to_non_nullable
as String,maxDailyCap: null == maxDailyCap ? _self.maxDailyCap : maxDailyCap // ignore: cast_nullable_to_non_nullable
as int,isPermissionDenied: null == isPermissionDenied ? _self.isPermissionDenied : isPermissionDenied // ignore: cast_nullable_to_non_nullable
as bool,saveStatus: null == saveStatus ? _self.saveStatus : saveStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}

/// Create a copy of NotificationsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get saveStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.saveStatus, (value) {
    return _then(_self.copyWith(saveStatus: value));
  });
}
}

// dart format on
