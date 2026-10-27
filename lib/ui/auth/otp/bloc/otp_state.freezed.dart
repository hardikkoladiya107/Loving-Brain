// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'otp_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OtpState {

 String get otpCode; String get otpError; ApiResultStatus<dynamic> get verifyStatus; ApiResultStatus<dynamic> get resendStatus; bool get isSubmitting; int get resendCountdown; bool get canResend; String get destination; String get verificationId; int? get resendToken; bool get isPhoneAuth; int get failedAttempts; bool get isLocked; int get lockoutSeconds; String get linkedEmail; String get linkedPhone;
/// Create a copy of OtpState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OtpStateCopyWith<OtpState> get copyWith => _$OtpStateCopyWithImpl<OtpState>(this as OtpState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OtpState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OtpState&&(identical(other.otpCode, _this.otpCode) || other.otpCode == _this.otpCode)&&(identical(other.otpError, _this.otpError) || other.otpError == _this.otpError)&&(identical(other.verifyStatus, _this.verifyStatus) || other.verifyStatus == _this.verifyStatus)&&(identical(other.resendStatus, _this.resendStatus) || other.resendStatus == _this.resendStatus)&&(identical(other.isSubmitting, _this.isSubmitting) || other.isSubmitting == _this.isSubmitting)&&(identical(other.resendCountdown, _this.resendCountdown) || other.resendCountdown == _this.resendCountdown)&&(identical(other.canResend, _this.canResend) || other.canResend == _this.canResend)&&(identical(other.destination, _this.destination) || other.destination == _this.destination)&&(identical(other.verificationId, _this.verificationId) || other.verificationId == _this.verificationId)&&(identical(other.resendToken, _this.resendToken) || other.resendToken == _this.resendToken)&&(identical(other.isPhoneAuth, _this.isPhoneAuth) || other.isPhoneAuth == _this.isPhoneAuth)&&(identical(other.failedAttempts, _this.failedAttempts) || other.failedAttempts == _this.failedAttempts)&&(identical(other.isLocked, _this.isLocked) || other.isLocked == _this.isLocked)&&(identical(other.lockoutSeconds, _this.lockoutSeconds) || other.lockoutSeconds == _this.lockoutSeconds)&&(identical(other.linkedEmail, _this.linkedEmail) || other.linkedEmail == _this.linkedEmail)&&(identical(other.linkedPhone, _this.linkedPhone) || other.linkedPhone == _this.linkedPhone));
}


@override
int get hashCode {
  final _this = this as OtpState;
  return Object.hash(runtimeType,_this.otpCode,_this.otpError,_this.verifyStatus,_this.resendStatus,_this.isSubmitting,_this.resendCountdown,_this.canResend,_this.destination,_this.verificationId,_this.resendToken,_this.isPhoneAuth,_this.failedAttempts,_this.isLocked,_this.lockoutSeconds,_this.linkedEmail,_this.linkedPhone);
}

@override
String toString() {
  final _this = this as OtpState;
  return 'OtpState(otpCode: ${_this.otpCode}, otpError: ${_this.otpError}, verifyStatus: ${_this.verifyStatus}, resendStatus: ${_this.resendStatus}, isSubmitting: ${_this.isSubmitting}, resendCountdown: ${_this.resendCountdown}, canResend: ${_this.canResend}, destination: ${_this.destination}, verificationId: ${_this.verificationId}, resendToken: ${_this.resendToken}, isPhoneAuth: ${_this.isPhoneAuth}, failedAttempts: ${_this.failedAttempts}, isLocked: ${_this.isLocked}, lockoutSeconds: ${_this.lockoutSeconds}, linkedEmail: ${_this.linkedEmail}, linkedPhone: ${_this.linkedPhone})';
}


}

/// @nodoc
abstract mixin class $OtpStateCopyWith<$Res>  {
  factory $OtpStateCopyWith(OtpState value, $Res Function(OtpState) _then) = _$OtpStateCopyWithImpl;
@useResult
$Res call({
 String otpCode, String otpError, ApiResultStatus<dynamic> verifyStatus, ApiResultStatus<dynamic> resendStatus, bool isSubmitting, int resendCountdown, bool canResend, String destination, String verificationId, int? resendToken, bool isPhoneAuth, int failedAttempts, bool isLocked, int lockoutSeconds, String linkedEmail, String linkedPhone
});


$ApiResultStatusCopyWith<dynamic, $Res> get verifyStatus;$ApiResultStatusCopyWith<dynamic, $Res> get resendStatus;

}
/// @nodoc
class _$OtpStateCopyWithImpl<$Res>
    implements $OtpStateCopyWith<$Res> {
  _$OtpStateCopyWithImpl(this._self, this._then);

  final OtpState _self;
  final $Res Function(OtpState) _then;

/// Create a copy of OtpState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? otpCode = null,Object? otpError = null,Object? verifyStatus = null,Object? resendStatus = null,Object? isSubmitting = null,Object? resendCountdown = null,Object? canResend = null,Object? destination = null,Object? verificationId = null,Object? resendToken = freezed,Object? isPhoneAuth = null,Object? failedAttempts = null,Object? isLocked = null,Object? lockoutSeconds = null,Object? linkedEmail = null,Object? linkedPhone = null,}) {
  return _then(OtpState(
otpCode: null == otpCode ? _self.otpCode : otpCode // ignore: cast_nullable_to_non_nullable
as String,otpError: null == otpError ? _self.otpError : otpError // ignore: cast_nullable_to_non_nullable
as String,verifyStatus: null == verifyStatus ? _self.verifyStatus : verifyStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,resendStatus: null == resendStatus ? _self.resendStatus : resendStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,resendCountdown: null == resendCountdown ? _self.resendCountdown : resendCountdown // ignore: cast_nullable_to_non_nullable
as int,canResend: null == canResend ? _self.canResend : canResend // ignore: cast_nullable_to_non_nullable
as bool,destination: null == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as String,verificationId: null == verificationId ? _self.verificationId : verificationId // ignore: cast_nullable_to_non_nullable
as String,resendToken: freezed == resendToken ? _self.resendToken : resendToken // ignore: cast_nullable_to_non_nullable
as int?,isPhoneAuth: null == isPhoneAuth ? _self.isPhoneAuth : isPhoneAuth // ignore: cast_nullable_to_non_nullable
as bool,failedAttempts: null == failedAttempts ? _self.failedAttempts : failedAttempts // ignore: cast_nullable_to_non_nullable
as int,isLocked: null == isLocked ? _self.isLocked : isLocked // ignore: cast_nullable_to_non_nullable
as bool,lockoutSeconds: null == lockoutSeconds ? _self.lockoutSeconds : lockoutSeconds // ignore: cast_nullable_to_non_nullable
as int,linkedEmail: null == linkedEmail ? _self.linkedEmail : linkedEmail // ignore: cast_nullable_to_non_nullable
as String,linkedPhone: null == linkedPhone ? _self.linkedPhone : linkedPhone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of OtpState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get verifyStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.verifyStatus, (value) {
    return _then(_self.copyWith(verifyStatus: value));
  });
}/// Create a copy of OtpState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get resendStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.resendStatus, (value) {
    return _then(_self.copyWith(resendStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [OtpState].
extension OtpStatePatterns on OtpState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OtpState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OtpState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OtpState value)  $default,){
final _that = this;
switch (_that) {
case _OtpState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OtpState value)?  $default,){
final _that = this;
switch (_that) {
case _OtpState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String otpCode,  String otpError,  ApiResultStatus<dynamic> verifyStatus,  ApiResultStatus<dynamic> resendStatus,  bool isSubmitting,  int resendCountdown,  bool canResend,  String destination,  String verificationId,  int? resendToken,  bool isPhoneAuth,  int failedAttempts,  bool isLocked,  int lockoutSeconds,  String linkedEmail,  String linkedPhone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OtpState() when $default != null:
return $default(_that.otpCode,_that.otpError,_that.verifyStatus,_that.resendStatus,_that.isSubmitting,_that.resendCountdown,_that.canResend,_that.destination,_that.verificationId,_that.resendToken,_that.isPhoneAuth,_that.failedAttempts,_that.isLocked,_that.lockoutSeconds,_that.linkedEmail,_that.linkedPhone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String otpCode,  String otpError,  ApiResultStatus<dynamic> verifyStatus,  ApiResultStatus<dynamic> resendStatus,  bool isSubmitting,  int resendCountdown,  bool canResend,  String destination,  String verificationId,  int? resendToken,  bool isPhoneAuth,  int failedAttempts,  bool isLocked,  int lockoutSeconds,  String linkedEmail,  String linkedPhone)  $default,) {final _that = this;
switch (_that) {
case _OtpState():
return $default(_that.otpCode,_that.otpError,_that.verifyStatus,_that.resendStatus,_that.isSubmitting,_that.resendCountdown,_that.canResend,_that.destination,_that.verificationId,_that.resendToken,_that.isPhoneAuth,_that.failedAttempts,_that.isLocked,_that.lockoutSeconds,_that.linkedEmail,_that.linkedPhone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String otpCode,  String otpError,  ApiResultStatus<dynamic> verifyStatus,  ApiResultStatus<dynamic> resendStatus,  bool isSubmitting,  int resendCountdown,  bool canResend,  String destination,  String verificationId,  int? resendToken,  bool isPhoneAuth,  int failedAttempts,  bool isLocked,  int lockoutSeconds,  String linkedEmail,  String linkedPhone)?  $default,) {final _that = this;
switch (_that) {
case _OtpState() when $default != null:
return $default(_that.otpCode,_that.otpError,_that.verifyStatus,_that.resendStatus,_that.isSubmitting,_that.resendCountdown,_that.canResend,_that.destination,_that.verificationId,_that.resendToken,_that.isPhoneAuth,_that.failedAttempts,_that.isLocked,_that.lockoutSeconds,_that.linkedEmail,_that.linkedPhone);case _:
  return null;

}
}

}

/// @nodoc


class _OtpState implements OtpState {
  const _OtpState({this.otpCode = '', this.otpError = '', this.verifyStatus = const ApiResultStatus.initial(), this.resendStatus = const ApiResultStatus.initial(), this.isSubmitting = false, this.resendCountdown = 30, this.canResend = false, this.destination = '', this.verificationId = '', this.resendToken = null, this.isPhoneAuth = false, this.failedAttempts = 0, this.isLocked = false, this.lockoutSeconds = 0, this.linkedEmail = '', this.linkedPhone = ''});
  

@override@JsonKey() final  String otpCode;
@override@JsonKey() final  String otpError;
@override@JsonKey() final  ApiResultStatus<dynamic> verifyStatus;
@override@JsonKey() final  ApiResultStatus<dynamic> resendStatus;
@override@JsonKey() final  bool isSubmitting;
@override@JsonKey() final  int resendCountdown;
@override@JsonKey() final  bool canResend;
@override@JsonKey() final  String destination;
@override@JsonKey() final  String verificationId;
@override@JsonKey() final  int? resendToken;
@override@JsonKey() final  bool isPhoneAuth;
@override@JsonKey() final  int failedAttempts;
@override@JsonKey() final  bool isLocked;
@override@JsonKey() final  int lockoutSeconds;
@override@JsonKey() final  String linkedEmail;
@override@JsonKey() final  String linkedPhone;

/// Create a copy of OtpState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OtpStateCopyWith<_OtpState> get copyWith => __$OtpStateCopyWithImpl<_OtpState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OtpState&&(identical(other.otpCode, otpCode) || other.otpCode == otpCode)&&(identical(other.otpError, otpError) || other.otpError == otpError)&&(identical(other.verifyStatus, verifyStatus) || other.verifyStatus == verifyStatus)&&(identical(other.resendStatus, resendStatus) || other.resendStatus == resendStatus)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.resendCountdown, resendCountdown) || other.resendCountdown == resendCountdown)&&(identical(other.canResend, canResend) || other.canResend == canResend)&&(identical(other.destination, destination) || other.destination == destination)&&(identical(other.verificationId, verificationId) || other.verificationId == verificationId)&&(identical(other.resendToken, resendToken) || other.resendToken == resendToken)&&(identical(other.isPhoneAuth, isPhoneAuth) || other.isPhoneAuth == isPhoneAuth)&&(identical(other.failedAttempts, failedAttempts) || other.failedAttempts == failedAttempts)&&(identical(other.isLocked, isLocked) || other.isLocked == isLocked)&&(identical(other.lockoutSeconds, lockoutSeconds) || other.lockoutSeconds == lockoutSeconds)&&(identical(other.linkedEmail, linkedEmail) || other.linkedEmail == linkedEmail)&&(identical(other.linkedPhone, linkedPhone) || other.linkedPhone == linkedPhone));
}


@override
int get hashCode {
    return Object.hash(runtimeType,otpCode,otpError,verifyStatus,resendStatus,isSubmitting,resendCountdown,canResend,destination,verificationId,resendToken,isPhoneAuth,failedAttempts,isLocked,lockoutSeconds,linkedEmail,linkedPhone);
}

@override
String toString() {
    return 'OtpState(otpCode: $otpCode, otpError: $otpError, verifyStatus: $verifyStatus, resendStatus: $resendStatus, isSubmitting: $isSubmitting, resendCountdown: $resendCountdown, canResend: $canResend, destination: $destination, verificationId: $verificationId, resendToken: $resendToken, isPhoneAuth: $isPhoneAuth, failedAttempts: $failedAttempts, isLocked: $isLocked, lockoutSeconds: $lockoutSeconds, linkedEmail: $linkedEmail, linkedPhone: $linkedPhone)';
}


}

/// @nodoc
abstract mixin class _$OtpStateCopyWith<$Res> implements $OtpStateCopyWith<$Res> {
  factory _$OtpStateCopyWith(_OtpState value, $Res Function(_OtpState) _then) = __$OtpStateCopyWithImpl;
@override @useResult
$Res call({
 String otpCode, String otpError, ApiResultStatus<dynamic> verifyStatus, ApiResultStatus<dynamic> resendStatus, bool isSubmitting, int resendCountdown, bool canResend, String destination, String verificationId, int? resendToken, bool isPhoneAuth, int failedAttempts, bool isLocked, int lockoutSeconds, String linkedEmail, String linkedPhone
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get verifyStatus;@override $ApiResultStatusCopyWith<dynamic, $Res> get resendStatus;

}
/// @nodoc
class __$OtpStateCopyWithImpl<$Res>
    implements _$OtpStateCopyWith<$Res> {
  __$OtpStateCopyWithImpl(this._self, this._then);

  final _OtpState _self;
  final $Res Function(_OtpState) _then;

/// Create a copy of OtpState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? otpCode = null,Object? otpError = null,Object? verifyStatus = null,Object? resendStatus = null,Object? isSubmitting = null,Object? resendCountdown = null,Object? canResend = null,Object? destination = null,Object? verificationId = null,Object? resendToken = freezed,Object? isPhoneAuth = null,Object? failedAttempts = null,Object? isLocked = null,Object? lockoutSeconds = null,Object? linkedEmail = null,Object? linkedPhone = null,}) {
  return _then(_OtpState(
otpCode: null == otpCode ? _self.otpCode : otpCode // ignore: cast_nullable_to_non_nullable
as String,otpError: null == otpError ? _self.otpError : otpError // ignore: cast_nullable_to_non_nullable
as String,verifyStatus: null == verifyStatus ? _self.verifyStatus : verifyStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,resendStatus: null == resendStatus ? _self.resendStatus : resendStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,resendCountdown: null == resendCountdown ? _self.resendCountdown : resendCountdown // ignore: cast_nullable_to_non_nullable
as int,canResend: null == canResend ? _self.canResend : canResend // ignore: cast_nullable_to_non_nullable
as bool,destination: null == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as String,verificationId: null == verificationId ? _self.verificationId : verificationId // ignore: cast_nullable_to_non_nullable
as String,resendToken: freezed == resendToken ? _self.resendToken : resendToken // ignore: cast_nullable_to_non_nullable
as int?,isPhoneAuth: null == isPhoneAuth ? _self.isPhoneAuth : isPhoneAuth // ignore: cast_nullable_to_non_nullable
as bool,failedAttempts: null == failedAttempts ? _self.failedAttempts : failedAttempts // ignore: cast_nullable_to_non_nullable
as int,isLocked: null == isLocked ? _self.isLocked : isLocked // ignore: cast_nullable_to_non_nullable
as bool,lockoutSeconds: null == lockoutSeconds ? _self.lockoutSeconds : lockoutSeconds // ignore: cast_nullable_to_non_nullable
as int,linkedEmail: null == linkedEmail ? _self.linkedEmail : linkedEmail // ignore: cast_nullable_to_non_nullable
as String,linkedPhone: null == linkedPhone ? _self.linkedPhone : linkedPhone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of OtpState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get verifyStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.verifyStatus, (value) {
    return _then(_self.copyWith(verifyStatus: value));
  });
}/// Create a copy of OtpState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get resendStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.resendStatus, (value) {
    return _then(_self.copyWith(resendStatus: value));
  });
}
}

// dart format on
