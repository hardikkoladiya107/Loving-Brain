// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calm_heads_up_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CalmHeadsUpState {

 bool get isLoading; ApiResultStatus<dynamic> get fetchStatus; BehaviourForecastResult? get forecast; String get childName; String get headline; String get reason; String get windowStart; String get windowEnd; int get confidenceDots; String get confidenceLabel; List<String> get contributingSignals; String? get healthCaveat;
/// Create a copy of CalmHeadsUpState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CalmHeadsUpStateCopyWith<CalmHeadsUpState> get copyWith => _$CalmHeadsUpStateCopyWithImpl<CalmHeadsUpState>(this as CalmHeadsUpState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CalmHeadsUpState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CalmHeadsUpState&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.fetchStatus, _this.fetchStatus) || other.fetchStatus == _this.fetchStatus)&&(identical(other.forecast, _this.forecast) || other.forecast == _this.forecast)&&(identical(other.childName, _this.childName) || other.childName == _this.childName)&&(identical(other.headline, _this.headline) || other.headline == _this.headline)&&(identical(other.reason, _this.reason) || other.reason == _this.reason)&&(identical(other.windowStart, _this.windowStart) || other.windowStart == _this.windowStart)&&(identical(other.windowEnd, _this.windowEnd) || other.windowEnd == _this.windowEnd)&&(identical(other.confidenceDots, _this.confidenceDots) || other.confidenceDots == _this.confidenceDots)&&(identical(other.confidenceLabel, _this.confidenceLabel) || other.confidenceLabel == _this.confidenceLabel)&&const DeepCollectionEquality().equals(other.contributingSignals, _this.contributingSignals)&&(identical(other.healthCaveat, _this.healthCaveat) || other.healthCaveat == _this.healthCaveat));
}


@override
int get hashCode {
  final _this = this as CalmHeadsUpState;
  return Object.hash(runtimeType,_this.isLoading,_this.fetchStatus,_this.forecast,_this.childName,_this.headline,_this.reason,_this.windowStart,_this.windowEnd,_this.confidenceDots,_this.confidenceLabel,const DeepCollectionEquality().hash(_this.contributingSignals),_this.healthCaveat);
}

@override
String toString() {
  final _this = this as CalmHeadsUpState;
  return 'CalmHeadsUpState(isLoading: ${_this.isLoading}, fetchStatus: ${_this.fetchStatus}, forecast: ${_this.forecast}, childName: ${_this.childName}, headline: ${_this.headline}, reason: ${_this.reason}, windowStart: ${_this.windowStart}, windowEnd: ${_this.windowEnd}, confidenceDots: ${_this.confidenceDots}, confidenceLabel: ${_this.confidenceLabel}, contributingSignals: ${_this.contributingSignals}, healthCaveat: ${_this.healthCaveat})';
}


}

/// @nodoc
abstract mixin class $CalmHeadsUpStateCopyWith<$Res>  {
  factory $CalmHeadsUpStateCopyWith(CalmHeadsUpState value, $Res Function(CalmHeadsUpState) _then) = _$CalmHeadsUpStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, ApiResultStatus<dynamic> fetchStatus, BehaviourForecastResult? forecast, String childName, String headline, String reason, String windowStart, String windowEnd, int confidenceDots, String confidenceLabel, List<String> contributingSignals, String? healthCaveat
});


$ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus;

}
/// @nodoc
class _$CalmHeadsUpStateCopyWithImpl<$Res>
    implements $CalmHeadsUpStateCopyWith<$Res> {
  _$CalmHeadsUpStateCopyWithImpl(this._self, this._then);

  final CalmHeadsUpState _self;
  final $Res Function(CalmHeadsUpState) _then;

/// Create a copy of CalmHeadsUpState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? fetchStatus = null,Object? forecast = freezed,Object? childName = null,Object? headline = null,Object? reason = null,Object? windowStart = null,Object? windowEnd = null,Object? confidenceDots = null,Object? confidenceLabel = null,Object? contributingSignals = null,Object? healthCaveat = freezed,}) {
  return _then(CalmHeadsUpState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,fetchStatus: null == fetchStatus ? _self.fetchStatus : fetchStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,forecast: freezed == forecast ? _self.forecast : forecast // ignore: cast_nullable_to_non_nullable
as BehaviourForecastResult?,childName: null == childName ? _self.childName : childName // ignore: cast_nullable_to_non_nullable
as String,headline: null == headline ? _self.headline : headline // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,windowStart: null == windowStart ? _self.windowStart : windowStart // ignore: cast_nullable_to_non_nullable
as String,windowEnd: null == windowEnd ? _self.windowEnd : windowEnd // ignore: cast_nullable_to_non_nullable
as String,confidenceDots: null == confidenceDots ? _self.confidenceDots : confidenceDots // ignore: cast_nullable_to_non_nullable
as int,confidenceLabel: null == confidenceLabel ? _self.confidenceLabel : confidenceLabel // ignore: cast_nullable_to_non_nullable
as String,contributingSignals: null == contributingSignals ? _self.contributingSignals : contributingSignals // ignore: cast_nullable_to_non_nullable
as List<String>,healthCaveat: freezed == healthCaveat ? _self.healthCaveat : healthCaveat // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of CalmHeadsUpState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.fetchStatus, (value) {
    return _then(_self.copyWith(fetchStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [CalmHeadsUpState].
extension CalmHeadsUpStatePatterns on CalmHeadsUpState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CalmHeadsUpState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CalmHeadsUpState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CalmHeadsUpState value)  $default,){
final _that = this;
switch (_that) {
case _CalmHeadsUpState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CalmHeadsUpState value)?  $default,){
final _that = this;
switch (_that) {
case _CalmHeadsUpState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  ApiResultStatus<dynamic> fetchStatus,  BehaviourForecastResult? forecast,  String childName,  String headline,  String reason,  String windowStart,  String windowEnd,  int confidenceDots,  String confidenceLabel,  List<String> contributingSignals,  String? healthCaveat)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CalmHeadsUpState() when $default != null:
return $default(_that.isLoading,_that.fetchStatus,_that.forecast,_that.childName,_that.headline,_that.reason,_that.windowStart,_that.windowEnd,_that.confidenceDots,_that.confidenceLabel,_that.contributingSignals,_that.healthCaveat);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  ApiResultStatus<dynamic> fetchStatus,  BehaviourForecastResult? forecast,  String childName,  String headline,  String reason,  String windowStart,  String windowEnd,  int confidenceDots,  String confidenceLabel,  List<String> contributingSignals,  String? healthCaveat)  $default,) {final _that = this;
switch (_that) {
case _CalmHeadsUpState():
return $default(_that.isLoading,_that.fetchStatus,_that.forecast,_that.childName,_that.headline,_that.reason,_that.windowStart,_that.windowEnd,_that.confidenceDots,_that.confidenceLabel,_that.contributingSignals,_that.healthCaveat);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  ApiResultStatus<dynamic> fetchStatus,  BehaviourForecastResult? forecast,  String childName,  String headline,  String reason,  String windowStart,  String windowEnd,  int confidenceDots,  String confidenceLabel,  List<String> contributingSignals,  String? healthCaveat)?  $default,) {final _that = this;
switch (_that) {
case _CalmHeadsUpState() when $default != null:
return $default(_that.isLoading,_that.fetchStatus,_that.forecast,_that.childName,_that.headline,_that.reason,_that.windowStart,_that.windowEnd,_that.confidenceDots,_that.confidenceLabel,_that.contributingSignals,_that.healthCaveat);case _:
  return null;

}
}

}

/// @nodoc


class _CalmHeadsUpState implements CalmHeadsUpState {
  const _CalmHeadsUpState({this.isLoading = false, this.fetchStatus = const ApiResultStatus.initial(), this.forecast, this.childName = 'your child', this.headline = 'A harder window may be more likely', this.reason = 'Between 5:30 and 7:00 PM — sensory load and transition today.', this.windowStart = '5:30 PM', this.windowEnd = '7:00 PM', this.confidenceDots = 2, this.confidenceLabel = 'Confidence: moderate',  List<String> contributingSignals = const <String>[], this.healthCaveat}): _contributingSignals = contributingSignals;
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  ApiResultStatus<dynamic> fetchStatus;
@override final  BehaviourForecastResult? forecast;
@override@JsonKey() final  String childName;
@override@JsonKey() final  String headline;
@override@JsonKey() final  String reason;
@override@JsonKey() final  String windowStart;
@override@JsonKey() final  String windowEnd;
@override@JsonKey() final  int confidenceDots;
@override@JsonKey() final  String confidenceLabel;
 final  List<String> _contributingSignals;
@override@JsonKey() List<String> get contributingSignals {
  if (_contributingSignals is EqualUnmodifiableListView) return _contributingSignals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_contributingSignals);
}

@override final  String? healthCaveat;

/// Create a copy of CalmHeadsUpState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CalmHeadsUpStateCopyWith<_CalmHeadsUpState> get copyWith => __$CalmHeadsUpStateCopyWithImpl<_CalmHeadsUpState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CalmHeadsUpState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.fetchStatus, fetchStatus) || other.fetchStatus == fetchStatus)&&(identical(other.forecast, forecast) || other.forecast == forecast)&&(identical(other.childName, childName) || other.childName == childName)&&(identical(other.headline, headline) || other.headline == headline)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.windowStart, windowStart) || other.windowStart == windowStart)&&(identical(other.windowEnd, windowEnd) || other.windowEnd == windowEnd)&&(identical(other.confidenceDots, confidenceDots) || other.confidenceDots == confidenceDots)&&(identical(other.confidenceLabel, confidenceLabel) || other.confidenceLabel == confidenceLabel)&&const DeepCollectionEquality().equals(other.contributingSignals, _contributingSignals)&&(identical(other.healthCaveat, healthCaveat) || other.healthCaveat == healthCaveat));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isLoading,fetchStatus,forecast,childName,headline,reason,windowStart,windowEnd,confidenceDots,confidenceLabel,const DeepCollectionEquality().hash(_contributingSignals),healthCaveat);
}

@override
String toString() {
    return 'CalmHeadsUpState(isLoading: $isLoading, fetchStatus: $fetchStatus, forecast: $forecast, childName: $childName, headline: $headline, reason: $reason, windowStart: $windowStart, windowEnd: $windowEnd, confidenceDots: $confidenceDots, confidenceLabel: $confidenceLabel, contributingSignals: $contributingSignals, healthCaveat: $healthCaveat)';
}


}

/// @nodoc
abstract mixin class _$CalmHeadsUpStateCopyWith<$Res> implements $CalmHeadsUpStateCopyWith<$Res> {
  factory _$CalmHeadsUpStateCopyWith(_CalmHeadsUpState value, $Res Function(_CalmHeadsUpState) _then) = __$CalmHeadsUpStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, ApiResultStatus<dynamic> fetchStatus, BehaviourForecastResult? forecast, String childName, String headline, String reason, String windowStart, String windowEnd, int confidenceDots, String confidenceLabel, List<String> contributingSignals, String? healthCaveat
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus;

}
/// @nodoc
class __$CalmHeadsUpStateCopyWithImpl<$Res>
    implements _$CalmHeadsUpStateCopyWith<$Res> {
  __$CalmHeadsUpStateCopyWithImpl(this._self, this._then);

  final _CalmHeadsUpState _self;
  final $Res Function(_CalmHeadsUpState) _then;

/// Create a copy of CalmHeadsUpState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? fetchStatus = null,Object? forecast = freezed,Object? childName = null,Object? headline = null,Object? reason = null,Object? windowStart = null,Object? windowEnd = null,Object? confidenceDots = null,Object? confidenceLabel = null,Object? contributingSignals = null,Object? healthCaveat = freezed,}) {
  return _then(_CalmHeadsUpState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,fetchStatus: null == fetchStatus ? _self.fetchStatus : fetchStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,forecast: freezed == forecast ? _self.forecast : forecast // ignore: cast_nullable_to_non_nullable
as BehaviourForecastResult?,childName: null == childName ? _self.childName : childName // ignore: cast_nullable_to_non_nullable
as String,headline: null == headline ? _self.headline : headline // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,windowStart: null == windowStart ? _self.windowStart : windowStart // ignore: cast_nullable_to_non_nullable
as String,windowEnd: null == windowEnd ? _self.windowEnd : windowEnd // ignore: cast_nullable_to_non_nullable
as String,confidenceDots: null == confidenceDots ? _self.confidenceDots : confidenceDots // ignore: cast_nullable_to_non_nullable
as int,confidenceLabel: null == confidenceLabel ? _self.confidenceLabel : confidenceLabel // ignore: cast_nullable_to_non_nullable
as String,contributingSignals: null == contributingSignals ? _self._contributingSignals : contributingSignals // ignore: cast_nullable_to_non_nullable
as List<String>,healthCaveat: freezed == healthCaveat ? _self.healthCaveat : healthCaveat // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of CalmHeadsUpState
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
