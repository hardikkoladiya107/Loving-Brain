// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EventDetailState {

 String get message; ApiResultStatus get getAssigneeApiResult; ApiResultStatus get getChildrenResult; ApiResultStatus get getCreatedByUserApiResult; ApiResultStatus get uploadDocumentApiResultStatus; UserModel? get createdByUser; List<UserModel> get assignedUserList; List<ChildModel> get childrenList; SharedEventModel? get sharedEvent; UserModel? get userModel;
/// Create a copy of EventDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventDetailStateCopyWith<EventDetailState> get copyWith => _$EventDetailStateCopyWithImpl<EventDetailState>(this as EventDetailState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventDetailState&&(identical(other.message, message) || other.message == message)&&(identical(other.getAssigneeApiResult, getAssigneeApiResult) || other.getAssigneeApiResult == getAssigneeApiResult)&&(identical(other.getChildrenResult, getChildrenResult) || other.getChildrenResult == getChildrenResult)&&(identical(other.getCreatedByUserApiResult, getCreatedByUserApiResult) || other.getCreatedByUserApiResult == getCreatedByUserApiResult)&&(identical(other.uploadDocumentApiResultStatus, uploadDocumentApiResultStatus) || other.uploadDocumentApiResultStatus == uploadDocumentApiResultStatus)&&(identical(other.createdByUser, createdByUser) || other.createdByUser == createdByUser)&&const DeepCollectionEquality().equals(other.assignedUserList, assignedUserList)&&const DeepCollectionEquality().equals(other.childrenList, childrenList)&&(identical(other.sharedEvent, sharedEvent) || other.sharedEvent == sharedEvent)&&(identical(other.userModel, userModel) || other.userModel == userModel));
}


@override
int get hashCode => Object.hash(runtimeType,message,getAssigneeApiResult,getChildrenResult,getCreatedByUserApiResult,uploadDocumentApiResultStatus,createdByUser,const DeepCollectionEquality().hash(assignedUserList),const DeepCollectionEquality().hash(childrenList),sharedEvent,userModel);

@override
String toString() {
  return 'EventDetailState(message: $message, getAssigneeApiResult: $getAssigneeApiResult, getChildrenResult: $getChildrenResult, getCreatedByUserApiResult: $getCreatedByUserApiResult, uploadDocumentApiResultStatus: $uploadDocumentApiResultStatus, createdByUser: $createdByUser, assignedUserList: $assignedUserList, childrenList: $childrenList, sharedEvent: $sharedEvent, userModel: $userModel)';
}


}

/// @nodoc
abstract mixin class $EventDetailStateCopyWith<$Res>  {
  factory $EventDetailStateCopyWith(EventDetailState value, $Res Function(EventDetailState) _then) = _$EventDetailStateCopyWithImpl;
@useResult
$Res call({
 String message, ApiResultStatus getAssigneeApiResult, ApiResultStatus getChildrenResult, ApiResultStatus getCreatedByUserApiResult, ApiResultStatus uploadDocumentApiResultStatus, UserModel? createdByUser, List<UserModel> assignedUserList, List<ChildModel> childrenList, SharedEventModel? sharedEvent, UserModel? userModel
});


$ApiResultStatusCopyWith<dynamic, $Res> get getAssigneeApiResult;$ApiResultStatusCopyWith<dynamic, $Res> get getChildrenResult;$ApiResultStatusCopyWith<dynamic, $Res> get getCreatedByUserApiResult;$ApiResultStatusCopyWith<dynamic, $Res> get uploadDocumentApiResultStatus;

}
/// @nodoc
class _$EventDetailStateCopyWithImpl<$Res>
    implements $EventDetailStateCopyWith<$Res> {
  _$EventDetailStateCopyWithImpl(this._self, this._then);

  final EventDetailState _self;
  final $Res Function(EventDetailState) _then;

/// Create a copy of EventDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,Object? getAssigneeApiResult = null,Object? getChildrenResult = null,Object? getCreatedByUserApiResult = null,Object? uploadDocumentApiResultStatus = null,Object? createdByUser = freezed,Object? assignedUserList = null,Object? childrenList = null,Object? sharedEvent = freezed,Object? userModel = freezed,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,getAssigneeApiResult: null == getAssigneeApiResult ? _self.getAssigneeApiResult : getAssigneeApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,getChildrenResult: null == getChildrenResult ? _self.getChildrenResult : getChildrenResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,getCreatedByUserApiResult: null == getCreatedByUserApiResult ? _self.getCreatedByUserApiResult : getCreatedByUserApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,uploadDocumentApiResultStatus: null == uploadDocumentApiResultStatus ? _self.uploadDocumentApiResultStatus : uploadDocumentApiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,createdByUser: freezed == createdByUser ? _self.createdByUser : createdByUser // ignore: cast_nullable_to_non_nullable
as UserModel?,assignedUserList: null == assignedUserList ? _self.assignedUserList : assignedUserList // ignore: cast_nullable_to_non_nullable
as List<UserModel>,childrenList: null == childrenList ? _self.childrenList : childrenList // ignore: cast_nullable_to_non_nullable
as List<ChildModel>,sharedEvent: freezed == sharedEvent ? _self.sharedEvent : sharedEvent // ignore: cast_nullable_to_non_nullable
as SharedEventModel?,userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,
  ));
}
/// Create a copy of EventDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get getAssigneeApiResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.getAssigneeApiResult, (value) {
    return _then(_self.copyWith(getAssigneeApiResult: value));
  });
}/// Create a copy of EventDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get getChildrenResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.getChildrenResult, (value) {
    return _then(_self.copyWith(getChildrenResult: value));
  });
}/// Create a copy of EventDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get getCreatedByUserApiResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.getCreatedByUserApiResult, (value) {
    return _then(_self.copyWith(getCreatedByUserApiResult: value));
  });
}/// Create a copy of EventDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get uploadDocumentApiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.uploadDocumentApiResultStatus, (value) {
    return _then(_self.copyWith(uploadDocumentApiResultStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [EventDetailState].
extension EventDetailStatePatterns on EventDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventDetailState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventDetailState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventDetailState value)  $default,){
final _that = this;
switch (_that) {
case _EventDetailState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventDetailState value)?  $default,){
final _that = this;
switch (_that) {
case _EventDetailState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String message,  ApiResultStatus getAssigneeApiResult,  ApiResultStatus getChildrenResult,  ApiResultStatus getCreatedByUserApiResult,  ApiResultStatus uploadDocumentApiResultStatus,  UserModel? createdByUser,  List<UserModel> assignedUserList,  List<ChildModel> childrenList,  SharedEventModel? sharedEvent,  UserModel? userModel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventDetailState() when $default != null:
return $default(_that.message,_that.getAssigneeApiResult,_that.getChildrenResult,_that.getCreatedByUserApiResult,_that.uploadDocumentApiResultStatus,_that.createdByUser,_that.assignedUserList,_that.childrenList,_that.sharedEvent,_that.userModel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String message,  ApiResultStatus getAssigneeApiResult,  ApiResultStatus getChildrenResult,  ApiResultStatus getCreatedByUserApiResult,  ApiResultStatus uploadDocumentApiResultStatus,  UserModel? createdByUser,  List<UserModel> assignedUserList,  List<ChildModel> childrenList,  SharedEventModel? sharedEvent,  UserModel? userModel)  $default,) {final _that = this;
switch (_that) {
case _EventDetailState():
return $default(_that.message,_that.getAssigneeApiResult,_that.getChildrenResult,_that.getCreatedByUserApiResult,_that.uploadDocumentApiResultStatus,_that.createdByUser,_that.assignedUserList,_that.childrenList,_that.sharedEvent,_that.userModel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String message,  ApiResultStatus getAssigneeApiResult,  ApiResultStatus getChildrenResult,  ApiResultStatus getCreatedByUserApiResult,  ApiResultStatus uploadDocumentApiResultStatus,  UserModel? createdByUser,  List<UserModel> assignedUserList,  List<ChildModel> childrenList,  SharedEventModel? sharedEvent,  UserModel? userModel)?  $default,) {final _that = this;
switch (_that) {
case _EventDetailState() when $default != null:
return $default(_that.message,_that.getAssigneeApiResult,_that.getChildrenResult,_that.getCreatedByUserApiResult,_that.uploadDocumentApiResultStatus,_that.createdByUser,_that.assignedUserList,_that.childrenList,_that.sharedEvent,_that.userModel);case _:
  return null;

}
}

}

/// @nodoc


class _EventDetailState implements EventDetailState {
  const _EventDetailState({this.message = "", this.getAssigneeApiResult = const ApiResultStatus.initial(), this.getChildrenResult = const ApiResultStatus.initial(), this.getCreatedByUserApiResult = const ApiResultStatus.initial(), this.uploadDocumentApiResultStatus = const ApiResultStatus.initial(), this.createdByUser, final  List<UserModel> assignedUserList = const [], final  List<ChildModel> childrenList = const [], this.sharedEvent, this.userModel}): _assignedUserList = assignedUserList,_childrenList = childrenList;
  

@override@JsonKey() final  String message;
@override@JsonKey() final  ApiResultStatus getAssigneeApiResult;
@override@JsonKey() final  ApiResultStatus getChildrenResult;
@override@JsonKey() final  ApiResultStatus getCreatedByUserApiResult;
@override@JsonKey() final  ApiResultStatus uploadDocumentApiResultStatus;
@override final  UserModel? createdByUser;
 final  List<UserModel> _assignedUserList;
@override@JsonKey() List<UserModel> get assignedUserList {
  if (_assignedUserList is EqualUnmodifiableListView) return _assignedUserList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_assignedUserList);
}

 final  List<ChildModel> _childrenList;
@override@JsonKey() List<ChildModel> get childrenList {
  if (_childrenList is EqualUnmodifiableListView) return _childrenList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_childrenList);
}

@override final  SharedEventModel? sharedEvent;
@override final  UserModel? userModel;

/// Create a copy of EventDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventDetailStateCopyWith<_EventDetailState> get copyWith => __$EventDetailStateCopyWithImpl<_EventDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventDetailState&&(identical(other.message, message) || other.message == message)&&(identical(other.getAssigneeApiResult, getAssigneeApiResult) || other.getAssigneeApiResult == getAssigneeApiResult)&&(identical(other.getChildrenResult, getChildrenResult) || other.getChildrenResult == getChildrenResult)&&(identical(other.getCreatedByUserApiResult, getCreatedByUserApiResult) || other.getCreatedByUserApiResult == getCreatedByUserApiResult)&&(identical(other.uploadDocumentApiResultStatus, uploadDocumentApiResultStatus) || other.uploadDocumentApiResultStatus == uploadDocumentApiResultStatus)&&(identical(other.createdByUser, createdByUser) || other.createdByUser == createdByUser)&&const DeepCollectionEquality().equals(other._assignedUserList, _assignedUserList)&&const DeepCollectionEquality().equals(other._childrenList, _childrenList)&&(identical(other.sharedEvent, sharedEvent) || other.sharedEvent == sharedEvent)&&(identical(other.userModel, userModel) || other.userModel == userModel));
}


@override
int get hashCode => Object.hash(runtimeType,message,getAssigneeApiResult,getChildrenResult,getCreatedByUserApiResult,uploadDocumentApiResultStatus,createdByUser,const DeepCollectionEquality().hash(_assignedUserList),const DeepCollectionEquality().hash(_childrenList),sharedEvent,userModel);

@override
String toString() {
  return 'EventDetailState(message: $message, getAssigneeApiResult: $getAssigneeApiResult, getChildrenResult: $getChildrenResult, getCreatedByUserApiResult: $getCreatedByUserApiResult, uploadDocumentApiResultStatus: $uploadDocumentApiResultStatus, createdByUser: $createdByUser, assignedUserList: $assignedUserList, childrenList: $childrenList, sharedEvent: $sharedEvent, userModel: $userModel)';
}


}

/// @nodoc
abstract mixin class _$EventDetailStateCopyWith<$Res> implements $EventDetailStateCopyWith<$Res> {
  factory _$EventDetailStateCopyWith(_EventDetailState value, $Res Function(_EventDetailState) _then) = __$EventDetailStateCopyWithImpl;
@override @useResult
$Res call({
 String message, ApiResultStatus getAssigneeApiResult, ApiResultStatus getChildrenResult, ApiResultStatus getCreatedByUserApiResult, ApiResultStatus uploadDocumentApiResultStatus, UserModel? createdByUser, List<UserModel> assignedUserList, List<ChildModel> childrenList, SharedEventModel? sharedEvent, UserModel? userModel
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get getAssigneeApiResult;@override $ApiResultStatusCopyWith<dynamic, $Res> get getChildrenResult;@override $ApiResultStatusCopyWith<dynamic, $Res> get getCreatedByUserApiResult;@override $ApiResultStatusCopyWith<dynamic, $Res> get uploadDocumentApiResultStatus;

}
/// @nodoc
class __$EventDetailStateCopyWithImpl<$Res>
    implements _$EventDetailStateCopyWith<$Res> {
  __$EventDetailStateCopyWithImpl(this._self, this._then);

  final _EventDetailState _self;
  final $Res Function(_EventDetailState) _then;

/// Create a copy of EventDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? getAssigneeApiResult = null,Object? getChildrenResult = null,Object? getCreatedByUserApiResult = null,Object? uploadDocumentApiResultStatus = null,Object? createdByUser = freezed,Object? assignedUserList = null,Object? childrenList = null,Object? sharedEvent = freezed,Object? userModel = freezed,}) {
  return _then(_EventDetailState(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,getAssigneeApiResult: null == getAssigneeApiResult ? _self.getAssigneeApiResult : getAssigneeApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,getChildrenResult: null == getChildrenResult ? _self.getChildrenResult : getChildrenResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,getCreatedByUserApiResult: null == getCreatedByUserApiResult ? _self.getCreatedByUserApiResult : getCreatedByUserApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,uploadDocumentApiResultStatus: null == uploadDocumentApiResultStatus ? _self.uploadDocumentApiResultStatus : uploadDocumentApiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,createdByUser: freezed == createdByUser ? _self.createdByUser : createdByUser // ignore: cast_nullable_to_non_nullable
as UserModel?,assignedUserList: null == assignedUserList ? _self._assignedUserList : assignedUserList // ignore: cast_nullable_to_non_nullable
as List<UserModel>,childrenList: null == childrenList ? _self._childrenList : childrenList // ignore: cast_nullable_to_non_nullable
as List<ChildModel>,sharedEvent: freezed == sharedEvent ? _self.sharedEvent : sharedEvent // ignore: cast_nullable_to_non_nullable
as SharedEventModel?,userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,
  ));
}

/// Create a copy of EventDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get getAssigneeApiResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.getAssigneeApiResult, (value) {
    return _then(_self.copyWith(getAssigneeApiResult: value));
  });
}/// Create a copy of EventDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get getChildrenResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.getChildrenResult, (value) {
    return _then(_self.copyWith(getChildrenResult: value));
  });
}/// Create a copy of EventDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get getCreatedByUserApiResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.getCreatedByUserApiResult, (value) {
    return _then(_self.copyWith(getCreatedByUserApiResult: value));
  });
}/// Create a copy of EventDetailState
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
