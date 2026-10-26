// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'child_essentials_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChildEssentialsState {

 bool get isLoading; String get childName; List<String> get allergies; List<String> get medications; List<String> get emergencyContacts; String get pediatrician; ApiResultStatus<dynamic> get fetchStatus;
/// Create a copy of ChildEssentialsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChildEssentialsStateCopyWith<ChildEssentialsState> get copyWith => _$ChildEssentialsStateCopyWithImpl<ChildEssentialsState>(this as ChildEssentialsState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ChildEssentialsState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChildEssentialsState&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.childName, _this.childName) || other.childName == _this.childName)&&const DeepCollectionEquality().equals(other.allergies, _this.allergies)&&const DeepCollectionEquality().equals(other.medications, _this.medications)&&const DeepCollectionEquality().equals(other.emergencyContacts, _this.emergencyContacts)&&(identical(other.pediatrician, _this.pediatrician) || other.pediatrician == _this.pediatrician)&&(identical(other.fetchStatus, _this.fetchStatus) || other.fetchStatus == _this.fetchStatus));
}


@override
int get hashCode {
  final _this = this as ChildEssentialsState;
  return Object.hash(runtimeType,_this.isLoading,_this.childName,const DeepCollectionEquality().hash(_this.allergies),const DeepCollectionEquality().hash(_this.medications),const DeepCollectionEquality().hash(_this.emergencyContacts),_this.pediatrician,_this.fetchStatus);
}

@override
String toString() {
  final _this = this as ChildEssentialsState;
  return 'ChildEssentialsState(isLoading: ${_this.isLoading}, childName: ${_this.childName}, allergies: ${_this.allergies}, medications: ${_this.medications}, emergencyContacts: ${_this.emergencyContacts}, pediatrician: ${_this.pediatrician}, fetchStatus: ${_this.fetchStatus})';
}


}

/// @nodoc
abstract mixin class $ChildEssentialsStateCopyWith<$Res>  {
  factory $ChildEssentialsStateCopyWith(ChildEssentialsState value, $Res Function(ChildEssentialsState) _then) = _$ChildEssentialsStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, String childName, List<String> allergies, List<String> medications, List<String> emergencyContacts, String pediatrician, ApiResultStatus<dynamic> fetchStatus
});


$ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus;

}
/// @nodoc
class _$ChildEssentialsStateCopyWithImpl<$Res>
    implements $ChildEssentialsStateCopyWith<$Res> {
  _$ChildEssentialsStateCopyWithImpl(this._self, this._then);

  final ChildEssentialsState _self;
  final $Res Function(ChildEssentialsState) _then;

/// Create a copy of ChildEssentialsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? childName = null,Object? allergies = null,Object? medications = null,Object? emergencyContacts = null,Object? pediatrician = null,Object? fetchStatus = null,}) {
  return _then(ChildEssentialsState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,childName: null == childName ? _self.childName : childName // ignore: cast_nullable_to_non_nullable
as String,allergies: null == allergies ? _self.allergies : allergies // ignore: cast_nullable_to_non_nullable
as List<String>,medications: null == medications ? _self.medications : medications // ignore: cast_nullable_to_non_nullable
as List<String>,emergencyContacts: null == emergencyContacts ? _self.emergencyContacts : emergencyContacts // ignore: cast_nullable_to_non_nullable
as List<String>,pediatrician: null == pediatrician ? _self.pediatrician : pediatrician // ignore: cast_nullable_to_non_nullable
as String,fetchStatus: null == fetchStatus ? _self.fetchStatus : fetchStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}
/// Create a copy of ChildEssentialsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.fetchStatus, (value) {
    return _then(_self.copyWith(fetchStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [ChildEssentialsState].
extension ChildEssentialsStatePatterns on ChildEssentialsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChildEssentialsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChildEssentialsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChildEssentialsState value)  $default,){
final _that = this;
switch (_that) {
case _ChildEssentialsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChildEssentialsState value)?  $default,){
final _that = this;
switch (_that) {
case _ChildEssentialsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  String childName,  List<String> allergies,  List<String> medications,  List<String> emergencyContacts,  String pediatrician,  ApiResultStatus<dynamic> fetchStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChildEssentialsState() when $default != null:
return $default(_that.isLoading,_that.childName,_that.allergies,_that.medications,_that.emergencyContacts,_that.pediatrician,_that.fetchStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  String childName,  List<String> allergies,  List<String> medications,  List<String> emergencyContacts,  String pediatrician,  ApiResultStatus<dynamic> fetchStatus)  $default,) {final _that = this;
switch (_that) {
case _ChildEssentialsState():
return $default(_that.isLoading,_that.childName,_that.allergies,_that.medications,_that.emergencyContacts,_that.pediatrician,_that.fetchStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  String childName,  List<String> allergies,  List<String> medications,  List<String> emergencyContacts,  String pediatrician,  ApiResultStatus<dynamic> fetchStatus)?  $default,) {final _that = this;
switch (_that) {
case _ChildEssentialsState() when $default != null:
return $default(_that.isLoading,_that.childName,_that.allergies,_that.medications,_that.emergencyContacts,_that.pediatrician,_that.fetchStatus);case _:
  return null;

}
}

}

/// @nodoc


class _ChildEssentialsState implements ChildEssentialsState {
  const _ChildEssentialsState({this.isLoading = false, this.childName = 'your child',  List<String> allergies = const <String>[],  List<String> medications = const <String>[],  List<String> emergencyContacts = const <String>[], this.pediatrician = '', this.fetchStatus = const ApiResultStatus.initial()}): _allergies = allergies,_medications = medications,_emergencyContacts = emergencyContacts;
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  String childName;
 final  List<String> _allergies;
@override@JsonKey() List<String> get allergies {
  if (_allergies is EqualUnmodifiableListView) return _allergies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allergies);
}

 final  List<String> _medications;
@override@JsonKey() List<String> get medications {
  if (_medications is EqualUnmodifiableListView) return _medications;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_medications);
}

 final  List<String> _emergencyContacts;
@override@JsonKey() List<String> get emergencyContacts {
  if (_emergencyContacts is EqualUnmodifiableListView) return _emergencyContacts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_emergencyContacts);
}

@override@JsonKey() final  String pediatrician;
@override@JsonKey() final  ApiResultStatus<dynamic> fetchStatus;

/// Create a copy of ChildEssentialsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChildEssentialsStateCopyWith<_ChildEssentialsState> get copyWith => __$ChildEssentialsStateCopyWithImpl<_ChildEssentialsState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChildEssentialsState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.childName, childName) || other.childName == childName)&&const DeepCollectionEquality().equals(other.allergies, _allergies)&&const DeepCollectionEquality().equals(other.medications, _medications)&&const DeepCollectionEquality().equals(other.emergencyContacts, _emergencyContacts)&&(identical(other.pediatrician, pediatrician) || other.pediatrician == pediatrician)&&(identical(other.fetchStatus, fetchStatus) || other.fetchStatus == fetchStatus));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isLoading,childName,const DeepCollectionEquality().hash(_allergies),const DeepCollectionEquality().hash(_medications),const DeepCollectionEquality().hash(_emergencyContacts),pediatrician,fetchStatus);
}

@override
String toString() {
    return 'ChildEssentialsState(isLoading: $isLoading, childName: $childName, allergies: $allergies, medications: $medications, emergencyContacts: $emergencyContacts, pediatrician: $pediatrician, fetchStatus: $fetchStatus)';
}


}

/// @nodoc
abstract mixin class _$ChildEssentialsStateCopyWith<$Res> implements $ChildEssentialsStateCopyWith<$Res> {
  factory _$ChildEssentialsStateCopyWith(_ChildEssentialsState value, $Res Function(_ChildEssentialsState) _then) = __$ChildEssentialsStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, String childName, List<String> allergies, List<String> medications, List<String> emergencyContacts, String pediatrician, ApiResultStatus<dynamic> fetchStatus
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus;

}
/// @nodoc
class __$ChildEssentialsStateCopyWithImpl<$Res>
    implements _$ChildEssentialsStateCopyWith<$Res> {
  __$ChildEssentialsStateCopyWithImpl(this._self, this._then);

  final _ChildEssentialsState _self;
  final $Res Function(_ChildEssentialsState) _then;

/// Create a copy of ChildEssentialsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? childName = null,Object? allergies = null,Object? medications = null,Object? emergencyContacts = null,Object? pediatrician = null,Object? fetchStatus = null,}) {
  return _then(_ChildEssentialsState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,childName: null == childName ? _self.childName : childName // ignore: cast_nullable_to_non_nullable
as String,allergies: null == allergies ? _self._allergies : allergies // ignore: cast_nullable_to_non_nullable
as List<String>,medications: null == medications ? _self._medications : medications // ignore: cast_nullable_to_non_nullable
as List<String>,emergencyContacts: null == emergencyContacts ? _self._emergencyContacts : emergencyContacts // ignore: cast_nullable_to_non_nullable
as List<String>,pediatrician: null == pediatrician ? _self.pediatrician : pediatrician // ignore: cast_nullable_to_non_nullable
as String,fetchStatus: null == fetchStatus ? _self.fetchStatus : fetchStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}

/// Create a copy of ChildEssentialsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.fetchStatus, (value) {
    return _then(_self.copyWith(fetchStatus: value));
  });
}
}

// dart format on
