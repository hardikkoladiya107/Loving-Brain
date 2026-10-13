// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'family_menu_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FamilyMenuState {

 bool get isLoading; String get childName; List<CaregiverItem> get linkedCaregivers; List<CaregiverItem> get pendingInvites; ApiResultStatus<dynamic> get fetchStatus;
/// Create a copy of FamilyMenuState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FamilyMenuStateCopyWith<FamilyMenuState> get copyWith => _$FamilyMenuStateCopyWithImpl<FamilyMenuState>(this as FamilyMenuState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FamilyMenuState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FamilyMenuState&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.childName, _this.childName) || other.childName == _this.childName)&&const DeepCollectionEquality().equals(other.linkedCaregivers, _this.linkedCaregivers)&&const DeepCollectionEquality().equals(other.pendingInvites, _this.pendingInvites)&&(identical(other.fetchStatus, _this.fetchStatus) || other.fetchStatus == _this.fetchStatus));
}


@override
int get hashCode {
  final _this = this as FamilyMenuState;
  return Object.hash(runtimeType,_this.isLoading,_this.childName,const DeepCollectionEquality().hash(_this.linkedCaregivers),const DeepCollectionEquality().hash(_this.pendingInvites),_this.fetchStatus);
}

@override
String toString() {
  final _this = this as FamilyMenuState;
  return 'FamilyMenuState(isLoading: ${_this.isLoading}, childName: ${_this.childName}, linkedCaregivers: ${_this.linkedCaregivers}, pendingInvites: ${_this.pendingInvites}, fetchStatus: ${_this.fetchStatus})';
}


}

/// @nodoc
abstract mixin class $FamilyMenuStateCopyWith<$Res>  {
  factory $FamilyMenuStateCopyWith(FamilyMenuState value, $Res Function(FamilyMenuState) _then) = _$FamilyMenuStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, String childName, List<CaregiverItem> linkedCaregivers, List<CaregiverItem> pendingInvites, ApiResultStatus<dynamic> fetchStatus
});


$ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus;

}
/// @nodoc
class _$FamilyMenuStateCopyWithImpl<$Res>
    implements $FamilyMenuStateCopyWith<$Res> {
  _$FamilyMenuStateCopyWithImpl(this._self, this._then);

  final FamilyMenuState _self;
  final $Res Function(FamilyMenuState) _then;

/// Create a copy of FamilyMenuState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? childName = null,Object? linkedCaregivers = null,Object? pendingInvites = null,Object? fetchStatus = null,}) {
  return _then(FamilyMenuState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,childName: null == childName ? _self.childName : childName // ignore: cast_nullable_to_non_nullable
as String,linkedCaregivers: null == linkedCaregivers ? _self.linkedCaregivers : linkedCaregivers // ignore: cast_nullable_to_non_nullable
as List<CaregiverItem>,pendingInvites: null == pendingInvites ? _self.pendingInvites : pendingInvites // ignore: cast_nullable_to_non_nullable
as List<CaregiverItem>,fetchStatus: null == fetchStatus ? _self.fetchStatus : fetchStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}
/// Create a copy of FamilyMenuState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.fetchStatus, (value) {
    return _then(_self.copyWith(fetchStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [FamilyMenuState].
extension FamilyMenuStatePatterns on FamilyMenuState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FamilyMenuState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FamilyMenuState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FamilyMenuState value)  $default,){
final _that = this;
switch (_that) {
case _FamilyMenuState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FamilyMenuState value)?  $default,){
final _that = this;
switch (_that) {
case _FamilyMenuState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  String childName,  List<CaregiverItem> linkedCaregivers,  List<CaregiverItem> pendingInvites,  ApiResultStatus<dynamic> fetchStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FamilyMenuState() when $default != null:
return $default(_that.isLoading,_that.childName,_that.linkedCaregivers,_that.pendingInvites,_that.fetchStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  String childName,  List<CaregiverItem> linkedCaregivers,  List<CaregiverItem> pendingInvites,  ApiResultStatus<dynamic> fetchStatus)  $default,) {final _that = this;
switch (_that) {
case _FamilyMenuState():
return $default(_that.isLoading,_that.childName,_that.linkedCaregivers,_that.pendingInvites,_that.fetchStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  String childName,  List<CaregiverItem> linkedCaregivers,  List<CaregiverItem> pendingInvites,  ApiResultStatus<dynamic> fetchStatus)?  $default,) {final _that = this;
switch (_that) {
case _FamilyMenuState() when $default != null:
return $default(_that.isLoading,_that.childName,_that.linkedCaregivers,_that.pendingInvites,_that.fetchStatus);case _:
  return null;

}
}

}

/// @nodoc


class _FamilyMenuState implements FamilyMenuState {
  const _FamilyMenuState({this.isLoading = false, this.childName = 'your child',  List<CaregiverItem> linkedCaregivers = const <CaregiverItem>[CaregiverItem(id: 'user_ravi', name: 'Ravi', email: 'ravi@example.com', role: 'Partner', status: 'Linked')],  List<CaregiverItem> pendingInvites = const <CaregiverItem>[CaregiverItem(id: 'invite_grandma', name: 'Grandma Susan', email: 'susan@example.com', role: 'Grandparent', status: 'Awaiting response', daysRemaining: 12)], this.fetchStatus = const ApiResultStatus.initial()}): _linkedCaregivers = linkedCaregivers,_pendingInvites = pendingInvites;
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  String childName;
 final  List<CaregiverItem> _linkedCaregivers;
@override@JsonKey() List<CaregiverItem> get linkedCaregivers {
  if (_linkedCaregivers is EqualUnmodifiableListView) return _linkedCaregivers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_linkedCaregivers);
}

 final  List<CaregiverItem> _pendingInvites;
@override@JsonKey() List<CaregiverItem> get pendingInvites {
  if (_pendingInvites is EqualUnmodifiableListView) return _pendingInvites;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pendingInvites);
}

@override@JsonKey() final  ApiResultStatus<dynamic> fetchStatus;

/// Create a copy of FamilyMenuState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FamilyMenuStateCopyWith<_FamilyMenuState> get copyWith => __$FamilyMenuStateCopyWithImpl<_FamilyMenuState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FamilyMenuState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.childName, childName) || other.childName == childName)&&const DeepCollectionEquality().equals(other.linkedCaregivers, _linkedCaregivers)&&const DeepCollectionEquality().equals(other.pendingInvites, _pendingInvites)&&(identical(other.fetchStatus, fetchStatus) || other.fetchStatus == fetchStatus));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isLoading,childName,const DeepCollectionEquality().hash(_linkedCaregivers),const DeepCollectionEquality().hash(_pendingInvites),fetchStatus);
}

@override
String toString() {
    return 'FamilyMenuState(isLoading: $isLoading, childName: $childName, linkedCaregivers: $linkedCaregivers, pendingInvites: $pendingInvites, fetchStatus: $fetchStatus)';
}


}

/// @nodoc
abstract mixin class _$FamilyMenuStateCopyWith<$Res> implements $FamilyMenuStateCopyWith<$Res> {
  factory _$FamilyMenuStateCopyWith(_FamilyMenuState value, $Res Function(_FamilyMenuState) _then) = __$FamilyMenuStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, String childName, List<CaregiverItem> linkedCaregivers, List<CaregiverItem> pendingInvites, ApiResultStatus<dynamic> fetchStatus
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus;

}
/// @nodoc
class __$FamilyMenuStateCopyWithImpl<$Res>
    implements _$FamilyMenuStateCopyWith<$Res> {
  __$FamilyMenuStateCopyWithImpl(this._self, this._then);

  final _FamilyMenuState _self;
  final $Res Function(_FamilyMenuState) _then;

/// Create a copy of FamilyMenuState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? childName = null,Object? linkedCaregivers = null,Object? pendingInvites = null,Object? fetchStatus = null,}) {
  return _then(_FamilyMenuState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,childName: null == childName ? _self.childName : childName // ignore: cast_nullable_to_non_nullable
as String,linkedCaregivers: null == linkedCaregivers ? _self._linkedCaregivers : linkedCaregivers // ignore: cast_nullable_to_non_nullable
as List<CaregiverItem>,pendingInvites: null == pendingInvites ? _self._pendingInvites : pendingInvites // ignore: cast_nullable_to_non_nullable
as List<CaregiverItem>,fetchStatus: null == fetchStatus ? _self.fetchStatus : fetchStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}

/// Create a copy of FamilyMenuState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.fetchStatus, (value) {
    return _then(_self.copyWith(fetchStatus: value));
  });
}
}

// dart format on
