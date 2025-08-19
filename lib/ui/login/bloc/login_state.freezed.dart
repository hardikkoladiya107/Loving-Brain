// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoginState {

 String get emailAddress; String get password; String get emailAddressError; String get passwordError; ApiResultStatus get apiResultStatus; bool get obscureTextPassword;
/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginStateCopyWith<LoginState> get copyWith => _$LoginStateCopyWithImpl<LoginState>(this as LoginState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginState&&(identical(other.emailAddress, emailAddress) || other.emailAddress == emailAddress)&&(identical(other.password, password) || other.password == password)&&(identical(other.emailAddressError, emailAddressError) || other.emailAddressError == emailAddressError)&&(identical(other.passwordError, passwordError) || other.passwordError == passwordError)&&(identical(other.apiResultStatus, apiResultStatus) || other.apiResultStatus == apiResultStatus)&&(identical(other.obscureTextPassword, obscureTextPassword) || other.obscureTextPassword == obscureTextPassword));
}


@override
int get hashCode => Object.hash(runtimeType,emailAddress,password,emailAddressError,passwordError,apiResultStatus,obscureTextPassword);

@override
String toString() {
  return 'LoginState(emailAddress: $emailAddress, password: $password, emailAddressError: $emailAddressError, passwordError: $passwordError, apiResultStatus: $apiResultStatus, obscureTextPassword: $obscureTextPassword)';
}


}

/// @nodoc
abstract mixin class $LoginStateCopyWith<$Res>  {
  factory $LoginStateCopyWith(LoginState value, $Res Function(LoginState) _then) = _$LoginStateCopyWithImpl;
@useResult
$Res call({
 String emailAddress, String password, String emailAddressError, String passwordError, ApiResultStatus apiResultStatus, bool obscureTextPassword
});


$ApiResultStatusCopyWith<dynamic, $Res> get apiResultStatus;

}
/// @nodoc
class _$LoginStateCopyWithImpl<$Res>
    implements $LoginStateCopyWith<$Res> {
  _$LoginStateCopyWithImpl(this._self, this._then);

  final LoginState _self;
  final $Res Function(LoginState) _then;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? emailAddress = null,Object? password = null,Object? emailAddressError = null,Object? passwordError = null,Object? apiResultStatus = null,Object? obscureTextPassword = null,}) {
  return _then(_self.copyWith(
emailAddress: null == emailAddress ? _self.emailAddress : emailAddress // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,emailAddressError: null == emailAddressError ? _self.emailAddressError : emailAddressError // ignore: cast_nullable_to_non_nullable
as String,passwordError: null == passwordError ? _self.passwordError : passwordError // ignore: cast_nullable_to_non_nullable
as String,apiResultStatus: null == apiResultStatus ? _self.apiResultStatus : apiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,obscureTextPassword: null == obscureTextPassword ? _self.obscureTextPassword : obscureTextPassword // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get apiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.apiResultStatus, (value) {
    return _then(_self.copyWith(apiResultStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [LoginState].
extension LoginStatePatterns on LoginState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoginState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoginState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoginState value)  $default,){
final _that = this;
switch (_that) {
case _LoginState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoginState value)?  $default,){
final _that = this;
switch (_that) {
case _LoginState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String emailAddress,  String password,  String emailAddressError,  String passwordError,  ApiResultStatus apiResultStatus,  bool obscureTextPassword)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoginState() when $default != null:
return $default(_that.emailAddress,_that.password,_that.emailAddressError,_that.passwordError,_that.apiResultStatus,_that.obscureTextPassword);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String emailAddress,  String password,  String emailAddressError,  String passwordError,  ApiResultStatus apiResultStatus,  bool obscureTextPassword)  $default,) {final _that = this;
switch (_that) {
case _LoginState():
return $default(_that.emailAddress,_that.password,_that.emailAddressError,_that.passwordError,_that.apiResultStatus,_that.obscureTextPassword);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String emailAddress,  String password,  String emailAddressError,  String passwordError,  ApiResultStatus apiResultStatus,  bool obscureTextPassword)?  $default,) {final _that = this;
switch (_that) {
case _LoginState() when $default != null:
return $default(_that.emailAddress,_that.password,_that.emailAddressError,_that.passwordError,_that.apiResultStatus,_that.obscureTextPassword);case _:
  return null;

}
}

}

/// @nodoc


class _LoginState implements LoginState {
  const _LoginState({this.emailAddress = "", this.password = "", this.emailAddressError = "", this.passwordError = "", this.apiResultStatus = const ApiResultStatus.initial(), this.obscureTextPassword = false});
  

@override@JsonKey() final  String emailAddress;
@override@JsonKey() final  String password;
@override@JsonKey() final  String emailAddressError;
@override@JsonKey() final  String passwordError;
@override@JsonKey() final  ApiResultStatus apiResultStatus;
@override@JsonKey() final  bool obscureTextPassword;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginStateCopyWith<_LoginState> get copyWith => __$LoginStateCopyWithImpl<_LoginState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginState&&(identical(other.emailAddress, emailAddress) || other.emailAddress == emailAddress)&&(identical(other.password, password) || other.password == password)&&(identical(other.emailAddressError, emailAddressError) || other.emailAddressError == emailAddressError)&&(identical(other.passwordError, passwordError) || other.passwordError == passwordError)&&(identical(other.apiResultStatus, apiResultStatus) || other.apiResultStatus == apiResultStatus)&&(identical(other.obscureTextPassword, obscureTextPassword) || other.obscureTextPassword == obscureTextPassword));
}


@override
int get hashCode => Object.hash(runtimeType,emailAddress,password,emailAddressError,passwordError,apiResultStatus,obscureTextPassword);

@override
String toString() {
  return 'LoginState(emailAddress: $emailAddress, password: $password, emailAddressError: $emailAddressError, passwordError: $passwordError, apiResultStatus: $apiResultStatus, obscureTextPassword: $obscureTextPassword)';
}


}

/// @nodoc
abstract mixin class _$LoginStateCopyWith<$Res> implements $LoginStateCopyWith<$Res> {
  factory _$LoginStateCopyWith(_LoginState value, $Res Function(_LoginState) _then) = __$LoginStateCopyWithImpl;
@override @useResult
$Res call({
 String emailAddress, String password, String emailAddressError, String passwordError, ApiResultStatus apiResultStatus, bool obscureTextPassword
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get apiResultStatus;

}
/// @nodoc
class __$LoginStateCopyWithImpl<$Res>
    implements _$LoginStateCopyWith<$Res> {
  __$LoginStateCopyWithImpl(this._self, this._then);

  final _LoginState _self;
  final $Res Function(_LoginState) _then;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? emailAddress = null,Object? password = null,Object? emailAddressError = null,Object? passwordError = null,Object? apiResultStatus = null,Object? obscureTextPassword = null,}) {
  return _then(_LoginState(
emailAddress: null == emailAddress ? _self.emailAddress : emailAddress // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,emailAddressError: null == emailAddressError ? _self.emailAddressError : emailAddressError // ignore: cast_nullable_to_non_nullable
as String,passwordError: null == passwordError ? _self.passwordError : passwordError // ignore: cast_nullable_to_non_nullable
as String,apiResultStatus: null == apiResultStatus ? _self.apiResultStatus : apiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,obscureTextPassword: null == obscureTextPassword ? _self.obscureTextPassword : obscureTextPassword // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of LoginState
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
