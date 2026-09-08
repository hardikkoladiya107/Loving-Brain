// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'otp_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OtpState {

 String get otpCode; String get otpError; ApiResultStatus get verifyStatus; ApiResultStatus get resendStatus; bool get isSubmitting; int get resendCountdown; bool get canResend; String get destination;
/// Create a copy of OtpState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OtpStateCopyWith<OtpState> get copyWith => _$OtpStateCopyWithImpl<OtpState>(this as OtpState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OtpState&&(identical(other.otpCode, otpCode) || other.otpCode == otpCode)&&(identical(other.otpError, otpError) || other.otpError == otpError)&&(identical(other.verifyStatus, verifyStatus) || other.verifyStatus == verifyStatus)&&(identical(other.resendStatus, resendStatus) || other.resendStatus == resendStatus)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.resendCountdown, resendCountdown) || other.resendCountdown == resendCountdown)&&(identical(other.canResend, canResend) || other.canResend == canResend)&&(identical(other.destination, destination) || other.destination == destination));
}


@override
int get hashCode => Object.hash(runtimeType,otpCode,otpError,verifyStatus,resendStatus,isSubmitting,resendCountdown,canResend,destination);

@override
String toString() {
  return 'OtpState(otpCode: $otpCode, otpError: $otpError, verifyStatus: $verifyStatus, resendStatus: $resendStatus, isSubmitting: $isSubmitting, resendCountdown: $resendCountdown, canResend: $canResend, destination: $destination)';
}


}

/// @nodoc
abstract mixin class $OtpStateCopyWith<$Res>  {
  factory $OtpStateCopyWith(OtpState value, $Res Function(OtpState) _then) = _$OtpStateCopyWithImpl;
@useResult
$Res call({
 String otpCode, String otpError, ApiResultStatus verifyStatus, ApiResultStatus resendStatus, bool isSubmitting, int resendCountdown, bool canResend, String destination
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
@pragma('vm:prefer-inline') @override $Res call({Object? otpCode = null,Object? otpError = null,Object? verifyStatus = null,Object? resendStatus = null,Object? isSubmitting = null,Object? resendCountdown = null,Object? canResend = null,Object? destination = null,}) {
  return _then(_self.copyWith(
otpCode: null == otpCode ? _self.otpCode : otpCode // ignore: cast_nullable_to_non_nullable
as String,otpError: null == otpError ? _self.otpError : otpError // ignore: cast_nullable_to_non_nullable
as String,verifyStatus: null == verifyStatus ? _self.verifyStatus : verifyStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,resendStatus: null == resendStatus ? _self.resendStatus : resendStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,resendCountdown: null == resendCountdown ? _self.resendCountdown : resendCountdown // ignore: cast_nullable_to_non_nullable
as int,canResend: null == canResend ? _self.canResend : canResend // ignore: cast_nullable_to_non_nullable
as bool,destination: null == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String otpCode,  String otpError,  ApiResultStatus verifyStatus,  ApiResultStatus resendStatus,  bool isSubmitting,  int resendCountdown,  bool canResend,  String destination)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OtpState() when $default != null:
return $default(_that.otpCode,_that.otpError,_that.verifyStatus,_that.resendStatus,_that.isSubmitting,_that.resendCountdown,_that.canResend,_that.destination);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String otpCode,  String otpError,  ApiResultStatus verifyStatus,  ApiResultStatus resendStatus,  bool isSubmitting,  int resendCountdown,  bool canResend,  String destination)  $default,) {final _that = this;
switch (_that) {
case _OtpState():
return $default(_that.otpCode,_that.otpError,_that.verifyStatus,_that.resendStatus,_that.isSubmitting,_that.resendCountdown,_that.canResend,_that.destination);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String otpCode,  String otpError,  ApiResultStatus verifyStatus,  ApiResultStatus resendStatus,  bool isSubmitting,  int resendCountdown,  bool canResend,  String destination)?  $default,) {final _that = this;
switch (_that) {
case _OtpState() when $default != null:
return $default(_that.otpCode,_that.otpError,_that.verifyStatus,_that.resendStatus,_that.isSubmitting,_that.resendCountdown,_that.canResend,_that.destination);case _:
  return null;

}
}

}

/// @nodoc


class _OtpState implements OtpState {
  const _OtpState({this.otpCode = '', this.otpError = '', this.verifyStatus = const ApiResultStatus.initial(), this.resendStatus = const ApiResultStatus.initial(), this.isSubmitting = false, this.resendCountdown = 30, this.canResend = false, this.destination = ''});
  

@override@JsonKey() final  String otpCode;
@override@JsonKey() final  String otpError;
@override@JsonKey() final  ApiResultStatus verifyStatus;
@override@JsonKey() final  ApiResultStatus resendStatus;
@override@JsonKey() final  bool isSubmitting;
@override@JsonKey() final  int resendCountdown;
@override@JsonKey() final  bool canResend;
@override@JsonKey() final  String destination;

/// Create a copy of OtpState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OtpStateCopyWith<_OtpState> get copyWith => __$OtpStateCopyWithImpl<_OtpState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OtpState&&(identical(other.otpCode, otpCode) || other.otpCode == otpCode)&&(identical(other.otpError, otpError) || other.otpError == otpError)&&(identical(other.verifyStatus, verifyStatus) || other.verifyStatus == verifyStatus)&&(identical(other.resendStatus, resendStatus) || other.resendStatus == resendStatus)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.resendCountdown, resendCountdown) || other.resendCountdown == resendCountdown)&&(identical(other.canResend, canResend) || other.canResend == canResend)&&(identical(other.destination, destination) || other.destination == destination));
}


@override
int get hashCode => Object.hash(runtimeType,otpCode,otpError,verifyStatus,resendStatus,isSubmitting,resendCountdown,canResend,destination);

@override
String toString() {
  return 'OtpState(otpCode: $otpCode, otpError: $otpError, verifyStatus: $verifyStatus, resendStatus: $resendStatus, isSubmitting: $isSubmitting, resendCountdown: $resendCountdown, canResend: $canResend, destination: $destination)';
}


}

/// @nodoc
abstract mixin class _$OtpStateCopyWith<$Res> implements $OtpStateCopyWith<$Res> {
  factory _$OtpStateCopyWith(_OtpState value, $Res Function(_OtpState) _then) = __$OtpStateCopyWithImpl;
@override @useResult
$Res call({
 String otpCode, String otpError, ApiResultStatus verifyStatus, ApiResultStatus resendStatus, bool isSubmitting, int resendCountdown, bool canResend, String destination
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
@override @pragma('vm:prefer-inline') $Res call({Object? otpCode = null,Object? otpError = null,Object? verifyStatus = null,Object? resendStatus = null,Object? isSubmitting = null,Object? resendCountdown = null,Object? canResend = null,Object? destination = null,}) {
  return _then(_OtpState(
otpCode: null == otpCode ? _self.otpCode : otpCode // ignore: cast_nullable_to_non_nullable
as String,otpError: null == otpError ? _self.otpError : otpError // ignore: cast_nullable_to_non_nullable
as String,verifyStatus: null == verifyStatus ? _self.verifyStatus : verifyStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,resendStatus: null == resendStatus ? _self.resendStatus : resendStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,resendCountdown: null == resendCountdown ? _self.resendCountdown : resendCountdown // ignore: cast_nullable_to_non_nullable
as int,canResend: null == canResend ? _self.canResend : canResend // ignore: cast_nullable_to_non_nullable
as bool,destination: null == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
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
