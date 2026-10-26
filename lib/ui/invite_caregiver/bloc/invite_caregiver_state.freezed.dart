// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invite_caregiver_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$InviteCaregiverState {

 String get selectedRole; String get childName; String get emailOrPhone; bool get isSending; String get createdInvitationId; ApiResultStatus<dynamic> get sendStatus;
/// Create a copy of InviteCaregiverState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InviteCaregiverStateCopyWith<InviteCaregiverState> get copyWith => _$InviteCaregiverStateCopyWithImpl<InviteCaregiverState>(this as InviteCaregiverState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as InviteCaregiverState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InviteCaregiverState&&(identical(other.selectedRole, _this.selectedRole) || other.selectedRole == _this.selectedRole)&&(identical(other.childName, _this.childName) || other.childName == _this.childName)&&(identical(other.emailOrPhone, _this.emailOrPhone) || other.emailOrPhone == _this.emailOrPhone)&&(identical(other.isSending, _this.isSending) || other.isSending == _this.isSending)&&(identical(other.createdInvitationId, _this.createdInvitationId) || other.createdInvitationId == _this.createdInvitationId)&&(identical(other.sendStatus, _this.sendStatus) || other.sendStatus == _this.sendStatus));
}


@override
int get hashCode {
  final _this = this as InviteCaregiverState;
  return Object.hash(runtimeType,_this.selectedRole,_this.childName,_this.emailOrPhone,_this.isSending,_this.createdInvitationId,_this.sendStatus);
}

@override
String toString() {
  final _this = this as InviteCaregiverState;
  return 'InviteCaregiverState(selectedRole: ${_this.selectedRole}, childName: ${_this.childName}, emailOrPhone: ${_this.emailOrPhone}, isSending: ${_this.isSending}, createdInvitationId: ${_this.createdInvitationId}, sendStatus: ${_this.sendStatus})';
}


}

/// @nodoc
abstract mixin class $InviteCaregiverStateCopyWith<$Res>  {
  factory $InviteCaregiverStateCopyWith(InviteCaregiverState value, $Res Function(InviteCaregiverState) _then) = _$InviteCaregiverStateCopyWithImpl;
@useResult
$Res call({
 String selectedRole, String childName, String emailOrPhone, bool isSending, String createdInvitationId, ApiResultStatus<dynamic> sendStatus
});


$ApiResultStatusCopyWith<dynamic, $Res> get sendStatus;

}
/// @nodoc
class _$InviteCaregiverStateCopyWithImpl<$Res>
    implements $InviteCaregiverStateCopyWith<$Res> {
  _$InviteCaregiverStateCopyWithImpl(this._self, this._then);

  final InviteCaregiverState _self;
  final $Res Function(InviteCaregiverState) _then;

/// Create a copy of InviteCaregiverState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selectedRole = null,Object? childName = null,Object? emailOrPhone = null,Object? isSending = null,Object? createdInvitationId = null,Object? sendStatus = null,}) {
  return _then(InviteCaregiverState(
selectedRole: null == selectedRole ? _self.selectedRole : selectedRole // ignore: cast_nullable_to_non_nullable
as String,childName: null == childName ? _self.childName : childName // ignore: cast_nullable_to_non_nullable
as String,emailOrPhone: null == emailOrPhone ? _self.emailOrPhone : emailOrPhone // ignore: cast_nullable_to_non_nullable
as String,isSending: null == isSending ? _self.isSending : isSending // ignore: cast_nullable_to_non_nullable
as bool,createdInvitationId: null == createdInvitationId ? _self.createdInvitationId : createdInvitationId // ignore: cast_nullable_to_non_nullable
as String,sendStatus: null == sendStatus ? _self.sendStatus : sendStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}
/// Create a copy of InviteCaregiverState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get sendStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.sendStatus, (value) {
    return _then(_self.copyWith(sendStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [InviteCaregiverState].
extension InviteCaregiverStatePatterns on InviteCaregiverState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InviteCaregiverState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InviteCaregiverState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InviteCaregiverState value)  $default,){
final _that = this;
switch (_that) {
case _InviteCaregiverState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InviteCaregiverState value)?  $default,){
final _that = this;
switch (_that) {
case _InviteCaregiverState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String selectedRole,  String childName,  String emailOrPhone,  bool isSending,  String createdInvitationId,  ApiResultStatus<dynamic> sendStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InviteCaregiverState() when $default != null:
return $default(_that.selectedRole,_that.childName,_that.emailOrPhone,_that.isSending,_that.createdInvitationId,_that.sendStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String selectedRole,  String childName,  String emailOrPhone,  bool isSending,  String createdInvitationId,  ApiResultStatus<dynamic> sendStatus)  $default,) {final _that = this;
switch (_that) {
case _InviteCaregiverState():
return $default(_that.selectedRole,_that.childName,_that.emailOrPhone,_that.isSending,_that.createdInvitationId,_that.sendStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String selectedRole,  String childName,  String emailOrPhone,  bool isSending,  String createdInvitationId,  ApiResultStatus<dynamic> sendStatus)?  $default,) {final _that = this;
switch (_that) {
case _InviteCaregiverState() when $default != null:
return $default(_that.selectedRole,_that.childName,_that.emailOrPhone,_that.isSending,_that.createdInvitationId,_that.sendStatus);case _:
  return null;

}
}

}

/// @nodoc


class _InviteCaregiverState implements InviteCaregiverState {
  const _InviteCaregiverState({this.selectedRole = 'Grandparent', this.childName = 'your child', this.emailOrPhone = '', this.isSending = false, this.createdInvitationId = '', this.sendStatus = const ApiResultStatus.initial()});
  

@override@JsonKey() final  String selectedRole;
@override@JsonKey() final  String childName;
@override@JsonKey() final  String emailOrPhone;
@override@JsonKey() final  bool isSending;
@override@JsonKey() final  String createdInvitationId;
@override@JsonKey() final  ApiResultStatus<dynamic> sendStatus;

/// Create a copy of InviteCaregiverState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InviteCaregiverStateCopyWith<_InviteCaregiverState> get copyWith => __$InviteCaregiverStateCopyWithImpl<_InviteCaregiverState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _InviteCaregiverState&&(identical(other.selectedRole, selectedRole) || other.selectedRole == selectedRole)&&(identical(other.childName, childName) || other.childName == childName)&&(identical(other.emailOrPhone, emailOrPhone) || other.emailOrPhone == emailOrPhone)&&(identical(other.isSending, isSending) || other.isSending == isSending)&&(identical(other.createdInvitationId, createdInvitationId) || other.createdInvitationId == createdInvitationId)&&(identical(other.sendStatus, sendStatus) || other.sendStatus == sendStatus));
}


@override
int get hashCode {
    return Object.hash(runtimeType,selectedRole,childName,emailOrPhone,isSending,createdInvitationId,sendStatus);
}

@override
String toString() {
    return 'InviteCaregiverState(selectedRole: $selectedRole, childName: $childName, emailOrPhone: $emailOrPhone, isSending: $isSending, createdInvitationId: $createdInvitationId, sendStatus: $sendStatus)';
}


}

/// @nodoc
abstract mixin class _$InviteCaregiverStateCopyWith<$Res> implements $InviteCaregiverStateCopyWith<$Res> {
  factory _$InviteCaregiverStateCopyWith(_InviteCaregiverState value, $Res Function(_InviteCaregiverState) _then) = __$InviteCaregiverStateCopyWithImpl;
@override @useResult
$Res call({
 String selectedRole, String childName, String emailOrPhone, bool isSending, String createdInvitationId, ApiResultStatus<dynamic> sendStatus
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get sendStatus;

}
/// @nodoc
class __$InviteCaregiverStateCopyWithImpl<$Res>
    implements _$InviteCaregiverStateCopyWith<$Res> {
  __$InviteCaregiverStateCopyWithImpl(this._self, this._then);

  final _InviteCaregiverState _self;
  final $Res Function(_InviteCaregiverState) _then;

/// Create a copy of InviteCaregiverState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectedRole = null,Object? childName = null,Object? emailOrPhone = null,Object? isSending = null,Object? createdInvitationId = null,Object? sendStatus = null,}) {
  return _then(_InviteCaregiverState(
selectedRole: null == selectedRole ? _self.selectedRole : selectedRole // ignore: cast_nullable_to_non_nullable
as String,childName: null == childName ? _self.childName : childName // ignore: cast_nullable_to_non_nullable
as String,emailOrPhone: null == emailOrPhone ? _self.emailOrPhone : emailOrPhone // ignore: cast_nullable_to_non_nullable
as String,isSending: null == isSending ? _self.isSending : isSending // ignore: cast_nullable_to_non_nullable
as bool,createdInvitationId: null == createdInvitationId ? _self.createdInvitationId : createdInvitationId // ignore: cast_nullable_to_non_nullable
as String,sendStatus: null == sendStatus ? _self.sendStatus : sendStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}

/// Create a copy of InviteCaregiverState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get sendStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.sendStatus, (value) {
    return _then(_self.copyWith(sendStatus: value));
  });
}
}

// dart format on
