// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'microphone_permission_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MicrophonePermissionState {

 bool get isGranted;
/// Create a copy of MicrophonePermissionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MicrophonePermissionStateCopyWith<MicrophonePermissionState> get copyWith => _$MicrophonePermissionStateCopyWithImpl<MicrophonePermissionState>(this as MicrophonePermissionState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MicrophonePermissionState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MicrophonePermissionState&&(identical(other.isGranted, _this.isGranted) || other.isGranted == _this.isGranted));
}


@override
int get hashCode {
  final _this = this as MicrophonePermissionState;
  return Object.hash(runtimeType,_this.isGranted);
}

@override
String toString() {
  final _this = this as MicrophonePermissionState;
  return 'MicrophonePermissionState(isGranted: ${_this.isGranted})';
}


}

/// @nodoc
abstract mixin class $MicrophonePermissionStateCopyWith<$Res>  {
  factory $MicrophonePermissionStateCopyWith(MicrophonePermissionState value, $Res Function(MicrophonePermissionState) _then) = _$MicrophonePermissionStateCopyWithImpl;
@useResult
$Res call({
 bool isGranted
});




}
/// @nodoc
class _$MicrophonePermissionStateCopyWithImpl<$Res>
    implements $MicrophonePermissionStateCopyWith<$Res> {
  _$MicrophonePermissionStateCopyWithImpl(this._self, this._then);

  final MicrophonePermissionState _self;
  final $Res Function(MicrophonePermissionState) _then;

/// Create a copy of MicrophonePermissionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isGranted = null,}) {
  return _then(MicrophonePermissionState(
isGranted: null == isGranted ? _self.isGranted : isGranted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MicrophonePermissionState].
extension MicrophonePermissionStatePatterns on MicrophonePermissionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MicrophonePermissionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MicrophonePermissionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MicrophonePermissionState value)  $default,){
final _that = this;
switch (_that) {
case _MicrophonePermissionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MicrophonePermissionState value)?  $default,){
final _that = this;
switch (_that) {
case _MicrophonePermissionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isGranted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MicrophonePermissionState() when $default != null:
return $default(_that.isGranted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isGranted)  $default,) {final _that = this;
switch (_that) {
case _MicrophonePermissionState():
return $default(_that.isGranted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isGranted)?  $default,) {final _that = this;
switch (_that) {
case _MicrophonePermissionState() when $default != null:
return $default(_that.isGranted);case _:
  return null;

}
}

}

/// @nodoc


class _MicrophonePermissionState implements MicrophonePermissionState {
  const _MicrophonePermissionState({this.isGranted = false});
  

@override@JsonKey() final  bool isGranted;

/// Create a copy of MicrophonePermissionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MicrophonePermissionStateCopyWith<_MicrophonePermissionState> get copyWith => __$MicrophonePermissionStateCopyWithImpl<_MicrophonePermissionState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MicrophonePermissionState&&(identical(other.isGranted, isGranted) || other.isGranted == isGranted));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isGranted);
}

@override
String toString() {
    return 'MicrophonePermissionState(isGranted: $isGranted)';
}


}

/// @nodoc
abstract mixin class _$MicrophonePermissionStateCopyWith<$Res> implements $MicrophonePermissionStateCopyWith<$Res> {
  factory _$MicrophonePermissionStateCopyWith(_MicrophonePermissionState value, $Res Function(_MicrophonePermissionState) _then) = __$MicrophonePermissionStateCopyWithImpl;
@override @useResult
$Res call({
 bool isGranted
});




}
/// @nodoc
class __$MicrophonePermissionStateCopyWithImpl<$Res>
    implements _$MicrophonePermissionStateCopyWith<$Res> {
  __$MicrophonePermissionStateCopyWithImpl(this._self, this._then);

  final _MicrophonePermissionState _self;
  final $Res Function(_MicrophonePermissionState) _then;

/// Create a copy of MicrophonePermissionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isGranted = null,}) {
  return _then(_MicrophonePermissionState(
isGranted: null == isGranted ? _self.isGranted : isGranted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
