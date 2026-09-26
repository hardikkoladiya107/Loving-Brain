// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sleep_details_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SleepDetailsState {

 bool get isLoading; String get timeInSleep; String get wakeUpTime; String get wentToBed; String get fellAsleepTime;
/// Create a copy of SleepDetailsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SleepDetailsStateCopyWith<SleepDetailsState> get copyWith => _$SleepDetailsStateCopyWithImpl<SleepDetailsState>(this as SleepDetailsState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SleepDetailsState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SleepDetailsState&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.timeInSleep, _this.timeInSleep) || other.timeInSleep == _this.timeInSleep)&&(identical(other.wakeUpTime, _this.wakeUpTime) || other.wakeUpTime == _this.wakeUpTime)&&(identical(other.wentToBed, _this.wentToBed) || other.wentToBed == _this.wentToBed)&&(identical(other.fellAsleepTime, _this.fellAsleepTime) || other.fellAsleepTime == _this.fellAsleepTime));
}


@override
int get hashCode {
  final _this = this as SleepDetailsState;
  return Object.hash(runtimeType,_this.isLoading,_this.timeInSleep,_this.wakeUpTime,_this.wentToBed,_this.fellAsleepTime);
}

@override
String toString() {
  final _this = this as SleepDetailsState;
  return 'SleepDetailsState(isLoading: ${_this.isLoading}, timeInSleep: ${_this.timeInSleep}, wakeUpTime: ${_this.wakeUpTime}, wentToBed: ${_this.wentToBed}, fellAsleepTime: ${_this.fellAsleepTime})';
}


}

/// @nodoc
abstract mixin class $SleepDetailsStateCopyWith<$Res>  {
  factory $SleepDetailsStateCopyWith(SleepDetailsState value, $Res Function(SleepDetailsState) _then) = _$SleepDetailsStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, String timeInSleep, String wakeUpTime, String wentToBed, String fellAsleepTime
});




}
/// @nodoc
class _$SleepDetailsStateCopyWithImpl<$Res>
    implements $SleepDetailsStateCopyWith<$Res> {
  _$SleepDetailsStateCopyWithImpl(this._self, this._then);

  final SleepDetailsState _self;
  final $Res Function(SleepDetailsState) _then;

/// Create a copy of SleepDetailsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? timeInSleep = null,Object? wakeUpTime = null,Object? wentToBed = null,Object? fellAsleepTime = null,}) {
  return _then(SleepDetailsState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,timeInSleep: null == timeInSleep ? _self.timeInSleep : timeInSleep // ignore: cast_nullable_to_non_nullable
as String,wakeUpTime: null == wakeUpTime ? _self.wakeUpTime : wakeUpTime // ignore: cast_nullable_to_non_nullable
as String,wentToBed: null == wentToBed ? _self.wentToBed : wentToBed // ignore: cast_nullable_to_non_nullable
as String,fellAsleepTime: null == fellAsleepTime ? _self.fellAsleepTime : fellAsleepTime // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SleepDetailsState].
extension SleepDetailsStatePatterns on SleepDetailsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SleepDetailsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SleepDetailsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SleepDetailsState value)  $default,){
final _that = this;
switch (_that) {
case _SleepDetailsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SleepDetailsState value)?  $default,){
final _that = this;
switch (_that) {
case _SleepDetailsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  String timeInSleep,  String wakeUpTime,  String wentToBed,  String fellAsleepTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SleepDetailsState() when $default != null:
return $default(_that.isLoading,_that.timeInSleep,_that.wakeUpTime,_that.wentToBed,_that.fellAsleepTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  String timeInSleep,  String wakeUpTime,  String wentToBed,  String fellAsleepTime)  $default,) {final _that = this;
switch (_that) {
case _SleepDetailsState():
return $default(_that.isLoading,_that.timeInSleep,_that.wakeUpTime,_that.wentToBed,_that.fellAsleepTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  String timeInSleep,  String wakeUpTime,  String wentToBed,  String fellAsleepTime)?  $default,) {final _that = this;
switch (_that) {
case _SleepDetailsState() when $default != null:
return $default(_that.isLoading,_that.timeInSleep,_that.wakeUpTime,_that.wentToBed,_that.fellAsleepTime);case _:
  return null;

}
}

}

/// @nodoc


class _SleepDetailsState implements SleepDetailsState {
  const _SleepDetailsState({this.isLoading = false, this.timeInSleep = "6h 52m", this.wakeUpTime = "07:12 AM", this.wentToBed = "7h 23m", this.fellAsleepTime = "25 min"});
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  String timeInSleep;
@override@JsonKey() final  String wakeUpTime;
@override@JsonKey() final  String wentToBed;
@override@JsonKey() final  String fellAsleepTime;

/// Create a copy of SleepDetailsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SleepDetailsStateCopyWith<_SleepDetailsState> get copyWith => __$SleepDetailsStateCopyWithImpl<_SleepDetailsState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SleepDetailsState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.timeInSleep, timeInSleep) || other.timeInSleep == timeInSleep)&&(identical(other.wakeUpTime, wakeUpTime) || other.wakeUpTime == wakeUpTime)&&(identical(other.wentToBed, wentToBed) || other.wentToBed == wentToBed)&&(identical(other.fellAsleepTime, fellAsleepTime) || other.fellAsleepTime == fellAsleepTime));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isLoading,timeInSleep,wakeUpTime,wentToBed,fellAsleepTime);
}

@override
String toString() {
    return 'SleepDetailsState(isLoading: $isLoading, timeInSleep: $timeInSleep, wakeUpTime: $wakeUpTime, wentToBed: $wentToBed, fellAsleepTime: $fellAsleepTime)';
}


}

/// @nodoc
abstract mixin class _$SleepDetailsStateCopyWith<$Res> implements $SleepDetailsStateCopyWith<$Res> {
  factory _$SleepDetailsStateCopyWith(_SleepDetailsState value, $Res Function(_SleepDetailsState) _then) = __$SleepDetailsStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, String timeInSleep, String wakeUpTime, String wentToBed, String fellAsleepTime
});




}
/// @nodoc
class __$SleepDetailsStateCopyWithImpl<$Res>
    implements _$SleepDetailsStateCopyWith<$Res> {
  __$SleepDetailsStateCopyWithImpl(this._self, this._then);

  final _SleepDetailsState _self;
  final $Res Function(_SleepDetailsState) _then;

/// Create a copy of SleepDetailsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? timeInSleep = null,Object? wakeUpTime = null,Object? wentToBed = null,Object? fellAsleepTime = null,}) {
  return _then(_SleepDetailsState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,timeInSleep: null == timeInSleep ? _self.timeInSleep : timeInSleep // ignore: cast_nullable_to_non_nullable
as String,wakeUpTime: null == wakeUpTime ? _self.wakeUpTime : wakeUpTime // ignore: cast_nullable_to_non_nullable
as String,wentToBed: null == wentToBed ? _self.wentToBed : wentToBed // ignore: cast_nullable_to_non_nullable
as String,fellAsleepTime: null == fellAsleepTime ? _self.fellAsleepTime : fellAsleepTime // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
