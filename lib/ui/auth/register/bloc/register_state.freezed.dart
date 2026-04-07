// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'register_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RegisterState {

 bool get obscureTextPassword; bool get obscureTextConfirmPassword; String get emailAddress; String get password; String get confirmPassword; String get emailAddressError; String get passwordError; String get confirmPasswordError; bool get isTermsAndConditionAccepted; ApiResultStatus get apiResultStatus;
/// Create a copy of RegisterState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegisterStateCopyWith<RegisterState> get copyWith => _$RegisterStateCopyWithImpl<RegisterState>(this as RegisterState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegisterState&&(identical(other.obscureTextPassword, obscureTextPassword) || other.obscureTextPassword == obscureTextPassword)&&(identical(other.obscureTextConfirmPassword, obscureTextConfirmPassword) || other.obscureTextConfirmPassword == obscureTextConfirmPassword)&&(identical(other.emailAddress, emailAddress) || other.emailAddress == emailAddress)&&(identical(other.password, password) || other.password == password)&&(identical(other.confirmPassword, confirmPassword) || other.confirmPassword == confirmPassword)&&(identical(other.emailAddressError, emailAddressError) || other.emailAddressError == emailAddressError)&&(identical(other.passwordError, passwordError) || other.passwordError == passwordError)&&(identical(other.confirmPasswordError, confirmPasswordError) || other.confirmPasswordError == confirmPasswordError)&&(identical(other.isTermsAndConditionAccepted, isTermsAndConditionAccepted) || other.isTermsAndConditionAccepted == isTermsAndConditionAccepted)&&(identical(other.apiResultStatus, apiResultStatus) || other.apiResultStatus == apiResultStatus));
}


@override
int get hashCode => Object.hash(runtimeType,obscureTextPassword,obscureTextConfirmPassword,emailAddress,password,confirmPassword,emailAddressError,passwordError,confirmPasswordError,isTermsAndConditionAccepted,apiResultStatus);

@override
String toString() {
  return 'RegisterState(obscureTextPassword: $obscureTextPassword, obscureTextConfirmPassword: $obscureTextConfirmPassword, emailAddress: $emailAddress, password: $password, confirmPassword: $confirmPassword, emailAddressError: $emailAddressError, passwordError: $passwordError, confirmPasswordError: $confirmPasswordError, isTermsAndConditionAccepted: $isTermsAndConditionAccepted, apiResultStatus: $apiResultStatus)';
}


}

/// @nodoc
abstract mixin class $RegisterStateCopyWith<$Res>  {
  factory $RegisterStateCopyWith(RegisterState value, $Res Function(RegisterState) _then) = _$RegisterStateCopyWithImpl;
@useResult
$Res call({
 bool obscureTextPassword, bool obscureTextConfirmPassword, String emailAddress, String password, String confirmPassword, String emailAddressError, String passwordError, String confirmPasswordError, bool isTermsAndConditionAccepted, ApiResultStatus apiResultStatus
});


$ApiResultStatusCopyWith<dynamic, $Res> get apiResultStatus;

}
/// @nodoc
class _$RegisterStateCopyWithImpl<$Res>
    implements $RegisterStateCopyWith<$Res> {
  _$RegisterStateCopyWithImpl(this._self, this._then);

  final RegisterState _self;
  final $Res Function(RegisterState) _then;

/// Create a copy of RegisterState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? obscureTextPassword = null,Object? obscureTextConfirmPassword = null,Object? emailAddress = null,Object? password = null,Object? confirmPassword = null,Object? emailAddressError = null,Object? passwordError = null,Object? confirmPasswordError = null,Object? isTermsAndConditionAccepted = null,Object? apiResultStatus = null,}) {
  return _then(_self.copyWith(
obscureTextPassword: null == obscureTextPassword ? _self.obscureTextPassword : obscureTextPassword // ignore: cast_nullable_to_non_nullable
as bool,obscureTextConfirmPassword: null == obscureTextConfirmPassword ? _self.obscureTextConfirmPassword : obscureTextConfirmPassword // ignore: cast_nullable_to_non_nullable
as bool,emailAddress: null == emailAddress ? _self.emailAddress : emailAddress // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,confirmPassword: null == confirmPassword ? _self.confirmPassword : confirmPassword // ignore: cast_nullable_to_non_nullable
as String,emailAddressError: null == emailAddressError ? _self.emailAddressError : emailAddressError // ignore: cast_nullable_to_non_nullable
as String,passwordError: null == passwordError ? _self.passwordError : passwordError // ignore: cast_nullable_to_non_nullable
as String,confirmPasswordError: null == confirmPasswordError ? _self.confirmPasswordError : confirmPasswordError // ignore: cast_nullable_to_non_nullable
as String,isTermsAndConditionAccepted: null == isTermsAndConditionAccepted ? _self.isTermsAndConditionAccepted : isTermsAndConditionAccepted // ignore: cast_nullable_to_non_nullable
as bool,apiResultStatus: null == apiResultStatus ? _self.apiResultStatus : apiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,
  ));
}
/// Create a copy of RegisterState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get apiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.apiResultStatus, (value) {
    return _then(_self.copyWith(apiResultStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [RegisterState].
extension RegisterStatePatterns on RegisterState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RegisterState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RegisterState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RegisterState value)  $default,){
final _that = this;
switch (_that) {
case _RegisterState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RegisterState value)?  $default,){
final _that = this;
switch (_that) {
case _RegisterState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool obscureTextPassword,  bool obscureTextConfirmPassword,  String emailAddress,  String password,  String confirmPassword,  String emailAddressError,  String passwordError,  String confirmPasswordError,  bool isTermsAndConditionAccepted,  ApiResultStatus apiResultStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RegisterState() when $default != null:
return $default(_that.obscureTextPassword,_that.obscureTextConfirmPassword,_that.emailAddress,_that.password,_that.confirmPassword,_that.emailAddressError,_that.passwordError,_that.confirmPasswordError,_that.isTermsAndConditionAccepted,_that.apiResultStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool obscureTextPassword,  bool obscureTextConfirmPassword,  String emailAddress,  String password,  String confirmPassword,  String emailAddressError,  String passwordError,  String confirmPasswordError,  bool isTermsAndConditionAccepted,  ApiResultStatus apiResultStatus)  $default,) {final _that = this;
switch (_that) {
case _RegisterState():
return $default(_that.obscureTextPassword,_that.obscureTextConfirmPassword,_that.emailAddress,_that.password,_that.confirmPassword,_that.emailAddressError,_that.passwordError,_that.confirmPasswordError,_that.isTermsAndConditionAccepted,_that.apiResultStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool obscureTextPassword,  bool obscureTextConfirmPassword,  String emailAddress,  String password,  String confirmPassword,  String emailAddressError,  String passwordError,  String confirmPasswordError,  bool isTermsAndConditionAccepted,  ApiResultStatus apiResultStatus)?  $default,) {final _that = this;
switch (_that) {
case _RegisterState() when $default != null:
return $default(_that.obscureTextPassword,_that.obscureTextConfirmPassword,_that.emailAddress,_that.password,_that.confirmPassword,_that.emailAddressError,_that.passwordError,_that.confirmPasswordError,_that.isTermsAndConditionAccepted,_that.apiResultStatus);case _:
  return null;

}
}

}

/// @nodoc


class _RegisterState implements RegisterState {
  const _RegisterState({this.obscureTextPassword = true, this.obscureTextConfirmPassword = true, this.emailAddress = "", this.password = "", this.confirmPassword = "", this.emailAddressError = "", this.passwordError = "", this.confirmPasswordError = "", this.isTermsAndConditionAccepted = false, this.apiResultStatus = const ApiResultStatus.initial()});
  

@override@JsonKey() final  bool obscureTextPassword;
@override@JsonKey() final  bool obscureTextConfirmPassword;
@override@JsonKey() final  String emailAddress;
@override@JsonKey() final  String password;
@override@JsonKey() final  String confirmPassword;
@override@JsonKey() final  String emailAddressError;
@override@JsonKey() final  String passwordError;
@override@JsonKey() final  String confirmPasswordError;
@override@JsonKey() final  bool isTermsAndConditionAccepted;
@override@JsonKey() final  ApiResultStatus apiResultStatus;

/// Create a copy of RegisterState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegisterStateCopyWith<_RegisterState> get copyWith => __$RegisterStateCopyWithImpl<_RegisterState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegisterState&&(identical(other.obscureTextPassword, obscureTextPassword) || other.obscureTextPassword == obscureTextPassword)&&(identical(other.obscureTextConfirmPassword, obscureTextConfirmPassword) || other.obscureTextConfirmPassword == obscureTextConfirmPassword)&&(identical(other.emailAddress, emailAddress) || other.emailAddress == emailAddress)&&(identical(other.password, password) || other.password == password)&&(identical(other.confirmPassword, confirmPassword) || other.confirmPassword == confirmPassword)&&(identical(other.emailAddressError, emailAddressError) || other.emailAddressError == emailAddressError)&&(identical(other.passwordError, passwordError) || other.passwordError == passwordError)&&(identical(other.confirmPasswordError, confirmPasswordError) || other.confirmPasswordError == confirmPasswordError)&&(identical(other.isTermsAndConditionAccepted, isTermsAndConditionAccepted) || other.isTermsAndConditionAccepted == isTermsAndConditionAccepted)&&(identical(other.apiResultStatus, apiResultStatus) || other.apiResultStatus == apiResultStatus));
}


@override
int get hashCode => Object.hash(runtimeType,obscureTextPassword,obscureTextConfirmPassword,emailAddress,password,confirmPassword,emailAddressError,passwordError,confirmPasswordError,isTermsAndConditionAccepted,apiResultStatus);

@override
String toString() {
  return 'RegisterState(obscureTextPassword: $obscureTextPassword, obscureTextConfirmPassword: $obscureTextConfirmPassword, emailAddress: $emailAddress, password: $password, confirmPassword: $confirmPassword, emailAddressError: $emailAddressError, passwordError: $passwordError, confirmPasswordError: $confirmPasswordError, isTermsAndConditionAccepted: $isTermsAndConditionAccepted, apiResultStatus: $apiResultStatus)';
}


}

/// @nodoc
abstract mixin class _$RegisterStateCopyWith<$Res> implements $RegisterStateCopyWith<$Res> {
  factory _$RegisterStateCopyWith(_RegisterState value, $Res Function(_RegisterState) _then) = __$RegisterStateCopyWithImpl;
@override @useResult
$Res call({
 bool obscureTextPassword, bool obscureTextConfirmPassword, String emailAddress, String password, String confirmPassword, String emailAddressError, String passwordError, String confirmPasswordError, bool isTermsAndConditionAccepted, ApiResultStatus apiResultStatus
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get apiResultStatus;

}
/// @nodoc
class __$RegisterStateCopyWithImpl<$Res>
    implements _$RegisterStateCopyWith<$Res> {
  __$RegisterStateCopyWithImpl(this._self, this._then);

  final _RegisterState _self;
  final $Res Function(_RegisterState) _then;

/// Create a copy of RegisterState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? obscureTextPassword = null,Object? obscureTextConfirmPassword = null,Object? emailAddress = null,Object? password = null,Object? confirmPassword = null,Object? emailAddressError = null,Object? passwordError = null,Object? confirmPasswordError = null,Object? isTermsAndConditionAccepted = null,Object? apiResultStatus = null,}) {
  return _then(_RegisterState(
obscureTextPassword: null == obscureTextPassword ? _self.obscureTextPassword : obscureTextPassword // ignore: cast_nullable_to_non_nullable
as bool,obscureTextConfirmPassword: null == obscureTextConfirmPassword ? _self.obscureTextConfirmPassword : obscureTextConfirmPassword // ignore: cast_nullable_to_non_nullable
as bool,emailAddress: null == emailAddress ? _self.emailAddress : emailAddress // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,confirmPassword: null == confirmPassword ? _self.confirmPassword : confirmPassword // ignore: cast_nullable_to_non_nullable
as String,emailAddressError: null == emailAddressError ? _self.emailAddressError : emailAddressError // ignore: cast_nullable_to_non_nullable
as String,passwordError: null == passwordError ? _self.passwordError : passwordError // ignore: cast_nullable_to_non_nullable
as String,confirmPasswordError: null == confirmPasswordError ? _self.confirmPasswordError : confirmPasswordError // ignore: cast_nullable_to_non_nullable
as String,isTermsAndConditionAccepted: null == isTermsAndConditionAccepted ? _self.isTermsAndConditionAccepted : isTermsAndConditionAccepted // ignore: cast_nullable_to_non_nullable
as bool,apiResultStatus: null == apiResultStatus ? _self.apiResultStatus : apiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,
  ));
}

/// Create a copy of RegisterState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get apiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.apiResultStatus, (value) {
    return _then(_self.copyWith(apiResultStatus: value));
  });
}
}

// dart format on
