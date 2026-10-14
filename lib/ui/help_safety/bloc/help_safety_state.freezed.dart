// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'help_safety_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HelpSafetyState {

 bool get isLoading; String get supportEmail; String get faqUrl; String get emergencyPhone; ApiResultStatus<dynamic> get actionStatus;
/// Create a copy of HelpSafetyState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HelpSafetyStateCopyWith<HelpSafetyState> get copyWith => _$HelpSafetyStateCopyWithImpl<HelpSafetyState>(this as HelpSafetyState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as HelpSafetyState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HelpSafetyState&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.supportEmail, _this.supportEmail) || other.supportEmail == _this.supportEmail)&&(identical(other.faqUrl, _this.faqUrl) || other.faqUrl == _this.faqUrl)&&(identical(other.emergencyPhone, _this.emergencyPhone) || other.emergencyPhone == _this.emergencyPhone)&&(identical(other.actionStatus, _this.actionStatus) || other.actionStatus == _this.actionStatus));
}


@override
int get hashCode {
  final _this = this as HelpSafetyState;
  return Object.hash(runtimeType,_this.isLoading,_this.supportEmail,_this.faqUrl,_this.emergencyPhone,_this.actionStatus);
}

@override
String toString() {
  final _this = this as HelpSafetyState;
  return 'HelpSafetyState(isLoading: ${_this.isLoading}, supportEmail: ${_this.supportEmail}, faqUrl: ${_this.faqUrl}, emergencyPhone: ${_this.emergencyPhone}, actionStatus: ${_this.actionStatus})';
}


}

/// @nodoc
abstract mixin class $HelpSafetyStateCopyWith<$Res>  {
  factory $HelpSafetyStateCopyWith(HelpSafetyState value, $Res Function(HelpSafetyState) _then) = _$HelpSafetyStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, String supportEmail, String faqUrl, String emergencyPhone, ApiResultStatus<dynamic> actionStatus
});


$ApiResultStatusCopyWith<dynamic, $Res> get actionStatus;

}
/// @nodoc
class _$HelpSafetyStateCopyWithImpl<$Res>
    implements $HelpSafetyStateCopyWith<$Res> {
  _$HelpSafetyStateCopyWithImpl(this._self, this._then);

  final HelpSafetyState _self;
  final $Res Function(HelpSafetyState) _then;

/// Create a copy of HelpSafetyState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? supportEmail = null,Object? faqUrl = null,Object? emergencyPhone = null,Object? actionStatus = null,}) {
  return _then(HelpSafetyState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,supportEmail: null == supportEmail ? _self.supportEmail : supportEmail // ignore: cast_nullable_to_non_nullable
as String,faqUrl: null == faqUrl ? _self.faqUrl : faqUrl // ignore: cast_nullable_to_non_nullable
as String,emergencyPhone: null == emergencyPhone ? _self.emergencyPhone : emergencyPhone // ignore: cast_nullable_to_non_nullable
as String,actionStatus: null == actionStatus ? _self.actionStatus : actionStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}
/// Create a copy of HelpSafetyState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get actionStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.actionStatus, (value) {
    return _then(_self.copyWith(actionStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [HelpSafetyState].
extension HelpSafetyStatePatterns on HelpSafetyState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HelpSafetyState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HelpSafetyState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HelpSafetyState value)  $default,){
final _that = this;
switch (_that) {
case _HelpSafetyState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HelpSafetyState value)?  $default,){
final _that = this;
switch (_that) {
case _HelpSafetyState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  String supportEmail,  String faqUrl,  String emergencyPhone,  ApiResultStatus<dynamic> actionStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HelpSafetyState() when $default != null:
return $default(_that.isLoading,_that.supportEmail,_that.faqUrl,_that.emergencyPhone,_that.actionStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  String supportEmail,  String faqUrl,  String emergencyPhone,  ApiResultStatus<dynamic> actionStatus)  $default,) {final _that = this;
switch (_that) {
case _HelpSafetyState():
return $default(_that.isLoading,_that.supportEmail,_that.faqUrl,_that.emergencyPhone,_that.actionStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  String supportEmail,  String faqUrl,  String emergencyPhone,  ApiResultStatus<dynamic> actionStatus)?  $default,) {final _that = this;
switch (_that) {
case _HelpSafetyState() when $default != null:
return $default(_that.isLoading,_that.supportEmail,_that.faqUrl,_that.emergencyPhone,_that.actionStatus);case _:
  return null;

}
}

}

/// @nodoc


class _HelpSafetyState implements HelpSafetyState {
  const _HelpSafetyState({this.isLoading = false, this.supportEmail = 'support@lovingbrain.com', this.faqUrl = 'https://lovingbrain.com/faq', this.emergencyPhone = 'tel:911', this.actionStatus = const ApiResultStatus.initial()});
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  String supportEmail;
@override@JsonKey() final  String faqUrl;
@override@JsonKey() final  String emergencyPhone;
@override@JsonKey() final  ApiResultStatus<dynamic> actionStatus;

/// Create a copy of HelpSafetyState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HelpSafetyStateCopyWith<_HelpSafetyState> get copyWith => __$HelpSafetyStateCopyWithImpl<_HelpSafetyState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HelpSafetyState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.supportEmail, supportEmail) || other.supportEmail == supportEmail)&&(identical(other.faqUrl, faqUrl) || other.faqUrl == faqUrl)&&(identical(other.emergencyPhone, emergencyPhone) || other.emergencyPhone == emergencyPhone)&&(identical(other.actionStatus, actionStatus) || other.actionStatus == actionStatus));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isLoading,supportEmail,faqUrl,emergencyPhone,actionStatus);
}

@override
String toString() {
    return 'HelpSafetyState(isLoading: $isLoading, supportEmail: $supportEmail, faqUrl: $faqUrl, emergencyPhone: $emergencyPhone, actionStatus: $actionStatus)';
}


}

/// @nodoc
abstract mixin class _$HelpSafetyStateCopyWith<$Res> implements $HelpSafetyStateCopyWith<$Res> {
  factory _$HelpSafetyStateCopyWith(_HelpSafetyState value, $Res Function(_HelpSafetyState) _then) = __$HelpSafetyStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, String supportEmail, String faqUrl, String emergencyPhone, ApiResultStatus<dynamic> actionStatus
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get actionStatus;

}
/// @nodoc
class __$HelpSafetyStateCopyWithImpl<$Res>
    implements _$HelpSafetyStateCopyWith<$Res> {
  __$HelpSafetyStateCopyWithImpl(this._self, this._then);

  final _HelpSafetyState _self;
  final $Res Function(_HelpSafetyState) _then;

/// Create a copy of HelpSafetyState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? supportEmail = null,Object? faqUrl = null,Object? emergencyPhone = null,Object? actionStatus = null,}) {
  return _then(_HelpSafetyState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,supportEmail: null == supportEmail ? _self.supportEmail : supportEmail // ignore: cast_nullable_to_non_nullable
as String,faqUrl: null == faqUrl ? _self.faqUrl : faqUrl // ignore: cast_nullable_to_non_nullable
as String,emergencyPhone: null == emergencyPhone ? _self.emergencyPhone : emergencyPhone // ignore: cast_nullable_to_non_nullable
as String,actionStatus: null == actionStatus ? _self.actionStatus : actionStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}

/// Create a copy of HelpSafetyState
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
