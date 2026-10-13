// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sleep_forecast_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SleepForecastState {

 bool get isLoading; int get selectedDayIndex; String get parentName; String get childName; String get timeOfDayGreeting; String get windowStart; String get windowEnd; String get bedtimeEstimate; String get reason; String get subtitle; String get confidenceLevel; int get confidenceDots; List<TonightPlanStep> get planSteps; bool get hasRealLogs; String? get healthCaveat;
/// Create a copy of SleepForecastState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SleepForecastStateCopyWith<SleepForecastState> get copyWith => _$SleepForecastStateCopyWithImpl<SleepForecastState>(this as SleepForecastState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SleepForecastState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SleepForecastState&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.selectedDayIndex, _this.selectedDayIndex) || other.selectedDayIndex == _this.selectedDayIndex)&&(identical(other.parentName, _this.parentName) || other.parentName == _this.parentName)&&(identical(other.childName, _this.childName) || other.childName == _this.childName)&&(identical(other.timeOfDayGreeting, _this.timeOfDayGreeting) || other.timeOfDayGreeting == _this.timeOfDayGreeting)&&(identical(other.windowStart, _this.windowStart) || other.windowStart == _this.windowStart)&&(identical(other.windowEnd, _this.windowEnd) || other.windowEnd == _this.windowEnd)&&(identical(other.bedtimeEstimate, _this.bedtimeEstimate) || other.bedtimeEstimate == _this.bedtimeEstimate)&&(identical(other.reason, _this.reason) || other.reason == _this.reason)&&(identical(other.subtitle, _this.subtitle) || other.subtitle == _this.subtitle)&&(identical(other.confidenceLevel, _this.confidenceLevel) || other.confidenceLevel == _this.confidenceLevel)&&(identical(other.confidenceDots, _this.confidenceDots) || other.confidenceDots == _this.confidenceDots)&&const DeepCollectionEquality().equals(other.planSteps, _this.planSteps)&&(identical(other.hasRealLogs, _this.hasRealLogs) || other.hasRealLogs == _this.hasRealLogs)&&(identical(other.healthCaveat, _this.healthCaveat) || other.healthCaveat == _this.healthCaveat));
}


@override
int get hashCode {
  final _this = this as SleepForecastState;
  return Object.hash(runtimeType,_this.isLoading,_this.selectedDayIndex,_this.parentName,_this.childName,_this.timeOfDayGreeting,_this.windowStart,_this.windowEnd,_this.bedtimeEstimate,_this.reason,_this.subtitle,_this.confidenceLevel,_this.confidenceDots,const DeepCollectionEquality().hash(_this.planSteps),_this.hasRealLogs,_this.healthCaveat);
}

@override
String toString() {
  final _this = this as SleepForecastState;
  return 'SleepForecastState(isLoading: ${_this.isLoading}, selectedDayIndex: ${_this.selectedDayIndex}, parentName: ${_this.parentName}, childName: ${_this.childName}, timeOfDayGreeting: ${_this.timeOfDayGreeting}, windowStart: ${_this.windowStart}, windowEnd: ${_this.windowEnd}, bedtimeEstimate: ${_this.bedtimeEstimate}, reason: ${_this.reason}, subtitle: ${_this.subtitle}, confidenceLevel: ${_this.confidenceLevel}, confidenceDots: ${_this.confidenceDots}, planSteps: ${_this.planSteps}, hasRealLogs: ${_this.hasRealLogs}, healthCaveat: ${_this.healthCaveat})';
}


}

/// @nodoc
abstract mixin class $SleepForecastStateCopyWith<$Res>  {
  factory $SleepForecastStateCopyWith(SleepForecastState value, $Res Function(SleepForecastState) _then) = _$SleepForecastStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, int selectedDayIndex, String parentName, String childName, String timeOfDayGreeting, String windowStart, String windowEnd, String bedtimeEstimate, String reason, String subtitle, String confidenceLevel, int confidenceDots, List<TonightPlanStep> planSteps, bool hasRealLogs, String? healthCaveat
});




}
/// @nodoc
class _$SleepForecastStateCopyWithImpl<$Res>
    implements $SleepForecastStateCopyWith<$Res> {
  _$SleepForecastStateCopyWithImpl(this._self, this._then);

  final SleepForecastState _self;
  final $Res Function(SleepForecastState) _then;

/// Create a copy of SleepForecastState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? selectedDayIndex = null,Object? parentName = null,Object? childName = null,Object? timeOfDayGreeting = null,Object? windowStart = null,Object? windowEnd = null,Object? bedtimeEstimate = null,Object? reason = null,Object? subtitle = null,Object? confidenceLevel = null,Object? confidenceDots = null,Object? planSteps = null,Object? hasRealLogs = null,Object? healthCaveat = freezed,}) {
  return _then(SleepForecastState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,selectedDayIndex: null == selectedDayIndex ? _self.selectedDayIndex : selectedDayIndex // ignore: cast_nullable_to_non_nullable
as int,parentName: null == parentName ? _self.parentName : parentName // ignore: cast_nullable_to_non_nullable
as String,childName: null == childName ? _self.childName : childName // ignore: cast_nullable_to_non_nullable
as String,timeOfDayGreeting: null == timeOfDayGreeting ? _self.timeOfDayGreeting : timeOfDayGreeting // ignore: cast_nullable_to_non_nullable
as String,windowStart: null == windowStart ? _self.windowStart : windowStart // ignore: cast_nullable_to_non_nullable
as String,windowEnd: null == windowEnd ? _self.windowEnd : windowEnd // ignore: cast_nullable_to_non_nullable
as String,bedtimeEstimate: null == bedtimeEstimate ? _self.bedtimeEstimate : bedtimeEstimate // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,confidenceLevel: null == confidenceLevel ? _self.confidenceLevel : confidenceLevel // ignore: cast_nullable_to_non_nullable
as String,confidenceDots: null == confidenceDots ? _self.confidenceDots : confidenceDots // ignore: cast_nullable_to_non_nullable
as int,planSteps: null == planSteps ? _self.planSteps : planSteps // ignore: cast_nullable_to_non_nullable
as List<TonightPlanStep>,hasRealLogs: null == hasRealLogs ? _self.hasRealLogs : hasRealLogs // ignore: cast_nullable_to_non_nullable
as bool,healthCaveat: freezed == healthCaveat ? _self.healthCaveat : healthCaveat // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SleepForecastState].
extension SleepForecastStatePatterns on SleepForecastState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SleepForecastState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SleepForecastState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SleepForecastState value)  $default,){
final _that = this;
switch (_that) {
case _SleepForecastState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SleepForecastState value)?  $default,){
final _that = this;
switch (_that) {
case _SleepForecastState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  int selectedDayIndex,  String parentName,  String childName,  String timeOfDayGreeting,  String windowStart,  String windowEnd,  String bedtimeEstimate,  String reason,  String subtitle,  String confidenceLevel,  int confidenceDots,  List<TonightPlanStep> planSteps,  bool hasRealLogs,  String? healthCaveat)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SleepForecastState() when $default != null:
return $default(_that.isLoading,_that.selectedDayIndex,_that.parentName,_that.childName,_that.timeOfDayGreeting,_that.windowStart,_that.windowEnd,_that.bedtimeEstimate,_that.reason,_that.subtitle,_that.confidenceLevel,_that.confidenceDots,_that.planSteps,_that.hasRealLogs,_that.healthCaveat);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  int selectedDayIndex,  String parentName,  String childName,  String timeOfDayGreeting,  String windowStart,  String windowEnd,  String bedtimeEstimate,  String reason,  String subtitle,  String confidenceLevel,  int confidenceDots,  List<TonightPlanStep> planSteps,  bool hasRealLogs,  String? healthCaveat)  $default,) {final _that = this;
switch (_that) {
case _SleepForecastState():
return $default(_that.isLoading,_that.selectedDayIndex,_that.parentName,_that.childName,_that.timeOfDayGreeting,_that.windowStart,_that.windowEnd,_that.bedtimeEstimate,_that.reason,_that.subtitle,_that.confidenceLevel,_that.confidenceDots,_that.planSteps,_that.hasRealLogs,_that.healthCaveat);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  int selectedDayIndex,  String parentName,  String childName,  String timeOfDayGreeting,  String windowStart,  String windowEnd,  String bedtimeEstimate,  String reason,  String subtitle,  String confidenceLevel,  int confidenceDots,  List<TonightPlanStep> planSteps,  bool hasRealLogs,  String? healthCaveat)?  $default,) {final _that = this;
switch (_that) {
case _SleepForecastState() when $default != null:
return $default(_that.isLoading,_that.selectedDayIndex,_that.parentName,_that.childName,_that.timeOfDayGreeting,_that.windowStart,_that.windowEnd,_that.bedtimeEstimate,_that.reason,_that.subtitle,_that.confidenceLevel,_that.confidenceDots,_that.planSteps,_that.hasRealLogs,_that.healthCaveat);case _:
  return null;

}
}

}

/// @nodoc


class _SleepForecastState implements SleepForecastState {
  const _SleepForecastState({this.isLoading = false, this.selectedDayIndex = 0, this.parentName = 'Parent', this.childName = 'your child', this.timeOfDayGreeting = 'GOOD EVENING', this.windowStart = '07:45 PM', this.windowEnd = '08:15 PM', this.bedtimeEstimate = '08:10 PM', this.reason = "Today's rest indicates normal wake pressure.", this.subtitle = 'Bedtime estimate 08:10 PM. Moderate confidence.', this.confidenceLevel = 'Moderate', this.confidenceDots = 2,  List<TonightPlanStep> planSteps = const [], this.hasRealLogs = false, this.healthCaveat}): _planSteps = planSteps;
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  int selectedDayIndex;
@override@JsonKey() final  String parentName;
@override@JsonKey() final  String childName;
@override@JsonKey() final  String timeOfDayGreeting;
@override@JsonKey() final  String windowStart;
@override@JsonKey() final  String windowEnd;
@override@JsonKey() final  String bedtimeEstimate;
@override@JsonKey() final  String reason;
@override@JsonKey() final  String subtitle;
@override@JsonKey() final  String confidenceLevel;
@override@JsonKey() final  int confidenceDots;
 final  List<TonightPlanStep> _planSteps;
@override@JsonKey() List<TonightPlanStep> get planSteps {
  if (_planSteps is EqualUnmodifiableListView) return _planSteps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_planSteps);
}

@override@JsonKey() final  bool hasRealLogs;
@override final  String? healthCaveat;

/// Create a copy of SleepForecastState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SleepForecastStateCopyWith<_SleepForecastState> get copyWith => __$SleepForecastStateCopyWithImpl<_SleepForecastState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SleepForecastState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.selectedDayIndex, selectedDayIndex) || other.selectedDayIndex == selectedDayIndex)&&(identical(other.parentName, parentName) || other.parentName == parentName)&&(identical(other.childName, childName) || other.childName == childName)&&(identical(other.timeOfDayGreeting, timeOfDayGreeting) || other.timeOfDayGreeting == timeOfDayGreeting)&&(identical(other.windowStart, windowStart) || other.windowStart == windowStart)&&(identical(other.windowEnd, windowEnd) || other.windowEnd == windowEnd)&&(identical(other.bedtimeEstimate, bedtimeEstimate) || other.bedtimeEstimate == bedtimeEstimate)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.confidenceLevel, confidenceLevel) || other.confidenceLevel == confidenceLevel)&&(identical(other.confidenceDots, confidenceDots) || other.confidenceDots == confidenceDots)&&const DeepCollectionEquality().equals(other.planSteps, _planSteps)&&(identical(other.hasRealLogs, hasRealLogs) || other.hasRealLogs == hasRealLogs)&&(identical(other.healthCaveat, healthCaveat) || other.healthCaveat == healthCaveat));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isLoading,selectedDayIndex,parentName,childName,timeOfDayGreeting,windowStart,windowEnd,bedtimeEstimate,reason,subtitle,confidenceLevel,confidenceDots,const DeepCollectionEquality().hash(_planSteps),hasRealLogs,healthCaveat);
}

@override
String toString() {
    return 'SleepForecastState(isLoading: $isLoading, selectedDayIndex: $selectedDayIndex, parentName: $parentName, childName: $childName, timeOfDayGreeting: $timeOfDayGreeting, windowStart: $windowStart, windowEnd: $windowEnd, bedtimeEstimate: $bedtimeEstimate, reason: $reason, subtitle: $subtitle, confidenceLevel: $confidenceLevel, confidenceDots: $confidenceDots, planSteps: $planSteps, hasRealLogs: $hasRealLogs, healthCaveat: $healthCaveat)';
}


}

/// @nodoc
abstract mixin class _$SleepForecastStateCopyWith<$Res> implements $SleepForecastStateCopyWith<$Res> {
  factory _$SleepForecastStateCopyWith(_SleepForecastState value, $Res Function(_SleepForecastState) _then) = __$SleepForecastStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, int selectedDayIndex, String parentName, String childName, String timeOfDayGreeting, String windowStart, String windowEnd, String bedtimeEstimate, String reason, String subtitle, String confidenceLevel, int confidenceDots, List<TonightPlanStep> planSteps, bool hasRealLogs, String? healthCaveat
});




}
/// @nodoc
class __$SleepForecastStateCopyWithImpl<$Res>
    implements _$SleepForecastStateCopyWith<$Res> {
  __$SleepForecastStateCopyWithImpl(this._self, this._then);

  final _SleepForecastState _self;
  final $Res Function(_SleepForecastState) _then;

/// Create a copy of SleepForecastState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? selectedDayIndex = null,Object? parentName = null,Object? childName = null,Object? timeOfDayGreeting = null,Object? windowStart = null,Object? windowEnd = null,Object? bedtimeEstimate = null,Object? reason = null,Object? subtitle = null,Object? confidenceLevel = null,Object? confidenceDots = null,Object? planSteps = null,Object? hasRealLogs = null,Object? healthCaveat = freezed,}) {
  return _then(_SleepForecastState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,selectedDayIndex: null == selectedDayIndex ? _self.selectedDayIndex : selectedDayIndex // ignore: cast_nullable_to_non_nullable
as int,parentName: null == parentName ? _self.parentName : parentName // ignore: cast_nullable_to_non_nullable
as String,childName: null == childName ? _self.childName : childName // ignore: cast_nullable_to_non_nullable
as String,timeOfDayGreeting: null == timeOfDayGreeting ? _self.timeOfDayGreeting : timeOfDayGreeting // ignore: cast_nullable_to_non_nullable
as String,windowStart: null == windowStart ? _self.windowStart : windowStart // ignore: cast_nullable_to_non_nullable
as String,windowEnd: null == windowEnd ? _self.windowEnd : windowEnd // ignore: cast_nullable_to_non_nullable
as String,bedtimeEstimate: null == bedtimeEstimate ? _self.bedtimeEstimate : bedtimeEstimate // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,confidenceLevel: null == confidenceLevel ? _self.confidenceLevel : confidenceLevel // ignore: cast_nullable_to_non_nullable
as String,confidenceDots: null == confidenceDots ? _self.confidenceDots : confidenceDots // ignore: cast_nullable_to_non_nullable
as int,planSteps: null == planSteps ? _self._planSteps : planSteps // ignore: cast_nullable_to_non_nullable
as List<TonightPlanStep>,hasRealLogs: null == hasRealLogs ? _self.hasRealLogs : hasRealLogs // ignore: cast_nullable_to_non_nullable
as bool,healthCaveat: freezed == healthCaveat ? _self.healthCaveat : healthCaveat // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
