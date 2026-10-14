// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sleep_low_confidence_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SleepLowConfidenceState {

 String get windowTimeRange; int get nightsCount; String get confidence; String get explanation; bool get isLoading;
/// Create a copy of SleepLowConfidenceState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SleepLowConfidenceStateCopyWith<SleepLowConfidenceState> get copyWith => _$SleepLowConfidenceStateCopyWithImpl<SleepLowConfidenceState>(this as SleepLowConfidenceState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SleepLowConfidenceState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SleepLowConfidenceState&&(identical(other.windowTimeRange, _this.windowTimeRange) || other.windowTimeRange == _this.windowTimeRange)&&(identical(other.nightsCount, _this.nightsCount) || other.nightsCount == _this.nightsCount)&&(identical(other.confidence, _this.confidence) || other.confidence == _this.confidence)&&(identical(other.explanation, _this.explanation) || other.explanation == _this.explanation)&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading));
}


@override
int get hashCode {
  final _this = this as SleepLowConfidenceState;
  return Object.hash(runtimeType,_this.windowTimeRange,_this.nightsCount,_this.confidence,_this.explanation,_this.isLoading);
}

@override
String toString() {
  final _this = this as SleepLowConfidenceState;
  return 'SleepLowConfidenceState(windowTimeRange: ${_this.windowTimeRange}, nightsCount: ${_this.nightsCount}, confidence: ${_this.confidence}, explanation: ${_this.explanation}, isLoading: ${_this.isLoading})';
}


}

/// @nodoc
abstract mixin class $SleepLowConfidenceStateCopyWith<$Res>  {
  factory $SleepLowConfidenceStateCopyWith(SleepLowConfidenceState value, $Res Function(SleepLowConfidenceState) _then) = _$SleepLowConfidenceStateCopyWithImpl;
@useResult
$Res call({
 String windowTimeRange, int nightsCount, String confidence, String explanation, bool isLoading
});




}
/// @nodoc
class _$SleepLowConfidenceStateCopyWithImpl<$Res>
    implements $SleepLowConfidenceStateCopyWith<$Res> {
  _$SleepLowConfidenceStateCopyWithImpl(this._self, this._then);

  final SleepLowConfidenceState _self;
  final $Res Function(SleepLowConfidenceState) _then;

/// Create a copy of SleepLowConfidenceState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? windowTimeRange = null,Object? nightsCount = null,Object? confidence = null,Object? explanation = null,Object? isLoading = null,}) {
  return _then(SleepLowConfidenceState(
windowTimeRange: null == windowTimeRange ? _self.windowTimeRange : windowTimeRange // ignore: cast_nullable_to_non_nullable
as String,nightsCount: null == nightsCount ? _self.nightsCount : nightsCount // ignore: cast_nullable_to_non_nullable
as int,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as String,explanation: null == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as String,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SleepLowConfidenceState].
extension SleepLowConfidenceStatePatterns on SleepLowConfidenceState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SleepLowConfidenceState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SleepLowConfidenceState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SleepLowConfidenceState value)  $default,){
final _that = this;
switch (_that) {
case _SleepLowConfidenceState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SleepLowConfidenceState value)?  $default,){
final _that = this;
switch (_that) {
case _SleepLowConfidenceState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String windowTimeRange,  int nightsCount,  String confidence,  String explanation,  bool isLoading)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SleepLowConfidenceState() when $default != null:
return $default(_that.windowTimeRange,_that.nightsCount,_that.confidence,_that.explanation,_that.isLoading);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String windowTimeRange,  int nightsCount,  String confidence,  String explanation,  bool isLoading)  $default,) {final _that = this;
switch (_that) {
case _SleepLowConfidenceState():
return $default(_that.windowTimeRange,_that.nightsCount,_that.confidence,_that.explanation,_that.isLoading);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String windowTimeRange,  int nightsCount,  String confidence,  String explanation,  bool isLoading)?  $default,) {final _that = this;
switch (_that) {
case _SleepLowConfidenceState() when $default != null:
return $default(_that.windowTimeRange,_that.nightsCount,_that.confidence,_that.explanation,_that.isLoading);case _:
  return null;

}
}

}

/// @nodoc


class _SleepLowConfidenceState implements SleepLowConfidenceState {
  const _SleepLowConfidenceState({this.windowTimeRange = '7:15 – 8:30 PM', this.nightsCount = 4, this.confidence = 'low', this.explanation = "A wider window than usual the last few days have been unsettled, so we're less sure tonight.", this.isLoading = false});
  

@override@JsonKey() final  String windowTimeRange;
@override@JsonKey() final  int nightsCount;
@override@JsonKey() final  String confidence;
@override@JsonKey() final  String explanation;
@override@JsonKey() final  bool isLoading;

/// Create a copy of SleepLowConfidenceState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SleepLowConfidenceStateCopyWith<_SleepLowConfidenceState> get copyWith => __$SleepLowConfidenceStateCopyWithImpl<_SleepLowConfidenceState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SleepLowConfidenceState&&(identical(other.windowTimeRange, windowTimeRange) || other.windowTimeRange == windowTimeRange)&&(identical(other.nightsCount, nightsCount) || other.nightsCount == nightsCount)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.explanation, explanation) || other.explanation == explanation)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode {
    return Object.hash(runtimeType,windowTimeRange,nightsCount,confidence,explanation,isLoading);
}

@override
String toString() {
    return 'SleepLowConfidenceState(windowTimeRange: $windowTimeRange, nightsCount: $nightsCount, confidence: $confidence, explanation: $explanation, isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class _$SleepLowConfidenceStateCopyWith<$Res> implements $SleepLowConfidenceStateCopyWith<$Res> {
  factory _$SleepLowConfidenceStateCopyWith(_SleepLowConfidenceState value, $Res Function(_SleepLowConfidenceState) _then) = __$SleepLowConfidenceStateCopyWithImpl;
@override @useResult
$Res call({
 String windowTimeRange, int nightsCount, String confidence, String explanation, bool isLoading
});




}
/// @nodoc
class __$SleepLowConfidenceStateCopyWithImpl<$Res>
    implements _$SleepLowConfidenceStateCopyWith<$Res> {
  __$SleepLowConfidenceStateCopyWithImpl(this._self, this._then);

  final _SleepLowConfidenceState _self;
  final $Res Function(_SleepLowConfidenceState) _then;

/// Create a copy of SleepLowConfidenceState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? windowTimeRange = null,Object? nightsCount = null,Object? confidence = null,Object? explanation = null,Object? isLoading = null,}) {
  return _then(_SleepLowConfidenceState(
windowTimeRange: null == windowTimeRange ? _self.windowTimeRange : windowTimeRange // ignore: cast_nullable_to_non_nullable
as String,nightsCount: null == nightsCount ? _self.nightsCount : nightsCount // ignore: cast_nullable_to_non_nullable
as int,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as String,explanation: null == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as String,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
