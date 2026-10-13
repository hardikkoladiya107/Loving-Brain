// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'permissions_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PermissionsState {

 String get caregiverName; String get caregiverRole; bool get sleepEnabled; bool get behaviourEnabled; bool get healthNotesEnabled; bool get plansEnabled; bool get mentorshipEnabled; bool get isSaving; ApiResultStatus<dynamic> get saveStatus;
/// Create a copy of PermissionsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PermissionsStateCopyWith<PermissionsState> get copyWith => _$PermissionsStateCopyWithImpl<PermissionsState>(this as PermissionsState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PermissionsState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PermissionsState&&(identical(other.caregiverName, _this.caregiverName) || other.caregiverName == _this.caregiverName)&&(identical(other.caregiverRole, _this.caregiverRole) || other.caregiverRole == _this.caregiverRole)&&(identical(other.sleepEnabled, _this.sleepEnabled) || other.sleepEnabled == _this.sleepEnabled)&&(identical(other.behaviourEnabled, _this.behaviourEnabled) || other.behaviourEnabled == _this.behaviourEnabled)&&(identical(other.healthNotesEnabled, _this.healthNotesEnabled) || other.healthNotesEnabled == _this.healthNotesEnabled)&&(identical(other.plansEnabled, _this.plansEnabled) || other.plansEnabled == _this.plansEnabled)&&(identical(other.mentorshipEnabled, _this.mentorshipEnabled) || other.mentorshipEnabled == _this.mentorshipEnabled)&&(identical(other.isSaving, _this.isSaving) || other.isSaving == _this.isSaving)&&(identical(other.saveStatus, _this.saveStatus) || other.saveStatus == _this.saveStatus));
}


@override
int get hashCode {
  final _this = this as PermissionsState;
  return Object.hash(runtimeType,_this.caregiverName,_this.caregiverRole,_this.sleepEnabled,_this.behaviourEnabled,_this.healthNotesEnabled,_this.plansEnabled,_this.mentorshipEnabled,_this.isSaving,_this.saveStatus);
}

@override
String toString() {
  final _this = this as PermissionsState;
  return 'PermissionsState(caregiverName: ${_this.caregiverName}, caregiverRole: ${_this.caregiverRole}, sleepEnabled: ${_this.sleepEnabled}, behaviourEnabled: ${_this.behaviourEnabled}, healthNotesEnabled: ${_this.healthNotesEnabled}, plansEnabled: ${_this.plansEnabled}, mentorshipEnabled: ${_this.mentorshipEnabled}, isSaving: ${_this.isSaving}, saveStatus: ${_this.saveStatus})';
}


}

/// @nodoc
abstract mixin class $PermissionsStateCopyWith<$Res>  {
  factory $PermissionsStateCopyWith(PermissionsState value, $Res Function(PermissionsState) _then) = _$PermissionsStateCopyWithImpl;
@useResult
$Res call({
 String caregiverName, String caregiverRole, bool sleepEnabled, bool behaviourEnabled, bool healthNotesEnabled, bool plansEnabled, bool mentorshipEnabled, bool isSaving, ApiResultStatus<dynamic> saveStatus
});


$ApiResultStatusCopyWith<dynamic, $Res> get saveStatus;

}
/// @nodoc
class _$PermissionsStateCopyWithImpl<$Res>
    implements $PermissionsStateCopyWith<$Res> {
  _$PermissionsStateCopyWithImpl(this._self, this._then);

  final PermissionsState _self;
  final $Res Function(PermissionsState) _then;

/// Create a copy of PermissionsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? caregiverName = null,Object? caregiverRole = null,Object? sleepEnabled = null,Object? behaviourEnabled = null,Object? healthNotesEnabled = null,Object? plansEnabled = null,Object? mentorshipEnabled = null,Object? isSaving = null,Object? saveStatus = null,}) {
  return _then(PermissionsState(
caregiverName: null == caregiverName ? _self.caregiverName : caregiverName // ignore: cast_nullable_to_non_nullable
as String,caregiverRole: null == caregiverRole ? _self.caregiverRole : caregiverRole // ignore: cast_nullable_to_non_nullable
as String,sleepEnabled: null == sleepEnabled ? _self.sleepEnabled : sleepEnabled // ignore: cast_nullable_to_non_nullable
as bool,behaviourEnabled: null == behaviourEnabled ? _self.behaviourEnabled : behaviourEnabled // ignore: cast_nullable_to_non_nullable
as bool,healthNotesEnabled: null == healthNotesEnabled ? _self.healthNotesEnabled : healthNotesEnabled // ignore: cast_nullable_to_non_nullable
as bool,plansEnabled: null == plansEnabled ? _self.plansEnabled : plansEnabled // ignore: cast_nullable_to_non_nullable
as bool,mentorshipEnabled: null == mentorshipEnabled ? _self.mentorshipEnabled : mentorshipEnabled // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,saveStatus: null == saveStatus ? _self.saveStatus : saveStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}
/// Create a copy of PermissionsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get saveStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.saveStatus, (value) {
    return _then(_self.copyWith(saveStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [PermissionsState].
extension PermissionsStatePatterns on PermissionsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PermissionsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PermissionsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PermissionsState value)  $default,){
final _that = this;
switch (_that) {
case _PermissionsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PermissionsState value)?  $default,){
final _that = this;
switch (_that) {
case _PermissionsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String caregiverName,  String caregiverRole,  bool sleepEnabled,  bool behaviourEnabled,  bool healthNotesEnabled,  bool plansEnabled,  bool mentorshipEnabled,  bool isSaving,  ApiResultStatus<dynamic> saveStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PermissionsState() when $default != null:
return $default(_that.caregiverName,_that.caregiverRole,_that.sleepEnabled,_that.behaviourEnabled,_that.healthNotesEnabled,_that.plansEnabled,_that.mentorshipEnabled,_that.isSaving,_that.saveStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String caregiverName,  String caregiverRole,  bool sleepEnabled,  bool behaviourEnabled,  bool healthNotesEnabled,  bool plansEnabled,  bool mentorshipEnabled,  bool isSaving,  ApiResultStatus<dynamic> saveStatus)  $default,) {final _that = this;
switch (_that) {
case _PermissionsState():
return $default(_that.caregiverName,_that.caregiverRole,_that.sleepEnabled,_that.behaviourEnabled,_that.healthNotesEnabled,_that.plansEnabled,_that.mentorshipEnabled,_that.isSaving,_that.saveStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String caregiverName,  String caregiverRole,  bool sleepEnabled,  bool behaviourEnabled,  bool healthNotesEnabled,  bool plansEnabled,  bool mentorshipEnabled,  bool isSaving,  ApiResultStatus<dynamic> saveStatus)?  $default,) {final _that = this;
switch (_that) {
case _PermissionsState() when $default != null:
return $default(_that.caregiverName,_that.caregiverRole,_that.sleepEnabled,_that.behaviourEnabled,_that.healthNotesEnabled,_that.plansEnabled,_that.mentorshipEnabled,_that.isSaving,_that.saveStatus);case _:
  return null;

}
}

}

/// @nodoc


class _PermissionsState implements PermissionsState {
  const _PermissionsState({this.caregiverName = 'Ravi', this.caregiverRole = 'Partner', this.sleepEnabled = true, this.behaviourEnabled = true, this.healthNotesEnabled = false, this.plansEnabled = true, this.mentorshipEnabled = false, this.isSaving = false, this.saveStatus = const ApiResultStatus.initial()});
  

@override@JsonKey() final  String caregiverName;
@override@JsonKey() final  String caregiverRole;
@override@JsonKey() final  bool sleepEnabled;
@override@JsonKey() final  bool behaviourEnabled;
@override@JsonKey() final  bool healthNotesEnabled;
@override@JsonKey() final  bool plansEnabled;
@override@JsonKey() final  bool mentorshipEnabled;
@override@JsonKey() final  bool isSaving;
@override@JsonKey() final  ApiResultStatus<dynamic> saveStatus;

/// Create a copy of PermissionsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PermissionsStateCopyWith<_PermissionsState> get copyWith => __$PermissionsStateCopyWithImpl<_PermissionsState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PermissionsState&&(identical(other.caregiverName, caregiverName) || other.caregiverName == caregiverName)&&(identical(other.caregiverRole, caregiverRole) || other.caregiverRole == caregiverRole)&&(identical(other.sleepEnabled, sleepEnabled) || other.sleepEnabled == sleepEnabled)&&(identical(other.behaviourEnabled, behaviourEnabled) || other.behaviourEnabled == behaviourEnabled)&&(identical(other.healthNotesEnabled, healthNotesEnabled) || other.healthNotesEnabled == healthNotesEnabled)&&(identical(other.plansEnabled, plansEnabled) || other.plansEnabled == plansEnabled)&&(identical(other.mentorshipEnabled, mentorshipEnabled) || other.mentorshipEnabled == mentorshipEnabled)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.saveStatus, saveStatus) || other.saveStatus == saveStatus));
}


@override
int get hashCode {
    return Object.hash(runtimeType,caregiverName,caregiverRole,sleepEnabled,behaviourEnabled,healthNotesEnabled,plansEnabled,mentorshipEnabled,isSaving,saveStatus);
}

@override
String toString() {
    return 'PermissionsState(caregiverName: $caregiverName, caregiverRole: $caregiverRole, sleepEnabled: $sleepEnabled, behaviourEnabled: $behaviourEnabled, healthNotesEnabled: $healthNotesEnabled, plansEnabled: $plansEnabled, mentorshipEnabled: $mentorshipEnabled, isSaving: $isSaving, saveStatus: $saveStatus)';
}


}

/// @nodoc
abstract mixin class _$PermissionsStateCopyWith<$Res> implements $PermissionsStateCopyWith<$Res> {
  factory _$PermissionsStateCopyWith(_PermissionsState value, $Res Function(_PermissionsState) _then) = __$PermissionsStateCopyWithImpl;
@override @useResult
$Res call({
 String caregiverName, String caregiverRole, bool sleepEnabled, bool behaviourEnabled, bool healthNotesEnabled, bool plansEnabled, bool mentorshipEnabled, bool isSaving, ApiResultStatus<dynamic> saveStatus
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get saveStatus;

}
/// @nodoc
class __$PermissionsStateCopyWithImpl<$Res>
    implements _$PermissionsStateCopyWith<$Res> {
  __$PermissionsStateCopyWithImpl(this._self, this._then);

  final _PermissionsState _self;
  final $Res Function(_PermissionsState) _then;

/// Create a copy of PermissionsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? caregiverName = null,Object? caregiverRole = null,Object? sleepEnabled = null,Object? behaviourEnabled = null,Object? healthNotesEnabled = null,Object? plansEnabled = null,Object? mentorshipEnabled = null,Object? isSaving = null,Object? saveStatus = null,}) {
  return _then(_PermissionsState(
caregiverName: null == caregiverName ? _self.caregiverName : caregiverName // ignore: cast_nullable_to_non_nullable
as String,caregiverRole: null == caregiverRole ? _self.caregiverRole : caregiverRole // ignore: cast_nullable_to_non_nullable
as String,sleepEnabled: null == sleepEnabled ? _self.sleepEnabled : sleepEnabled // ignore: cast_nullable_to_non_nullable
as bool,behaviourEnabled: null == behaviourEnabled ? _self.behaviourEnabled : behaviourEnabled // ignore: cast_nullable_to_non_nullable
as bool,healthNotesEnabled: null == healthNotesEnabled ? _self.healthNotesEnabled : healthNotesEnabled // ignore: cast_nullable_to_non_nullable
as bool,plansEnabled: null == plansEnabled ? _self.plansEnabled : plansEnabled // ignore: cast_nullable_to_non_nullable
as bool,mentorshipEnabled: null == mentorshipEnabled ? _self.mentorshipEnabled : mentorshipEnabled // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,saveStatus: null == saveStatus ? _self.saveStatus : saveStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}

/// Create a copy of PermissionsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get saveStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.saveStatus, (value) {
    return _then(_self.copyWith(saveStatus: value));
  });
}
}

// dart format on
