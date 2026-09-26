// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sleep_pattern_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SleepPatternState {

 bool get isLoading; int get selectedToggleIndex;
/// Create a copy of SleepPatternState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SleepPatternStateCopyWith<SleepPatternState> get copyWith => _$SleepPatternStateCopyWithImpl<SleepPatternState>(this as SleepPatternState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SleepPatternState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SleepPatternState&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.selectedToggleIndex, _this.selectedToggleIndex) || other.selectedToggleIndex == _this.selectedToggleIndex));
}


@override
int get hashCode {
  final _this = this as SleepPatternState;
  return Object.hash(runtimeType,_this.isLoading,_this.selectedToggleIndex);
}

@override
String toString() {
  final _this = this as SleepPatternState;
  return 'SleepPatternState(isLoading: ${_this.isLoading}, selectedToggleIndex: ${_this.selectedToggleIndex})';
}


}

/// @nodoc
abstract mixin class $SleepPatternStateCopyWith<$Res>  {
  factory $SleepPatternStateCopyWith(SleepPatternState value, $Res Function(SleepPatternState) _then) = _$SleepPatternStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, int selectedToggleIndex
});




}
/// @nodoc
class _$SleepPatternStateCopyWithImpl<$Res>
    implements $SleepPatternStateCopyWith<$Res> {
  _$SleepPatternStateCopyWithImpl(this._self, this._then);

  final SleepPatternState _self;
  final $Res Function(SleepPatternState) _then;

/// Create a copy of SleepPatternState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? selectedToggleIndex = null,}) {
  return _then(SleepPatternState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,selectedToggleIndex: null == selectedToggleIndex ? _self.selectedToggleIndex : selectedToggleIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SleepPatternState].
extension SleepPatternStatePatterns on SleepPatternState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SleepPatternState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SleepPatternState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SleepPatternState value)  $default,){
final _that = this;
switch (_that) {
case _SleepPatternState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SleepPatternState value)?  $default,){
final _that = this;
switch (_that) {
case _SleepPatternState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  int selectedToggleIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SleepPatternState() when $default != null:
return $default(_that.isLoading,_that.selectedToggleIndex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  int selectedToggleIndex)  $default,) {final _that = this;
switch (_that) {
case _SleepPatternState():
return $default(_that.isLoading,_that.selectedToggleIndex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  int selectedToggleIndex)?  $default,) {final _that = this;
switch (_that) {
case _SleepPatternState() when $default != null:
return $default(_that.isLoading,_that.selectedToggleIndex);case _:
  return null;

}
}

}

/// @nodoc


class _SleepPatternState implements SleepPatternState {
  const _SleepPatternState({this.isLoading = false, this.selectedToggleIndex = 1});
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  int selectedToggleIndex;

/// Create a copy of SleepPatternState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SleepPatternStateCopyWith<_SleepPatternState> get copyWith => __$SleepPatternStateCopyWithImpl<_SleepPatternState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SleepPatternState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.selectedToggleIndex, selectedToggleIndex) || other.selectedToggleIndex == selectedToggleIndex));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isLoading,selectedToggleIndex);
}

@override
String toString() {
    return 'SleepPatternState(isLoading: $isLoading, selectedToggleIndex: $selectedToggleIndex)';
}


}

/// @nodoc
abstract mixin class _$SleepPatternStateCopyWith<$Res> implements $SleepPatternStateCopyWith<$Res> {
  factory _$SleepPatternStateCopyWith(_SleepPatternState value, $Res Function(_SleepPatternState) _then) = __$SleepPatternStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, int selectedToggleIndex
});




}
/// @nodoc
class __$SleepPatternStateCopyWithImpl<$Res>
    implements _$SleepPatternStateCopyWith<$Res> {
  __$SleepPatternStateCopyWithImpl(this._self, this._then);

  final _SleepPatternState _self;
  final $Res Function(_SleepPatternState) _then;

/// Create a copy of SleepPatternState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? selectedToggleIndex = null,}) {
  return _then(_SleepPatternState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,selectedToggleIndex: null == selectedToggleIndex ? _self.selectedToggleIndex : selectedToggleIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
