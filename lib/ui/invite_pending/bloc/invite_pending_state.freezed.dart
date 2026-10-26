// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invite_pending_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$InvitePendingState {

 String get recipientEmail; String get role; String get invitationId; String get childName; int get daysUntilExpiry; List<String> get sharedCategories; bool get isResending; bool get isCancelled; ApiResultStatus<dynamic> get actionStatus;
/// Create a copy of InvitePendingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvitePendingStateCopyWith<InvitePendingState> get copyWith => _$InvitePendingStateCopyWithImpl<InvitePendingState>(this as InvitePendingState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as InvitePendingState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvitePendingState&&(identical(other.recipientEmail, _this.recipientEmail) || other.recipientEmail == _this.recipientEmail)&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.invitationId, _this.invitationId) || other.invitationId == _this.invitationId)&&(identical(other.childName, _this.childName) || other.childName == _this.childName)&&(identical(other.daysUntilExpiry, _this.daysUntilExpiry) || other.daysUntilExpiry == _this.daysUntilExpiry)&&const DeepCollectionEquality().equals(other.sharedCategories, _this.sharedCategories)&&(identical(other.isResending, _this.isResending) || other.isResending == _this.isResending)&&(identical(other.isCancelled, _this.isCancelled) || other.isCancelled == _this.isCancelled)&&(identical(other.actionStatus, _this.actionStatus) || other.actionStatus == _this.actionStatus));
}


@override
int get hashCode {
  final _this = this as InvitePendingState;
  return Object.hash(runtimeType,_this.recipientEmail,_this.role,_this.invitationId,_this.childName,_this.daysUntilExpiry,const DeepCollectionEquality().hash(_this.sharedCategories),_this.isResending,_this.isCancelled,_this.actionStatus);
}

@override
String toString() {
  final _this = this as InvitePendingState;
  return 'InvitePendingState(recipientEmail: ${_this.recipientEmail}, role: ${_this.role}, invitationId: ${_this.invitationId}, childName: ${_this.childName}, daysUntilExpiry: ${_this.daysUntilExpiry}, sharedCategories: ${_this.sharedCategories}, isResending: ${_this.isResending}, isCancelled: ${_this.isCancelled}, actionStatus: ${_this.actionStatus})';
}


}

/// @nodoc
abstract mixin class $InvitePendingStateCopyWith<$Res>  {
  factory $InvitePendingStateCopyWith(InvitePendingState value, $Res Function(InvitePendingState) _then) = _$InvitePendingStateCopyWithImpl;
@useResult
$Res call({
 String recipientEmail, String role, String invitationId, String childName, int daysUntilExpiry, List<String> sharedCategories, bool isResending, bool isCancelled, ApiResultStatus<dynamic> actionStatus
});


$ApiResultStatusCopyWith<dynamic, $Res> get actionStatus;

}
/// @nodoc
class _$InvitePendingStateCopyWithImpl<$Res>
    implements $InvitePendingStateCopyWith<$Res> {
  _$InvitePendingStateCopyWithImpl(this._self, this._then);

  final InvitePendingState _self;
  final $Res Function(InvitePendingState) _then;

/// Create a copy of InvitePendingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? recipientEmail = null,Object? role = null,Object? invitationId = null,Object? childName = null,Object? daysUntilExpiry = null,Object? sharedCategories = null,Object? isResending = null,Object? isCancelled = null,Object? actionStatus = null,}) {
  return _then(InvitePendingState(
recipientEmail: null == recipientEmail ? _self.recipientEmail : recipientEmail // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,invitationId: null == invitationId ? _self.invitationId : invitationId // ignore: cast_nullable_to_non_nullable
as String,childName: null == childName ? _self.childName : childName // ignore: cast_nullable_to_non_nullable
as String,daysUntilExpiry: null == daysUntilExpiry ? _self.daysUntilExpiry : daysUntilExpiry // ignore: cast_nullable_to_non_nullable
as int,sharedCategories: null == sharedCategories ? _self.sharedCategories : sharedCategories // ignore: cast_nullable_to_non_nullable
as List<String>,isResending: null == isResending ? _self.isResending : isResending // ignore: cast_nullable_to_non_nullable
as bool,isCancelled: null == isCancelled ? _self.isCancelled : isCancelled // ignore: cast_nullable_to_non_nullable
as bool,actionStatus: null == actionStatus ? _self.actionStatus : actionStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}
/// Create a copy of InvitePendingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get actionStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.actionStatus, (value) {
    return _then(_self.copyWith(actionStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [InvitePendingState].
extension InvitePendingStatePatterns on InvitePendingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InvitePendingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InvitePendingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InvitePendingState value)  $default,){
final _that = this;
switch (_that) {
case _InvitePendingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InvitePendingState value)?  $default,){
final _that = this;
switch (_that) {
case _InvitePendingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String recipientEmail,  String role,  String invitationId,  String childName,  int daysUntilExpiry,  List<String> sharedCategories,  bool isResending,  bool isCancelled,  ApiResultStatus<dynamic> actionStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InvitePendingState() when $default != null:
return $default(_that.recipientEmail,_that.role,_that.invitationId,_that.childName,_that.daysUntilExpiry,_that.sharedCategories,_that.isResending,_that.isCancelled,_that.actionStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String recipientEmail,  String role,  String invitationId,  String childName,  int daysUntilExpiry,  List<String> sharedCategories,  bool isResending,  bool isCancelled,  ApiResultStatus<dynamic> actionStatus)  $default,) {final _that = this;
switch (_that) {
case _InvitePendingState():
return $default(_that.recipientEmail,_that.role,_that.invitationId,_that.childName,_that.daysUntilExpiry,_that.sharedCategories,_that.isResending,_that.isCancelled,_that.actionStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String recipientEmail,  String role,  String invitationId,  String childName,  int daysUntilExpiry,  List<String> sharedCategories,  bool isResending,  bool isCancelled,  ApiResultStatus<dynamic> actionStatus)?  $default,) {final _that = this;
switch (_that) {
case _InvitePendingState() when $default != null:
return $default(_that.recipientEmail,_that.role,_that.invitationId,_that.childName,_that.daysUntilExpiry,_that.sharedCategories,_that.isResending,_that.isCancelled,_that.actionStatus);case _:
  return null;

}
}

}

/// @nodoc


class _InvitePendingState implements InvitePendingState {
  const _InvitePendingState({this.recipientEmail = '', this.role = 'Caregiver', this.invitationId = '', this.childName = 'your child', this.daysUntilExpiry = 14,  List<String> sharedCategories = const <String>['Sleep patterns', "Tonight's plan"], this.isResending = false, this.isCancelled = false, this.actionStatus = const ApiResultStatus.initial()}): _sharedCategories = sharedCategories;
  

@override@JsonKey() final  String recipientEmail;
@override@JsonKey() final  String role;
@override@JsonKey() final  String invitationId;
@override@JsonKey() final  String childName;
@override@JsonKey() final  int daysUntilExpiry;
 final  List<String> _sharedCategories;
@override@JsonKey() List<String> get sharedCategories {
  if (_sharedCategories is EqualUnmodifiableListView) return _sharedCategories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sharedCategories);
}

@override@JsonKey() final  bool isResending;
@override@JsonKey() final  bool isCancelled;
@override@JsonKey() final  ApiResultStatus<dynamic> actionStatus;

/// Create a copy of InvitePendingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvitePendingStateCopyWith<_InvitePendingState> get copyWith => __$InvitePendingStateCopyWithImpl<_InvitePendingState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _InvitePendingState&&(identical(other.recipientEmail, recipientEmail) || other.recipientEmail == recipientEmail)&&(identical(other.role, role) || other.role == role)&&(identical(other.invitationId, invitationId) || other.invitationId == invitationId)&&(identical(other.childName, childName) || other.childName == childName)&&(identical(other.daysUntilExpiry, daysUntilExpiry) || other.daysUntilExpiry == daysUntilExpiry)&&const DeepCollectionEquality().equals(other.sharedCategories, _sharedCategories)&&(identical(other.isResending, isResending) || other.isResending == isResending)&&(identical(other.isCancelled, isCancelled) || other.isCancelled == isCancelled)&&(identical(other.actionStatus, actionStatus) || other.actionStatus == actionStatus));
}


@override
int get hashCode {
    return Object.hash(runtimeType,recipientEmail,role,invitationId,childName,daysUntilExpiry,const DeepCollectionEquality().hash(_sharedCategories),isResending,isCancelled,actionStatus);
}

@override
String toString() {
    return 'InvitePendingState(recipientEmail: $recipientEmail, role: $role, invitationId: $invitationId, childName: $childName, daysUntilExpiry: $daysUntilExpiry, sharedCategories: $sharedCategories, isResending: $isResending, isCancelled: $isCancelled, actionStatus: $actionStatus)';
}


}

/// @nodoc
abstract mixin class _$InvitePendingStateCopyWith<$Res> implements $InvitePendingStateCopyWith<$Res> {
  factory _$InvitePendingStateCopyWith(_InvitePendingState value, $Res Function(_InvitePendingState) _then) = __$InvitePendingStateCopyWithImpl;
@override @useResult
$Res call({
 String recipientEmail, String role, String invitationId, String childName, int daysUntilExpiry, List<String> sharedCategories, bool isResending, bool isCancelled, ApiResultStatus<dynamic> actionStatus
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get actionStatus;

}
/// @nodoc
class __$InvitePendingStateCopyWithImpl<$Res>
    implements _$InvitePendingStateCopyWith<$Res> {
  __$InvitePendingStateCopyWithImpl(this._self, this._then);

  final _InvitePendingState _self;
  final $Res Function(_InvitePendingState) _then;

/// Create a copy of InvitePendingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? recipientEmail = null,Object? role = null,Object? invitationId = null,Object? childName = null,Object? daysUntilExpiry = null,Object? sharedCategories = null,Object? isResending = null,Object? isCancelled = null,Object? actionStatus = null,}) {
  return _then(_InvitePendingState(
recipientEmail: null == recipientEmail ? _self.recipientEmail : recipientEmail // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,invitationId: null == invitationId ? _self.invitationId : invitationId // ignore: cast_nullable_to_non_nullable
as String,childName: null == childName ? _self.childName : childName // ignore: cast_nullable_to_non_nullable
as String,daysUntilExpiry: null == daysUntilExpiry ? _self.daysUntilExpiry : daysUntilExpiry // ignore: cast_nullable_to_non_nullable
as int,sharedCategories: null == sharedCategories ? _self._sharedCategories : sharedCategories // ignore: cast_nullable_to_non_nullable
as List<String>,isResending: null == isResending ? _self.isResending : isResending // ignore: cast_nullable_to_non_nullable
as bool,isCancelled: null == isCancelled ? _self.isCancelled : isCancelled // ignore: cast_nullable_to_non_nullable
as bool,actionStatus: null == actionStatus ? _self.actionStatus : actionStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}

/// Create a copy of InvitePendingState
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
