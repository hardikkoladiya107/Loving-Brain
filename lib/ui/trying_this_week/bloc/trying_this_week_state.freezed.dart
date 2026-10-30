// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trying_this_week_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TryingThisWeekState {

 ActiveExperimentModel? get experiment; ChildModel? get child; int get currentDay; int get totalDays; bool get hasExperiment; ApiResultStatus<dynamic> get fetchStatus; ApiResultStatus<dynamic> get finishStatus;
/// Create a copy of TryingThisWeekState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TryingThisWeekStateCopyWith<TryingThisWeekState> get copyWith => _$TryingThisWeekStateCopyWithImpl<TryingThisWeekState>(this as TryingThisWeekState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TryingThisWeekState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TryingThisWeekState&&(identical(other.experiment, _this.experiment) || other.experiment == _this.experiment)&&(identical(other.child, _this.child) || other.child == _this.child)&&(identical(other.currentDay, _this.currentDay) || other.currentDay == _this.currentDay)&&(identical(other.totalDays, _this.totalDays) || other.totalDays == _this.totalDays)&&(identical(other.hasExperiment, _this.hasExperiment) || other.hasExperiment == _this.hasExperiment)&&(identical(other.fetchStatus, _this.fetchStatus) || other.fetchStatus == _this.fetchStatus)&&(identical(other.finishStatus, _this.finishStatus) || other.finishStatus == _this.finishStatus));
}


@override
int get hashCode {
  final _this = this as TryingThisWeekState;
  return Object.hash(runtimeType,_this.experiment,_this.child,_this.currentDay,_this.totalDays,_this.hasExperiment,_this.fetchStatus,_this.finishStatus);
}

@override
String toString() {
  final _this = this as TryingThisWeekState;
  return 'TryingThisWeekState(experiment: ${_this.experiment}, child: ${_this.child}, currentDay: ${_this.currentDay}, totalDays: ${_this.totalDays}, hasExperiment: ${_this.hasExperiment}, fetchStatus: ${_this.fetchStatus}, finishStatus: ${_this.finishStatus})';
}


}

/// @nodoc
abstract mixin class $TryingThisWeekStateCopyWith<$Res>  {
  factory $TryingThisWeekStateCopyWith(TryingThisWeekState value, $Res Function(TryingThisWeekState) _then) = _$TryingThisWeekStateCopyWithImpl;
@useResult
$Res call({
 ActiveExperimentModel? experiment, ChildModel? child, int currentDay, int totalDays, bool hasExperiment, ApiResultStatus<dynamic> fetchStatus, ApiResultStatus<dynamic> finishStatus
});


$ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus;$ApiResultStatusCopyWith<dynamic, $Res> get finishStatus;

}
/// @nodoc
class _$TryingThisWeekStateCopyWithImpl<$Res>
    implements $TryingThisWeekStateCopyWith<$Res> {
  _$TryingThisWeekStateCopyWithImpl(this._self, this._then);

  final TryingThisWeekState _self;
  final $Res Function(TryingThisWeekState) _then;

/// Create a copy of TryingThisWeekState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? experiment = freezed,Object? child = freezed,Object? currentDay = null,Object? totalDays = null,Object? hasExperiment = null,Object? fetchStatus = null,Object? finishStatus = null,}) {
  return _then(TryingThisWeekState(
experiment: freezed == experiment ? _self.experiment : experiment // ignore: cast_nullable_to_non_nullable
as ActiveExperimentModel?,child: freezed == child ? _self.child : child // ignore: cast_nullable_to_non_nullable
as ChildModel?,currentDay: null == currentDay ? _self.currentDay : currentDay // ignore: cast_nullable_to_non_nullable
as int,totalDays: null == totalDays ? _self.totalDays : totalDays // ignore: cast_nullable_to_non_nullable
as int,hasExperiment: null == hasExperiment ? _self.hasExperiment : hasExperiment // ignore: cast_nullable_to_non_nullable
as bool,fetchStatus: null == fetchStatus ? _self.fetchStatus : fetchStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,finishStatus: null == finishStatus ? _self.finishStatus : finishStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}
/// Create a copy of TryingThisWeekState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.fetchStatus, (value) {
    return _then(_self.copyWith(fetchStatus: value));
  });
}/// Create a copy of TryingThisWeekState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get finishStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.finishStatus, (value) {
    return _then(_self.copyWith(finishStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [TryingThisWeekState].
extension TryingThisWeekStatePatterns on TryingThisWeekState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TryingThisWeekState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TryingThisWeekState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TryingThisWeekState value)  $default,){
final _that = this;
switch (_that) {
case _TryingThisWeekState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TryingThisWeekState value)?  $default,){
final _that = this;
switch (_that) {
case _TryingThisWeekState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ActiveExperimentModel? experiment,  ChildModel? child,  int currentDay,  int totalDays,  bool hasExperiment,  ApiResultStatus<dynamic> fetchStatus,  ApiResultStatus<dynamic> finishStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TryingThisWeekState() when $default != null:
return $default(_that.experiment,_that.child,_that.currentDay,_that.totalDays,_that.hasExperiment,_that.fetchStatus,_that.finishStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ActiveExperimentModel? experiment,  ChildModel? child,  int currentDay,  int totalDays,  bool hasExperiment,  ApiResultStatus<dynamic> fetchStatus,  ApiResultStatus<dynamic> finishStatus)  $default,) {final _that = this;
switch (_that) {
case _TryingThisWeekState():
return $default(_that.experiment,_that.child,_that.currentDay,_that.totalDays,_that.hasExperiment,_that.fetchStatus,_that.finishStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ActiveExperimentModel? experiment,  ChildModel? child,  int currentDay,  int totalDays,  bool hasExperiment,  ApiResultStatus<dynamic> fetchStatus,  ApiResultStatus<dynamic> finishStatus)?  $default,) {final _that = this;
switch (_that) {
case _TryingThisWeekState() when $default != null:
return $default(_that.experiment,_that.child,_that.currentDay,_that.totalDays,_that.hasExperiment,_that.fetchStatus,_that.finishStatus);case _:
  return null;

}
}

}

/// @nodoc


class _TryingThisWeekState implements TryingThisWeekState {
  const _TryingThisWeekState({this.experiment, this.child, this.currentDay = 3, this.totalDays = 7, this.hasExperiment = false, this.fetchStatus = const ApiResultStatus.initial(), this.finishStatus = const ApiResultStatus.initial()});
  

@override final  ActiveExperimentModel? experiment;
@override final  ChildModel? child;
@override@JsonKey() final  int currentDay;
@override@JsonKey() final  int totalDays;
@override@JsonKey() final  bool hasExperiment;
@override@JsonKey() final  ApiResultStatus<dynamic> fetchStatus;
@override@JsonKey() final  ApiResultStatus<dynamic> finishStatus;

/// Create a copy of TryingThisWeekState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TryingThisWeekStateCopyWith<_TryingThisWeekState> get copyWith => __$TryingThisWeekStateCopyWithImpl<_TryingThisWeekState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TryingThisWeekState&&(identical(other.experiment, experiment) || other.experiment == experiment)&&(identical(other.child, child) || other.child == child)&&(identical(other.currentDay, currentDay) || other.currentDay == currentDay)&&(identical(other.totalDays, totalDays) || other.totalDays == totalDays)&&(identical(other.hasExperiment, hasExperiment) || other.hasExperiment == hasExperiment)&&(identical(other.fetchStatus, fetchStatus) || other.fetchStatus == fetchStatus)&&(identical(other.finishStatus, finishStatus) || other.finishStatus == finishStatus));
}


@override
int get hashCode {
    return Object.hash(runtimeType,experiment,child,currentDay,totalDays,hasExperiment,fetchStatus,finishStatus);
}

@override
String toString() {
    return 'TryingThisWeekState(experiment: $experiment, child: $child, currentDay: $currentDay, totalDays: $totalDays, hasExperiment: $hasExperiment, fetchStatus: $fetchStatus, finishStatus: $finishStatus)';
}


}

/// @nodoc
abstract mixin class _$TryingThisWeekStateCopyWith<$Res> implements $TryingThisWeekStateCopyWith<$Res> {
  factory _$TryingThisWeekStateCopyWith(_TryingThisWeekState value, $Res Function(_TryingThisWeekState) _then) = __$TryingThisWeekStateCopyWithImpl;
@override @useResult
$Res call({
 ActiveExperimentModel? experiment, ChildModel? child, int currentDay, int totalDays, bool hasExperiment, ApiResultStatus<dynamic> fetchStatus, ApiResultStatus<dynamic> finishStatus
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus;@override $ApiResultStatusCopyWith<dynamic, $Res> get finishStatus;

}
/// @nodoc
class __$TryingThisWeekStateCopyWithImpl<$Res>
    implements _$TryingThisWeekStateCopyWith<$Res> {
  __$TryingThisWeekStateCopyWithImpl(this._self, this._then);

  final _TryingThisWeekState _self;
  final $Res Function(_TryingThisWeekState) _then;

/// Create a copy of TryingThisWeekState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? experiment = freezed,Object? child = freezed,Object? currentDay = null,Object? totalDays = null,Object? hasExperiment = null,Object? fetchStatus = null,Object? finishStatus = null,}) {
  return _then(_TryingThisWeekState(
experiment: freezed == experiment ? _self.experiment : experiment // ignore: cast_nullable_to_non_nullable
as ActiveExperimentModel?,child: freezed == child ? _self.child : child // ignore: cast_nullable_to_non_nullable
as ChildModel?,currentDay: null == currentDay ? _self.currentDay : currentDay // ignore: cast_nullable_to_non_nullable
as int,totalDays: null == totalDays ? _self.totalDays : totalDays // ignore: cast_nullable_to_non_nullable
as int,hasExperiment: null == hasExperiment ? _self.hasExperiment : hasExperiment // ignore: cast_nullable_to_non_nullable
as bool,fetchStatus: null == fetchStatus ? _self.fetchStatus : fetchStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,finishStatus: null == finishStatus ? _self.finishStatus : finishStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}

/// Create a copy of TryingThisWeekState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.fetchStatus, (value) {
    return _then(_self.copyWith(fetchStatus: value));
  });
}/// Create a copy of TryingThisWeekState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get finishStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.finishStatus, (value) {
    return _then(_self.copyWith(finishStatus: value));
  });
}
}

// dart format on
