// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'journey_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$JourneyState {

 JourneyMode get mode; ChildModel? get child; WeeklyInsightsResult? get weeklyInsights; ActiveExperimentModel? get activeExperiment; int get savedGuidanceCount; int get timelineEventCount; bool get isSleepJourneyEnrolled; int get sleepJourneyWeek; int get sleepJourneyTotalWeeks; ApiResultStatus<dynamic> get fetchStatus;
/// Create a copy of JourneyState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JourneyStateCopyWith<JourneyState> get copyWith => _$JourneyStateCopyWithImpl<JourneyState>(this as JourneyState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as JourneyState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JourneyState&&(identical(other.mode, _this.mode) || other.mode == _this.mode)&&(identical(other.child, _this.child) || other.child == _this.child)&&(identical(other.weeklyInsights, _this.weeklyInsights) || other.weeklyInsights == _this.weeklyInsights)&&(identical(other.activeExperiment, _this.activeExperiment) || other.activeExperiment == _this.activeExperiment)&&(identical(other.savedGuidanceCount, _this.savedGuidanceCount) || other.savedGuidanceCount == _this.savedGuidanceCount)&&(identical(other.timelineEventCount, _this.timelineEventCount) || other.timelineEventCount == _this.timelineEventCount)&&(identical(other.isSleepJourneyEnrolled, _this.isSleepJourneyEnrolled) || other.isSleepJourneyEnrolled == _this.isSleepJourneyEnrolled)&&(identical(other.sleepJourneyWeek, _this.sleepJourneyWeek) || other.sleepJourneyWeek == _this.sleepJourneyWeek)&&(identical(other.sleepJourneyTotalWeeks, _this.sleepJourneyTotalWeeks) || other.sleepJourneyTotalWeeks == _this.sleepJourneyTotalWeeks)&&(identical(other.fetchStatus, _this.fetchStatus) || other.fetchStatus == _this.fetchStatus));
}


@override
int get hashCode {
  final _this = this as JourneyState;
  return Object.hash(runtimeType,_this.mode,_this.child,_this.weeklyInsights,_this.activeExperiment,_this.savedGuidanceCount,_this.timelineEventCount,_this.isSleepJourneyEnrolled,_this.sleepJourneyWeek,_this.sleepJourneyTotalWeeks,_this.fetchStatus);
}

@override
String toString() {
  final _this = this as JourneyState;
  return 'JourneyState(mode: ${_this.mode}, child: ${_this.child}, weeklyInsights: ${_this.weeklyInsights}, activeExperiment: ${_this.activeExperiment}, savedGuidanceCount: ${_this.savedGuidanceCount}, timelineEventCount: ${_this.timelineEventCount}, isSleepJourneyEnrolled: ${_this.isSleepJourneyEnrolled}, sleepJourneyWeek: ${_this.sleepJourneyWeek}, sleepJourneyTotalWeeks: ${_this.sleepJourneyTotalWeeks}, fetchStatus: ${_this.fetchStatus})';
}


}

/// @nodoc
abstract mixin class $JourneyStateCopyWith<$Res>  {
  factory $JourneyStateCopyWith(JourneyState value, $Res Function(JourneyState) _then) = _$JourneyStateCopyWithImpl;
@useResult
$Res call({
 JourneyMode mode, ChildModel? child, WeeklyInsightsResult? weeklyInsights, ActiveExperimentModel? activeExperiment, int savedGuidanceCount, int timelineEventCount, bool isSleepJourneyEnrolled, int sleepJourneyWeek, int sleepJourneyTotalWeeks, ApiResultStatus<dynamic> fetchStatus
});


$ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus;

}
/// @nodoc
class _$JourneyStateCopyWithImpl<$Res>
    implements $JourneyStateCopyWith<$Res> {
  _$JourneyStateCopyWithImpl(this._self, this._then);

  final JourneyState _self;
  final $Res Function(JourneyState) _then;

/// Create a copy of JourneyState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? child = freezed,Object? weeklyInsights = freezed,Object? activeExperiment = freezed,Object? savedGuidanceCount = null,Object? timelineEventCount = null,Object? isSleepJourneyEnrolled = null,Object? sleepJourneyWeek = null,Object? sleepJourneyTotalWeeks = null,Object? fetchStatus = null,}) {
  return _then(JourneyState(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as JourneyMode,child: freezed == child ? _self.child : child // ignore: cast_nullable_to_non_nullable
as ChildModel?,weeklyInsights: freezed == weeklyInsights ? _self.weeklyInsights : weeklyInsights // ignore: cast_nullable_to_non_nullable
as WeeklyInsightsResult?,activeExperiment: freezed == activeExperiment ? _self.activeExperiment : activeExperiment // ignore: cast_nullable_to_non_nullable
as ActiveExperimentModel?,savedGuidanceCount: null == savedGuidanceCount ? _self.savedGuidanceCount : savedGuidanceCount // ignore: cast_nullable_to_non_nullable
as int,timelineEventCount: null == timelineEventCount ? _self.timelineEventCount : timelineEventCount // ignore: cast_nullable_to_non_nullable
as int,isSleepJourneyEnrolled: null == isSleepJourneyEnrolled ? _self.isSleepJourneyEnrolled : isSleepJourneyEnrolled // ignore: cast_nullable_to_non_nullable
as bool,sleepJourneyWeek: null == sleepJourneyWeek ? _self.sleepJourneyWeek : sleepJourneyWeek // ignore: cast_nullable_to_non_nullable
as int,sleepJourneyTotalWeeks: null == sleepJourneyTotalWeeks ? _self.sleepJourneyTotalWeeks : sleepJourneyTotalWeeks // ignore: cast_nullable_to_non_nullable
as int,fetchStatus: null == fetchStatus ? _self.fetchStatus : fetchStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}
/// Create a copy of JourneyState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.fetchStatus, (value) {
    return _then(_self.copyWith(fetchStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [JourneyState].
extension JourneyStatePatterns on JourneyState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JourneyState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JourneyState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JourneyState value)  $default,){
final _that = this;
switch (_that) {
case _JourneyState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JourneyState value)?  $default,){
final _that = this;
switch (_that) {
case _JourneyState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( JourneyMode mode,  ChildModel? child,  WeeklyInsightsResult? weeklyInsights,  ActiveExperimentModel? activeExperiment,  int savedGuidanceCount,  int timelineEventCount,  bool isSleepJourneyEnrolled,  int sleepJourneyWeek,  int sleepJourneyTotalWeeks,  ApiResultStatus<dynamic> fetchStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JourneyState() when $default != null:
return $default(_that.mode,_that.child,_that.weeklyInsights,_that.activeExperiment,_that.savedGuidanceCount,_that.timelineEventCount,_that.isSleepJourneyEnrolled,_that.sleepJourneyWeek,_that.sleepJourneyTotalWeeks,_that.fetchStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( JourneyMode mode,  ChildModel? child,  WeeklyInsightsResult? weeklyInsights,  ActiveExperimentModel? activeExperiment,  int savedGuidanceCount,  int timelineEventCount,  bool isSleepJourneyEnrolled,  int sleepJourneyWeek,  int sleepJourneyTotalWeeks,  ApiResultStatus<dynamic> fetchStatus)  $default,) {final _that = this;
switch (_that) {
case _JourneyState():
return $default(_that.mode,_that.child,_that.weeklyInsights,_that.activeExperiment,_that.savedGuidanceCount,_that.timelineEventCount,_that.isSleepJourneyEnrolled,_that.sleepJourneyWeek,_that.sleepJourneyTotalWeeks,_that.fetchStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( JourneyMode mode,  ChildModel? child,  WeeklyInsightsResult? weeklyInsights,  ActiveExperimentModel? activeExperiment,  int savedGuidanceCount,  int timelineEventCount,  bool isSleepJourneyEnrolled,  int sleepJourneyWeek,  int sleepJourneyTotalWeeks,  ApiResultStatus<dynamic> fetchStatus)?  $default,) {final _that = this;
switch (_that) {
case _JourneyState() when $default != null:
return $default(_that.mode,_that.child,_that.weeklyInsights,_that.activeExperiment,_that.savedGuidanceCount,_that.timelineEventCount,_that.isSleepJourneyEnrolled,_that.sleepJourneyWeek,_that.sleepJourneyTotalWeeks,_that.fetchStatus);case _:
  return null;

}
}

}

/// @nodoc


class _JourneyState implements JourneyState {
  const _JourneyState({this.mode = JourneyMode.normal, this.child, this.weeklyInsights, this.activeExperiment, this.savedGuidanceCount = 0, this.timelineEventCount = 0, this.isSleepJourneyEnrolled = false, this.sleepJourneyWeek = 1, this.sleepJourneyTotalWeeks = 6, this.fetchStatus = const ApiResultStatus.initial()});
  

@override@JsonKey() final  JourneyMode mode;
@override final  ChildModel? child;
@override final  WeeklyInsightsResult? weeklyInsights;
@override final  ActiveExperimentModel? activeExperiment;
@override@JsonKey() final  int savedGuidanceCount;
@override@JsonKey() final  int timelineEventCount;
@override@JsonKey() final  bool isSleepJourneyEnrolled;
@override@JsonKey() final  int sleepJourneyWeek;
@override@JsonKey() final  int sleepJourneyTotalWeeks;
@override@JsonKey() final  ApiResultStatus<dynamic> fetchStatus;

/// Create a copy of JourneyState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JourneyStateCopyWith<_JourneyState> get copyWith => __$JourneyStateCopyWithImpl<_JourneyState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _JourneyState&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.child, child) || other.child == child)&&(identical(other.weeklyInsights, weeklyInsights) || other.weeklyInsights == weeklyInsights)&&(identical(other.activeExperiment, activeExperiment) || other.activeExperiment == activeExperiment)&&(identical(other.savedGuidanceCount, savedGuidanceCount) || other.savedGuidanceCount == savedGuidanceCount)&&(identical(other.timelineEventCount, timelineEventCount) || other.timelineEventCount == timelineEventCount)&&(identical(other.isSleepJourneyEnrolled, isSleepJourneyEnrolled) || other.isSleepJourneyEnrolled == isSleepJourneyEnrolled)&&(identical(other.sleepJourneyWeek, sleepJourneyWeek) || other.sleepJourneyWeek == sleepJourneyWeek)&&(identical(other.sleepJourneyTotalWeeks, sleepJourneyTotalWeeks) || other.sleepJourneyTotalWeeks == sleepJourneyTotalWeeks)&&(identical(other.fetchStatus, fetchStatus) || other.fetchStatus == fetchStatus));
}


@override
int get hashCode {
    return Object.hash(runtimeType,mode,child,weeklyInsights,activeExperiment,savedGuidanceCount,timelineEventCount,isSleepJourneyEnrolled,sleepJourneyWeek,sleepJourneyTotalWeeks,fetchStatus);
}

@override
String toString() {
    return 'JourneyState(mode: $mode, child: $child, weeklyInsights: $weeklyInsights, activeExperiment: $activeExperiment, savedGuidanceCount: $savedGuidanceCount, timelineEventCount: $timelineEventCount, isSleepJourneyEnrolled: $isSleepJourneyEnrolled, sleepJourneyWeek: $sleepJourneyWeek, sleepJourneyTotalWeeks: $sleepJourneyTotalWeeks, fetchStatus: $fetchStatus)';
}


}

/// @nodoc
abstract mixin class _$JourneyStateCopyWith<$Res> implements $JourneyStateCopyWith<$Res> {
  factory _$JourneyStateCopyWith(_JourneyState value, $Res Function(_JourneyState) _then) = __$JourneyStateCopyWithImpl;
@override @useResult
$Res call({
 JourneyMode mode, ChildModel? child, WeeklyInsightsResult? weeklyInsights, ActiveExperimentModel? activeExperiment, int savedGuidanceCount, int timelineEventCount, bool isSleepJourneyEnrolled, int sleepJourneyWeek, int sleepJourneyTotalWeeks, ApiResultStatus<dynamic> fetchStatus
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus;

}
/// @nodoc
class __$JourneyStateCopyWithImpl<$Res>
    implements _$JourneyStateCopyWith<$Res> {
  __$JourneyStateCopyWithImpl(this._self, this._then);

  final _JourneyState _self;
  final $Res Function(_JourneyState) _then;

/// Create a copy of JourneyState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,Object? child = freezed,Object? weeklyInsights = freezed,Object? activeExperiment = freezed,Object? savedGuidanceCount = null,Object? timelineEventCount = null,Object? isSleepJourneyEnrolled = null,Object? sleepJourneyWeek = null,Object? sleepJourneyTotalWeeks = null,Object? fetchStatus = null,}) {
  return _then(_JourneyState(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as JourneyMode,child: freezed == child ? _self.child : child // ignore: cast_nullable_to_non_nullable
as ChildModel?,weeklyInsights: freezed == weeklyInsights ? _self.weeklyInsights : weeklyInsights // ignore: cast_nullable_to_non_nullable
as WeeklyInsightsResult?,activeExperiment: freezed == activeExperiment ? _self.activeExperiment : activeExperiment // ignore: cast_nullable_to_non_nullable
as ActiveExperimentModel?,savedGuidanceCount: null == savedGuidanceCount ? _self.savedGuidanceCount : savedGuidanceCount // ignore: cast_nullable_to_non_nullable
as int,timelineEventCount: null == timelineEventCount ? _self.timelineEventCount : timelineEventCount // ignore: cast_nullable_to_non_nullable
as int,isSleepJourneyEnrolled: null == isSleepJourneyEnrolled ? _self.isSleepJourneyEnrolled : isSleepJourneyEnrolled // ignore: cast_nullable_to_non_nullable
as bool,sleepJourneyWeek: null == sleepJourneyWeek ? _self.sleepJourneyWeek : sleepJourneyWeek // ignore: cast_nullable_to_non_nullable
as int,sleepJourneyTotalWeeks: null == sleepJourneyTotalWeeks ? _self.sleepJourneyTotalWeeks : sleepJourneyTotalWeeks // ignore: cast_nullable_to_non_nullable
as int,fetchStatus: null == fetchStatus ? _self.fetchStatus : fetchStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}

/// Create a copy of JourneyState
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
