// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'after_reflection_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AfterReflectionState {

 bool get isLoading; double get intensityValue; String get selectedHelped; String get selectedFeeling;
/// Create a copy of AfterReflectionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AfterReflectionStateCopyWith<AfterReflectionState> get copyWith => _$AfterReflectionStateCopyWithImpl<AfterReflectionState>(this as AfterReflectionState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AfterReflectionState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AfterReflectionState&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.intensityValue, _this.intensityValue) || other.intensityValue == _this.intensityValue)&&(identical(other.selectedHelped, _this.selectedHelped) || other.selectedHelped == _this.selectedHelped)&&(identical(other.selectedFeeling, _this.selectedFeeling) || other.selectedFeeling == _this.selectedFeeling));
}


@override
int get hashCode {
  final _this = this as AfterReflectionState;
  return Object.hash(runtimeType,_this.isLoading,_this.intensityValue,_this.selectedHelped,_this.selectedFeeling);
}

@override
String toString() {
  final _this = this as AfterReflectionState;
  return 'AfterReflectionState(isLoading: ${_this.isLoading}, intensityValue: ${_this.intensityValue}, selectedHelped: ${_this.selectedHelped}, selectedFeeling: ${_this.selectedFeeling})';
}


}

/// @nodoc
abstract mixin class $AfterReflectionStateCopyWith<$Res>  {
  factory $AfterReflectionStateCopyWith(AfterReflectionState value, $Res Function(AfterReflectionState) _then) = _$AfterReflectionStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, double intensityValue, String selectedHelped, String selectedFeeling
});




}
/// @nodoc
class _$AfterReflectionStateCopyWithImpl<$Res>
    implements $AfterReflectionStateCopyWith<$Res> {
  _$AfterReflectionStateCopyWithImpl(this._self, this._then);

  final AfterReflectionState _self;
  final $Res Function(AfterReflectionState) _then;

/// Create a copy of AfterReflectionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? intensityValue = null,Object? selectedHelped = null,Object? selectedFeeling = null,}) {
  return _then(AfterReflectionState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,intensityValue: null == intensityValue ? _self.intensityValue : intensityValue // ignore: cast_nullable_to_non_nullable
as double,selectedHelped: null == selectedHelped ? _self.selectedHelped : selectedHelped // ignore: cast_nullable_to_non_nullable
as String,selectedFeeling: null == selectedFeeling ? _self.selectedFeeling : selectedFeeling // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AfterReflectionState].
extension AfterReflectionStatePatterns on AfterReflectionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AfterReflectionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AfterReflectionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AfterReflectionState value)  $default,){
final _that = this;
switch (_that) {
case _AfterReflectionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AfterReflectionState value)?  $default,){
final _that = this;
switch (_that) {
case _AfterReflectionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  double intensityValue,  String selectedHelped,  String selectedFeeling)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AfterReflectionState() when $default != null:
return $default(_that.isLoading,_that.intensityValue,_that.selectedHelped,_that.selectedFeeling);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  double intensityValue,  String selectedHelped,  String selectedFeeling)  $default,) {final _that = this;
switch (_that) {
case _AfterReflectionState():
return $default(_that.isLoading,_that.intensityValue,_that.selectedHelped,_that.selectedFeeling);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  double intensityValue,  String selectedHelped,  String selectedFeeling)?  $default,) {final _that = this;
switch (_that) {
case _AfterReflectionState() when $default != null:
return $default(_that.isLoading,_that.intensityValue,_that.selectedHelped,_that.selectedFeeling);case _:
  return null;

}
}

}

/// @nodoc


class _AfterReflectionState implements AfterReflectionState {
  const _AfterReflectionState({this.isLoading = false, this.intensityValue = 0.5, this.selectedHelped = 'Holding close', this.selectedFeeling = 'Tired'});
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  double intensityValue;
@override@JsonKey() final  String selectedHelped;
@override@JsonKey() final  String selectedFeeling;

/// Create a copy of AfterReflectionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AfterReflectionStateCopyWith<_AfterReflectionState> get copyWith => __$AfterReflectionStateCopyWithImpl<_AfterReflectionState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AfterReflectionState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.intensityValue, intensityValue) || other.intensityValue == intensityValue)&&(identical(other.selectedHelped, selectedHelped) || other.selectedHelped == selectedHelped)&&(identical(other.selectedFeeling, selectedFeeling) || other.selectedFeeling == selectedFeeling));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isLoading,intensityValue,selectedHelped,selectedFeeling);
}

@override
String toString() {
    return 'AfterReflectionState(isLoading: $isLoading, intensityValue: $intensityValue, selectedHelped: $selectedHelped, selectedFeeling: $selectedFeeling)';
}


}

/// @nodoc
abstract mixin class _$AfterReflectionStateCopyWith<$Res> implements $AfterReflectionStateCopyWith<$Res> {
  factory _$AfterReflectionStateCopyWith(_AfterReflectionState value, $Res Function(_AfterReflectionState) _then) = __$AfterReflectionStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, double intensityValue, String selectedHelped, String selectedFeeling
});




}
/// @nodoc
class __$AfterReflectionStateCopyWithImpl<$Res>
    implements _$AfterReflectionStateCopyWith<$Res> {
  __$AfterReflectionStateCopyWithImpl(this._self, this._then);

  final _AfterReflectionState _self;
  final $Res Function(_AfterReflectionState) _then;

/// Create a copy of AfterReflectionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? intensityValue = null,Object? selectedHelped = null,Object? selectedFeeling = null,}) {
  return _then(_AfterReflectionState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,intensityValue: null == intensityValue ? _self.intensityValue : intensityValue // ignore: cast_nullable_to_non_nullable
as double,selectedHelped: null == selectedHelped ? _self.selectedHelped : selectedHelped // ignore: cast_nullable_to_non_nullable
as String,selectedFeeling: null == selectedFeeling ? _self.selectedFeeling : selectedFeeling // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
