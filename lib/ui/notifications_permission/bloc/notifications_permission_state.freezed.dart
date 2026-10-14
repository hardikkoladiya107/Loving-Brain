// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notifications_permission_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NotificationsPermissionState {

 String get childName; bool get isGranted;
/// Create a copy of NotificationsPermissionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationsPermissionStateCopyWith<NotificationsPermissionState> get copyWith => _$NotificationsPermissionStateCopyWithImpl<NotificationsPermissionState>(this as NotificationsPermissionState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as NotificationsPermissionState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationsPermissionState&&(identical(other.childName, _this.childName) || other.childName == _this.childName)&&(identical(other.isGranted, _this.isGranted) || other.isGranted == _this.isGranted));
}


@override
int get hashCode {
  final _this = this as NotificationsPermissionState;
  return Object.hash(runtimeType,_this.childName,_this.isGranted);
}

@override
String toString() {
  final _this = this as NotificationsPermissionState;
  return 'NotificationsPermissionState(childName: ${_this.childName}, isGranted: ${_this.isGranted})';
}


}

/// @nodoc
abstract mixin class $NotificationsPermissionStateCopyWith<$Res>  {
  factory $NotificationsPermissionStateCopyWith(NotificationsPermissionState value, $Res Function(NotificationsPermissionState) _then) = _$NotificationsPermissionStateCopyWithImpl;
@useResult
$Res call({
 String childName, bool isGranted
});




}
/// @nodoc
class _$NotificationsPermissionStateCopyWithImpl<$Res>
    implements $NotificationsPermissionStateCopyWith<$Res> {
  _$NotificationsPermissionStateCopyWithImpl(this._self, this._then);

  final NotificationsPermissionState _self;
  final $Res Function(NotificationsPermissionState) _then;

/// Create a copy of NotificationsPermissionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? childName = null,Object? isGranted = null,}) {
  return _then(NotificationsPermissionState(
childName: null == childName ? _self.childName : childName // ignore: cast_nullable_to_non_nullable
as String,isGranted: null == isGranted ? _self.isGranted : isGranted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationsPermissionState].
extension NotificationsPermissionStatePatterns on NotificationsPermissionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationsPermissionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationsPermissionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationsPermissionState value)  $default,){
final _that = this;
switch (_that) {
case _NotificationsPermissionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationsPermissionState value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationsPermissionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String childName,  bool isGranted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationsPermissionState() when $default != null:
return $default(_that.childName,_that.isGranted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String childName,  bool isGranted)  $default,) {final _that = this;
switch (_that) {
case _NotificationsPermissionState():
return $default(_that.childName,_that.isGranted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String childName,  bool isGranted)?  $default,) {final _that = this;
switch (_that) {
case _NotificationsPermissionState() when $default != null:
return $default(_that.childName,_that.isGranted);case _:
  return null;

}
}

}

/// @nodoc


class _NotificationsPermissionState implements NotificationsPermissionState {
  const _NotificationsPermissionState({this.childName = 'your child', this.isGranted = false});
  

@override@JsonKey() final  String childName;
@override@JsonKey() final  bool isGranted;

/// Create a copy of NotificationsPermissionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationsPermissionStateCopyWith<_NotificationsPermissionState> get copyWith => __$NotificationsPermissionStateCopyWithImpl<_NotificationsPermissionState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationsPermissionState&&(identical(other.childName, childName) || other.childName == childName)&&(identical(other.isGranted, isGranted) || other.isGranted == isGranted));
}


@override
int get hashCode {
    return Object.hash(runtimeType,childName,isGranted);
}

@override
String toString() {
    return 'NotificationsPermissionState(childName: $childName, isGranted: $isGranted)';
}


}

/// @nodoc
abstract mixin class _$NotificationsPermissionStateCopyWith<$Res> implements $NotificationsPermissionStateCopyWith<$Res> {
  factory _$NotificationsPermissionStateCopyWith(_NotificationsPermissionState value, $Res Function(_NotificationsPermissionState) _then) = __$NotificationsPermissionStateCopyWithImpl;
@override @useResult
$Res call({
 String childName, bool isGranted
});




}
/// @nodoc
class __$NotificationsPermissionStateCopyWithImpl<$Res>
    implements _$NotificationsPermissionStateCopyWith<$Res> {
  __$NotificationsPermissionStateCopyWithImpl(this._self, this._then);

  final _NotificationsPermissionState _self;
  final $Res Function(_NotificationsPermissionState) _then;

/// Create a copy of NotificationsPermissionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? childName = null,Object? isGranted = null,}) {
  return _then(_NotificationsPermissionState(
childName: null == childName ? _self.childName : childName // ignore: cast_nullable_to_non_nullable
as String,isGranted: null == isGranted ? _self.isGranted : isGranted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
