// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'co_parent_register_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CoParentRegisterState {

 String get password; String get confirmPassword; String get passwordError; String get confirmPasswordError; bool get obscurePassword; bool get obscureConfirmPassword; bool get isTermsAccepted; ApiResultStatus get apiResultStatus; bool get isSubmitting;
/// Create a copy of CoParentRegisterState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoParentRegisterStateCopyWith<CoParentRegisterState> get copyWith => _$CoParentRegisterStateCopyWithImpl<CoParentRegisterState>(this as CoParentRegisterState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoParentRegisterState&&(identical(other.password, password) || other.password == password)&&(identical(other.confirmPassword, confirmPassword) || other.confirmPassword == confirmPassword)&&(identical(other.passwordError, passwordError) || other.passwordError == passwordError)&&(identical(other.confirmPasswordError, confirmPasswordError) || other.confirmPasswordError == confirmPasswordError)&&(identical(other.obscurePassword, obscurePassword) || other.obscurePassword == obscurePassword)&&(identical(other.obscureConfirmPassword, obscureConfirmPassword) || other.obscureConfirmPassword == obscureConfirmPassword)&&(identical(other.isTermsAccepted, isTermsAccepted) || other.isTermsAccepted == isTermsAccepted)&&(identical(other.apiResultStatus, apiResultStatus) || other.apiResultStatus == apiResultStatus)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting));
}


@override
int get hashCode => Object.hash(runtimeType,password,confirmPassword,passwordError,confirmPasswordError,obscurePassword,obscureConfirmPassword,isTermsAccepted,apiResultStatus,isSubmitting);

@override
String toString() {
  return 'CoParentRegisterState(password: $password, confirmPassword: $confirmPassword, passwordError: $passwordError, confirmPasswordError: $confirmPasswordError, obscurePassword: $obscurePassword, obscureConfirmPassword: $obscureConfirmPassword, isTermsAccepted: $isTermsAccepted, apiResultStatus: $apiResultStatus, isSubmitting: $isSubmitting)';
}


}

/// @nodoc
abstract mixin class $CoParentRegisterStateCopyWith<$Res>  {
  factory $CoParentRegisterStateCopyWith(CoParentRegisterState value, $Res Function(CoParentRegisterState) _then) = _$CoParentRegisterStateCopyWithImpl;
@useResult
$Res call({
 String password, String confirmPassword, String passwordError, String confirmPasswordError, bool obscurePassword, bool obscureConfirmPassword, bool isTermsAccepted, ApiResultStatus apiResultStatus, bool isSubmitting
});


$ApiResultStatusCopyWith<dynamic, $Res> get apiResultStatus;

}
/// @nodoc
class _$CoParentRegisterStateCopyWithImpl<$Res>
    implements $CoParentRegisterStateCopyWith<$Res> {
  _$CoParentRegisterStateCopyWithImpl(this._self, this._then);

  final CoParentRegisterState _self;
  final $Res Function(CoParentRegisterState) _then;

/// Create a copy of CoParentRegisterState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? password = null,Object? confirmPassword = null,Object? passwordError = null,Object? confirmPasswordError = null,Object? obscurePassword = null,Object? obscureConfirmPassword = null,Object? isTermsAccepted = null,Object? apiResultStatus = null,Object? isSubmitting = null,}) {
  return _then(_self.copyWith(
password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,confirmPassword: null == confirmPassword ? _self.confirmPassword : confirmPassword // ignore: cast_nullable_to_non_nullable
as String,passwordError: null == passwordError ? _self.passwordError : passwordError // ignore: cast_nullable_to_non_nullable
as String,confirmPasswordError: null == confirmPasswordError ? _self.confirmPasswordError : confirmPasswordError // ignore: cast_nullable_to_non_nullable
as String,obscurePassword: null == obscurePassword ? _self.obscurePassword : obscurePassword // ignore: cast_nullable_to_non_nullable
as bool,obscureConfirmPassword: null == obscureConfirmPassword ? _self.obscureConfirmPassword : obscureConfirmPassword // ignore: cast_nullable_to_non_nullable
as bool,isTermsAccepted: null == isTermsAccepted ? _self.isTermsAccepted : isTermsAccepted // ignore: cast_nullable_to_non_nullable
as bool,apiResultStatus: null == apiResultStatus ? _self.apiResultStatus : apiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of CoParentRegisterState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get apiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.apiResultStatus, (value) {
    return _then(_self.copyWith(apiResultStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [CoParentRegisterState].
extension CoParentRegisterStatePatterns on CoParentRegisterState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoParentRegisterState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoParentRegisterState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoParentRegisterState value)  $default,){
final _that = this;
switch (_that) {
case _CoParentRegisterState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoParentRegisterState value)?  $default,){
final _that = this;
switch (_that) {
case _CoParentRegisterState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String password,  String confirmPassword,  String passwordError,  String confirmPasswordError,  bool obscurePassword,  bool obscureConfirmPassword,  bool isTermsAccepted,  ApiResultStatus apiResultStatus,  bool isSubmitting)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoParentRegisterState() when $default != null:
return $default(_that.password,_that.confirmPassword,_that.passwordError,_that.confirmPasswordError,_that.obscurePassword,_that.obscureConfirmPassword,_that.isTermsAccepted,_that.apiResultStatus,_that.isSubmitting);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String password,  String confirmPassword,  String passwordError,  String confirmPasswordError,  bool obscurePassword,  bool obscureConfirmPassword,  bool isTermsAccepted,  ApiResultStatus apiResultStatus,  bool isSubmitting)  $default,) {final _that = this;
switch (_that) {
case _CoParentRegisterState():
return $default(_that.password,_that.confirmPassword,_that.passwordError,_that.confirmPasswordError,_that.obscurePassword,_that.obscureConfirmPassword,_that.isTermsAccepted,_that.apiResultStatus,_that.isSubmitting);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String password,  String confirmPassword,  String passwordError,  String confirmPasswordError,  bool obscurePassword,  bool obscureConfirmPassword,  bool isTermsAccepted,  ApiResultStatus apiResultStatus,  bool isSubmitting)?  $default,) {final _that = this;
switch (_that) {
case _CoParentRegisterState() when $default != null:
return $default(_that.password,_that.confirmPassword,_that.passwordError,_that.confirmPasswordError,_that.obscurePassword,_that.obscureConfirmPassword,_that.isTermsAccepted,_that.apiResultStatus,_that.isSubmitting);case _:
  return null;

}
}

}

/// @nodoc


class _CoParentRegisterState implements CoParentRegisterState {
  const _CoParentRegisterState({this.password = '', this.confirmPassword = '', this.passwordError = '', this.confirmPasswordError = '', this.obscurePassword = true, this.obscureConfirmPassword = true, this.isTermsAccepted = false, this.apiResultStatus = const ApiResultStatus.initial(), this.isSubmitting = false});
  

@override@JsonKey() final  String password;
@override@JsonKey() final  String confirmPassword;
@override@JsonKey() final  String passwordError;
@override@JsonKey() final  String confirmPasswordError;
@override@JsonKey() final  bool obscurePassword;
@override@JsonKey() final  bool obscureConfirmPassword;
@override@JsonKey() final  bool isTermsAccepted;
@override@JsonKey() final  ApiResultStatus apiResultStatus;
@override@JsonKey() final  bool isSubmitting;

/// Create a copy of CoParentRegisterState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoParentRegisterStateCopyWith<_CoParentRegisterState> get copyWith => __$CoParentRegisterStateCopyWithImpl<_CoParentRegisterState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoParentRegisterState&&(identical(other.password, password) || other.password == password)&&(identical(other.confirmPassword, confirmPassword) || other.confirmPassword == confirmPassword)&&(identical(other.passwordError, passwordError) || other.passwordError == passwordError)&&(identical(other.confirmPasswordError, confirmPasswordError) || other.confirmPasswordError == confirmPasswordError)&&(identical(other.obscurePassword, obscurePassword) || other.obscurePassword == obscurePassword)&&(identical(other.obscureConfirmPassword, obscureConfirmPassword) || other.obscureConfirmPassword == obscureConfirmPassword)&&(identical(other.isTermsAccepted, isTermsAccepted) || other.isTermsAccepted == isTermsAccepted)&&(identical(other.apiResultStatus, apiResultStatus) || other.apiResultStatus == apiResultStatus)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting));
}


@override
int get hashCode => Object.hash(runtimeType,password,confirmPassword,passwordError,confirmPasswordError,obscurePassword,obscureConfirmPassword,isTermsAccepted,apiResultStatus,isSubmitting);

@override
String toString() {
  return 'CoParentRegisterState(password: $password, confirmPassword: $confirmPassword, passwordError: $passwordError, confirmPasswordError: $confirmPasswordError, obscurePassword: $obscurePassword, obscureConfirmPassword: $obscureConfirmPassword, isTermsAccepted: $isTermsAccepted, apiResultStatus: $apiResultStatus, isSubmitting: $isSubmitting)';
}


}

/// @nodoc
abstract mixin class _$CoParentRegisterStateCopyWith<$Res> implements $CoParentRegisterStateCopyWith<$Res> {
  factory _$CoParentRegisterStateCopyWith(_CoParentRegisterState value, $Res Function(_CoParentRegisterState) _then) = __$CoParentRegisterStateCopyWithImpl;
@override @useResult
$Res call({
 String password, String confirmPassword, String passwordError, String confirmPasswordError, bool obscurePassword, bool obscureConfirmPassword, bool isTermsAccepted, ApiResultStatus apiResultStatus, bool isSubmitting
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get apiResultStatus;

}
/// @nodoc
class __$CoParentRegisterStateCopyWithImpl<$Res>
    implements _$CoParentRegisterStateCopyWith<$Res> {
  __$CoParentRegisterStateCopyWithImpl(this._self, this._then);

  final _CoParentRegisterState _self;
  final $Res Function(_CoParentRegisterState) _then;

/// Create a copy of CoParentRegisterState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? password = null,Object? confirmPassword = null,Object? passwordError = null,Object? confirmPasswordError = null,Object? obscurePassword = null,Object? obscureConfirmPassword = null,Object? isTermsAccepted = null,Object? apiResultStatus = null,Object? isSubmitting = null,}) {
  return _then(_CoParentRegisterState(
password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,confirmPassword: null == confirmPassword ? _self.confirmPassword : confirmPassword // ignore: cast_nullable_to_non_nullable
as String,passwordError: null == passwordError ? _self.passwordError : passwordError // ignore: cast_nullable_to_non_nullable
as String,confirmPasswordError: null == confirmPasswordError ? _self.confirmPasswordError : confirmPasswordError // ignore: cast_nullable_to_non_nullable
as String,obscurePassword: null == obscurePassword ? _self.obscurePassword : obscurePassword // ignore: cast_nullable_to_non_nullable
as bool,obscureConfirmPassword: null == obscureConfirmPassword ? _self.obscureConfirmPassword : obscureConfirmPassword // ignore: cast_nullable_to_non_nullable
as bool,isTermsAccepted: null == isTermsAccepted ? _self.isTermsAccepted : isTermsAccepted // ignore: cast_nullable_to_non_nullable
as bool,apiResultStatus: null == apiResultStatus ? _self.apiResultStatus : apiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of CoParentRegisterState
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
