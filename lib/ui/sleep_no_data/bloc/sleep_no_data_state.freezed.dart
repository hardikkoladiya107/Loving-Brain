// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sleep_no_data_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SleepNoDataState {

 String get childName; String get childAge; bool get isLoading;
/// Create a copy of SleepNoDataState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SleepNoDataStateCopyWith<SleepNoDataState> get copyWith => _$SleepNoDataStateCopyWithImpl<SleepNoDataState>(this as SleepNoDataState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SleepNoDataState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SleepNoDataState&&(identical(other.childName, _this.childName) || other.childName == _this.childName)&&(identical(other.childAge, _this.childAge) || other.childAge == _this.childAge)&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading));
}


@override
int get hashCode {
  final _this = this as SleepNoDataState;
  return Object.hash(runtimeType,_this.childName,_this.childAge,_this.isLoading);
}

@override
String toString() {
  final _this = this as SleepNoDataState;
  return 'SleepNoDataState(childName: ${_this.childName}, childAge: ${_this.childAge}, isLoading: ${_this.isLoading})';
}


}

/// @nodoc
abstract mixin class $SleepNoDataStateCopyWith<$Res>  {
  factory $SleepNoDataStateCopyWith(SleepNoDataState value, $Res Function(SleepNoDataState) _then) = _$SleepNoDataStateCopyWithImpl;
@useResult
$Res call({
 String childName, String childAge, bool isLoading
});




}
/// @nodoc
class _$SleepNoDataStateCopyWithImpl<$Res>
    implements $SleepNoDataStateCopyWith<$Res> {
  _$SleepNoDataStateCopyWithImpl(this._self, this._then);

  final SleepNoDataState _self;
  final $Res Function(SleepNoDataState) _then;

/// Create a copy of SleepNoDataState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? childName = null,Object? childAge = null,Object? isLoading = null,}) {
  return _then(SleepNoDataState(
childName: null == childName ? _self.childName : childName // ignore: cast_nullable_to_non_nullable
as String,childAge: null == childAge ? _self.childAge : childAge // ignore: cast_nullable_to_non_nullable
as String,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SleepNoDataState].
extension SleepNoDataStatePatterns on SleepNoDataState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SleepNoDataState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SleepNoDataState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SleepNoDataState value)  $default,){
final _that = this;
switch (_that) {
case _SleepNoDataState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SleepNoDataState value)?  $default,){
final _that = this;
switch (_that) {
case _SleepNoDataState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String childName,  String childAge,  bool isLoading)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SleepNoDataState() when $default != null:
return $default(_that.childName,_that.childAge,_that.isLoading);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String childName,  String childAge,  bool isLoading)  $default,) {final _that = this;
switch (_that) {
case _SleepNoDataState():
return $default(_that.childName,_that.childAge,_that.isLoading);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String childName,  String childAge,  bool isLoading)?  $default,) {final _that = this;
switch (_that) {
case _SleepNoDataState() when $default != null:
return $default(_that.childName,_that.childAge,_that.isLoading);case _:
  return null;

}
}

}

/// @nodoc


class _SleepNoDataState implements SleepNoDataState {
  const _SleepNoDataState({this.childName = 'your child', this.childAge = '17 months', this.isLoading = false});
  

@override@JsonKey() final  String childName;
@override@JsonKey() final  String childAge;
@override@JsonKey() final  bool isLoading;

/// Create a copy of SleepNoDataState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SleepNoDataStateCopyWith<_SleepNoDataState> get copyWith => __$SleepNoDataStateCopyWithImpl<_SleepNoDataState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SleepNoDataState&&(identical(other.childName, childName) || other.childName == childName)&&(identical(other.childAge, childAge) || other.childAge == childAge)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode {
    return Object.hash(runtimeType,childName,childAge,isLoading);
}

@override
String toString() {
    return 'SleepNoDataState(childName: $childName, childAge: $childAge, isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class _$SleepNoDataStateCopyWith<$Res> implements $SleepNoDataStateCopyWith<$Res> {
  factory _$SleepNoDataStateCopyWith(_SleepNoDataState value, $Res Function(_SleepNoDataState) _then) = __$SleepNoDataStateCopyWithImpl;
@override @useResult
$Res call({
 String childName, String childAge, bool isLoading
});




}
/// @nodoc
class __$SleepNoDataStateCopyWithImpl<$Res>
    implements _$SleepNoDataStateCopyWith<$Res> {
  __$SleepNoDataStateCopyWithImpl(this._self, this._then);

  final _SleepNoDataState _self;
  final $Res Function(_SleepNoDataState) _then;

/// Create a copy of SleepNoDataState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? childName = null,Object? childAge = null,Object? isLoading = null,}) {
  return _then(_SleepNoDataState(
childName: null == childName ? _self.childName : childName // ignore: cast_nullable_to_non_nullable
as String,childAge: null == childAge ? _self.childAge : childAge // ignore: cast_nullable_to_non_nullable
as String,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
