// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'energy_bridge_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EnergyBridgeState {

 ApiResultStatus get apiResultStatus; bool get isTimerActive; int? get startTime;
/// Create a copy of EnergyBridgeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EnergyBridgeStateCopyWith<EnergyBridgeState> get copyWith => _$EnergyBridgeStateCopyWithImpl<EnergyBridgeState>(this as EnergyBridgeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EnergyBridgeState&&(identical(other.apiResultStatus, apiResultStatus) || other.apiResultStatus == apiResultStatus)&&(identical(other.isTimerActive, isTimerActive) || other.isTimerActive == isTimerActive)&&(identical(other.startTime, startTime) || other.startTime == startTime));
}


@override
int get hashCode => Object.hash(runtimeType,apiResultStatus,isTimerActive,startTime);

@override
String toString() {
  return 'EnergyBridgeState(apiResultStatus: $apiResultStatus, isTimerActive: $isTimerActive, startTime: $startTime)';
}


}

/// @nodoc
abstract mixin class $EnergyBridgeStateCopyWith<$Res>  {
  factory $EnergyBridgeStateCopyWith(EnergyBridgeState value, $Res Function(EnergyBridgeState) _then) = _$EnergyBridgeStateCopyWithImpl;
@useResult
$Res call({
 ApiResultStatus apiResultStatus, bool isTimerActive, int? startTime
});


$ApiResultStatusCopyWith<dynamic, $Res> get apiResultStatus;

}
/// @nodoc
class _$EnergyBridgeStateCopyWithImpl<$Res>
    implements $EnergyBridgeStateCopyWith<$Res> {
  _$EnergyBridgeStateCopyWithImpl(this._self, this._then);

  final EnergyBridgeState _self;
  final $Res Function(EnergyBridgeState) _then;

/// Create a copy of EnergyBridgeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? apiResultStatus = null,Object? isTimerActive = null,Object? startTime = freezed,}) {
  return _then(_self.copyWith(
apiResultStatus: null == apiResultStatus ? _self.apiResultStatus : apiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,isTimerActive: null == isTimerActive ? _self.isTimerActive : isTimerActive // ignore: cast_nullable_to_non_nullable
as bool,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of EnergyBridgeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get apiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.apiResultStatus, (value) {
    return _then(_self.copyWith(apiResultStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [EnergyBridgeState].
extension EnergyBridgeStatePatterns on EnergyBridgeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EnergyBridgeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EnergyBridgeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EnergyBridgeState value)  $default,){
final _that = this;
switch (_that) {
case _EnergyBridgeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EnergyBridgeState value)?  $default,){
final _that = this;
switch (_that) {
case _EnergyBridgeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ApiResultStatus apiResultStatus,  bool isTimerActive,  int? startTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EnergyBridgeState() when $default != null:
return $default(_that.apiResultStatus,_that.isTimerActive,_that.startTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ApiResultStatus apiResultStatus,  bool isTimerActive,  int? startTime)  $default,) {final _that = this;
switch (_that) {
case _EnergyBridgeState():
return $default(_that.apiResultStatus,_that.isTimerActive,_that.startTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ApiResultStatus apiResultStatus,  bool isTimerActive,  int? startTime)?  $default,) {final _that = this;
switch (_that) {
case _EnergyBridgeState() when $default != null:
return $default(_that.apiResultStatus,_that.isTimerActive,_that.startTime);case _:
  return null;

}
}

}

/// @nodoc


class _EnergyBridgeState implements EnergyBridgeState {
  const _EnergyBridgeState({this.apiResultStatus = const ApiResultStatus.initial(), this.isTimerActive = false, this.startTime});
  

@override@JsonKey() final  ApiResultStatus apiResultStatus;
@override@JsonKey() final  bool isTimerActive;
@override final  int? startTime;

/// Create a copy of EnergyBridgeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EnergyBridgeStateCopyWith<_EnergyBridgeState> get copyWith => __$EnergyBridgeStateCopyWithImpl<_EnergyBridgeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EnergyBridgeState&&(identical(other.apiResultStatus, apiResultStatus) || other.apiResultStatus == apiResultStatus)&&(identical(other.isTimerActive, isTimerActive) || other.isTimerActive == isTimerActive)&&(identical(other.startTime, startTime) || other.startTime == startTime));
}


@override
int get hashCode => Object.hash(runtimeType,apiResultStatus,isTimerActive,startTime);

@override
String toString() {
  return 'EnergyBridgeState(apiResultStatus: $apiResultStatus, isTimerActive: $isTimerActive, startTime: $startTime)';
}


}

/// @nodoc
abstract mixin class _$EnergyBridgeStateCopyWith<$Res> implements $EnergyBridgeStateCopyWith<$Res> {
  factory _$EnergyBridgeStateCopyWith(_EnergyBridgeState value, $Res Function(_EnergyBridgeState) _then) = __$EnergyBridgeStateCopyWithImpl;
@override @useResult
$Res call({
 ApiResultStatus apiResultStatus, bool isTimerActive, int? startTime
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get apiResultStatus;

}
/// @nodoc
class __$EnergyBridgeStateCopyWithImpl<$Res>
    implements _$EnergyBridgeStateCopyWith<$Res> {
  __$EnergyBridgeStateCopyWithImpl(this._self, this._then);

  final _EnergyBridgeState _self;
  final $Res Function(_EnergyBridgeState) _then;

/// Create a copy of EnergyBridgeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? apiResultStatus = null,Object? isTimerActive = null,Object? startTime = freezed,}) {
  return _then(_EnergyBridgeState(
apiResultStatus: null == apiResultStatus ? _self.apiResultStatus : apiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,isTimerActive: null == isTimerActive ? _self.isTimerActive : isTimerActive // ignore: cast_nullable_to_non_nullable
as bool,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of EnergyBridgeState
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
