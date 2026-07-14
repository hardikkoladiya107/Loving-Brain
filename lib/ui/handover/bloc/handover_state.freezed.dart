// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'handover_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HandoverState {

 UserModel? get userModel; ApiResultStatus get transferStatus;
/// Create a copy of HandoverState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HandoverStateCopyWith<HandoverState> get copyWith => _$HandoverStateCopyWithImpl<HandoverState>(this as HandoverState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HandoverState&&(identical(other.userModel, userModel) || other.userModel == userModel)&&(identical(other.transferStatus, transferStatus) || other.transferStatus == transferStatus));
}


@override
int get hashCode => Object.hash(runtimeType,userModel,transferStatus);

@override
String toString() {
  return 'HandoverState(userModel: $userModel, transferStatus: $transferStatus)';
}


}

/// @nodoc
abstract mixin class $HandoverStateCopyWith<$Res>  {
  factory $HandoverStateCopyWith(HandoverState value, $Res Function(HandoverState) _then) = _$HandoverStateCopyWithImpl;
@useResult
$Res call({
 UserModel? userModel, ApiResultStatus transferStatus
});


$ApiResultStatusCopyWith<dynamic, $Res> get transferStatus;

}
/// @nodoc
class _$HandoverStateCopyWithImpl<$Res>
    implements $HandoverStateCopyWith<$Res> {
  _$HandoverStateCopyWithImpl(this._self, this._then);

  final HandoverState _self;
  final $Res Function(HandoverState) _then;

/// Create a copy of HandoverState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userModel = freezed,Object? transferStatus = null,}) {
  return _then(_self.copyWith(
userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,transferStatus: null == transferStatus ? _self.transferStatus : transferStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,
  ));
}
/// Create a copy of HandoverState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get transferStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.transferStatus, (value) {
    return _then(_self.copyWith(transferStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [HandoverState].
extension HandoverStatePatterns on HandoverState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HandoverState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HandoverState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HandoverState value)  $default,){
final _that = this;
switch (_that) {
case _HandoverState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HandoverState value)?  $default,){
final _that = this;
switch (_that) {
case _HandoverState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UserModel? userModel,  ApiResultStatus transferStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HandoverState() when $default != null:
return $default(_that.userModel,_that.transferStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UserModel? userModel,  ApiResultStatus transferStatus)  $default,) {final _that = this;
switch (_that) {
case _HandoverState():
return $default(_that.userModel,_that.transferStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UserModel? userModel,  ApiResultStatus transferStatus)?  $default,) {final _that = this;
switch (_that) {
case _HandoverState() when $default != null:
return $default(_that.userModel,_that.transferStatus);case _:
  return null;

}
}

}

/// @nodoc


class _HandoverState implements HandoverState {
  const _HandoverState({this.userModel, this.transferStatus = const ApiResultStatus.initial()});
  

@override final  UserModel? userModel;
@override@JsonKey() final  ApiResultStatus transferStatus;

/// Create a copy of HandoverState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HandoverStateCopyWith<_HandoverState> get copyWith => __$HandoverStateCopyWithImpl<_HandoverState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HandoverState&&(identical(other.userModel, userModel) || other.userModel == userModel)&&(identical(other.transferStatus, transferStatus) || other.transferStatus == transferStatus));
}


@override
int get hashCode => Object.hash(runtimeType,userModel,transferStatus);

@override
String toString() {
  return 'HandoverState(userModel: $userModel, transferStatus: $transferStatus)';
}


}

/// @nodoc
abstract mixin class _$HandoverStateCopyWith<$Res> implements $HandoverStateCopyWith<$Res> {
  factory _$HandoverStateCopyWith(_HandoverState value, $Res Function(_HandoverState) _then) = __$HandoverStateCopyWithImpl;
@override @useResult
$Res call({
 UserModel? userModel, ApiResultStatus transferStatus
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get transferStatus;

}
/// @nodoc
class __$HandoverStateCopyWithImpl<$Res>
    implements _$HandoverStateCopyWith<$Res> {
  __$HandoverStateCopyWithImpl(this._self, this._then);

  final _HandoverState _self;
  final $Res Function(_HandoverState) _then;

/// Create a copy of HandoverState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userModel = freezed,Object? transferStatus = null,}) {
  return _then(_HandoverState(
userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,transferStatus: null == transferStatus ? _self.transferStatus : transferStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,
  ));
}

/// Create a copy of HandoverState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get transferStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.transferStatus, (value) {
    return _then(_self.copyWith(transferStatus: value));
  });
}
}

// dart format on
