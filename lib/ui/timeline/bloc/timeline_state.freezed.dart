// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timeline_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TimelineState {

 UserModel? get userModel; ChildModel? get childModel; List<TimelineEventModel> get events; ApiResultStatus get loadStatus;
/// Create a copy of TimelineState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimelineStateCopyWith<TimelineState> get copyWith => _$TimelineStateCopyWithImpl<TimelineState>(this as TimelineState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimelineState&&(identical(other.userModel, userModel) || other.userModel == userModel)&&(identical(other.childModel, childModel) || other.childModel == childModel)&&const DeepCollectionEquality().equals(other.events, events)&&(identical(other.loadStatus, loadStatus) || other.loadStatus == loadStatus));
}


@override
int get hashCode => Object.hash(runtimeType,userModel,childModel,const DeepCollectionEquality().hash(events),loadStatus);

@override
String toString() {
  return 'TimelineState(userModel: $userModel, childModel: $childModel, events: $events, loadStatus: $loadStatus)';
}


}

/// @nodoc
abstract mixin class $TimelineStateCopyWith<$Res>  {
  factory $TimelineStateCopyWith(TimelineState value, $Res Function(TimelineState) _then) = _$TimelineStateCopyWithImpl;
@useResult
$Res call({
 UserModel? userModel, ChildModel? childModel, List<TimelineEventModel> events, ApiResultStatus loadStatus
});


$ApiResultStatusCopyWith<dynamic, $Res> get loadStatus;

}
/// @nodoc
class _$TimelineStateCopyWithImpl<$Res>
    implements $TimelineStateCopyWith<$Res> {
  _$TimelineStateCopyWithImpl(this._self, this._then);

  final TimelineState _self;
  final $Res Function(TimelineState) _then;

/// Create a copy of TimelineState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userModel = freezed,Object? childModel = freezed,Object? events = null,Object? loadStatus = null,}) {
  return _then(_self.copyWith(
userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,childModel: freezed == childModel ? _self.childModel : childModel // ignore: cast_nullable_to_non_nullable
as ChildModel?,events: null == events ? _self.events : events // ignore: cast_nullable_to_non_nullable
as List<TimelineEventModel>,loadStatus: null == loadStatus ? _self.loadStatus : loadStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,
  ));
}
/// Create a copy of TimelineState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get loadStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.loadStatus, (value) {
    return _then(_self.copyWith(loadStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [TimelineState].
extension TimelineStatePatterns on TimelineState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimelineState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimelineState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimelineState value)  $default,){
final _that = this;
switch (_that) {
case _TimelineState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimelineState value)?  $default,){
final _that = this;
switch (_that) {
case _TimelineState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UserModel? userModel,  ChildModel? childModel,  List<TimelineEventModel> events,  ApiResultStatus loadStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimelineState() when $default != null:
return $default(_that.userModel,_that.childModel,_that.events,_that.loadStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UserModel? userModel,  ChildModel? childModel,  List<TimelineEventModel> events,  ApiResultStatus loadStatus)  $default,) {final _that = this;
switch (_that) {
case _TimelineState():
return $default(_that.userModel,_that.childModel,_that.events,_that.loadStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UserModel? userModel,  ChildModel? childModel,  List<TimelineEventModel> events,  ApiResultStatus loadStatus)?  $default,) {final _that = this;
switch (_that) {
case _TimelineState() when $default != null:
return $default(_that.userModel,_that.childModel,_that.events,_that.loadStatus);case _:
  return null;

}
}

}

/// @nodoc


class _TimelineState implements TimelineState {
  const _TimelineState({this.userModel, this.childModel, final  List<TimelineEventModel> events = const <TimelineEventModel>[], this.loadStatus = const ApiResultStatus.initial()}): _events = events;
  

@override final  UserModel? userModel;
@override final  ChildModel? childModel;
 final  List<TimelineEventModel> _events;
@override@JsonKey() List<TimelineEventModel> get events {
  if (_events is EqualUnmodifiableListView) return _events;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_events);
}

@override@JsonKey() final  ApiResultStatus loadStatus;

/// Create a copy of TimelineState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimelineStateCopyWith<_TimelineState> get copyWith => __$TimelineStateCopyWithImpl<_TimelineState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimelineState&&(identical(other.userModel, userModel) || other.userModel == userModel)&&(identical(other.childModel, childModel) || other.childModel == childModel)&&const DeepCollectionEquality().equals(other._events, _events)&&(identical(other.loadStatus, loadStatus) || other.loadStatus == loadStatus));
}


@override
int get hashCode => Object.hash(runtimeType,userModel,childModel,const DeepCollectionEquality().hash(_events),loadStatus);

@override
String toString() {
  return 'TimelineState(userModel: $userModel, childModel: $childModel, events: $events, loadStatus: $loadStatus)';
}


}

/// @nodoc
abstract mixin class _$TimelineStateCopyWith<$Res> implements $TimelineStateCopyWith<$Res> {
  factory _$TimelineStateCopyWith(_TimelineState value, $Res Function(_TimelineState) _then) = __$TimelineStateCopyWithImpl;
@override @useResult
$Res call({
 UserModel? userModel, ChildModel? childModel, List<TimelineEventModel> events, ApiResultStatus loadStatus
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get loadStatus;

}
/// @nodoc
class __$TimelineStateCopyWithImpl<$Res>
    implements _$TimelineStateCopyWith<$Res> {
  __$TimelineStateCopyWithImpl(this._self, this._then);

  final _TimelineState _self;
  final $Res Function(_TimelineState) _then;

/// Create a copy of TimelineState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userModel = freezed,Object? childModel = freezed,Object? events = null,Object? loadStatus = null,}) {
  return _then(_TimelineState(
userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,childModel: freezed == childModel ? _self.childModel : childModel // ignore: cast_nullable_to_non_nullable
as ChildModel?,events: null == events ? _self._events : events // ignore: cast_nullable_to_non_nullable
as List<TimelineEventModel>,loadStatus: null == loadStatus ? _self.loadStatus : loadStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,
  ));
}

/// Create a copy of TimelineState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get loadStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.loadStatus, (value) {
    return _then(_self.copyWith(loadStatus: value));
  });
}
}

// dart format on
