// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invite_respond_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$InviteRespondState {

 String get invitationId; String get fromParentName; String get childNames; String get invitedEmailMasked; String get role; String get status; bool get isLoadingPreview; ApiResultStatus<dynamic> get previewStatus; ApiResultStatus<dynamic> get actionStatus;
/// Create a copy of InviteRespondState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InviteRespondStateCopyWith<InviteRespondState> get copyWith => _$InviteRespondStateCopyWithImpl<InviteRespondState>(this as InviteRespondState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as InviteRespondState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InviteRespondState&&(identical(other.invitationId, _this.invitationId) || other.invitationId == _this.invitationId)&&(identical(other.fromParentName, _this.fromParentName) || other.fromParentName == _this.fromParentName)&&(identical(other.childNames, _this.childNames) || other.childNames == _this.childNames)&&(identical(other.invitedEmailMasked, _this.invitedEmailMasked) || other.invitedEmailMasked == _this.invitedEmailMasked)&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.isLoadingPreview, _this.isLoadingPreview) || other.isLoadingPreview == _this.isLoadingPreview)&&(identical(other.previewStatus, _this.previewStatus) || other.previewStatus == _this.previewStatus)&&(identical(other.actionStatus, _this.actionStatus) || other.actionStatus == _this.actionStatus));
}


@override
int get hashCode {
  final _this = this as InviteRespondState;
  return Object.hash(runtimeType,_this.invitationId,_this.fromParentName,_this.childNames,_this.invitedEmailMasked,_this.role,_this.status,_this.isLoadingPreview,_this.previewStatus,_this.actionStatus);
}

@override
String toString() {
  final _this = this as InviteRespondState;
  return 'InviteRespondState(invitationId: ${_this.invitationId}, fromParentName: ${_this.fromParentName}, childNames: ${_this.childNames}, invitedEmailMasked: ${_this.invitedEmailMasked}, role: ${_this.role}, status: ${_this.status}, isLoadingPreview: ${_this.isLoadingPreview}, previewStatus: ${_this.previewStatus}, actionStatus: ${_this.actionStatus})';
}


}

/// @nodoc
abstract mixin class $InviteRespondStateCopyWith<$Res>  {
  factory $InviteRespondStateCopyWith(InviteRespondState value, $Res Function(InviteRespondState) _then) = _$InviteRespondStateCopyWithImpl;
@useResult
$Res call({
 String invitationId, String fromParentName, String childNames, String invitedEmailMasked, String role, String status, bool isLoadingPreview, ApiResultStatus<dynamic> previewStatus, ApiResultStatus<dynamic> actionStatus
});


$ApiResultStatusCopyWith<dynamic, $Res> get previewStatus;$ApiResultStatusCopyWith<dynamic, $Res> get actionStatus;

}
/// @nodoc
class _$InviteRespondStateCopyWithImpl<$Res>
    implements $InviteRespondStateCopyWith<$Res> {
  _$InviteRespondStateCopyWithImpl(this._self, this._then);

  final InviteRespondState _self;
  final $Res Function(InviteRespondState) _then;

/// Create a copy of InviteRespondState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? invitationId = null,Object? fromParentName = null,Object? childNames = null,Object? invitedEmailMasked = null,Object? role = null,Object? status = null,Object? isLoadingPreview = null,Object? previewStatus = null,Object? actionStatus = null,}) {
  return _then(InviteRespondState(
invitationId: null == invitationId ? _self.invitationId : invitationId // ignore: cast_nullable_to_non_nullable
as String,fromParentName: null == fromParentName ? _self.fromParentName : fromParentName // ignore: cast_nullable_to_non_nullable
as String,childNames: null == childNames ? _self.childNames : childNames // ignore: cast_nullable_to_non_nullable
as String,invitedEmailMasked: null == invitedEmailMasked ? _self.invitedEmailMasked : invitedEmailMasked // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,isLoadingPreview: null == isLoadingPreview ? _self.isLoadingPreview : isLoadingPreview // ignore: cast_nullable_to_non_nullable
as bool,previewStatus: null == previewStatus ? _self.previewStatus : previewStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,actionStatus: null == actionStatus ? _self.actionStatus : actionStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}
/// Create a copy of InviteRespondState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get previewStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.previewStatus, (value) {
    return _then(_self.copyWith(previewStatus: value));
  });
}/// Create a copy of InviteRespondState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get actionStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.actionStatus, (value) {
    return _then(_self.copyWith(actionStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [InviteRespondState].
extension InviteRespondStatePatterns on InviteRespondState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InviteRespondState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InviteRespondState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InviteRespondState value)  $default,){
final _that = this;
switch (_that) {
case _InviteRespondState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InviteRespondState value)?  $default,){
final _that = this;
switch (_that) {
case _InviteRespondState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String invitationId,  String fromParentName,  String childNames,  String invitedEmailMasked,  String role,  String status,  bool isLoadingPreview,  ApiResultStatus<dynamic> previewStatus,  ApiResultStatus<dynamic> actionStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InviteRespondState() when $default != null:
return $default(_that.invitationId,_that.fromParentName,_that.childNames,_that.invitedEmailMasked,_that.role,_that.status,_that.isLoadingPreview,_that.previewStatus,_that.actionStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String invitationId,  String fromParentName,  String childNames,  String invitedEmailMasked,  String role,  String status,  bool isLoadingPreview,  ApiResultStatus<dynamic> previewStatus,  ApiResultStatus<dynamic> actionStatus)  $default,) {final _that = this;
switch (_that) {
case _InviteRespondState():
return $default(_that.invitationId,_that.fromParentName,_that.childNames,_that.invitedEmailMasked,_that.role,_that.status,_that.isLoadingPreview,_that.previewStatus,_that.actionStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String invitationId,  String fromParentName,  String childNames,  String invitedEmailMasked,  String role,  String status,  bool isLoadingPreview,  ApiResultStatus<dynamic> previewStatus,  ApiResultStatus<dynamic> actionStatus)?  $default,) {final _that = this;
switch (_that) {
case _InviteRespondState() when $default != null:
return $default(_that.invitationId,_that.fromParentName,_that.childNames,_that.invitedEmailMasked,_that.role,_that.status,_that.isLoadingPreview,_that.previewStatus,_that.actionStatus);case _:
  return null;

}
}

}

/// @nodoc


class _InviteRespondState implements InviteRespondState {
  const _InviteRespondState({this.invitationId = '', this.fromParentName = '', this.childNames = '', this.invitedEmailMasked = '', this.role = '', this.status = '', this.isLoadingPreview = false, this.previewStatus = const ApiResultStatus.initial(), this.actionStatus = const ApiResultStatus.initial()});
  

@override@JsonKey() final  String invitationId;
@override@JsonKey() final  String fromParentName;
@override@JsonKey() final  String childNames;
@override@JsonKey() final  String invitedEmailMasked;
@override@JsonKey() final  String role;
@override@JsonKey() final  String status;
@override@JsonKey() final  bool isLoadingPreview;
@override@JsonKey() final  ApiResultStatus<dynamic> previewStatus;
@override@JsonKey() final  ApiResultStatus<dynamic> actionStatus;

/// Create a copy of InviteRespondState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InviteRespondStateCopyWith<_InviteRespondState> get copyWith => __$InviteRespondStateCopyWithImpl<_InviteRespondState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _InviteRespondState&&(identical(other.invitationId, invitationId) || other.invitationId == invitationId)&&(identical(other.fromParentName, fromParentName) || other.fromParentName == fromParentName)&&(identical(other.childNames, childNames) || other.childNames == childNames)&&(identical(other.invitedEmailMasked, invitedEmailMasked) || other.invitedEmailMasked == invitedEmailMasked)&&(identical(other.role, role) || other.role == role)&&(identical(other.status, status) || other.status == status)&&(identical(other.isLoadingPreview, isLoadingPreview) || other.isLoadingPreview == isLoadingPreview)&&(identical(other.previewStatus, previewStatus) || other.previewStatus == previewStatus)&&(identical(other.actionStatus, actionStatus) || other.actionStatus == actionStatus));
}


@override
int get hashCode {
    return Object.hash(runtimeType,invitationId,fromParentName,childNames,invitedEmailMasked,role,status,isLoadingPreview,previewStatus,actionStatus);
}

@override
String toString() {
    return 'InviteRespondState(invitationId: $invitationId, fromParentName: $fromParentName, childNames: $childNames, invitedEmailMasked: $invitedEmailMasked, role: $role, status: $status, isLoadingPreview: $isLoadingPreview, previewStatus: $previewStatus, actionStatus: $actionStatus)';
}


}

/// @nodoc
abstract mixin class _$InviteRespondStateCopyWith<$Res> implements $InviteRespondStateCopyWith<$Res> {
  factory _$InviteRespondStateCopyWith(_InviteRespondState value, $Res Function(_InviteRespondState) _then) = __$InviteRespondStateCopyWithImpl;
@override @useResult
$Res call({
 String invitationId, String fromParentName, String childNames, String invitedEmailMasked, String role, String status, bool isLoadingPreview, ApiResultStatus<dynamic> previewStatus, ApiResultStatus<dynamic> actionStatus
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get previewStatus;@override $ApiResultStatusCopyWith<dynamic, $Res> get actionStatus;

}
/// @nodoc
class __$InviteRespondStateCopyWithImpl<$Res>
    implements _$InviteRespondStateCopyWith<$Res> {
  __$InviteRespondStateCopyWithImpl(this._self, this._then);

  final _InviteRespondState _self;
  final $Res Function(_InviteRespondState) _then;

/// Create a copy of InviteRespondState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? invitationId = null,Object? fromParentName = null,Object? childNames = null,Object? invitedEmailMasked = null,Object? role = null,Object? status = null,Object? isLoadingPreview = null,Object? previewStatus = null,Object? actionStatus = null,}) {
  return _then(_InviteRespondState(
invitationId: null == invitationId ? _self.invitationId : invitationId // ignore: cast_nullable_to_non_nullable
as String,fromParentName: null == fromParentName ? _self.fromParentName : fromParentName // ignore: cast_nullable_to_non_nullable
as String,childNames: null == childNames ? _self.childNames : childNames // ignore: cast_nullable_to_non_nullable
as String,invitedEmailMasked: null == invitedEmailMasked ? _self.invitedEmailMasked : invitedEmailMasked // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,isLoadingPreview: null == isLoadingPreview ? _self.isLoadingPreview : isLoadingPreview // ignore: cast_nullable_to_non_nullable
as bool,previewStatus: null == previewStatus ? _self.previewStatus : previewStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,actionStatus: null == actionStatus ? _self.actionStatus : actionStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}

/// Create a copy of InviteRespondState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get previewStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.previewStatus, (value) {
    return _then(_self.copyWith(previewStatus: value));
  });
}/// Create a copy of InviteRespondState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get actionStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.actionStatus, (value) {
    return _then(_self.copyWith(actionStatus: value));
  });
}
}

// dart format on
