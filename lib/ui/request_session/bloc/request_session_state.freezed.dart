// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'request_session_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RequestSessionState {

 GuideProfileModel? get guide; String get childName; String get mainConcern; String get mainConcernError; String get childAge; String get preferredDays; String get preferredLanguage; bool get shareSummary; bool get isSubmitting; ApiResultStatus<dynamic> get saveStatus;
/// Create a copy of RequestSessionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RequestSessionStateCopyWith<RequestSessionState> get copyWith => _$RequestSessionStateCopyWithImpl<RequestSessionState>(this as RequestSessionState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RequestSessionState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RequestSessionState&&(identical(other.guide, _this.guide) || other.guide == _this.guide)&&(identical(other.childName, _this.childName) || other.childName == _this.childName)&&(identical(other.mainConcern, _this.mainConcern) || other.mainConcern == _this.mainConcern)&&(identical(other.mainConcernError, _this.mainConcernError) || other.mainConcernError == _this.mainConcernError)&&(identical(other.childAge, _this.childAge) || other.childAge == _this.childAge)&&(identical(other.preferredDays, _this.preferredDays) || other.preferredDays == _this.preferredDays)&&(identical(other.preferredLanguage, _this.preferredLanguage) || other.preferredLanguage == _this.preferredLanguage)&&(identical(other.shareSummary, _this.shareSummary) || other.shareSummary == _this.shareSummary)&&(identical(other.isSubmitting, _this.isSubmitting) || other.isSubmitting == _this.isSubmitting)&&(identical(other.saveStatus, _this.saveStatus) || other.saveStatus == _this.saveStatus));
}


@override
int get hashCode {
  final _this = this as RequestSessionState;
  return Object.hash(runtimeType,_this.guide,_this.childName,_this.mainConcern,_this.mainConcernError,_this.childAge,_this.preferredDays,_this.preferredLanguage,_this.shareSummary,_this.isSubmitting,_this.saveStatus);
}

@override
String toString() {
  final _this = this as RequestSessionState;
  return 'RequestSessionState(guide: ${_this.guide}, childName: ${_this.childName}, mainConcern: ${_this.mainConcern}, mainConcernError: ${_this.mainConcernError}, childAge: ${_this.childAge}, preferredDays: ${_this.preferredDays}, preferredLanguage: ${_this.preferredLanguage}, shareSummary: ${_this.shareSummary}, isSubmitting: ${_this.isSubmitting}, saveStatus: ${_this.saveStatus})';
}


}

/// @nodoc
abstract mixin class $RequestSessionStateCopyWith<$Res>  {
  factory $RequestSessionStateCopyWith(RequestSessionState value, $Res Function(RequestSessionState) _then) = _$RequestSessionStateCopyWithImpl;
@useResult
$Res call({
 GuideProfileModel? guide, String childName, String mainConcern, String mainConcernError, String childAge, String preferredDays, String preferredLanguage, bool shareSummary, bool isSubmitting, ApiResultStatus<dynamic> saveStatus
});


$ApiResultStatusCopyWith<dynamic, $Res> get saveStatus;

}
/// @nodoc
class _$RequestSessionStateCopyWithImpl<$Res>
    implements $RequestSessionStateCopyWith<$Res> {
  _$RequestSessionStateCopyWithImpl(this._self, this._then);

  final RequestSessionState _self;
  final $Res Function(RequestSessionState) _then;

/// Create a copy of RequestSessionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? guide = freezed,Object? childName = null,Object? mainConcern = null,Object? mainConcernError = null,Object? childAge = null,Object? preferredDays = null,Object? preferredLanguage = null,Object? shareSummary = null,Object? isSubmitting = null,Object? saveStatus = null,}) {
  return _then(RequestSessionState(
guide: freezed == guide ? _self.guide : guide // ignore: cast_nullable_to_non_nullable
as GuideProfileModel?,childName: null == childName ? _self.childName : childName // ignore: cast_nullable_to_non_nullable
as String,mainConcern: null == mainConcern ? _self.mainConcern : mainConcern // ignore: cast_nullable_to_non_nullable
as String,mainConcernError: null == mainConcernError ? _self.mainConcernError : mainConcernError // ignore: cast_nullable_to_non_nullable
as String,childAge: null == childAge ? _self.childAge : childAge // ignore: cast_nullable_to_non_nullable
as String,preferredDays: null == preferredDays ? _self.preferredDays : preferredDays // ignore: cast_nullable_to_non_nullable
as String,preferredLanguage: null == preferredLanguage ? _self.preferredLanguage : preferredLanguage // ignore: cast_nullable_to_non_nullable
as String,shareSummary: null == shareSummary ? _self.shareSummary : shareSummary // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,saveStatus: null == saveStatus ? _self.saveStatus : saveStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}
/// Create a copy of RequestSessionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get saveStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.saveStatus, (value) {
    return _then(_self.copyWith(saveStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [RequestSessionState].
extension RequestSessionStatePatterns on RequestSessionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RequestSessionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RequestSessionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RequestSessionState value)  $default,){
final _that = this;
switch (_that) {
case _RequestSessionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RequestSessionState value)?  $default,){
final _that = this;
switch (_that) {
case _RequestSessionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( GuideProfileModel? guide,  String childName,  String mainConcern,  String mainConcernError,  String childAge,  String preferredDays,  String preferredLanguage,  bool shareSummary,  bool isSubmitting,  ApiResultStatus<dynamic> saveStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RequestSessionState() when $default != null:
return $default(_that.guide,_that.childName,_that.mainConcern,_that.mainConcernError,_that.childAge,_that.preferredDays,_that.preferredLanguage,_that.shareSummary,_that.isSubmitting,_that.saveStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( GuideProfileModel? guide,  String childName,  String mainConcern,  String mainConcernError,  String childAge,  String preferredDays,  String preferredLanguage,  bool shareSummary,  bool isSubmitting,  ApiResultStatus<dynamic> saveStatus)  $default,) {final _that = this;
switch (_that) {
case _RequestSessionState():
return $default(_that.guide,_that.childName,_that.mainConcern,_that.mainConcernError,_that.childAge,_that.preferredDays,_that.preferredLanguage,_that.shareSummary,_that.isSubmitting,_that.saveStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( GuideProfileModel? guide,  String childName,  String mainConcern,  String mainConcernError,  String childAge,  String preferredDays,  String preferredLanguage,  bool shareSummary,  bool isSubmitting,  ApiResultStatus<dynamic> saveStatus)?  $default,) {final _that = this;
switch (_that) {
case _RequestSessionState() when $default != null:
return $default(_that.guide,_that.childName,_that.mainConcern,_that.mainConcernError,_that.childAge,_that.preferredDays,_that.preferredLanguage,_that.shareSummary,_that.isSubmitting,_that.saveStatus);case _:
  return null;

}
}

}

/// @nodoc


class _RequestSessionState implements RequestSessionState {
  const _RequestSessionState({this.guide, this.childName = 'your child', this.mainConcern = '', this.mainConcernError = '', this.childAge = '17 months', this.preferredDays = '', this.preferredLanguage = '', this.shareSummary = false, this.isSubmitting = false, this.saveStatus = const ApiResultStatus.initial()});
  

@override final  GuideProfileModel? guide;
@override@JsonKey() final  String childName;
@override@JsonKey() final  String mainConcern;
@override@JsonKey() final  String mainConcernError;
@override@JsonKey() final  String childAge;
@override@JsonKey() final  String preferredDays;
@override@JsonKey() final  String preferredLanguage;
@override@JsonKey() final  bool shareSummary;
@override@JsonKey() final  bool isSubmitting;
@override@JsonKey() final  ApiResultStatus<dynamic> saveStatus;

/// Create a copy of RequestSessionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RequestSessionStateCopyWith<_RequestSessionState> get copyWith => __$RequestSessionStateCopyWithImpl<_RequestSessionState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RequestSessionState&&(identical(other.guide, guide) || other.guide == guide)&&(identical(other.childName, childName) || other.childName == childName)&&(identical(other.mainConcern, mainConcern) || other.mainConcern == mainConcern)&&(identical(other.mainConcernError, mainConcernError) || other.mainConcernError == mainConcernError)&&(identical(other.childAge, childAge) || other.childAge == childAge)&&(identical(other.preferredDays, preferredDays) || other.preferredDays == preferredDays)&&(identical(other.preferredLanguage, preferredLanguage) || other.preferredLanguage == preferredLanguage)&&(identical(other.shareSummary, shareSummary) || other.shareSummary == shareSummary)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.saveStatus, saveStatus) || other.saveStatus == saveStatus));
}


@override
int get hashCode {
    return Object.hash(runtimeType,guide,childName,mainConcern,mainConcernError,childAge,preferredDays,preferredLanguage,shareSummary,isSubmitting,saveStatus);
}

@override
String toString() {
    return 'RequestSessionState(guide: $guide, childName: $childName, mainConcern: $mainConcern, mainConcernError: $mainConcernError, childAge: $childAge, preferredDays: $preferredDays, preferredLanguage: $preferredLanguage, shareSummary: $shareSummary, isSubmitting: $isSubmitting, saveStatus: $saveStatus)';
}


}

/// @nodoc
abstract mixin class _$RequestSessionStateCopyWith<$Res> implements $RequestSessionStateCopyWith<$Res> {
  factory _$RequestSessionStateCopyWith(_RequestSessionState value, $Res Function(_RequestSessionState) _then) = __$RequestSessionStateCopyWithImpl;
@override @useResult
$Res call({
 GuideProfileModel? guide, String childName, String mainConcern, String mainConcernError, String childAge, String preferredDays, String preferredLanguage, bool shareSummary, bool isSubmitting, ApiResultStatus<dynamic> saveStatus
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get saveStatus;

}
/// @nodoc
class __$RequestSessionStateCopyWithImpl<$Res>
    implements _$RequestSessionStateCopyWith<$Res> {
  __$RequestSessionStateCopyWithImpl(this._self, this._then);

  final _RequestSessionState _self;
  final $Res Function(_RequestSessionState) _then;

/// Create a copy of RequestSessionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? guide = freezed,Object? childName = null,Object? mainConcern = null,Object? mainConcernError = null,Object? childAge = null,Object? preferredDays = null,Object? preferredLanguage = null,Object? shareSummary = null,Object? isSubmitting = null,Object? saveStatus = null,}) {
  return _then(_RequestSessionState(
guide: freezed == guide ? _self.guide : guide // ignore: cast_nullable_to_non_nullable
as GuideProfileModel?,childName: null == childName ? _self.childName : childName // ignore: cast_nullable_to_non_nullable
as String,mainConcern: null == mainConcern ? _self.mainConcern : mainConcern // ignore: cast_nullable_to_non_nullable
as String,mainConcernError: null == mainConcernError ? _self.mainConcernError : mainConcernError // ignore: cast_nullable_to_non_nullable
as String,childAge: null == childAge ? _self.childAge : childAge // ignore: cast_nullable_to_non_nullable
as String,preferredDays: null == preferredDays ? _self.preferredDays : preferredDays // ignore: cast_nullable_to_non_nullable
as String,preferredLanguage: null == preferredLanguage ? _self.preferredLanguage : preferredLanguage // ignore: cast_nullable_to_non_nullable
as String,shareSummary: null == shareSummary ? _self.shareSummary : shareSummary // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,saveStatus: null == saveStatus ? _self.saveStatus : saveStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}

/// Create a copy of RequestSessionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get saveStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.saveStatus, (value) {
    return _then(_self.copyWith(saveStatus: value));
  });
}
}

// dart format on
