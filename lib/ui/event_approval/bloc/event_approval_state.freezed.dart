// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_approval_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EventApprovalState {

 String get message; SharedEventModel? get sharedEvent; ApiResultStatus get getAssigneeApiResult; ApiResultStatus get getChildrenResult; ApiResultStatus get getCreatedByUserApiResult; ApiResultStatus get updatedSharedEventApiResult; UserModel? get createdByUser; UserModel? get userModel; List<UserModel> get assignedUserList; List<ChildModel> get childrenList;
/// Create a copy of EventApprovalState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventApprovalStateCopyWith<EventApprovalState> get copyWith => _$EventApprovalStateCopyWithImpl<EventApprovalState>(this as EventApprovalState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventApprovalState&&(identical(other.message, message) || other.message == message)&&(identical(other.sharedEvent, sharedEvent) || other.sharedEvent == sharedEvent)&&(identical(other.getAssigneeApiResult, getAssigneeApiResult) || other.getAssigneeApiResult == getAssigneeApiResult)&&(identical(other.getChildrenResult, getChildrenResult) || other.getChildrenResult == getChildrenResult)&&(identical(other.getCreatedByUserApiResult, getCreatedByUserApiResult) || other.getCreatedByUserApiResult == getCreatedByUserApiResult)&&(identical(other.updatedSharedEventApiResult, updatedSharedEventApiResult) || other.updatedSharedEventApiResult == updatedSharedEventApiResult)&&(identical(other.createdByUser, createdByUser) || other.createdByUser == createdByUser)&&(identical(other.userModel, userModel) || other.userModel == userModel)&&const DeepCollectionEquality().equals(other.assignedUserList, assignedUserList)&&const DeepCollectionEquality().equals(other.childrenList, childrenList));
}


@override
int get hashCode => Object.hash(runtimeType,message,sharedEvent,getAssigneeApiResult,getChildrenResult,getCreatedByUserApiResult,updatedSharedEventApiResult,createdByUser,userModel,const DeepCollectionEquality().hash(assignedUserList),const DeepCollectionEquality().hash(childrenList));

@override
String toString() {
  return 'EventApprovalState(message: $message, sharedEvent: $sharedEvent, getAssigneeApiResult: $getAssigneeApiResult, getChildrenResult: $getChildrenResult, getCreatedByUserApiResult: $getCreatedByUserApiResult, updatedSharedEventApiResult: $updatedSharedEventApiResult, createdByUser: $createdByUser, userModel: $userModel, assignedUserList: $assignedUserList, childrenList: $childrenList)';
}


}

/// @nodoc
abstract mixin class $EventApprovalStateCopyWith<$Res>  {
  factory $EventApprovalStateCopyWith(EventApprovalState value, $Res Function(EventApprovalState) _then) = _$EventApprovalStateCopyWithImpl;
@useResult
$Res call({
 String message, SharedEventModel? sharedEvent, ApiResultStatus getAssigneeApiResult, ApiResultStatus getChildrenResult, ApiResultStatus getCreatedByUserApiResult, ApiResultStatus updatedSharedEventApiResult, UserModel? createdByUser, UserModel? userModel, List<UserModel> assignedUserList, List<ChildModel> childrenList
});


$ApiResultStatusCopyWith<dynamic, $Res> get getAssigneeApiResult;$ApiResultStatusCopyWith<dynamic, $Res> get getChildrenResult;$ApiResultStatusCopyWith<dynamic, $Res> get getCreatedByUserApiResult;$ApiResultStatusCopyWith<dynamic, $Res> get updatedSharedEventApiResult;

}
/// @nodoc
class _$EventApprovalStateCopyWithImpl<$Res>
    implements $EventApprovalStateCopyWith<$Res> {
  _$EventApprovalStateCopyWithImpl(this._self, this._then);

  final EventApprovalState _self;
  final $Res Function(EventApprovalState) _then;

/// Create a copy of EventApprovalState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,Object? sharedEvent = freezed,Object? getAssigneeApiResult = null,Object? getChildrenResult = null,Object? getCreatedByUserApiResult = null,Object? updatedSharedEventApiResult = null,Object? createdByUser = freezed,Object? userModel = freezed,Object? assignedUserList = null,Object? childrenList = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,sharedEvent: freezed == sharedEvent ? _self.sharedEvent : sharedEvent // ignore: cast_nullable_to_non_nullable
as SharedEventModel?,getAssigneeApiResult: null == getAssigneeApiResult ? _self.getAssigneeApiResult : getAssigneeApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,getChildrenResult: null == getChildrenResult ? _self.getChildrenResult : getChildrenResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,getCreatedByUserApiResult: null == getCreatedByUserApiResult ? _self.getCreatedByUserApiResult : getCreatedByUserApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,updatedSharedEventApiResult: null == updatedSharedEventApiResult ? _self.updatedSharedEventApiResult : updatedSharedEventApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,createdByUser: freezed == createdByUser ? _self.createdByUser : createdByUser // ignore: cast_nullable_to_non_nullable
as UserModel?,userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,assignedUserList: null == assignedUserList ? _self.assignedUserList : assignedUserList // ignore: cast_nullable_to_non_nullable
as List<UserModel>,childrenList: null == childrenList ? _self.childrenList : childrenList // ignore: cast_nullable_to_non_nullable
as List<ChildModel>,
  ));
}
/// Create a copy of EventApprovalState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get getAssigneeApiResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.getAssigneeApiResult, (value) {
    return _then(_self.copyWith(getAssigneeApiResult: value));
  });
}/// Create a copy of EventApprovalState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get getChildrenResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.getChildrenResult, (value) {
    return _then(_self.copyWith(getChildrenResult: value));
  });
}/// Create a copy of EventApprovalState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get getCreatedByUserApiResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.getCreatedByUserApiResult, (value) {
    return _then(_self.copyWith(getCreatedByUserApiResult: value));
  });
}/// Create a copy of EventApprovalState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get updatedSharedEventApiResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.updatedSharedEventApiResult, (value) {
    return _then(_self.copyWith(updatedSharedEventApiResult: value));
  });
}
}


/// Adds pattern-matching-related methods to [EventApprovalState].
extension EventApprovalStatePatterns on EventApprovalState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventApprovalState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventApprovalState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventApprovalState value)  $default,){
final _that = this;
switch (_that) {
case _EventApprovalState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventApprovalState value)?  $default,){
final _that = this;
switch (_that) {
case _EventApprovalState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String message,  SharedEventModel? sharedEvent,  ApiResultStatus getAssigneeApiResult,  ApiResultStatus getChildrenResult,  ApiResultStatus getCreatedByUserApiResult,  ApiResultStatus updatedSharedEventApiResult,  UserModel? createdByUser,  UserModel? userModel,  List<UserModel> assignedUserList,  List<ChildModel> childrenList)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventApprovalState() when $default != null:
return $default(_that.message,_that.sharedEvent,_that.getAssigneeApiResult,_that.getChildrenResult,_that.getCreatedByUserApiResult,_that.updatedSharedEventApiResult,_that.createdByUser,_that.userModel,_that.assignedUserList,_that.childrenList);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String message,  SharedEventModel? sharedEvent,  ApiResultStatus getAssigneeApiResult,  ApiResultStatus getChildrenResult,  ApiResultStatus getCreatedByUserApiResult,  ApiResultStatus updatedSharedEventApiResult,  UserModel? createdByUser,  UserModel? userModel,  List<UserModel> assignedUserList,  List<ChildModel> childrenList)  $default,) {final _that = this;
switch (_that) {
case _EventApprovalState():
return $default(_that.message,_that.sharedEvent,_that.getAssigneeApiResult,_that.getChildrenResult,_that.getCreatedByUserApiResult,_that.updatedSharedEventApiResult,_that.createdByUser,_that.userModel,_that.assignedUserList,_that.childrenList);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String message,  SharedEventModel? sharedEvent,  ApiResultStatus getAssigneeApiResult,  ApiResultStatus getChildrenResult,  ApiResultStatus getCreatedByUserApiResult,  ApiResultStatus updatedSharedEventApiResult,  UserModel? createdByUser,  UserModel? userModel,  List<UserModel> assignedUserList,  List<ChildModel> childrenList)?  $default,) {final _that = this;
switch (_that) {
case _EventApprovalState() when $default != null:
return $default(_that.message,_that.sharedEvent,_that.getAssigneeApiResult,_that.getChildrenResult,_that.getCreatedByUserApiResult,_that.updatedSharedEventApiResult,_that.createdByUser,_that.userModel,_that.assignedUserList,_that.childrenList);case _:
  return null;

}
}

}

/// @nodoc


class _EventApprovalState implements EventApprovalState {
  const _EventApprovalState({this.message = "", this.sharedEvent, this.getAssigneeApiResult = const ApiResultStatus.initial(), this.getChildrenResult = const ApiResultStatus.initial(), this.getCreatedByUserApiResult = const ApiResultStatus.initial(), this.updatedSharedEventApiResult = const ApiResultStatus.initial(), this.createdByUser, this.userModel, final  List<UserModel> assignedUserList = const [], final  List<ChildModel> childrenList = const []}): _assignedUserList = assignedUserList,_childrenList = childrenList;
  

@override@JsonKey() final  String message;
@override final  SharedEventModel? sharedEvent;
@override@JsonKey() final  ApiResultStatus getAssigneeApiResult;
@override@JsonKey() final  ApiResultStatus getChildrenResult;
@override@JsonKey() final  ApiResultStatus getCreatedByUserApiResult;
@override@JsonKey() final  ApiResultStatus updatedSharedEventApiResult;
@override final  UserModel? createdByUser;
@override final  UserModel? userModel;
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


/// Create a copy of EventApprovalState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventApprovalStateCopyWith<_EventApprovalState> get copyWith => __$EventApprovalStateCopyWithImpl<_EventApprovalState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventApprovalState&&(identical(other.message, message) || other.message == message)&&(identical(other.sharedEvent, sharedEvent) || other.sharedEvent == sharedEvent)&&(identical(other.getAssigneeApiResult, getAssigneeApiResult) || other.getAssigneeApiResult == getAssigneeApiResult)&&(identical(other.getChildrenResult, getChildrenResult) || other.getChildrenResult == getChildrenResult)&&(identical(other.getCreatedByUserApiResult, getCreatedByUserApiResult) || other.getCreatedByUserApiResult == getCreatedByUserApiResult)&&(identical(other.updatedSharedEventApiResult, updatedSharedEventApiResult) || other.updatedSharedEventApiResult == updatedSharedEventApiResult)&&(identical(other.createdByUser, createdByUser) || other.createdByUser == createdByUser)&&(identical(other.userModel, userModel) || other.userModel == userModel)&&const DeepCollectionEquality().equals(other._assignedUserList, _assignedUserList)&&const DeepCollectionEquality().equals(other._childrenList, _childrenList));
}


@override
int get hashCode => Object.hash(runtimeType,message,sharedEvent,getAssigneeApiResult,getChildrenResult,getCreatedByUserApiResult,updatedSharedEventApiResult,createdByUser,userModel,const DeepCollectionEquality().hash(_assignedUserList),const DeepCollectionEquality().hash(_childrenList));

@override
String toString() {
  return 'EventApprovalState(message: $message, sharedEvent: $sharedEvent, getAssigneeApiResult: $getAssigneeApiResult, getChildrenResult: $getChildrenResult, getCreatedByUserApiResult: $getCreatedByUserApiResult, updatedSharedEventApiResult: $updatedSharedEventApiResult, createdByUser: $createdByUser, userModel: $userModel, assignedUserList: $assignedUserList, childrenList: $childrenList)';
}


}

/// @nodoc
abstract mixin class _$EventApprovalStateCopyWith<$Res> implements $EventApprovalStateCopyWith<$Res> {
  factory _$EventApprovalStateCopyWith(_EventApprovalState value, $Res Function(_EventApprovalState) _then) = __$EventApprovalStateCopyWithImpl;
@override @useResult
$Res call({
 String message, SharedEventModel? sharedEvent, ApiResultStatus getAssigneeApiResult, ApiResultStatus getChildrenResult, ApiResultStatus getCreatedByUserApiResult, ApiResultStatus updatedSharedEventApiResult, UserModel? createdByUser, UserModel? userModel, List<UserModel> assignedUserList, List<ChildModel> childrenList
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get getAssigneeApiResult;@override $ApiResultStatusCopyWith<dynamic, $Res> get getChildrenResult;@override $ApiResultStatusCopyWith<dynamic, $Res> get getCreatedByUserApiResult;@override $ApiResultStatusCopyWith<dynamic, $Res> get updatedSharedEventApiResult;

}
/// @nodoc
class __$EventApprovalStateCopyWithImpl<$Res>
    implements _$EventApprovalStateCopyWith<$Res> {
  __$EventApprovalStateCopyWithImpl(this._self, this._then);

  final _EventApprovalState _self;
  final $Res Function(_EventApprovalState) _then;

/// Create a copy of EventApprovalState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? sharedEvent = freezed,Object? getAssigneeApiResult = null,Object? getChildrenResult = null,Object? getCreatedByUserApiResult = null,Object? updatedSharedEventApiResult = null,Object? createdByUser = freezed,Object? userModel = freezed,Object? assignedUserList = null,Object? childrenList = null,}) {
  return _then(_EventApprovalState(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,sharedEvent: freezed == sharedEvent ? _self.sharedEvent : sharedEvent // ignore: cast_nullable_to_non_nullable
as SharedEventModel?,getAssigneeApiResult: null == getAssigneeApiResult ? _self.getAssigneeApiResult : getAssigneeApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,getChildrenResult: null == getChildrenResult ? _self.getChildrenResult : getChildrenResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,getCreatedByUserApiResult: null == getCreatedByUserApiResult ? _self.getCreatedByUserApiResult : getCreatedByUserApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,updatedSharedEventApiResult: null == updatedSharedEventApiResult ? _self.updatedSharedEventApiResult : updatedSharedEventApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,createdByUser: freezed == createdByUser ? _self.createdByUser : createdByUser // ignore: cast_nullable_to_non_nullable
as UserModel?,userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,assignedUserList: null == assignedUserList ? _self._assignedUserList : assignedUserList // ignore: cast_nullable_to_non_nullable
as List<UserModel>,childrenList: null == childrenList ? _self._childrenList : childrenList // ignore: cast_nullable_to_non_nullable
as List<ChildModel>,
  ));
}

/// Create a copy of EventApprovalState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get getAssigneeApiResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.getAssigneeApiResult, (value) {
    return _then(_self.copyWith(getAssigneeApiResult: value));
  });
}/// Create a copy of EventApprovalState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get getChildrenResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.getChildrenResult, (value) {
    return _then(_self.copyWith(getChildrenResult: value));
  });
}/// Create a copy of EventApprovalState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get getCreatedByUserApiResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.getCreatedByUserApiResult, (value) {
    return _then(_self.copyWith(getCreatedByUserApiResult: value));
  });
}/// Create a copy of EventApprovalState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get updatedSharedEventApiResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.updatedSharedEventApiResult, (value) {
    return _then(_self.copyWith(updatedSharedEventApiResult: value));
  });
}
}

// dart format on
