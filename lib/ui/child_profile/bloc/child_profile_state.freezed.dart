// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'child_profile_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChildProfileState {

 String get childName; String get childNameError; DateTime? get childDob; String get childDobError; ApiResultStatus get apiResultStatus;
/// Create a copy of ChildProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChildProfileStateCopyWith<ChildProfileState> get copyWith => _$ChildProfileStateCopyWithImpl<ChildProfileState>(this as ChildProfileState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChildProfileState&&(identical(other.childName, childName) || other.childName == childName)&&(identical(other.childNameError, childNameError) || other.childNameError == childNameError)&&(identical(other.childDob, childDob) || other.childDob == childDob)&&(identical(other.childDobError, childDobError) || other.childDobError == childDobError)&&(identical(other.apiResultStatus, apiResultStatus) || other.apiResultStatus == apiResultStatus));
}


@override
int get hashCode => Object.hash(runtimeType,childName,childNameError,childDob,childDobError,apiResultStatus);

@override
String toString() {
  return 'ChildProfileState(childName: $childName, childNameError: $childNameError, childDob: $childDob, childDobError: $childDobError, apiResultStatus: $apiResultStatus)';
}


}

/// @nodoc
abstract mixin class $ChildProfileStateCopyWith<$Res>  {
  factory $ChildProfileStateCopyWith(ChildProfileState value, $Res Function(ChildProfileState) _then) = _$ChildProfileStateCopyWithImpl;
@useResult
$Res call({
 String childName, String childNameError, DateTime? childDob, String childDobError, ApiResultStatus apiResultStatus
});


$ApiResultStatusCopyWith<dynamic, $Res> get apiResultStatus;

}
/// @nodoc
class _$ChildProfileStateCopyWithImpl<$Res>
    implements $ChildProfileStateCopyWith<$Res> {
  _$ChildProfileStateCopyWithImpl(this._self, this._then);

  final ChildProfileState _self;
  final $Res Function(ChildProfileState) _then;

/// Create a copy of ChildProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? childName = null,Object? childNameError = null,Object? childDob = freezed,Object? childDobError = null,Object? apiResultStatus = null,}) {
  return _then(_self.copyWith(
childName: null == childName ? _self.childName : childName // ignore: cast_nullable_to_non_nullable
as String,childNameError: null == childNameError ? _self.childNameError : childNameError // ignore: cast_nullable_to_non_nullable
as String,childDob: freezed == childDob ? _self.childDob : childDob // ignore: cast_nullable_to_non_nullable
as DateTime?,childDobError: null == childDobError ? _self.childDobError : childDobError // ignore: cast_nullable_to_non_nullable
as String,apiResultStatus: null == apiResultStatus ? _self.apiResultStatus : apiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,
  ));
}
/// Create a copy of ChildProfileState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get apiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.apiResultStatus, (value) {
    return _then(_self.copyWith(apiResultStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [ChildProfileState].
extension ChildProfileStatePatterns on ChildProfileState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChildProfileState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChildProfileState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChildProfileState value)  $default,){
final _that = this;
switch (_that) {
case _ChildProfileState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChildProfileState value)?  $default,){
final _that = this;
switch (_that) {
case _ChildProfileState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String childName,  String childNameError,  DateTime? childDob,  String childDobError,  ApiResultStatus apiResultStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChildProfileState() when $default != null:
return $default(_that.childName,_that.childNameError,_that.childDob,_that.childDobError,_that.apiResultStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String childName,  String childNameError,  DateTime? childDob,  String childDobError,  ApiResultStatus apiResultStatus)  $default,) {final _that = this;
switch (_that) {
case _ChildProfileState():
return $default(_that.childName,_that.childNameError,_that.childDob,_that.childDobError,_that.apiResultStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String childName,  String childNameError,  DateTime? childDob,  String childDobError,  ApiResultStatus apiResultStatus)?  $default,) {final _that = this;
switch (_that) {
case _ChildProfileState() when $default != null:
return $default(_that.childName,_that.childNameError,_that.childDob,_that.childDobError,_that.apiResultStatus);case _:
  return null;

}
}

}

/// @nodoc


class _ChildProfileState implements ChildProfileState {
  const _ChildProfileState({this.childName = "", this.childNameError = "", this.childDob, this.childDobError = "", this.apiResultStatus = const ApiResultStatus.initial()});
  

@override@JsonKey() final  String childName;
@override@JsonKey() final  String childNameError;
@override final  DateTime? childDob;
@override@JsonKey() final  String childDobError;
@override@JsonKey() final  ApiResultStatus apiResultStatus;

/// Create a copy of ChildProfileState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChildProfileStateCopyWith<_ChildProfileState> get copyWith => __$ChildProfileStateCopyWithImpl<_ChildProfileState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChildProfileState&&(identical(other.childName, childName) || other.childName == childName)&&(identical(other.childNameError, childNameError) || other.childNameError == childNameError)&&(identical(other.childDob, childDob) || other.childDob == childDob)&&(identical(other.childDobError, childDobError) || other.childDobError == childDobError)&&(identical(other.apiResultStatus, apiResultStatus) || other.apiResultStatus == apiResultStatus));
}


@override
int get hashCode => Object.hash(runtimeType,childName,childNameError,childDob,childDobError,apiResultStatus);

@override
String toString() {
  return 'ChildProfileState(childName: $childName, childNameError: $childNameError, childDob: $childDob, childDobError: $childDobError, apiResultStatus: $apiResultStatus)';
}


}

/// @nodoc
abstract mixin class _$ChildProfileStateCopyWith<$Res> implements $ChildProfileStateCopyWith<$Res> {
  factory _$ChildProfileStateCopyWith(_ChildProfileState value, $Res Function(_ChildProfileState) _then) = __$ChildProfileStateCopyWithImpl;
@override @useResult
$Res call({
 String childName, String childNameError, DateTime? childDob, String childDobError, ApiResultStatus apiResultStatus
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get apiResultStatus;

}
/// @nodoc
class __$ChildProfileStateCopyWithImpl<$Res>
    implements _$ChildProfileStateCopyWith<$Res> {
  __$ChildProfileStateCopyWithImpl(this._self, this._then);

  final _ChildProfileState _self;
  final $Res Function(_ChildProfileState) _then;

/// Create a copy of ChildProfileState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? childName = null,Object? childNameError = null,Object? childDob = freezed,Object? childDobError = null,Object? apiResultStatus = null,}) {
  return _then(_ChildProfileState(
childName: null == childName ? _self.childName : childName // ignore: cast_nullable_to_non_nullable
as String,childNameError: null == childNameError ? _self.childNameError : childNameError // ignore: cast_nullable_to_non_nullable
as String,childDob: freezed == childDob ? _self.childDob : childDob // ignore: cast_nullable_to_non_nullable
as DateTime?,childDobError: null == childDobError ? _self.childDobError : childDobError // ignore: cast_nullable_to_non_nullable
as String,apiResultStatus: null == apiResultStatus ? _self.apiResultStatus : apiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,
  ));
}

/// Create a copy of ChildProfileState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get apiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.apiResultStatus, (value) {
    return _then(_self.copyWith(apiResultStatus: value));
  });
}
}

// dart format on
