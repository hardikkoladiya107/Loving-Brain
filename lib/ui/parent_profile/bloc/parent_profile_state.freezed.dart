// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parent_profile_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ParentProfileState {

 List<String> get genderList; String get parentName; String get parentNameError; String get parentEmailAddress; String get parentEmailAddressError; DateTime? get parentDateOfBirth; String get parentDateOfBirthError; String get parentGender; String get parentGenderError; ApiResultStatus get apiResultStatus;
/// Create a copy of ParentProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParentProfileStateCopyWith<ParentProfileState> get copyWith => _$ParentProfileStateCopyWithImpl<ParentProfileState>(this as ParentProfileState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParentProfileState&&const DeepCollectionEquality().equals(other.genderList, genderList)&&(identical(other.parentName, parentName) || other.parentName == parentName)&&(identical(other.parentNameError, parentNameError) || other.parentNameError == parentNameError)&&(identical(other.parentEmailAddress, parentEmailAddress) || other.parentEmailAddress == parentEmailAddress)&&(identical(other.parentEmailAddressError, parentEmailAddressError) || other.parentEmailAddressError == parentEmailAddressError)&&(identical(other.parentDateOfBirth, parentDateOfBirth) || other.parentDateOfBirth == parentDateOfBirth)&&(identical(other.parentDateOfBirthError, parentDateOfBirthError) || other.parentDateOfBirthError == parentDateOfBirthError)&&(identical(other.parentGender, parentGender) || other.parentGender == parentGender)&&(identical(other.parentGenderError, parentGenderError) || other.parentGenderError == parentGenderError)&&(identical(other.apiResultStatus, apiResultStatus) || other.apiResultStatus == apiResultStatus));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(genderList),parentName,parentNameError,parentEmailAddress,parentEmailAddressError,parentDateOfBirth,parentDateOfBirthError,parentGender,parentGenderError,apiResultStatus);

@override
String toString() {
  return 'ParentProfileState(genderList: $genderList, parentName: $parentName, parentNameError: $parentNameError, parentEmailAddress: $parentEmailAddress, parentEmailAddressError: $parentEmailAddressError, parentDateOfBirth: $parentDateOfBirth, parentDateOfBirthError: $parentDateOfBirthError, parentGender: $parentGender, parentGenderError: $parentGenderError, apiResultStatus: $apiResultStatus)';
}


}

/// @nodoc
abstract mixin class $ParentProfileStateCopyWith<$Res>  {
  factory $ParentProfileStateCopyWith(ParentProfileState value, $Res Function(ParentProfileState) _then) = _$ParentProfileStateCopyWithImpl;
@useResult
$Res call({
 List<String> genderList, String parentName, String parentNameError, String parentEmailAddress, String parentEmailAddressError, DateTime? parentDateOfBirth, String parentDateOfBirthError, String parentGender, String parentGenderError, ApiResultStatus apiResultStatus
});


$ApiResultStatusCopyWith<dynamic, $Res> get apiResultStatus;

}
/// @nodoc
class _$ParentProfileStateCopyWithImpl<$Res>
    implements $ParentProfileStateCopyWith<$Res> {
  _$ParentProfileStateCopyWithImpl(this._self, this._then);

  final ParentProfileState _self;
  final $Res Function(ParentProfileState) _then;

/// Create a copy of ParentProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? genderList = null,Object? parentName = null,Object? parentNameError = null,Object? parentEmailAddress = null,Object? parentEmailAddressError = null,Object? parentDateOfBirth = freezed,Object? parentDateOfBirthError = null,Object? parentGender = null,Object? parentGenderError = null,Object? apiResultStatus = null,}) {
  return _then(_self.copyWith(
genderList: null == genderList ? _self.genderList : genderList // ignore: cast_nullable_to_non_nullable
as List<String>,parentName: null == parentName ? _self.parentName : parentName // ignore: cast_nullable_to_non_nullable
as String,parentNameError: null == parentNameError ? _self.parentNameError : parentNameError // ignore: cast_nullable_to_non_nullable
as String,parentEmailAddress: null == parentEmailAddress ? _self.parentEmailAddress : parentEmailAddress // ignore: cast_nullable_to_non_nullable
as String,parentEmailAddressError: null == parentEmailAddressError ? _self.parentEmailAddressError : parentEmailAddressError // ignore: cast_nullable_to_non_nullable
as String,parentDateOfBirth: freezed == parentDateOfBirth ? _self.parentDateOfBirth : parentDateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime?,parentDateOfBirthError: null == parentDateOfBirthError ? _self.parentDateOfBirthError : parentDateOfBirthError // ignore: cast_nullable_to_non_nullable
as String,parentGender: null == parentGender ? _self.parentGender : parentGender // ignore: cast_nullable_to_non_nullable
as String,parentGenderError: null == parentGenderError ? _self.parentGenderError : parentGenderError // ignore: cast_nullable_to_non_nullable
as String,apiResultStatus: null == apiResultStatus ? _self.apiResultStatus : apiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,
  ));
}
/// Create a copy of ParentProfileState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get apiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.apiResultStatus, (value) {
    return _then(_self.copyWith(apiResultStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [ParentProfileState].
extension ParentProfileStatePatterns on ParentProfileState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParentProfileState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParentProfileState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParentProfileState value)  $default,){
final _that = this;
switch (_that) {
case _ParentProfileState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParentProfileState value)?  $default,){
final _that = this;
switch (_that) {
case _ParentProfileState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> genderList,  String parentName,  String parentNameError,  String parentEmailAddress,  String parentEmailAddressError,  DateTime? parentDateOfBirth,  String parentDateOfBirthError,  String parentGender,  String parentGenderError,  ApiResultStatus apiResultStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParentProfileState() when $default != null:
return $default(_that.genderList,_that.parentName,_that.parentNameError,_that.parentEmailAddress,_that.parentEmailAddressError,_that.parentDateOfBirth,_that.parentDateOfBirthError,_that.parentGender,_that.parentGenderError,_that.apiResultStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> genderList,  String parentName,  String parentNameError,  String parentEmailAddress,  String parentEmailAddressError,  DateTime? parentDateOfBirth,  String parentDateOfBirthError,  String parentGender,  String parentGenderError,  ApiResultStatus apiResultStatus)  $default,) {final _that = this;
switch (_that) {
case _ParentProfileState():
return $default(_that.genderList,_that.parentName,_that.parentNameError,_that.parentEmailAddress,_that.parentEmailAddressError,_that.parentDateOfBirth,_that.parentDateOfBirthError,_that.parentGender,_that.parentGenderError,_that.apiResultStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> genderList,  String parentName,  String parentNameError,  String parentEmailAddress,  String parentEmailAddressError,  DateTime? parentDateOfBirth,  String parentDateOfBirthError,  String parentGender,  String parentGenderError,  ApiResultStatus apiResultStatus)?  $default,) {final _that = this;
switch (_that) {
case _ParentProfileState() when $default != null:
return $default(_that.genderList,_that.parentName,_that.parentNameError,_that.parentEmailAddress,_that.parentEmailAddressError,_that.parentDateOfBirth,_that.parentDateOfBirthError,_that.parentGender,_that.parentGenderError,_that.apiResultStatus);case _:
  return null;

}
}

}

/// @nodoc


class _ParentProfileState implements ParentProfileState {
  const _ParentProfileState({final  List<String> genderList = const [], this.parentName = "", this.parentNameError = "", this.parentEmailAddress = "", this.parentEmailAddressError = "", this.parentDateOfBirth, this.parentDateOfBirthError = "", this.parentGender = "", this.parentGenderError = "", this.apiResultStatus = const ApiResultStatus.initial()}): _genderList = genderList;
  

 final  List<String> _genderList;
@override@JsonKey() List<String> get genderList {
  if (_genderList is EqualUnmodifiableListView) return _genderList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_genderList);
}

@override@JsonKey() final  String parentName;
@override@JsonKey() final  String parentNameError;
@override@JsonKey() final  String parentEmailAddress;
@override@JsonKey() final  String parentEmailAddressError;
@override final  DateTime? parentDateOfBirth;
@override@JsonKey() final  String parentDateOfBirthError;
@override@JsonKey() final  String parentGender;
@override@JsonKey() final  String parentGenderError;
@override@JsonKey() final  ApiResultStatus apiResultStatus;

/// Create a copy of ParentProfileState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParentProfileStateCopyWith<_ParentProfileState> get copyWith => __$ParentProfileStateCopyWithImpl<_ParentProfileState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParentProfileState&&const DeepCollectionEquality().equals(other._genderList, _genderList)&&(identical(other.parentName, parentName) || other.parentName == parentName)&&(identical(other.parentNameError, parentNameError) || other.parentNameError == parentNameError)&&(identical(other.parentEmailAddress, parentEmailAddress) || other.parentEmailAddress == parentEmailAddress)&&(identical(other.parentEmailAddressError, parentEmailAddressError) || other.parentEmailAddressError == parentEmailAddressError)&&(identical(other.parentDateOfBirth, parentDateOfBirth) || other.parentDateOfBirth == parentDateOfBirth)&&(identical(other.parentDateOfBirthError, parentDateOfBirthError) || other.parentDateOfBirthError == parentDateOfBirthError)&&(identical(other.parentGender, parentGender) || other.parentGender == parentGender)&&(identical(other.parentGenderError, parentGenderError) || other.parentGenderError == parentGenderError)&&(identical(other.apiResultStatus, apiResultStatus) || other.apiResultStatus == apiResultStatus));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_genderList),parentName,parentNameError,parentEmailAddress,parentEmailAddressError,parentDateOfBirth,parentDateOfBirthError,parentGender,parentGenderError,apiResultStatus);

@override
String toString() {
  return 'ParentProfileState(genderList: $genderList, parentName: $parentName, parentNameError: $parentNameError, parentEmailAddress: $parentEmailAddress, parentEmailAddressError: $parentEmailAddressError, parentDateOfBirth: $parentDateOfBirth, parentDateOfBirthError: $parentDateOfBirthError, parentGender: $parentGender, parentGenderError: $parentGenderError, apiResultStatus: $apiResultStatus)';
}


}

/// @nodoc
abstract mixin class _$ParentProfileStateCopyWith<$Res> implements $ParentProfileStateCopyWith<$Res> {
  factory _$ParentProfileStateCopyWith(_ParentProfileState value, $Res Function(_ParentProfileState) _then) = __$ParentProfileStateCopyWithImpl;
@override @useResult
$Res call({
 List<String> genderList, String parentName, String parentNameError, String parentEmailAddress, String parentEmailAddressError, DateTime? parentDateOfBirth, String parentDateOfBirthError, String parentGender, String parentGenderError, ApiResultStatus apiResultStatus
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get apiResultStatus;

}
/// @nodoc
class __$ParentProfileStateCopyWithImpl<$Res>
    implements _$ParentProfileStateCopyWith<$Res> {
  __$ParentProfileStateCopyWithImpl(this._self, this._then);

  final _ParentProfileState _self;
  final $Res Function(_ParentProfileState) _then;

/// Create a copy of ParentProfileState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? genderList = null,Object? parentName = null,Object? parentNameError = null,Object? parentEmailAddress = null,Object? parentEmailAddressError = null,Object? parentDateOfBirth = freezed,Object? parentDateOfBirthError = null,Object? parentGender = null,Object? parentGenderError = null,Object? apiResultStatus = null,}) {
  return _then(_ParentProfileState(
genderList: null == genderList ? _self._genderList : genderList // ignore: cast_nullable_to_non_nullable
as List<String>,parentName: null == parentName ? _self.parentName : parentName // ignore: cast_nullable_to_non_nullable
as String,parentNameError: null == parentNameError ? _self.parentNameError : parentNameError // ignore: cast_nullable_to_non_nullable
as String,parentEmailAddress: null == parentEmailAddress ? _self.parentEmailAddress : parentEmailAddress // ignore: cast_nullable_to_non_nullable
as String,parentEmailAddressError: null == parentEmailAddressError ? _self.parentEmailAddressError : parentEmailAddressError // ignore: cast_nullable_to_non_nullable
as String,parentDateOfBirth: freezed == parentDateOfBirth ? _self.parentDateOfBirth : parentDateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime?,parentDateOfBirthError: null == parentDateOfBirthError ? _self.parentDateOfBirthError : parentDateOfBirthError // ignore: cast_nullable_to_non_nullable
as String,parentGender: null == parentGender ? _self.parentGender : parentGender // ignore: cast_nullable_to_non_nullable
as String,parentGenderError: null == parentGenderError ? _self.parentGenderError : parentGenderError // ignore: cast_nullable_to_non_nullable
as String,apiResultStatus: null == apiResultStatus ? _self.apiResultStatus : apiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,
  ));
}

/// Create a copy of ParentProfileState
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
