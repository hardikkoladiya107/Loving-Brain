// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'family_sharing_consent_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FamilySharingConsentState {

 String get childName; bool get isConsentGiven;
/// Create a copy of FamilySharingConsentState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FamilySharingConsentStateCopyWith<FamilySharingConsentState> get copyWith => _$FamilySharingConsentStateCopyWithImpl<FamilySharingConsentState>(this as FamilySharingConsentState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FamilySharingConsentState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FamilySharingConsentState&&(identical(other.childName, _this.childName) || other.childName == _this.childName)&&(identical(other.isConsentGiven, _this.isConsentGiven) || other.isConsentGiven == _this.isConsentGiven));
}


@override
int get hashCode {
  final _this = this as FamilySharingConsentState;
  return Object.hash(runtimeType,_this.childName,_this.isConsentGiven);
}

@override
String toString() {
  final _this = this as FamilySharingConsentState;
  return 'FamilySharingConsentState(childName: ${_this.childName}, isConsentGiven: ${_this.isConsentGiven})';
}


}

/// @nodoc
abstract mixin class $FamilySharingConsentStateCopyWith<$Res>  {
  factory $FamilySharingConsentStateCopyWith(FamilySharingConsentState value, $Res Function(FamilySharingConsentState) _then) = _$FamilySharingConsentStateCopyWithImpl;
@useResult
$Res call({
 String childName, bool isConsentGiven
});




}
/// @nodoc
class _$FamilySharingConsentStateCopyWithImpl<$Res>
    implements $FamilySharingConsentStateCopyWith<$Res> {
  _$FamilySharingConsentStateCopyWithImpl(this._self, this._then);

  final FamilySharingConsentState _self;
  final $Res Function(FamilySharingConsentState) _then;

/// Create a copy of FamilySharingConsentState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? childName = null,Object? isConsentGiven = null,}) {
  return _then(FamilySharingConsentState(
childName: null == childName ? _self.childName : childName // ignore: cast_nullable_to_non_nullable
as String,isConsentGiven: null == isConsentGiven ? _self.isConsentGiven : isConsentGiven // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [FamilySharingConsentState].
extension FamilySharingConsentStatePatterns on FamilySharingConsentState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FamilySharingConsentState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FamilySharingConsentState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FamilySharingConsentState value)  $default,){
final _that = this;
switch (_that) {
case _FamilySharingConsentState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FamilySharingConsentState value)?  $default,){
final _that = this;
switch (_that) {
case _FamilySharingConsentState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String childName,  bool isConsentGiven)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FamilySharingConsentState() when $default != null:
return $default(_that.childName,_that.isConsentGiven);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String childName,  bool isConsentGiven)  $default,) {final _that = this;
switch (_that) {
case _FamilySharingConsentState():
return $default(_that.childName,_that.isConsentGiven);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String childName,  bool isConsentGiven)?  $default,) {final _that = this;
switch (_that) {
case _FamilySharingConsentState() when $default != null:
return $default(_that.childName,_that.isConsentGiven);case _:
  return null;

}
}

}

/// @nodoc


class _FamilySharingConsentState implements FamilySharingConsentState {
  const _FamilySharingConsentState({this.childName = 'your child', this.isConsentGiven = false});
  

@override@JsonKey() final  String childName;
@override@JsonKey() final  bool isConsentGiven;

/// Create a copy of FamilySharingConsentState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FamilySharingConsentStateCopyWith<_FamilySharingConsentState> get copyWith => __$FamilySharingConsentStateCopyWithImpl<_FamilySharingConsentState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FamilySharingConsentState&&(identical(other.childName, childName) || other.childName == childName)&&(identical(other.isConsentGiven, isConsentGiven) || other.isConsentGiven == isConsentGiven));
}


@override
int get hashCode {
    return Object.hash(runtimeType,childName,isConsentGiven);
}

@override
String toString() {
    return 'FamilySharingConsentState(childName: $childName, isConsentGiven: $isConsentGiven)';
}


}

/// @nodoc
abstract mixin class _$FamilySharingConsentStateCopyWith<$Res> implements $FamilySharingConsentStateCopyWith<$Res> {
  factory _$FamilySharingConsentStateCopyWith(_FamilySharingConsentState value, $Res Function(_FamilySharingConsentState) _then) = __$FamilySharingConsentStateCopyWithImpl;
@override @useResult
$Res call({
 String childName, bool isConsentGiven
});




}
/// @nodoc
class __$FamilySharingConsentStateCopyWithImpl<$Res>
    implements _$FamilySharingConsentStateCopyWith<$Res> {
  __$FamilySharingConsentStateCopyWithImpl(this._self, this._then);

  final _FamilySharingConsentState _self;
  final $Res Function(_FamilySharingConsentState) _then;

/// Create a copy of FamilySharingConsentState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? childName = null,Object? isConsentGiven = null,}) {
  return _then(_FamilySharingConsentState(
childName: null == childName ? _self.childName : childName // ignore: cast_nullable_to_non_nullable
as String,isConsentGiven: null == isConsentGiven ? _self.isConsentGiven : isConsentGiven // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
