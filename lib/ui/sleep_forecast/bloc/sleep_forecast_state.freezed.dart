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

 bool get isLoading; int get selectedDayIndex;
/// Create a copy of SleepForecastState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SleepForecastStateCopyWith<SleepForecastState> get copyWith => _$SleepForecastStateCopyWithImpl<SleepForecastState>(this as SleepForecastState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SleepForecastState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SleepForecastState&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.selectedDayIndex, _this.selectedDayIndex) || other.selectedDayIndex == _this.selectedDayIndex));
}


@override
int get hashCode {
  final _this = this as SleepForecastState;
  return Object.hash(runtimeType,_this.isLoading,_this.selectedDayIndex);
}

@override
String toString() {
  final _this = this as SleepForecastState;
  return 'SleepForecastState(isLoading: ${_this.isLoading}, selectedDayIndex: ${_this.selectedDayIndex})';
}


}

/// @nodoc
abstract mixin class $SleepForecastStateCopyWith<$Res>  {
  factory $SleepForecastStateCopyWith(SleepForecastState value, $Res Function(SleepForecastState) _then) = _$SleepForecastStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, int selectedDayIndex
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
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? selectedDayIndex = null,}) {
  return _then(SleepForecastState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,selectedDayIndex: null == selectedDayIndex ? _self.selectedDayIndex : selectedDayIndex // ignore: cast_nullable_to_non_nullable
as int,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  int selectedDayIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SleepForecastState() when $default != null:
return $default(_that.isLoading,_that.selectedDayIndex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  int selectedDayIndex)  $default,) {final _that = this;
switch (_that) {
case _SleepForecastState():
return $default(_that.isLoading,_that.selectedDayIndex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  int selectedDayIndex)?  $default,) {final _that = this;
switch (_that) {
case _SleepForecastState() when $default != null:
return $default(_that.isLoading,_that.selectedDayIndex);case _:
  return null;

}
}

}

/// @nodoc


class _SleepForecastState implements SleepForecastState {
  const _SleepForecastState({this.isLoading = false, this.selectedDayIndex = 0});
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  int selectedDayIndex;

/// Create a copy of SleepForecastState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SleepForecastStateCopyWith<_SleepForecastState> get copyWith => __$SleepForecastStateCopyWithImpl<_SleepForecastState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SleepForecastState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.selectedDayIndex, selectedDayIndex) || other.selectedDayIndex == selectedDayIndex));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isLoading,selectedDayIndex);
}

@override
String toString() {
    return 'SleepForecastState(isLoading: $isLoading, selectedDayIndex: $selectedDayIndex)';
}


}

/// @nodoc
abstract mixin class _$SleepForecastStateCopyWith<$Res> implements $SleepForecastStateCopyWith<$Res> {
  factory _$SleepForecastStateCopyWith(_SleepForecastState value, $Res Function(_SleepForecastState) _then) = __$SleepForecastStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, int selectedDayIndex
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
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? selectedDayIndex = null,}) {
  return _then(_SleepForecastState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,selectedDayIndex: null == selectedDayIndex ? _self.selectedDayIndex : selectedDayIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
