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

 String get message; DateTime? get dateOfBirth; List<String> get genderList; String get selectedGender; String get parentName; String get parentEmail;
/// Create a copy of ParentProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParentProfileStateCopyWith<ParentProfileState> get copyWith => _$ParentProfileStateCopyWithImpl<ParentProfileState>(this as ParentProfileState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParentProfileState&&(identical(other.message, message) || other.message == message)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&const DeepCollectionEquality().equals(other.genderList, genderList)&&(identical(other.selectedGender, selectedGender) || other.selectedGender == selectedGender)&&(identical(other.parentName, parentName) || other.parentName == parentName)&&(identical(other.parentEmail, parentEmail) || other.parentEmail == parentEmail));
}


@override
int get hashCode => Object.hash(runtimeType,message,dateOfBirth,const DeepCollectionEquality().hash(genderList),selectedGender,parentName,parentEmail);

@override
String toString() {
  return 'ParentProfileState(message: $message, dateOfBirth: $dateOfBirth, genderList: $genderList, selectedGender: $selectedGender, parentName: $parentName, parentEmail: $parentEmail)';
}


}

/// @nodoc
abstract mixin class $ParentProfileStateCopyWith<$Res>  {
  factory $ParentProfileStateCopyWith(ParentProfileState value, $Res Function(ParentProfileState) _then) = _$ParentProfileStateCopyWithImpl;
@useResult
$Res call({
 String message, DateTime? dateOfBirth, List<String> genderList, String selectedGender, String parentName, String parentEmail
});




}
/// @nodoc
class _$ParentProfileStateCopyWithImpl<$Res>
    implements $ParentProfileStateCopyWith<$Res> {
  _$ParentProfileStateCopyWithImpl(this._self, this._then);

  final ParentProfileState _self;
  final $Res Function(ParentProfileState) _then;

/// Create a copy of ParentProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,Object? dateOfBirth = freezed,Object? genderList = null,Object? selectedGender = null,Object? parentName = null,Object? parentEmail = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime?,genderList: null == genderList ? _self.genderList : genderList // ignore: cast_nullable_to_non_nullable
as List<String>,selectedGender: null == selectedGender ? _self.selectedGender : selectedGender // ignore: cast_nullable_to_non_nullable
as String,parentName: null == parentName ? _self.parentName : parentName // ignore: cast_nullable_to_non_nullable
as String,parentEmail: null == parentEmail ? _self.parentEmail : parentEmail // ignore: cast_nullable_to_non_nullable
as String,
  ));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String message,  DateTime? dateOfBirth,  List<String> genderList,  String selectedGender,  String parentName,  String parentEmail)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParentProfileState() when $default != null:
return $default(_that.message,_that.dateOfBirth,_that.genderList,_that.selectedGender,_that.parentName,_that.parentEmail);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String message,  DateTime? dateOfBirth,  List<String> genderList,  String selectedGender,  String parentName,  String parentEmail)  $default,) {final _that = this;
switch (_that) {
case _ParentProfileState():
return $default(_that.message,_that.dateOfBirth,_that.genderList,_that.selectedGender,_that.parentName,_that.parentEmail);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String message,  DateTime? dateOfBirth,  List<String> genderList,  String selectedGender,  String parentName,  String parentEmail)?  $default,) {final _that = this;
switch (_that) {
case _ParentProfileState() when $default != null:
return $default(_that.message,_that.dateOfBirth,_that.genderList,_that.selectedGender,_that.parentName,_that.parentEmail);case _:
  return null;

}
}

}

/// @nodoc


class _ParentProfileState implements ParentProfileState {
  const _ParentProfileState({this.message = "", this.dateOfBirth, final  List<String> genderList = const [], this.selectedGender = "", this.parentName = "", this.parentEmail = ""}): _genderList = genderList;
  

@override@JsonKey() final  String message;
@override final  DateTime? dateOfBirth;
 final  List<String> _genderList;
@override@JsonKey() List<String> get genderList {
  if (_genderList is EqualUnmodifiableListView) return _genderList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_genderList);
}

@override@JsonKey() final  String selectedGender;
@override@JsonKey() final  String parentName;
@override@JsonKey() final  String parentEmail;

/// Create a copy of ParentProfileState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParentProfileStateCopyWith<_ParentProfileState> get copyWith => __$ParentProfileStateCopyWithImpl<_ParentProfileState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParentProfileState&&(identical(other.message, message) || other.message == message)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&const DeepCollectionEquality().equals(other._genderList, _genderList)&&(identical(other.selectedGender, selectedGender) || other.selectedGender == selectedGender)&&(identical(other.parentName, parentName) || other.parentName == parentName)&&(identical(other.parentEmail, parentEmail) || other.parentEmail == parentEmail));
}


@override
int get hashCode => Object.hash(runtimeType,message,dateOfBirth,const DeepCollectionEquality().hash(_genderList),selectedGender,parentName,parentEmail);

@override
String toString() {
  return 'ParentProfileState(message: $message, dateOfBirth: $dateOfBirth, genderList: $genderList, selectedGender: $selectedGender, parentName: $parentName, parentEmail: $parentEmail)';
}


}

/// @nodoc
abstract mixin class _$ParentProfileStateCopyWith<$Res> implements $ParentProfileStateCopyWith<$Res> {
  factory _$ParentProfileStateCopyWith(_ParentProfileState value, $Res Function(_ParentProfileState) _then) = __$ParentProfileStateCopyWithImpl;
@override @useResult
$Res call({
 String message, DateTime? dateOfBirth, List<String> genderList, String selectedGender, String parentName, String parentEmail
});




}
/// @nodoc
class __$ParentProfileStateCopyWithImpl<$Res>
    implements _$ParentProfileStateCopyWith<$Res> {
  __$ParentProfileStateCopyWithImpl(this._self, this._then);

  final _ParentProfileState _self;
  final $Res Function(_ParentProfileState) _then;

/// Create a copy of ParentProfileState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? dateOfBirth = freezed,Object? genderList = null,Object? selectedGender = null,Object? parentName = null,Object? parentEmail = null,}) {
  return _then(_ParentProfileState(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime?,genderList: null == genderList ? _self._genderList : genderList // ignore: cast_nullable_to_non_nullable
as List<String>,selectedGender: null == selectedGender ? _self.selectedGender : selectedGender // ignore: cast_nullable_to_non_nullable
as String,parentName: null == parentName ? _self.parentName : parentName // ignore: cast_nullable_to_non_nullable
as String,parentEmail: null == parentEmail ? _self.parentEmail : parentEmail // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
