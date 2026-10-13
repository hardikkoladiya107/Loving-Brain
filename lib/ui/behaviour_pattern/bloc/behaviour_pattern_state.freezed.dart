// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'behaviour_pattern_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BehaviourPatternState {

 bool get isLoading; ApiResultStatus<dynamic> get fetchStatus; BehaviourPatternSummary? get summary; int get totalTantrums; String get mostCommonTimeWindow; List<String> get topTriggers; List<String> get topHelpedStrategies; double get averageIntensity; String get insightText; String get childName;
/// Create a copy of BehaviourPatternState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BehaviourPatternStateCopyWith<BehaviourPatternState> get copyWith => _$BehaviourPatternStateCopyWithImpl<BehaviourPatternState>(this as BehaviourPatternState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BehaviourPatternState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BehaviourPatternState&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.fetchStatus, _this.fetchStatus) || other.fetchStatus == _this.fetchStatus)&&(identical(other.summary, _this.summary) || other.summary == _this.summary)&&(identical(other.totalTantrums, _this.totalTantrums) || other.totalTantrums == _this.totalTantrums)&&(identical(other.mostCommonTimeWindow, _this.mostCommonTimeWindow) || other.mostCommonTimeWindow == _this.mostCommonTimeWindow)&&const DeepCollectionEquality().equals(other.topTriggers, _this.topTriggers)&&const DeepCollectionEquality().equals(other.topHelpedStrategies, _this.topHelpedStrategies)&&(identical(other.averageIntensity, _this.averageIntensity) || other.averageIntensity == _this.averageIntensity)&&(identical(other.insightText, _this.insightText) || other.insightText == _this.insightText)&&(identical(other.childName, _this.childName) || other.childName == _this.childName));
}


@override
int get hashCode {
  final _this = this as BehaviourPatternState;
  return Object.hash(runtimeType,_this.isLoading,_this.fetchStatus,_this.summary,_this.totalTantrums,_this.mostCommonTimeWindow,const DeepCollectionEquality().hash(_this.topTriggers),const DeepCollectionEquality().hash(_this.topHelpedStrategies),_this.averageIntensity,_this.insightText,_this.childName);
}

@override
String toString() {
  final _this = this as BehaviourPatternState;
  return 'BehaviourPatternState(isLoading: ${_this.isLoading}, fetchStatus: ${_this.fetchStatus}, summary: ${_this.summary}, totalTantrums: ${_this.totalTantrums}, mostCommonTimeWindow: ${_this.mostCommonTimeWindow}, topTriggers: ${_this.topTriggers}, topHelpedStrategies: ${_this.topHelpedStrategies}, averageIntensity: ${_this.averageIntensity}, insightText: ${_this.insightText}, childName: ${_this.childName})';
}


}

/// @nodoc
abstract mixin class $BehaviourPatternStateCopyWith<$Res>  {
  factory $BehaviourPatternStateCopyWith(BehaviourPatternState value, $Res Function(BehaviourPatternState) _then) = _$BehaviourPatternStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, ApiResultStatus<dynamic> fetchStatus, BehaviourPatternSummary? summary, int totalTantrums, String mostCommonTimeWindow, List<String> topTriggers, List<String> topHelpedStrategies, double averageIntensity, String insightText, String childName
});


$ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus;

}
/// @nodoc
class _$BehaviourPatternStateCopyWithImpl<$Res>
    implements $BehaviourPatternStateCopyWith<$Res> {
  _$BehaviourPatternStateCopyWithImpl(this._self, this._then);

  final BehaviourPatternState _self;
  final $Res Function(BehaviourPatternState) _then;

/// Create a copy of BehaviourPatternState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? fetchStatus = null,Object? summary = freezed,Object? totalTantrums = null,Object? mostCommonTimeWindow = null,Object? topTriggers = null,Object? topHelpedStrategies = null,Object? averageIntensity = null,Object? insightText = null,Object? childName = null,}) {
  return _then(BehaviourPatternState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,fetchStatus: null == fetchStatus ? _self.fetchStatus : fetchStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as BehaviourPatternSummary?,totalTantrums: null == totalTantrums ? _self.totalTantrums : totalTantrums // ignore: cast_nullable_to_non_nullable
as int,mostCommonTimeWindow: null == mostCommonTimeWindow ? _self.mostCommonTimeWindow : mostCommonTimeWindow // ignore: cast_nullable_to_non_nullable
as String,topTriggers: null == topTriggers ? _self.topTriggers : topTriggers // ignore: cast_nullable_to_non_nullable
as List<String>,topHelpedStrategies: null == topHelpedStrategies ? _self.topHelpedStrategies : topHelpedStrategies // ignore: cast_nullable_to_non_nullable
as List<String>,averageIntensity: null == averageIntensity ? _self.averageIntensity : averageIntensity // ignore: cast_nullable_to_non_nullable
as double,insightText: null == insightText ? _self.insightText : insightText // ignore: cast_nullable_to_non_nullable
as String,childName: null == childName ? _self.childName : childName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of BehaviourPatternState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.fetchStatus, (value) {
    return _then(_self.copyWith(fetchStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [BehaviourPatternState].
extension BehaviourPatternStatePatterns on BehaviourPatternState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BehaviourPatternState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BehaviourPatternState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BehaviourPatternState value)  $default,){
final _that = this;
switch (_that) {
case _BehaviourPatternState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BehaviourPatternState value)?  $default,){
final _that = this;
switch (_that) {
case _BehaviourPatternState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  ApiResultStatus<dynamic> fetchStatus,  BehaviourPatternSummary? summary,  int totalTantrums,  String mostCommonTimeWindow,  List<String> topTriggers,  List<String> topHelpedStrategies,  double averageIntensity,  String insightText,  String childName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BehaviourPatternState() when $default != null:
return $default(_that.isLoading,_that.fetchStatus,_that.summary,_that.totalTantrums,_that.mostCommonTimeWindow,_that.topTriggers,_that.topHelpedStrategies,_that.averageIntensity,_that.insightText,_that.childName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  ApiResultStatus<dynamic> fetchStatus,  BehaviourPatternSummary? summary,  int totalTantrums,  String mostCommonTimeWindow,  List<String> topTriggers,  List<String> topHelpedStrategies,  double averageIntensity,  String insightText,  String childName)  $default,) {final _that = this;
switch (_that) {
case _BehaviourPatternState():
return $default(_that.isLoading,_that.fetchStatus,_that.summary,_that.totalTantrums,_that.mostCommonTimeWindow,_that.topTriggers,_that.topHelpedStrategies,_that.averageIntensity,_that.insightText,_that.childName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  ApiResultStatus<dynamic> fetchStatus,  BehaviourPatternSummary? summary,  int totalTantrums,  String mostCommonTimeWindow,  List<String> topTriggers,  List<String> topHelpedStrategies,  double averageIntensity,  String insightText,  String childName)?  $default,) {final _that = this;
switch (_that) {
case _BehaviourPatternState() when $default != null:
return $default(_that.isLoading,_that.fetchStatus,_that.summary,_that.totalTantrums,_that.mostCommonTimeWindow,_that.topTriggers,_that.topHelpedStrategies,_that.averageIntensity,_that.insightText,_that.childName);case _:
  return null;

}
}

}

/// @nodoc


class _BehaviourPatternState implements BehaviourPatternState {
  const _BehaviourPatternState({this.isLoading = false, this.fetchStatus = const ApiResultStatus.initial(), this.summary, this.totalTantrums = 0, this.mostCommonTimeWindow = '5:00 PM – 7:00 PM',  List<String> topTriggers = const <String>['Tiredness', 'Transitions'],  List<String> topHelpedStrategies = const <String>['Lowering stimulation', 'Quiet connection'], this.averageIntensity = 0.5, this.insightText = 'Harder moments most often follow tiredness and transition load.', this.childName = 'your child'}): _topTriggers = topTriggers,_topHelpedStrategies = topHelpedStrategies;
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  ApiResultStatus<dynamic> fetchStatus;
@override final  BehaviourPatternSummary? summary;
@override@JsonKey() final  int totalTantrums;
@override@JsonKey() final  String mostCommonTimeWindow;
 final  List<String> _topTriggers;
@override@JsonKey() List<String> get topTriggers {
  if (_topTriggers is EqualUnmodifiableListView) return _topTriggers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topTriggers);
}

 final  List<String> _topHelpedStrategies;
@override@JsonKey() List<String> get topHelpedStrategies {
  if (_topHelpedStrategies is EqualUnmodifiableListView) return _topHelpedStrategies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topHelpedStrategies);
}

@override@JsonKey() final  double averageIntensity;
@override@JsonKey() final  String insightText;
@override@JsonKey() final  String childName;

/// Create a copy of BehaviourPatternState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BehaviourPatternStateCopyWith<_BehaviourPatternState> get copyWith => __$BehaviourPatternStateCopyWithImpl<_BehaviourPatternState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BehaviourPatternState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.fetchStatus, fetchStatus) || other.fetchStatus == fetchStatus)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.totalTantrums, totalTantrums) || other.totalTantrums == totalTantrums)&&(identical(other.mostCommonTimeWindow, mostCommonTimeWindow) || other.mostCommonTimeWindow == mostCommonTimeWindow)&&const DeepCollectionEquality().equals(other.topTriggers, _topTriggers)&&const DeepCollectionEquality().equals(other.topHelpedStrategies, _topHelpedStrategies)&&(identical(other.averageIntensity, averageIntensity) || other.averageIntensity == averageIntensity)&&(identical(other.insightText, insightText) || other.insightText == insightText)&&(identical(other.childName, childName) || other.childName == childName));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isLoading,fetchStatus,summary,totalTantrums,mostCommonTimeWindow,const DeepCollectionEquality().hash(_topTriggers),const DeepCollectionEquality().hash(_topHelpedStrategies),averageIntensity,insightText,childName);
}

@override
String toString() {
    return 'BehaviourPatternState(isLoading: $isLoading, fetchStatus: $fetchStatus, summary: $summary, totalTantrums: $totalTantrums, mostCommonTimeWindow: $mostCommonTimeWindow, topTriggers: $topTriggers, topHelpedStrategies: $topHelpedStrategies, averageIntensity: $averageIntensity, insightText: $insightText, childName: $childName)';
}


}

/// @nodoc
abstract mixin class _$BehaviourPatternStateCopyWith<$Res> implements $BehaviourPatternStateCopyWith<$Res> {
  factory _$BehaviourPatternStateCopyWith(_BehaviourPatternState value, $Res Function(_BehaviourPatternState) _then) = __$BehaviourPatternStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, ApiResultStatus<dynamic> fetchStatus, BehaviourPatternSummary? summary, int totalTantrums, String mostCommonTimeWindow, List<String> topTriggers, List<String> topHelpedStrategies, double averageIntensity, String insightText, String childName
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus;

}
/// @nodoc
class __$BehaviourPatternStateCopyWithImpl<$Res>
    implements _$BehaviourPatternStateCopyWith<$Res> {
  __$BehaviourPatternStateCopyWithImpl(this._self, this._then);

  final _BehaviourPatternState _self;
  final $Res Function(_BehaviourPatternState) _then;

/// Create a copy of BehaviourPatternState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? fetchStatus = null,Object? summary = freezed,Object? totalTantrums = null,Object? mostCommonTimeWindow = null,Object? topTriggers = null,Object? topHelpedStrategies = null,Object? averageIntensity = null,Object? insightText = null,Object? childName = null,}) {
  return _then(_BehaviourPatternState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,fetchStatus: null == fetchStatus ? _self.fetchStatus : fetchStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as BehaviourPatternSummary?,totalTantrums: null == totalTantrums ? _self.totalTantrums : totalTantrums // ignore: cast_nullable_to_non_nullable
as int,mostCommonTimeWindow: null == mostCommonTimeWindow ? _self.mostCommonTimeWindow : mostCommonTimeWindow // ignore: cast_nullable_to_non_nullable
as String,topTriggers: null == topTriggers ? _self._topTriggers : topTriggers // ignore: cast_nullable_to_non_nullable
as List<String>,topHelpedStrategies: null == topHelpedStrategies ? _self._topHelpedStrategies : topHelpedStrategies // ignore: cast_nullable_to_non_nullable
as List<String>,averageIntensity: null == averageIntensity ? _self.averageIntensity : averageIntensity // ignore: cast_nullable_to_non_nullable
as double,insightText: null == insightText ? _self.insightText : insightText // ignore: cast_nullable_to_non_nullable
as String,childName: null == childName ? _self.childName : childName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of BehaviourPatternState
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
