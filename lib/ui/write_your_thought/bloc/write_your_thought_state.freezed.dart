// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'write_your_thought_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WriteYourThoughtState {

 String get xyz;
/// Create a copy of WriteYourThoughtState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WriteYourThoughtStateCopyWith<WriteYourThoughtState> get copyWith => _$WriteYourThoughtStateCopyWithImpl<WriteYourThoughtState>(this as WriteYourThoughtState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WriteYourThoughtState&&(identical(other.xyz, xyz) || other.xyz == xyz));
}


@override
int get hashCode => Object.hash(runtimeType,xyz);

@override
String toString() {
  return 'WriteYourThoughtState(xyz: $xyz)';
}


}

/// @nodoc
abstract mixin class $WriteYourThoughtStateCopyWith<$Res>  {
  factory $WriteYourThoughtStateCopyWith(WriteYourThoughtState value, $Res Function(WriteYourThoughtState) _then) = _$WriteYourThoughtStateCopyWithImpl;
@useResult
$Res call({
 String xyz
});




}
/// @nodoc
class _$WriteYourThoughtStateCopyWithImpl<$Res>
    implements $WriteYourThoughtStateCopyWith<$Res> {
  _$WriteYourThoughtStateCopyWithImpl(this._self, this._then);

  final WriteYourThoughtState _self;
  final $Res Function(WriteYourThoughtState) _then;

/// Create a copy of WriteYourThoughtState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? xyz = null,}) {
  return _then(_self.copyWith(
xyz: null == xyz ? _self.xyz : xyz // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [WriteYourThoughtState].
extension WriteYourThoughtStatePatterns on WriteYourThoughtState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WriteYourThoughtState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WriteYourThoughtState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WriteYourThoughtState value)  $default,){
final _that = this;
switch (_that) {
case _WriteYourThoughtState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WriteYourThoughtState value)?  $default,){
final _that = this;
switch (_that) {
case _WriteYourThoughtState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String xyz)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WriteYourThoughtState() when $default != null:
return $default(_that.xyz);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String xyz)  $default,) {final _that = this;
switch (_that) {
case _WriteYourThoughtState():
return $default(_that.xyz);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String xyz)?  $default,) {final _that = this;
switch (_that) {
case _WriteYourThoughtState() when $default != null:
return $default(_that.xyz);case _:
  return null;

}
}

}

/// @nodoc


class _WriteYourThoughtState implements WriteYourThoughtState {
  const _WriteYourThoughtState({this.xyz = ""});
  

@override@JsonKey() final  String xyz;

/// Create a copy of WriteYourThoughtState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WriteYourThoughtStateCopyWith<_WriteYourThoughtState> get copyWith => __$WriteYourThoughtStateCopyWithImpl<_WriteYourThoughtState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WriteYourThoughtState&&(identical(other.xyz, xyz) || other.xyz == xyz));
}


@override
int get hashCode => Object.hash(runtimeType,xyz);

@override
String toString() {
  return 'WriteYourThoughtState(xyz: $xyz)';
}


}

/// @nodoc
abstract mixin class _$WriteYourThoughtStateCopyWith<$Res> implements $WriteYourThoughtStateCopyWith<$Res> {
  factory _$WriteYourThoughtStateCopyWith(_WriteYourThoughtState value, $Res Function(_WriteYourThoughtState) _then) = __$WriteYourThoughtStateCopyWithImpl;
@override @useResult
$Res call({
 String xyz
});




}
/// @nodoc
class __$WriteYourThoughtStateCopyWithImpl<$Res>
    implements _$WriteYourThoughtStateCopyWith<$Res> {
  __$WriteYourThoughtStateCopyWithImpl(this._self, this._then);

  final _WriteYourThoughtState _self;
  final $Res Function(_WriteYourThoughtState) _then;

/// Create a copy of WriteYourThoughtState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? xyz = null,}) {
  return _then(_WriteYourThoughtState(
xyz: null == xyz ? _self.xyz : xyz // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
