// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OnboardingState {

 int get currentPage; int get totalPages; String get parentName; String get parentRole; String get preferredLanguage; String get location; ApiResultStatus get completeStatus;
/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingStateCopyWith<OnboardingState> get copyWith => _$OnboardingStateCopyWithImpl<OnboardingState>(this as OnboardingState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingState&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.parentName, parentName) || other.parentName == parentName)&&(identical(other.parentRole, parentRole) || other.parentRole == parentRole)&&(identical(other.preferredLanguage, preferredLanguage) || other.preferredLanguage == preferredLanguage)&&(identical(other.location, location) || other.location == location)&&(identical(other.completeStatus, completeStatus) || other.completeStatus == completeStatus));
}


@override
int get hashCode => Object.hash(runtimeType,currentPage,totalPages,parentName,parentRole,preferredLanguage,location,completeStatus);

@override
String toString() {
  return 'OnboardingState(currentPage: $currentPage, totalPages: $totalPages, parentName: $parentName, parentRole: $parentRole, preferredLanguage: $preferredLanguage, location: $location, completeStatus: $completeStatus)';
}


}

/// @nodoc
abstract mixin class $OnboardingStateCopyWith<$Res>  {
  factory $OnboardingStateCopyWith(OnboardingState value, $Res Function(OnboardingState) _then) = _$OnboardingStateCopyWithImpl;
@useResult
$Res call({
 int currentPage, int totalPages, String parentName, String parentRole, String preferredLanguage, String location, ApiResultStatus completeStatus
});


$ApiResultStatusCopyWith<dynamic, $Res> get completeStatus;

}
/// @nodoc
class _$OnboardingStateCopyWithImpl<$Res>
    implements $OnboardingStateCopyWith<$Res> {
  _$OnboardingStateCopyWithImpl(this._self, this._then);

  final OnboardingState _self;
  final $Res Function(OnboardingState) _then;

/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentPage = null,Object? totalPages = null,Object? parentName = null,Object? parentRole = null,Object? preferredLanguage = null,Object? location = null,Object? completeStatus = null,}) {
  return _then(_self.copyWith(
currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,parentName: null == parentName ? _self.parentName : parentName // ignore: cast_nullable_to_non_nullable
as String,parentRole: null == parentRole ? _self.parentRole : parentRole // ignore: cast_nullable_to_non_nullable
as String,preferredLanguage: null == preferredLanguage ? _self.preferredLanguage : preferredLanguage // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,completeStatus: null == completeStatus ? _self.completeStatus : completeStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,
  ));
}
/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get completeStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.completeStatus, (value) {
    return _then(_self.copyWith(completeStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [OnboardingState].
extension OnboardingStatePatterns on OnboardingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingState value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingState value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int currentPage,  int totalPages,  String parentName,  String parentRole,  String preferredLanguage,  String location,  ApiResultStatus completeStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
return $default(_that.currentPage,_that.totalPages,_that.parentName,_that.parentRole,_that.preferredLanguage,_that.location,_that.completeStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int currentPage,  int totalPages,  String parentName,  String parentRole,  String preferredLanguage,  String location,  ApiResultStatus completeStatus)  $default,) {final _that = this;
switch (_that) {
case _OnboardingState():
return $default(_that.currentPage,_that.totalPages,_that.parentName,_that.parentRole,_that.preferredLanguage,_that.location,_that.completeStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int currentPage,  int totalPages,  String parentName,  String parentRole,  String preferredLanguage,  String location,  ApiResultStatus completeStatus)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
return $default(_that.currentPage,_that.totalPages,_that.parentName,_that.parentRole,_that.preferredLanguage,_that.location,_that.completeStatus);case _:
  return null;

}
}

}

/// @nodoc


class _OnboardingState implements OnboardingState {
  const _OnboardingState({this.currentPage = 0, this.totalPages = 6, this.parentName = 'Russell Sprout', this.parentRole = 'Mother', this.preferredLanguage = 'English', this.location = 'Chennai, India (GMT+5:30)', this.completeStatus = const ApiResultStatus.initial()});
  

@override@JsonKey() final  int currentPage;
@override@JsonKey() final  int totalPages;
@override@JsonKey() final  String parentName;
@override@JsonKey() final  String parentRole;
@override@JsonKey() final  String preferredLanguage;
@override@JsonKey() final  String location;
@override@JsonKey() final  ApiResultStatus completeStatus;

/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingStateCopyWith<_OnboardingState> get copyWith => __$OnboardingStateCopyWithImpl<_OnboardingState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingState&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.parentName, parentName) || other.parentName == parentName)&&(identical(other.parentRole, parentRole) || other.parentRole == parentRole)&&(identical(other.preferredLanguage, preferredLanguage) || other.preferredLanguage == preferredLanguage)&&(identical(other.location, location) || other.location == location)&&(identical(other.completeStatus, completeStatus) || other.completeStatus == completeStatus));
}


@override
int get hashCode => Object.hash(runtimeType,currentPage,totalPages,parentName,parentRole,preferredLanguage,location,completeStatus);

@override
String toString() {
  return 'OnboardingState(currentPage: $currentPage, totalPages: $totalPages, parentName: $parentName, parentRole: $parentRole, preferredLanguage: $preferredLanguage, location: $location, completeStatus: $completeStatus)';
}


}

/// @nodoc
abstract mixin class _$OnboardingStateCopyWith<$Res> implements $OnboardingStateCopyWith<$Res> {
  factory _$OnboardingStateCopyWith(_OnboardingState value, $Res Function(_OnboardingState) _then) = __$OnboardingStateCopyWithImpl;
@override @useResult
$Res call({
 int currentPage, int totalPages, String parentName, String parentRole, String preferredLanguage, String location, ApiResultStatus completeStatus
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get completeStatus;

}
/// @nodoc
class __$OnboardingStateCopyWithImpl<$Res>
    implements _$OnboardingStateCopyWith<$Res> {
  __$OnboardingStateCopyWithImpl(this._self, this._then);

  final _OnboardingState _self;
  final $Res Function(_OnboardingState) _then;

/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentPage = null,Object? totalPages = null,Object? parentName = null,Object? parentRole = null,Object? preferredLanguage = null,Object? location = null,Object? completeStatus = null,}) {
  return _then(_OnboardingState(
currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,parentName: null == parentName ? _self.parentName : parentName // ignore: cast_nullable_to_non_nullable
as String,parentRole: null == parentRole ? _self.parentRole : parentRole // ignore: cast_nullable_to_non_nullable
as String,preferredLanguage: null == preferredLanguage ? _self.preferredLanguage : preferredLanguage // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,completeStatus: null == completeStatus ? _self.completeStatus : completeStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,
  ));
}

/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get completeStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.completeStatus, (value) {
    return _then(_self.copyWith(completeStatus: value));
  });
}
}

// dart format on
