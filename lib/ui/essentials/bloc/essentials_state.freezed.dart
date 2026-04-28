// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'essentials_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EssentialsState {

 String get titleError; String get descriptionError; UserModel? get userModel; ChildModel? get childModel; List<ChildModel> get childList; ApiResultStatus get addEssentialsApiResult; ApiResultStatus get childrenListApiResult; ApiResultStatus get uploadDocumentApiResultStatus;
/// Create a copy of EssentialsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EssentialsStateCopyWith<EssentialsState> get copyWith => _$EssentialsStateCopyWithImpl<EssentialsState>(this as EssentialsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EssentialsState&&(identical(other.titleError, titleError) || other.titleError == titleError)&&(identical(other.descriptionError, descriptionError) || other.descriptionError == descriptionError)&&(identical(other.userModel, userModel) || other.userModel == userModel)&&(identical(other.childModel, childModel) || other.childModel == childModel)&&const DeepCollectionEquality().equals(other.childList, childList)&&(identical(other.addEssentialsApiResult, addEssentialsApiResult) || other.addEssentialsApiResult == addEssentialsApiResult)&&(identical(other.childrenListApiResult, childrenListApiResult) || other.childrenListApiResult == childrenListApiResult)&&(identical(other.uploadDocumentApiResultStatus, uploadDocumentApiResultStatus) || other.uploadDocumentApiResultStatus == uploadDocumentApiResultStatus));
}


@override
int get hashCode => Object.hash(runtimeType,titleError,descriptionError,userModel,childModel,const DeepCollectionEquality().hash(childList),addEssentialsApiResult,childrenListApiResult,uploadDocumentApiResultStatus);

@override
String toString() {
  return 'EssentialsState(titleError: $titleError, descriptionError: $descriptionError, userModel: $userModel, childModel: $childModel, childList: $childList, addEssentialsApiResult: $addEssentialsApiResult, childrenListApiResult: $childrenListApiResult, uploadDocumentApiResultStatus: $uploadDocumentApiResultStatus)';
}


}

/// @nodoc
abstract mixin class $EssentialsStateCopyWith<$Res>  {
  factory $EssentialsStateCopyWith(EssentialsState value, $Res Function(EssentialsState) _then) = _$EssentialsStateCopyWithImpl;
@useResult
$Res call({
 String titleError, String descriptionError, UserModel? userModel, ChildModel? childModel, List<ChildModel> childList, ApiResultStatus addEssentialsApiResult, ApiResultStatus childrenListApiResult, ApiResultStatus uploadDocumentApiResultStatus
});


$ApiResultStatusCopyWith<dynamic, $Res> get addEssentialsApiResult;$ApiResultStatusCopyWith<dynamic, $Res> get childrenListApiResult;$ApiResultStatusCopyWith<dynamic, $Res> get uploadDocumentApiResultStatus;

}
/// @nodoc
class _$EssentialsStateCopyWithImpl<$Res>
    implements $EssentialsStateCopyWith<$Res> {
  _$EssentialsStateCopyWithImpl(this._self, this._then);

  final EssentialsState _self;
  final $Res Function(EssentialsState) _then;

/// Create a copy of EssentialsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? titleError = null,Object? descriptionError = null,Object? userModel = freezed,Object? childModel = freezed,Object? childList = null,Object? addEssentialsApiResult = null,Object? childrenListApiResult = null,Object? uploadDocumentApiResultStatus = null,}) {
  return _then(_self.copyWith(
titleError: null == titleError ? _self.titleError : titleError // ignore: cast_nullable_to_non_nullable
as String,descriptionError: null == descriptionError ? _self.descriptionError : descriptionError // ignore: cast_nullable_to_non_nullable
as String,userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,childModel: freezed == childModel ? _self.childModel : childModel // ignore: cast_nullable_to_non_nullable
as ChildModel?,childList: null == childList ? _self.childList : childList // ignore: cast_nullable_to_non_nullable
as List<ChildModel>,addEssentialsApiResult: null == addEssentialsApiResult ? _self.addEssentialsApiResult : addEssentialsApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,childrenListApiResult: null == childrenListApiResult ? _self.childrenListApiResult : childrenListApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,uploadDocumentApiResultStatus: null == uploadDocumentApiResultStatus ? _self.uploadDocumentApiResultStatus : uploadDocumentApiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,
  ));
}
/// Create a copy of EssentialsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get addEssentialsApiResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.addEssentialsApiResult, (value) {
    return _then(_self.copyWith(addEssentialsApiResult: value));
  });
}/// Create a copy of EssentialsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get childrenListApiResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.childrenListApiResult, (value) {
    return _then(_self.copyWith(childrenListApiResult: value));
  });
}/// Create a copy of EssentialsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get uploadDocumentApiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.uploadDocumentApiResultStatus, (value) {
    return _then(_self.copyWith(uploadDocumentApiResultStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [EssentialsState].
extension EssentialsStatePatterns on EssentialsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EssentialsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EssentialsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EssentialsState value)  $default,){
final _that = this;
switch (_that) {
case _EssentialsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EssentialsState value)?  $default,){
final _that = this;
switch (_that) {
case _EssentialsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String titleError,  String descriptionError,  UserModel? userModel,  ChildModel? childModel,  List<ChildModel> childList,  ApiResultStatus addEssentialsApiResult,  ApiResultStatus childrenListApiResult,  ApiResultStatus uploadDocumentApiResultStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EssentialsState() when $default != null:
return $default(_that.titleError,_that.descriptionError,_that.userModel,_that.childModel,_that.childList,_that.addEssentialsApiResult,_that.childrenListApiResult,_that.uploadDocumentApiResultStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String titleError,  String descriptionError,  UserModel? userModel,  ChildModel? childModel,  List<ChildModel> childList,  ApiResultStatus addEssentialsApiResult,  ApiResultStatus childrenListApiResult,  ApiResultStatus uploadDocumentApiResultStatus)  $default,) {final _that = this;
switch (_that) {
case _EssentialsState():
return $default(_that.titleError,_that.descriptionError,_that.userModel,_that.childModel,_that.childList,_that.addEssentialsApiResult,_that.childrenListApiResult,_that.uploadDocumentApiResultStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String titleError,  String descriptionError,  UserModel? userModel,  ChildModel? childModel,  List<ChildModel> childList,  ApiResultStatus addEssentialsApiResult,  ApiResultStatus childrenListApiResult,  ApiResultStatus uploadDocumentApiResultStatus)?  $default,) {final _that = this;
switch (_that) {
case _EssentialsState() when $default != null:
return $default(_that.titleError,_that.descriptionError,_that.userModel,_that.childModel,_that.childList,_that.addEssentialsApiResult,_that.childrenListApiResult,_that.uploadDocumentApiResultStatus);case _:
  return null;

}
}

}

/// @nodoc


class _EssentialsState implements EssentialsState {
  const _EssentialsState({this.titleError = "", this.descriptionError = "", this.userModel, this.childModel, final  List<ChildModel> childList = const [], this.addEssentialsApiResult = const ApiResultStatus.initial(), this.childrenListApiResult = const ApiResultStatus.initial(), this.uploadDocumentApiResultStatus = const ApiResultStatus.initial()}): _childList = childList;
  

@override@JsonKey() final  String titleError;
@override@JsonKey() final  String descriptionError;
@override final  UserModel? userModel;
@override final  ChildModel? childModel;
 final  List<ChildModel> _childList;
@override@JsonKey() List<ChildModel> get childList {
  if (_childList is EqualUnmodifiableListView) return _childList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_childList);
}

@override@JsonKey() final  ApiResultStatus addEssentialsApiResult;
@override@JsonKey() final  ApiResultStatus childrenListApiResult;
@override@JsonKey() final  ApiResultStatus uploadDocumentApiResultStatus;

/// Create a copy of EssentialsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EssentialsStateCopyWith<_EssentialsState> get copyWith => __$EssentialsStateCopyWithImpl<_EssentialsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EssentialsState&&(identical(other.titleError, titleError) || other.titleError == titleError)&&(identical(other.descriptionError, descriptionError) || other.descriptionError == descriptionError)&&(identical(other.userModel, userModel) || other.userModel == userModel)&&(identical(other.childModel, childModel) || other.childModel == childModel)&&const DeepCollectionEquality().equals(other._childList, _childList)&&(identical(other.addEssentialsApiResult, addEssentialsApiResult) || other.addEssentialsApiResult == addEssentialsApiResult)&&(identical(other.childrenListApiResult, childrenListApiResult) || other.childrenListApiResult == childrenListApiResult)&&(identical(other.uploadDocumentApiResultStatus, uploadDocumentApiResultStatus) || other.uploadDocumentApiResultStatus == uploadDocumentApiResultStatus));
}


@override
int get hashCode => Object.hash(runtimeType,titleError,descriptionError,userModel,childModel,const DeepCollectionEquality().hash(_childList),addEssentialsApiResult,childrenListApiResult,uploadDocumentApiResultStatus);

@override
String toString() {
  return 'EssentialsState(titleError: $titleError, descriptionError: $descriptionError, userModel: $userModel, childModel: $childModel, childList: $childList, addEssentialsApiResult: $addEssentialsApiResult, childrenListApiResult: $childrenListApiResult, uploadDocumentApiResultStatus: $uploadDocumentApiResultStatus)';
}


}

/// @nodoc
abstract mixin class _$EssentialsStateCopyWith<$Res> implements $EssentialsStateCopyWith<$Res> {
  factory _$EssentialsStateCopyWith(_EssentialsState value, $Res Function(_EssentialsState) _then) = __$EssentialsStateCopyWithImpl;
@override @useResult
$Res call({
 String titleError, String descriptionError, UserModel? userModel, ChildModel? childModel, List<ChildModel> childList, ApiResultStatus addEssentialsApiResult, ApiResultStatus childrenListApiResult, ApiResultStatus uploadDocumentApiResultStatus
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get addEssentialsApiResult;@override $ApiResultStatusCopyWith<dynamic, $Res> get childrenListApiResult;@override $ApiResultStatusCopyWith<dynamic, $Res> get uploadDocumentApiResultStatus;

}
/// @nodoc
class __$EssentialsStateCopyWithImpl<$Res>
    implements _$EssentialsStateCopyWith<$Res> {
  __$EssentialsStateCopyWithImpl(this._self, this._then);

  final _EssentialsState _self;
  final $Res Function(_EssentialsState) _then;

/// Create a copy of EssentialsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? titleError = null,Object? descriptionError = null,Object? userModel = freezed,Object? childModel = freezed,Object? childList = null,Object? addEssentialsApiResult = null,Object? childrenListApiResult = null,Object? uploadDocumentApiResultStatus = null,}) {
  return _then(_EssentialsState(
titleError: null == titleError ? _self.titleError : titleError // ignore: cast_nullable_to_non_nullable
as String,descriptionError: null == descriptionError ? _self.descriptionError : descriptionError // ignore: cast_nullable_to_non_nullable
as String,userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,childModel: freezed == childModel ? _self.childModel : childModel // ignore: cast_nullable_to_non_nullable
as ChildModel?,childList: null == childList ? _self._childList : childList // ignore: cast_nullable_to_non_nullable
as List<ChildModel>,addEssentialsApiResult: null == addEssentialsApiResult ? _self.addEssentialsApiResult : addEssentialsApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,childrenListApiResult: null == childrenListApiResult ? _self.childrenListApiResult : childrenListApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,uploadDocumentApiResultStatus: null == uploadDocumentApiResultStatus ? _self.uploadDocumentApiResultStatus : uploadDocumentApiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,
  ));
}

/// Create a copy of EssentialsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get addEssentialsApiResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.addEssentialsApiResult, (value) {
    return _then(_self.copyWith(addEssentialsApiResult: value));
  });
}/// Create a copy of EssentialsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get childrenListApiResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.childrenListApiResult, (value) {
    return _then(_self.copyWith(childrenListApiResult: value));
  });
}/// Create a copy of EssentialsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get uploadDocumentApiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.uploadDocumentApiResultStatus, (value) {
    return _then(_self.copyWith(uploadDocumentApiResultStatus: value));
  });
}
}

// dart format on
