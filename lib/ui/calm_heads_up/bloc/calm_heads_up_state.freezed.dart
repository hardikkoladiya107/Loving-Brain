// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calm_heads_up_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CalmHeadsUpState {

 bool get isLoading;
/// Create a copy of CalmHeadsUpState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CalmHeadsUpStateCopyWith<CalmHeadsUpState> get copyWith => _$CalmHeadsUpStateCopyWithImpl<CalmHeadsUpState>(this as CalmHeadsUpState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CalmHeadsUpState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CalmHeadsUpState&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading));
}


@override
int get hashCode {
  final _this = this as CalmHeadsUpState;
  return Object.hash(runtimeType,_this.isLoading);
}

@override
String toString() {
  final _this = this as CalmHeadsUpState;
  return 'CalmHeadsUpState(isLoading: ${_this.isLoading})';
}


}

/// @nodoc
abstract mixin class $CalmHeadsUpStateCopyWith<$Res>  {
  factory $CalmHeadsUpStateCopyWith(CalmHeadsUpState value, $Res Function(CalmHeadsUpState) _then) = _$CalmHeadsUpStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class _$CalmHeadsUpStateCopyWithImpl<$Res>
    implements $CalmHeadsUpStateCopyWith<$Res> {
  _$CalmHeadsUpStateCopyWithImpl(this._self, this._then);

  final CalmHeadsUpState _self;
  final $Res Function(CalmHeadsUpState) _then;

/// Create a copy of CalmHeadsUpState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,}) {
  return _then(CalmHeadsUpState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CalmHeadsUpState].
extension CalmHeadsUpStatePatterns on CalmHeadsUpState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CalmHeadsUpState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CalmHeadsUpState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CalmHeadsUpState value)  $default,){
final _that = this;
switch (_that) {
case _CalmHeadsUpState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CalmHeadsUpState value)?  $default,){
final _that = this;
switch (_that) {
case _CalmHeadsUpState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CalmHeadsUpState() when $default != null:
return $default(_that.isLoading);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading)  $default,) {final _that = this;
switch (_that) {
case _CalmHeadsUpState():
return $default(_that.isLoading);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading)?  $default,) {final _that = this;
switch (_that) {
case _CalmHeadsUpState() when $default != null:
return $default(_that.isLoading);case _:
  return null;

}
}

}

/// @nodoc


class _CalmHeadsUpState implements CalmHeadsUpState {
  const _CalmHeadsUpState({this.isLoading = false});
  

@override@JsonKey() final  bool isLoading;

/// Create a copy of CalmHeadsUpState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CalmHeadsUpStateCopyWith<_CalmHeadsUpState> get copyWith => __$CalmHeadsUpStateCopyWithImpl<_CalmHeadsUpState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CalmHeadsUpState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isLoading);
}

@override
String toString() {
    return 'CalmHeadsUpState(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class _$CalmHeadsUpStateCopyWith<$Res> implements $CalmHeadsUpStateCopyWith<$Res> {
  factory _$CalmHeadsUpStateCopyWith(_CalmHeadsUpState value, $Res Function(_CalmHeadsUpState) _then) = __$CalmHeadsUpStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class __$CalmHeadsUpStateCopyWithImpl<$Res>
    implements _$CalmHeadsUpStateCopyWith<$Res> {
  __$CalmHeadsUpStateCopyWithImpl(this._self, this._then);

  final _CalmHeadsUpState _self;
  final $Res Function(_CalmHeadsUpState) _then;

/// Create a copy of CalmHeadsUpState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,}) {
  return _then(_CalmHeadsUpState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
