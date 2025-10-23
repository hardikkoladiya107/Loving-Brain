// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'essentials_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EssentialsState {

 String get xyz; UserModel? get userModel; ChildModel? get childModel;
/// Create a copy of EssentialsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EssentialsStateCopyWith<EssentialsState> get copyWith => _$EssentialsStateCopyWithImpl<EssentialsState>(this as EssentialsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EssentialsState&&(identical(other.xyz, xyz) || other.xyz == xyz)&&(identical(other.userModel, userModel) || other.userModel == userModel)&&(identical(other.childModel, childModel) || other.childModel == childModel));
}


@override
int get hashCode => Object.hash(runtimeType,xyz,userModel,childModel);

@override
String toString() {
  return 'EssentialsState(xyz: $xyz, userModel: $userModel, childModel: $childModel)';
}


}

/// @nodoc
abstract mixin class $EssentialsStateCopyWith<$Res>  {
  factory $EssentialsStateCopyWith(EssentialsState value, $Res Function(EssentialsState) _then) = _$EssentialsStateCopyWithImpl;
@useResult
$Res call({
 String xyz, UserModel? userModel, ChildModel? childModel
});




}
/// @nodoc
class _$EssentialsStateCopyWithImpl<$Res>
    implements $EssentialsStateCopyWith<$Res> {
  _$EssentialsStateCopyWithImpl(this._self, this._then);

  final EssentialsState _self;
  final $Res Function(EssentialsState) _then;

/// Create a copy of EssentialsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? xyz = null,Object? userModel = freezed,Object? childModel = freezed,}) {
  return _then(_self.copyWith(
xyz: null == xyz ? _self.xyz : xyz // ignore: cast_nullable_to_non_nullable
as String,userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,childModel: freezed == childModel ? _self.childModel : childModel // ignore: cast_nullable_to_non_nullable
as ChildModel?,
  ));
}

}


/// Adds pattern-matching-related methods to [EssentialsState].
extension EssentialsStatePatterns on EssentialsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EssentialsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EssentialsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EssentialsState value)  $default,){
final _that = this;
switch (_that) {
case _EssentialsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EssentialsState value)?  $default,){
final _that = this;
switch (_that) {
case _EssentialsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String xyz,  UserModel? userModel,  ChildModel? childModel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EssentialsState() when $default != null:
return $default(_that.xyz,_that.userModel,_that.childModel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String xyz,  UserModel? userModel,  ChildModel? childModel)  $default,) {final _that = this;
switch (_that) {
case _EssentialsState():
return $default(_that.xyz,_that.userModel,_that.childModel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String xyz,  UserModel? userModel,  ChildModel? childModel)?  $default,) {final _that = this;
switch (_that) {
case _EssentialsState() when $default != null:
return $default(_that.xyz,_that.userModel,_that.childModel);case _:
  return null;

}
}

}

/// @nodoc


class _EssentialsState implements EssentialsState {
  const _EssentialsState({this.xyz = "", this.userModel, this.childModel});
  

@override@JsonKey() final  String xyz;
@override final  UserModel? userModel;
@override final  ChildModel? childModel;

/// Create a copy of EssentialsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EssentialsStateCopyWith<_EssentialsState> get copyWith => __$EssentialsStateCopyWithImpl<_EssentialsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EssentialsState&&(identical(other.xyz, xyz) || other.xyz == xyz)&&(identical(other.userModel, userModel) || other.userModel == userModel)&&(identical(other.childModel, childModel) || other.childModel == childModel));
}


@override
int get hashCode => Object.hash(runtimeType,xyz,userModel,childModel);

@override
String toString() {
  return 'EssentialsState(xyz: $xyz, userModel: $userModel, childModel: $childModel)';
}


}

/// @nodoc
abstract mixin class _$EssentialsStateCopyWith<$Res> implements $EssentialsStateCopyWith<$Res> {
  factory _$EssentialsStateCopyWith(_EssentialsState value, $Res Function(_EssentialsState) _then) = __$EssentialsStateCopyWithImpl;
@override @useResult
$Res call({
 String xyz, UserModel? userModel, ChildModel? childModel
});




}
/// @nodoc
class __$EssentialsStateCopyWithImpl<$Res>
    implements _$EssentialsStateCopyWith<$Res> {
  __$EssentialsStateCopyWithImpl(this._self, this._then);

  final _EssentialsState _self;
  final $Res Function(_EssentialsState) _then;

/// Create a copy of EssentialsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? xyz = null,Object? userModel = freezed,Object? childModel = freezed,}) {
  return _then(_EssentialsState(
xyz: null == xyz ? _self.xyz : xyz // ignore: cast_nullable_to_non_nullable
as String,userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,childModel: freezed == childModel ? _self.childModel : childModel // ignore: cast_nullable_to_non_nullable
as ChildModel?,
  ));
}


}

// dart format on
