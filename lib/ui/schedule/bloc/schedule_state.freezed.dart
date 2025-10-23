// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScheduleState {

 String get message; int get tabIndex; List<SharedEventModel> get sharedEventList; UserModel? get userModel; ChildModel? get childModel; ApiResultStatus get deleteRoutineApiResultStatus;
/// Create a copy of ScheduleState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleStateCopyWith<ScheduleState> get copyWith => _$ScheduleStateCopyWithImpl<ScheduleState>(this as ScheduleState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleState&&(identical(other.message, message) || other.message == message)&&(identical(other.tabIndex, tabIndex) || other.tabIndex == tabIndex)&&const DeepCollectionEquality().equals(other.sharedEventList, sharedEventList)&&(identical(other.userModel, userModel) || other.userModel == userModel)&&(identical(other.childModel, childModel) || other.childModel == childModel)&&(identical(other.deleteRoutineApiResultStatus, deleteRoutineApiResultStatus) || other.deleteRoutineApiResultStatus == deleteRoutineApiResultStatus));
}


@override
int get hashCode => Object.hash(runtimeType,message,tabIndex,const DeepCollectionEquality().hash(sharedEventList),userModel,childModel,deleteRoutineApiResultStatus);

@override
String toString() {
  return 'ScheduleState(message: $message, tabIndex: $tabIndex, sharedEventList: $sharedEventList, userModel: $userModel, childModel: $childModel, deleteRoutineApiResultStatus: $deleteRoutineApiResultStatus)';
}


}

/// @nodoc
abstract mixin class $ScheduleStateCopyWith<$Res>  {
  factory $ScheduleStateCopyWith(ScheduleState value, $Res Function(ScheduleState) _then) = _$ScheduleStateCopyWithImpl;
@useResult
$Res call({
 String message, int tabIndex, List<SharedEventModel> sharedEventList, UserModel? userModel, ChildModel? childModel, ApiResultStatus deleteRoutineApiResultStatus
});


$ApiResultStatusCopyWith<dynamic, $Res> get deleteRoutineApiResultStatus;

}
/// @nodoc
class _$ScheduleStateCopyWithImpl<$Res>
    implements $ScheduleStateCopyWith<$Res> {
  _$ScheduleStateCopyWithImpl(this._self, this._then);

  final ScheduleState _self;
  final $Res Function(ScheduleState) _then;

/// Create a copy of ScheduleState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,Object? tabIndex = null,Object? sharedEventList = null,Object? userModel = freezed,Object? childModel = freezed,Object? deleteRoutineApiResultStatus = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,tabIndex: null == tabIndex ? _self.tabIndex : tabIndex // ignore: cast_nullable_to_non_nullable
as int,sharedEventList: null == sharedEventList ? _self.sharedEventList : sharedEventList // ignore: cast_nullable_to_non_nullable
as List<SharedEventModel>,userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,childModel: freezed == childModel ? _self.childModel : childModel // ignore: cast_nullable_to_non_nullable
as ChildModel?,deleteRoutineApiResultStatus: null == deleteRoutineApiResultStatus ? _self.deleteRoutineApiResultStatus : deleteRoutineApiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,
  ));
}
/// Create a copy of ScheduleState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get deleteRoutineApiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.deleteRoutineApiResultStatus, (value) {
    return _then(_self.copyWith(deleteRoutineApiResultStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [ScheduleState].
extension ScheduleStatePatterns on ScheduleState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleState value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleState value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String message,  int tabIndex,  List<SharedEventModel> sharedEventList,  UserModel? userModel,  ChildModel? childModel,  ApiResultStatus deleteRoutineApiResultStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleState() when $default != null:
return $default(_that.message,_that.tabIndex,_that.sharedEventList,_that.userModel,_that.childModel,_that.deleteRoutineApiResultStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String message,  int tabIndex,  List<SharedEventModel> sharedEventList,  UserModel? userModel,  ChildModel? childModel,  ApiResultStatus deleteRoutineApiResultStatus)  $default,) {final _that = this;
switch (_that) {
case _ScheduleState():
return $default(_that.message,_that.tabIndex,_that.sharedEventList,_that.userModel,_that.childModel,_that.deleteRoutineApiResultStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String message,  int tabIndex,  List<SharedEventModel> sharedEventList,  UserModel? userModel,  ChildModel? childModel,  ApiResultStatus deleteRoutineApiResultStatus)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleState() when $default != null:
return $default(_that.message,_that.tabIndex,_that.sharedEventList,_that.userModel,_that.childModel,_that.deleteRoutineApiResultStatus);case _:
  return null;

}
}

}

/// @nodoc


class _ScheduleState implements ScheduleState {
  const _ScheduleState({this.message = "", this.tabIndex = 0, final  List<SharedEventModel> sharedEventList = const [], this.userModel, this.childModel, this.deleteRoutineApiResultStatus = const ApiResultStatus.initial()}): _sharedEventList = sharedEventList;
  

@override@JsonKey() final  String message;
@override@JsonKey() final  int tabIndex;
 final  List<SharedEventModel> _sharedEventList;
@override@JsonKey() List<SharedEventModel> get sharedEventList {
  if (_sharedEventList is EqualUnmodifiableListView) return _sharedEventList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sharedEventList);
}

@override final  UserModel? userModel;
@override final  ChildModel? childModel;
@override@JsonKey() final  ApiResultStatus deleteRoutineApiResultStatus;

/// Create a copy of ScheduleState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleStateCopyWith<_ScheduleState> get copyWith => __$ScheduleStateCopyWithImpl<_ScheduleState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleState&&(identical(other.message, message) || other.message == message)&&(identical(other.tabIndex, tabIndex) || other.tabIndex == tabIndex)&&const DeepCollectionEquality().equals(other._sharedEventList, _sharedEventList)&&(identical(other.userModel, userModel) || other.userModel == userModel)&&(identical(other.childModel, childModel) || other.childModel == childModel)&&(identical(other.deleteRoutineApiResultStatus, deleteRoutineApiResultStatus) || other.deleteRoutineApiResultStatus == deleteRoutineApiResultStatus));
}


@override
int get hashCode => Object.hash(runtimeType,message,tabIndex,const DeepCollectionEquality().hash(_sharedEventList),userModel,childModel,deleteRoutineApiResultStatus);

@override
String toString() {
  return 'ScheduleState(message: $message, tabIndex: $tabIndex, sharedEventList: $sharedEventList, userModel: $userModel, childModel: $childModel, deleteRoutineApiResultStatus: $deleteRoutineApiResultStatus)';
}


}

/// @nodoc
abstract mixin class _$ScheduleStateCopyWith<$Res> implements $ScheduleStateCopyWith<$Res> {
  factory _$ScheduleStateCopyWith(_ScheduleState value, $Res Function(_ScheduleState) _then) = __$ScheduleStateCopyWithImpl;
@override @useResult
$Res call({
 String message, int tabIndex, List<SharedEventModel> sharedEventList, UserModel? userModel, ChildModel? childModel, ApiResultStatus deleteRoutineApiResultStatus
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get deleteRoutineApiResultStatus;

}
/// @nodoc
class __$ScheduleStateCopyWithImpl<$Res>
    implements _$ScheduleStateCopyWith<$Res> {
  __$ScheduleStateCopyWithImpl(this._self, this._then);

  final _ScheduleState _self;
  final $Res Function(_ScheduleState) _then;

/// Create a copy of ScheduleState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? tabIndex = null,Object? sharedEventList = null,Object? userModel = freezed,Object? childModel = freezed,Object? deleteRoutineApiResultStatus = null,}) {
  return _then(_ScheduleState(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,tabIndex: null == tabIndex ? _self.tabIndex : tabIndex // ignore: cast_nullable_to_non_nullable
as int,sharedEventList: null == sharedEventList ? _self._sharedEventList : sharedEventList // ignore: cast_nullable_to_non_nullable
as List<SharedEventModel>,userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,childModel: freezed == childModel ? _self.childModel : childModel // ignore: cast_nullable_to_non_nullable
as ChildModel?,deleteRoutineApiResultStatus: null == deleteRoutineApiResultStatus ? _self.deleteRoutineApiResultStatus : deleteRoutineApiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,
  ));
}

/// Create a copy of ScheduleState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get deleteRoutineApiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.deleteRoutineApiResultStatus, (value) {
    return _then(_self.copyWith(deleteRoutineApiResultStatus: value));
  });
}
}

// dart format on
