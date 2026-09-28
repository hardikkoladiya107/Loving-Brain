// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parent_profile_v2_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ParentProfileV2State {

 UserModel? get user; String get name; String get relationship; String get dob; String get gender; String get language; String get location; ApiResultStatus<String> get saveStatus; ApiResultStatus<String> get logoutStatus; ApiResultStatus<String> get deleteAccountStatus;
/// Create a copy of ParentProfileV2State
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParentProfileV2StateCopyWith<ParentProfileV2State> get copyWith => _$ParentProfileV2StateCopyWithImpl<ParentProfileV2State>(this as ParentProfileV2State, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ParentProfileV2State;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParentProfileV2State&&(identical(other.user, _this.user) || other.user == _this.user)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.relationship, _this.relationship) || other.relationship == _this.relationship)&&(identical(other.dob, _this.dob) || other.dob == _this.dob)&&(identical(other.gender, _this.gender) || other.gender == _this.gender)&&(identical(other.language, _this.language) || other.language == _this.language)&&(identical(other.location, _this.location) || other.location == _this.location)&&(identical(other.saveStatus, _this.saveStatus) || other.saveStatus == _this.saveStatus)&&(identical(other.logoutStatus, _this.logoutStatus) || other.logoutStatus == _this.logoutStatus)&&(identical(other.deleteAccountStatus, _this.deleteAccountStatus) || other.deleteAccountStatus == _this.deleteAccountStatus));
}


@override
int get hashCode {
  final _this = this as ParentProfileV2State;
  return Object.hash(runtimeType,_this.user,_this.name,_this.relationship,_this.dob,_this.gender,_this.language,_this.location,_this.saveStatus,_this.logoutStatus,_this.deleteAccountStatus);
}

@override
String toString() {
  final _this = this as ParentProfileV2State;
  return 'ParentProfileV2State(user: ${_this.user}, name: ${_this.name}, relationship: ${_this.relationship}, dob: ${_this.dob}, gender: ${_this.gender}, language: ${_this.language}, location: ${_this.location}, saveStatus: ${_this.saveStatus}, logoutStatus: ${_this.logoutStatus}, deleteAccountStatus: ${_this.deleteAccountStatus})';
}


}

/// @nodoc
abstract mixin class $ParentProfileV2StateCopyWith<$Res>  {
  factory $ParentProfileV2StateCopyWith(ParentProfileV2State value, $Res Function(ParentProfileV2State) _then) = _$ParentProfileV2StateCopyWithImpl;
@useResult
$Res call({
 UserModel? user, String name, String relationship, String dob, String gender, String language, String location, ApiResultStatus<String> saveStatus, ApiResultStatus<String> logoutStatus, ApiResultStatus<String> deleteAccountStatus
});


$ApiResultStatusCopyWith<String, $Res> get saveStatus;$ApiResultStatusCopyWith<String, $Res> get logoutStatus;$ApiResultStatusCopyWith<String, $Res> get deleteAccountStatus;

}
/// @nodoc
class _$ParentProfileV2StateCopyWithImpl<$Res>
    implements $ParentProfileV2StateCopyWith<$Res> {
  _$ParentProfileV2StateCopyWithImpl(this._self, this._then);

  final ParentProfileV2State _self;
  final $Res Function(ParentProfileV2State) _then;

/// Create a copy of ParentProfileV2State
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? user = freezed,Object? name = null,Object? relationship = null,Object? dob = null,Object? gender = null,Object? language = null,Object? location = null,Object? saveStatus = null,Object? logoutStatus = null,Object? deleteAccountStatus = null,}) {
  return _then(ParentProfileV2State(
user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserModel?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,relationship: null == relationship ? _self.relationship : relationship // ignore: cast_nullable_to_non_nullable
as String,dob: null == dob ? _self.dob : dob // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,saveStatus: null == saveStatus ? _self.saveStatus : saveStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<String>,logoutStatus: null == logoutStatus ? _self.logoutStatus : logoutStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<String>,deleteAccountStatus: null == deleteAccountStatus ? _self.deleteAccountStatus : deleteAccountStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<String>,
  ));
}
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<String, $Res> get saveStatus {
  
  return $ApiResultStatusCopyWith<String, $Res>(_self.saveStatus, (value) {
    return _then(_self.copyWith(saveStatus: value));
  });
}
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<String, $Res> get logoutStatus {
  
  return $ApiResultStatusCopyWith<String, $Res>(_self.logoutStatus, (value) {
    return _then(_self.copyWith(logoutStatus: value));
  });
}
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<String, $Res> get deleteAccountStatus {
  
  return $ApiResultStatusCopyWith<String, $Res>(_self.deleteAccountStatus, (value) {
    return _then(_self.copyWith(deleteAccountStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [ParentProfileV2State].
extension ParentProfileV2StatePatterns on ParentProfileV2State {
@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParentProfileV2State value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParentProfileV2State() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParentProfileV2State value)  $default,){
final _that = this;
switch (_that) {
case _ParentProfileV2State():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParentProfileV2State value)?  $default,){
final _that = this;
switch (_that) {
case _ParentProfileV2State() when $default != null:
return $default(_that);case _:
  return null;

}
}
@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UserModel? user,  String name,  String relationship,  String dob,  String gender,  String language,  String location,  ApiResultStatus<String> saveStatus,  ApiResultStatus<String> logoutStatus,  ApiResultStatus<String> deleteAccountStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParentProfileV2State() when $default != null:
return $default(_that.user,_that.name,_that.relationship,_that.dob,_that.gender,_that.language,_that.location,_that.saveStatus,_that.logoutStatus,_that.deleteAccountStatus);case _:
  return orElse();

}
}
@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UserModel? user,  String name,  String relationship,  String dob,  String gender,  String language,  String location,  ApiResultStatus<String> saveStatus,  ApiResultStatus<String> logoutStatus,  ApiResultStatus<String> deleteAccountStatus)  $default,) {final _that = this;
switch (_that) {
case _ParentProfileV2State():
return $default(_that.user,_that.name,_that.relationship,_that.dob,_that.gender,_that.language,_that.location,_that.saveStatus,_that.logoutStatus,_that.deleteAccountStatus);case _:
  throw StateError('Unexpected subclass');

}
}
@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UserModel? user,  String name,  String relationship,  String dob,  String gender,  String language,  String location,  ApiResultStatus<String> saveStatus,  ApiResultStatus<String> logoutStatus,  ApiResultStatus<String> deleteAccountStatus)?  $default,) {final _that = this;
switch (_that) {
case _ParentProfileV2State() when $default != null:
return $default(_that.user,_that.name,_that.relationship,_that.dob,_that.gender,_that.language,_that.location,_that.saveStatus,_that.logoutStatus,_that.deleteAccountStatus);case _:
  return null;

}
}

}

/// @nodoc


class _ParentProfileV2State implements ParentProfileV2State {
  const _ParentProfileV2State({this.user, this.name = '', this.relationship = '', this.dob = '', this.gender = '', this.language = '', this.location = '', this.saveStatus = const ApiResultStatus<String>.initial(), this.logoutStatus = const ApiResultStatus<String>.initial(), this.deleteAccountStatus = const ApiResultStatus<String>.initial()});
  

@override final  UserModel? user;
@override@JsonKey() final  String name;
@override@JsonKey() final  String relationship;
@override@JsonKey() final  String dob;
@override@JsonKey() final  String gender;
@override@JsonKey() final  String language;
@override@JsonKey() final  String location;
@override@JsonKey() final  ApiResultStatus<String> saveStatus;
@override@JsonKey() final  ApiResultStatus<String> logoutStatus;
@override@JsonKey() final  ApiResultStatus<String> deleteAccountStatus;

/// Create a copy of ParentProfileV2State
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParentProfileV2StateCopyWith<_ParentProfileV2State> get copyWith => __$ParentProfileV2StateCopyWithImpl<_ParentProfileV2State>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParentProfileV2State&&(identical(other.user, user) || other.user == user)&&(identical(other.name, name) || other.name == name)&&(identical(other.relationship, relationship) || other.relationship == relationship)&&(identical(other.dob, dob) || other.dob == dob)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.language, language) || other.language == language)&&(identical(other.location, location) || other.location == location)&&(identical(other.saveStatus, saveStatus) || other.saveStatus == saveStatus)&&(identical(other.logoutStatus, logoutStatus) || other.logoutStatus == logoutStatus)&&(identical(other.deleteAccountStatus, deleteAccountStatus) || other.deleteAccountStatus == deleteAccountStatus));
}


@override
int get hashCode {
    return Object.hash(runtimeType,user,name,relationship,dob,gender,language,location,saveStatus,logoutStatus,deleteAccountStatus);
}

@override
String toString() {
    return 'ParentProfileV2State(user: $user, name: $name, relationship: $relationship, dob: $dob, gender: $gender, language: $language, location: $location, saveStatus: $saveStatus, logoutStatus: $logoutStatus, deleteAccountStatus: $deleteAccountStatus)';
}


}

/// @nodoc
abstract mixin class _$ParentProfileV2StateCopyWith<$Res> implements $ParentProfileV2StateCopyWith<$Res> {
  factory _$ParentProfileV2StateCopyWith(_ParentProfileV2State value, $Res Function(_ParentProfileV2State) _then) = __$ParentProfileV2StateCopyWithImpl;
@override @useResult
$Res call({
 UserModel? user, String name, String relationship, String dob, String gender, String language, String location, ApiResultStatus<String> saveStatus, ApiResultStatus<String> logoutStatus, ApiResultStatus<String> deleteAccountStatus
});


@override $ApiResultStatusCopyWith<String, $Res> get saveStatus;@override $ApiResultStatusCopyWith<String, $Res> get logoutStatus;@override $ApiResultStatusCopyWith<String, $Res> get deleteAccountStatus;

}
/// @nodoc
class __$ParentProfileV2StateCopyWithImpl<$Res>
    implements _$ParentProfileV2StateCopyWith<$Res> {
  __$ParentProfileV2StateCopyWithImpl(this._self, this._then);

  final _ParentProfileV2State _self;
  final $Res Function(_ParentProfileV2State) _then;

/// Create a copy of ParentProfileV2State
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? user = freezed,Object? name = null,Object? relationship = null,Object? dob = null,Object? gender = null,Object? language = null,Object? location = null,Object? saveStatus = null,Object? logoutStatus = null,Object? deleteAccountStatus = null,}) {
  return _then(_ParentProfileV2State(
user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserModel?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,relationship: null == relationship ? _self.relationship : relationship // ignore: cast_nullable_to_non_nullable
as String,dob: null == dob ? _self.dob : dob // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,saveStatus: null == saveStatus ? _self.saveStatus : saveStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<String>,logoutStatus: null == logoutStatus ? _self.logoutStatus : logoutStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<String>,deleteAccountStatus: null == deleteAccountStatus ? _self.deleteAccountStatus : deleteAccountStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<String>,
  ));
}

@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<String, $Res> get saveStatus {
  
  return $ApiResultStatusCopyWith<String, $Res>(_self.saveStatus, (value) {
    return _then(_self.copyWith(saveStatus: value));
  });
}
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<String, $Res> get logoutStatus {
  
  return $ApiResultStatusCopyWith<String, $Res>(_self.logoutStatus, (value) {
    return _then(_self.copyWith(logoutStatus: value));
  });
}
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<String, $Res> get deleteAccountStatus {
  
  return $ApiResultStatusCopyWith<String, $Res>(_self.deleteAccountStatus, (value) {
    return _then(_self.copyWith(deleteAccountStatus: value));
  });
}
}

// dart format on
