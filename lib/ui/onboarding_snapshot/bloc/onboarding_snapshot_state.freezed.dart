// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_snapshot_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OnboardingSnapshotState {

 ApiResultStatus get status;
/// Create a copy of OnboardingSnapshotState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingSnapshotStateCopyWith<OnboardingSnapshotState> get copyWith => _$OnboardingSnapshotStateCopyWithImpl<OnboardingSnapshotState>(this as OnboardingSnapshotState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingSnapshotState&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,status);

@override
String toString() {
  return 'OnboardingSnapshotState(status: $status)';
}


}

/// @nodoc
abstract mixin class $OnboardingSnapshotStateCopyWith<$Res>  {
  factory $OnboardingSnapshotStateCopyWith(OnboardingSnapshotState value, $Res Function(OnboardingSnapshotState) _then) = _$OnboardingSnapshotStateCopyWithImpl;
@useResult
$Res call({
 ApiResultStatus status
});


$ApiResultStatusCopyWith<dynamic, $Res> get status;

}
/// @nodoc
class _$OnboardingSnapshotStateCopyWithImpl<$Res>
    implements $OnboardingSnapshotStateCopyWith<$Res> {
  _$OnboardingSnapshotStateCopyWithImpl(this._self, this._then);

  final OnboardingSnapshotState _self;
  final $Res Function(OnboardingSnapshotState) _then;

/// Create a copy of OnboardingSnapshotState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,
  ));
}
/// Create a copy of OnboardingSnapshotState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get status {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.status, (value) {
    return _then(_self.copyWith(status: value));
  });
}
}


/// Adds pattern-matching-related methods to [OnboardingSnapshotState].
extension OnboardingSnapshotStatePatterns on OnboardingSnapshotState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingSnapshotState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingSnapshotState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingSnapshotState value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingSnapshotState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingSnapshotState value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingSnapshotState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ApiResultStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingSnapshotState() when $default != null:
return $default(_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ApiResultStatus status)  $default,) {final _that = this;
switch (_that) {
case _OnboardingSnapshotState():
return $default(_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ApiResultStatus status)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingSnapshotState() when $default != null:
return $default(_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _OnboardingSnapshotState implements OnboardingSnapshotState {
  const _OnboardingSnapshotState({this.status = const ApiResultStatus.initial()});
  

@override@JsonKey() final  ApiResultStatus status;

/// Create a copy of OnboardingSnapshotState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingSnapshotStateCopyWith<_OnboardingSnapshotState> get copyWith => __$OnboardingSnapshotStateCopyWithImpl<_OnboardingSnapshotState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingSnapshotState&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,status);

@override
String toString() {
  return 'OnboardingSnapshotState(status: $status)';
}


}

/// @nodoc
abstract mixin class _$OnboardingSnapshotStateCopyWith<$Res> implements $OnboardingSnapshotStateCopyWith<$Res> {
  factory _$OnboardingSnapshotStateCopyWith(_OnboardingSnapshotState value, $Res Function(_OnboardingSnapshotState) _then) = __$OnboardingSnapshotStateCopyWithImpl;
@override @useResult
$Res call({
 ApiResultStatus status
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get status;

}
/// @nodoc
class __$OnboardingSnapshotStateCopyWithImpl<$Res>
    implements _$OnboardingSnapshotStateCopyWith<$Res> {
  __$OnboardingSnapshotStateCopyWithImpl(this._self, this._then);

  final _OnboardingSnapshotState _self;
  final $Res Function(_OnboardingSnapshotState) _then;

/// Create a copy of OnboardingSnapshotState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,}) {
  return _then(_OnboardingSnapshotState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,
  ));
}

/// Create a copy of OnboardingSnapshotState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get status {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.status, (value) {
    return _then(_self.copyWith(status: value));
  });
}
}

// dart format on
