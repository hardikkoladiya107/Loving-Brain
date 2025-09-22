// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'base_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BaseState {

 String get message; int get bottomNavigationIndex;
/// Create a copy of BaseState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BaseStateCopyWith<BaseState> get copyWith => _$BaseStateCopyWithImpl<BaseState>(this as BaseState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BaseState&&(identical(other.message, message) || other.message == message)&&(identical(other.bottomNavigationIndex, bottomNavigationIndex) || other.bottomNavigationIndex == bottomNavigationIndex));
}


@override
int get hashCode => Object.hash(runtimeType,message,bottomNavigationIndex);

@override
String toString() {
  return 'BaseState(message: $message, bottomNavigationIndex: $bottomNavigationIndex)';
}


}

/// @nodoc
abstract mixin class $BaseStateCopyWith<$Res>  {
  factory $BaseStateCopyWith(BaseState value, $Res Function(BaseState) _then) = _$BaseStateCopyWithImpl;
@useResult
$Res call({
 String message, int bottomNavigationIndex
});




}
/// @nodoc
class _$BaseStateCopyWithImpl<$Res>
    implements $BaseStateCopyWith<$Res> {
  _$BaseStateCopyWithImpl(this._self, this._then);

  final BaseState _self;
  final $Res Function(BaseState) _then;

/// Create a copy of BaseState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,Object? bottomNavigationIndex = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,bottomNavigationIndex: null == bottomNavigationIndex ? _self.bottomNavigationIndex : bottomNavigationIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BaseState].
extension BaseStatePatterns on BaseState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BaseState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BaseState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BaseState value)  $default,){
final _that = this;
switch (_that) {
case _BaseState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BaseState value)?  $default,){
final _that = this;
switch (_that) {
case _BaseState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String message,  int bottomNavigationIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BaseState() when $default != null:
return $default(_that.message,_that.bottomNavigationIndex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String message,  int bottomNavigationIndex)  $default,) {final _that = this;
switch (_that) {
case _BaseState():
return $default(_that.message,_that.bottomNavigationIndex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String message,  int bottomNavigationIndex)?  $default,) {final _that = this;
switch (_that) {
case _BaseState() when $default != null:
return $default(_that.message,_that.bottomNavigationIndex);case _:
  return null;

}
}

}

/// @nodoc


class _BaseState implements BaseState {
  const _BaseState({this.message = "", this.bottomNavigationIndex = 0});
  

@override@JsonKey() final  String message;
@override@JsonKey() final  int bottomNavigationIndex;

/// Create a copy of BaseState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BaseStateCopyWith<_BaseState> get copyWith => __$BaseStateCopyWithImpl<_BaseState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BaseState&&(identical(other.message, message) || other.message == message)&&(identical(other.bottomNavigationIndex, bottomNavigationIndex) || other.bottomNavigationIndex == bottomNavigationIndex));
}


@override
int get hashCode => Object.hash(runtimeType,message,bottomNavigationIndex);

@override
String toString() {
  return 'BaseState(message: $message, bottomNavigationIndex: $bottomNavigationIndex)';
}


}

/// @nodoc
abstract mixin class _$BaseStateCopyWith<$Res> implements $BaseStateCopyWith<$Res> {
  factory _$BaseStateCopyWith(_BaseState value, $Res Function(_BaseState) _then) = __$BaseStateCopyWithImpl;
@override @useResult
$Res call({
 String message, int bottomNavigationIndex
});




}
/// @nodoc
class __$BaseStateCopyWithImpl<$Res>
    implements _$BaseStateCopyWith<$Res> {
  __$BaseStateCopyWithImpl(this._self, this._then);

  final _BaseState _self;
  final $Res Function(_BaseState) _then;

/// Create a copy of BaseState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? bottomNavigationIndex = null,}) {
  return _then(_BaseState(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,bottomNavigationIndex: null == bottomNavigationIndex ? _self.bottomNavigationIndex : bottomNavigationIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
