// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calm_plan_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CalmPlanState {

 bool get isLoading; bool get isAudioPlaying; ApiResultStatus<dynamic> get fetchStatus; BehaviourForecastResult? get forecast; List<CalmPlanAction> get actions; String get avoidInstructionTitle; String get avoidInstructionSubtitle; String get childName;
/// Create a copy of CalmPlanState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CalmPlanStateCopyWith<CalmPlanState> get copyWith => _$CalmPlanStateCopyWithImpl<CalmPlanState>(this as CalmPlanState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CalmPlanState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CalmPlanState&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.isAudioPlaying, _this.isAudioPlaying) || other.isAudioPlaying == _this.isAudioPlaying)&&(identical(other.fetchStatus, _this.fetchStatus) || other.fetchStatus == _this.fetchStatus)&&(identical(other.forecast, _this.forecast) || other.forecast == _this.forecast)&&const DeepCollectionEquality().equals(other.actions, _this.actions)&&(identical(other.avoidInstructionTitle, _this.avoidInstructionTitle) || other.avoidInstructionTitle == _this.avoidInstructionTitle)&&(identical(other.avoidInstructionSubtitle, _this.avoidInstructionSubtitle) || other.avoidInstructionSubtitle == _this.avoidInstructionSubtitle)&&(identical(other.childName, _this.childName) || other.childName == _this.childName));
}


@override
int get hashCode {
  final _this = this as CalmPlanState;
  return Object.hash(runtimeType,_this.isLoading,_this.isAudioPlaying,_this.fetchStatus,_this.forecast,const DeepCollectionEquality().hash(_this.actions),_this.avoidInstructionTitle,_this.avoidInstructionSubtitle,_this.childName);
}

@override
String toString() {
  final _this = this as CalmPlanState;
  return 'CalmPlanState(isLoading: ${_this.isLoading}, isAudioPlaying: ${_this.isAudioPlaying}, fetchStatus: ${_this.fetchStatus}, forecast: ${_this.forecast}, actions: ${_this.actions}, avoidInstructionTitle: ${_this.avoidInstructionTitle}, avoidInstructionSubtitle: ${_this.avoidInstructionSubtitle}, childName: ${_this.childName})';
}


}

/// @nodoc
abstract mixin class $CalmPlanStateCopyWith<$Res>  {
  factory $CalmPlanStateCopyWith(CalmPlanState value, $Res Function(CalmPlanState) _then) = _$CalmPlanStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool isAudioPlaying, ApiResultStatus<dynamic> fetchStatus, BehaviourForecastResult? forecast, List<CalmPlanAction> actions, String avoidInstructionTitle, String avoidInstructionSubtitle, String childName
});


$ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus;

}
/// @nodoc
class _$CalmPlanStateCopyWithImpl<$Res>
    implements $CalmPlanStateCopyWith<$Res> {
  _$CalmPlanStateCopyWithImpl(this._self, this._then);

  final CalmPlanState _self;
  final $Res Function(CalmPlanState) _then;

/// Create a copy of CalmPlanState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? isAudioPlaying = null,Object? fetchStatus = null,Object? forecast = freezed,Object? actions = null,Object? avoidInstructionTitle = null,Object? avoidInstructionSubtitle = null,Object? childName = null,}) {
  return _then(CalmPlanState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isAudioPlaying: null == isAudioPlaying ? _self.isAudioPlaying : isAudioPlaying // ignore: cast_nullable_to_non_nullable
as bool,fetchStatus: null == fetchStatus ? _self.fetchStatus : fetchStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,forecast: freezed == forecast ? _self.forecast : forecast // ignore: cast_nullable_to_non_nullable
as BehaviourForecastResult?,actions: null == actions ? _self.actions : actions // ignore: cast_nullable_to_non_nullable
as List<CalmPlanAction>,avoidInstructionTitle: null == avoidInstructionTitle ? _self.avoidInstructionTitle : avoidInstructionTitle // ignore: cast_nullable_to_non_nullable
as String,avoidInstructionSubtitle: null == avoidInstructionSubtitle ? _self.avoidInstructionSubtitle : avoidInstructionSubtitle // ignore: cast_nullable_to_non_nullable
as String,childName: null == childName ? _self.childName : childName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of CalmPlanState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.fetchStatus, (value) {
    return _then(_self.copyWith(fetchStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [CalmPlanState].
extension CalmPlanStatePatterns on CalmPlanState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CalmPlanState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CalmPlanState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CalmPlanState value)  $default,){
final _that = this;
switch (_that) {
case _CalmPlanState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CalmPlanState value)?  $default,){
final _that = this;
switch (_that) {
case _CalmPlanState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool isAudioPlaying,  ApiResultStatus<dynamic> fetchStatus,  BehaviourForecastResult? forecast,  List<CalmPlanAction> actions,  String avoidInstructionTitle,  String avoidInstructionSubtitle,  String childName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CalmPlanState() when $default != null:
return $default(_that.isLoading,_that.isAudioPlaying,_that.fetchStatus,_that.forecast,_that.actions,_that.avoidInstructionTitle,_that.avoidInstructionSubtitle,_that.childName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool isAudioPlaying,  ApiResultStatus<dynamic> fetchStatus,  BehaviourForecastResult? forecast,  List<CalmPlanAction> actions,  String avoidInstructionTitle,  String avoidInstructionSubtitle,  String childName)  $default,) {final _that = this;
switch (_that) {
case _CalmPlanState():
return $default(_that.isLoading,_that.isAudioPlaying,_that.fetchStatus,_that.forecast,_that.actions,_that.avoidInstructionTitle,_that.avoidInstructionSubtitle,_that.childName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool isAudioPlaying,  ApiResultStatus<dynamic> fetchStatus,  BehaviourForecastResult? forecast,  List<CalmPlanAction> actions,  String avoidInstructionTitle,  String avoidInstructionSubtitle,  String childName)?  $default,) {final _that = this;
switch (_that) {
case _CalmPlanState() when $default != null:
return $default(_that.isLoading,_that.isAudioPlaying,_that.fetchStatus,_that.forecast,_that.actions,_that.avoidInstructionTitle,_that.avoidInstructionSubtitle,_that.childName);case _:
  return null;

}
}

}

/// @nodoc


class _CalmPlanState implements CalmPlanState {
  const _CalmPlanState({this.isLoading = false, this.isAudioPlaying = false, this.fetchStatus = const ApiResultStatus.initial(), this.forecast,  List<CalmPlanAction> actions = const <CalmPlanAction>[CalmPlanAction(stepNumber: '1', title: 'Lower stimulation now', description: 'Dim the room, turn off background noise, and pause high-energy play.'), CalmPlanAction(stepNumber: '2', title: 'Offer a quiet, familiar activity', description: 'Choose something familiar without demands.'), CalmPlanAction(stepNumber: '3', title: 'Stay close and steady', description: 'Your calm physical presence is the clearest safety signal.')], this.avoidInstructionTitle = "Don't introduce a new demand right now", this.avoidInstructionSubtitle = 'Requests, transitions, and boundary debates can wait until your child has settled.', this.childName = 'your child'}): _actions = actions;
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isAudioPlaying;
@override@JsonKey() final  ApiResultStatus<dynamic> fetchStatus;
@override final  BehaviourForecastResult? forecast;
 final  List<CalmPlanAction> _actions;
@override@JsonKey() List<CalmPlanAction> get actions {
  if (_actions is EqualUnmodifiableListView) return _actions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_actions);
}

@override@JsonKey() final  String avoidInstructionTitle;
@override@JsonKey() final  String avoidInstructionSubtitle;
@override@JsonKey() final  String childName;

/// Create a copy of CalmPlanState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CalmPlanStateCopyWith<_CalmPlanState> get copyWith => __$CalmPlanStateCopyWithImpl<_CalmPlanState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CalmPlanState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isAudioPlaying, isAudioPlaying) || other.isAudioPlaying == isAudioPlaying)&&(identical(other.fetchStatus, fetchStatus) || other.fetchStatus == fetchStatus)&&(identical(other.forecast, forecast) || other.forecast == forecast)&&const DeepCollectionEquality().equals(other.actions, _actions)&&(identical(other.avoidInstructionTitle, avoidInstructionTitle) || other.avoidInstructionTitle == avoidInstructionTitle)&&(identical(other.avoidInstructionSubtitle, avoidInstructionSubtitle) || other.avoidInstructionSubtitle == avoidInstructionSubtitle)&&(identical(other.childName, childName) || other.childName == childName));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isLoading,isAudioPlaying,fetchStatus,forecast,const DeepCollectionEquality().hash(_actions),avoidInstructionTitle,avoidInstructionSubtitle,childName);
}

@override
String toString() {
    return 'CalmPlanState(isLoading: $isLoading, isAudioPlaying: $isAudioPlaying, fetchStatus: $fetchStatus, forecast: $forecast, actions: $actions, avoidInstructionTitle: $avoidInstructionTitle, avoidInstructionSubtitle: $avoidInstructionSubtitle, childName: $childName)';
}


}

/// @nodoc
abstract mixin class _$CalmPlanStateCopyWith<$Res> implements $CalmPlanStateCopyWith<$Res> {
  factory _$CalmPlanStateCopyWith(_CalmPlanState value, $Res Function(_CalmPlanState) _then) = __$CalmPlanStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool isAudioPlaying, ApiResultStatus<dynamic> fetchStatus, BehaviourForecastResult? forecast, List<CalmPlanAction> actions, String avoidInstructionTitle, String avoidInstructionSubtitle, String childName
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus;

}
/// @nodoc
class __$CalmPlanStateCopyWithImpl<$Res>
    implements _$CalmPlanStateCopyWith<$Res> {
  __$CalmPlanStateCopyWithImpl(this._self, this._then);

  final _CalmPlanState _self;
  final $Res Function(_CalmPlanState) _then;

/// Create a copy of CalmPlanState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? isAudioPlaying = null,Object? fetchStatus = null,Object? forecast = freezed,Object? actions = null,Object? avoidInstructionTitle = null,Object? avoidInstructionSubtitle = null,Object? childName = null,}) {
  return _then(_CalmPlanState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isAudioPlaying: null == isAudioPlaying ? _self.isAudioPlaying : isAudioPlaying // ignore: cast_nullable_to_non_nullable
as bool,fetchStatus: null == fetchStatus ? _self.fetchStatus : fetchStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,forecast: freezed == forecast ? _self.forecast : forecast // ignore: cast_nullable_to_non_nullable
as BehaviourForecastResult?,actions: null == actions ? _self._actions : actions // ignore: cast_nullable_to_non_nullable
as List<CalmPlanAction>,avoidInstructionTitle: null == avoidInstructionTitle ? _self.avoidInstructionTitle : avoidInstructionTitle // ignore: cast_nullable_to_non_nullable
as String,avoidInstructionSubtitle: null == avoidInstructionSubtitle ? _self.avoidInstructionSubtitle : avoidInstructionSubtitle // ignore: cast_nullable_to_non_nullable
as String,childName: null == childName ? _self.childName : childName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of CalmPlanState
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
