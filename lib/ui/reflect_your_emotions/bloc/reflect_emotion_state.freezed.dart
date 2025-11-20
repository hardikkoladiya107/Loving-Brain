// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reflect_emotion_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReflectEmotionState {

 UserModel? get userModel; ChildModel? get childModel; List<ChildModel>? get children; WeekRange? get selectedWeek; List<MoodLogModel> get logs; ApiResultStatus get emotionsLogApiResult; ApiResultStatus get apiResultStatus; ApiResultStatus get childrenListApiResult;
/// Create a copy of ReflectEmotionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReflectEmotionStateCopyWith<ReflectEmotionState> get copyWith => _$ReflectEmotionStateCopyWithImpl<ReflectEmotionState>(this as ReflectEmotionState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReflectEmotionState&&(identical(other.userModel, userModel) || other.userModel == userModel)&&(identical(other.childModel, childModel) || other.childModel == childModel)&&const DeepCollectionEquality().equals(other.children, children)&&(identical(other.selectedWeek, selectedWeek) || other.selectedWeek == selectedWeek)&&const DeepCollectionEquality().equals(other.logs, logs)&&(identical(other.emotionsLogApiResult, emotionsLogApiResult) || other.emotionsLogApiResult == emotionsLogApiResult)&&(identical(other.apiResultStatus, apiResultStatus) || other.apiResultStatus == apiResultStatus)&&(identical(other.childrenListApiResult, childrenListApiResult) || other.childrenListApiResult == childrenListApiResult));
}


@override
int get hashCode => Object.hash(runtimeType,userModel,childModel,const DeepCollectionEquality().hash(children),selectedWeek,const DeepCollectionEquality().hash(logs),emotionsLogApiResult,apiResultStatus,childrenListApiResult);

@override
String toString() {
  return 'ReflectEmotionState(userModel: $userModel, childModel: $childModel, children: $children, selectedWeek: $selectedWeek, logs: $logs, emotionsLogApiResult: $emotionsLogApiResult, apiResultStatus: $apiResultStatus, childrenListApiResult: $childrenListApiResult)';
}


}

/// @nodoc
abstract mixin class $ReflectEmotionStateCopyWith<$Res>  {
  factory $ReflectEmotionStateCopyWith(ReflectEmotionState value, $Res Function(ReflectEmotionState) _then) = _$ReflectEmotionStateCopyWithImpl;
@useResult
$Res call({
 UserModel? userModel, ChildModel? childModel, List<ChildModel>? children, WeekRange? selectedWeek, List<MoodLogModel> logs, ApiResultStatus emotionsLogApiResult, ApiResultStatus apiResultStatus, ApiResultStatus childrenListApiResult
});


$ApiResultStatusCopyWith<dynamic, $Res> get emotionsLogApiResult;$ApiResultStatusCopyWith<dynamic, $Res> get apiResultStatus;$ApiResultStatusCopyWith<dynamic, $Res> get childrenListApiResult;

}
/// @nodoc
class _$ReflectEmotionStateCopyWithImpl<$Res>
    implements $ReflectEmotionStateCopyWith<$Res> {
  _$ReflectEmotionStateCopyWithImpl(this._self, this._then);

  final ReflectEmotionState _self;
  final $Res Function(ReflectEmotionState) _then;

/// Create a copy of ReflectEmotionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userModel = freezed,Object? childModel = freezed,Object? children = freezed,Object? selectedWeek = freezed,Object? logs = null,Object? emotionsLogApiResult = null,Object? apiResultStatus = null,Object? childrenListApiResult = null,}) {
  return _then(_self.copyWith(
userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,childModel: freezed == childModel ? _self.childModel : childModel // ignore: cast_nullable_to_non_nullable
as ChildModel?,children: freezed == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as List<ChildModel>?,selectedWeek: freezed == selectedWeek ? _self.selectedWeek : selectedWeek // ignore: cast_nullable_to_non_nullable
as WeekRange?,logs: null == logs ? _self.logs : logs // ignore: cast_nullable_to_non_nullable
as List<MoodLogModel>,emotionsLogApiResult: null == emotionsLogApiResult ? _self.emotionsLogApiResult : emotionsLogApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,apiResultStatus: null == apiResultStatus ? _self.apiResultStatus : apiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,childrenListApiResult: null == childrenListApiResult ? _self.childrenListApiResult : childrenListApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,
  ));
}
/// Create a copy of ReflectEmotionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get emotionsLogApiResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.emotionsLogApiResult, (value) {
    return _then(_self.copyWith(emotionsLogApiResult: value));
  });
}/// Create a copy of ReflectEmotionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get apiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.apiResultStatus, (value) {
    return _then(_self.copyWith(apiResultStatus: value));
  });
}/// Create a copy of ReflectEmotionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get childrenListApiResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.childrenListApiResult, (value) {
    return _then(_self.copyWith(childrenListApiResult: value));
  });
}
}


/// Adds pattern-matching-related methods to [ReflectEmotionState].
extension ReflectEmotionStatePatterns on ReflectEmotionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReflectEmotionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReflectEmotionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReflectEmotionState value)  $default,){
final _that = this;
switch (_that) {
case _ReflectEmotionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReflectEmotionState value)?  $default,){
final _that = this;
switch (_that) {
case _ReflectEmotionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UserModel? userModel,  ChildModel? childModel,  List<ChildModel>? children,  WeekRange? selectedWeek,  List<MoodLogModel> logs,  ApiResultStatus emotionsLogApiResult,  ApiResultStatus apiResultStatus,  ApiResultStatus childrenListApiResult)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReflectEmotionState() when $default != null:
return $default(_that.userModel,_that.childModel,_that.children,_that.selectedWeek,_that.logs,_that.emotionsLogApiResult,_that.apiResultStatus,_that.childrenListApiResult);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UserModel? userModel,  ChildModel? childModel,  List<ChildModel>? children,  WeekRange? selectedWeek,  List<MoodLogModel> logs,  ApiResultStatus emotionsLogApiResult,  ApiResultStatus apiResultStatus,  ApiResultStatus childrenListApiResult)  $default,) {final _that = this;
switch (_that) {
case _ReflectEmotionState():
return $default(_that.userModel,_that.childModel,_that.children,_that.selectedWeek,_that.logs,_that.emotionsLogApiResult,_that.apiResultStatus,_that.childrenListApiResult);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UserModel? userModel,  ChildModel? childModel,  List<ChildModel>? children,  WeekRange? selectedWeek,  List<MoodLogModel> logs,  ApiResultStatus emotionsLogApiResult,  ApiResultStatus apiResultStatus,  ApiResultStatus childrenListApiResult)?  $default,) {final _that = this;
switch (_that) {
case _ReflectEmotionState() when $default != null:
return $default(_that.userModel,_that.childModel,_that.children,_that.selectedWeek,_that.logs,_that.emotionsLogApiResult,_that.apiResultStatus,_that.childrenListApiResult);case _:
  return null;

}
}

}

/// @nodoc


class _ReflectEmotionState implements ReflectEmotionState {
  const _ReflectEmotionState({this.userModel, this.childModel, final  List<ChildModel>? children, this.selectedWeek, final  List<MoodLogModel> logs = const [], this.emotionsLogApiResult = const ApiResultStatus.initial(), this.apiResultStatus = const ApiResultStatus.initial(), this.childrenListApiResult = const ApiResultStatus.initial()}): _children = children,_logs = logs;
  

@override final  UserModel? userModel;
@override final  ChildModel? childModel;
 final  List<ChildModel>? _children;
@override List<ChildModel>? get children {
  final value = _children;
  if (value == null) return null;
  if (_children is EqualUnmodifiableListView) return _children;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  WeekRange? selectedWeek;
 final  List<MoodLogModel> _logs;
@override@JsonKey() List<MoodLogModel> get logs {
  if (_logs is EqualUnmodifiableListView) return _logs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_logs);
}

@override@JsonKey() final  ApiResultStatus emotionsLogApiResult;
@override@JsonKey() final  ApiResultStatus apiResultStatus;
@override@JsonKey() final  ApiResultStatus childrenListApiResult;

/// Create a copy of ReflectEmotionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReflectEmotionStateCopyWith<_ReflectEmotionState> get copyWith => __$ReflectEmotionStateCopyWithImpl<_ReflectEmotionState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReflectEmotionState&&(identical(other.userModel, userModel) || other.userModel == userModel)&&(identical(other.childModel, childModel) || other.childModel == childModel)&&const DeepCollectionEquality().equals(other._children, _children)&&(identical(other.selectedWeek, selectedWeek) || other.selectedWeek == selectedWeek)&&const DeepCollectionEquality().equals(other._logs, _logs)&&(identical(other.emotionsLogApiResult, emotionsLogApiResult) || other.emotionsLogApiResult == emotionsLogApiResult)&&(identical(other.apiResultStatus, apiResultStatus) || other.apiResultStatus == apiResultStatus)&&(identical(other.childrenListApiResult, childrenListApiResult) || other.childrenListApiResult == childrenListApiResult));
}


@override
int get hashCode => Object.hash(runtimeType,userModel,childModel,const DeepCollectionEquality().hash(_children),selectedWeek,const DeepCollectionEquality().hash(_logs),emotionsLogApiResult,apiResultStatus,childrenListApiResult);

@override
String toString() {
  return 'ReflectEmotionState(userModel: $userModel, childModel: $childModel, children: $children, selectedWeek: $selectedWeek, logs: $logs, emotionsLogApiResult: $emotionsLogApiResult, apiResultStatus: $apiResultStatus, childrenListApiResult: $childrenListApiResult)';
}


}

/// @nodoc
abstract mixin class _$ReflectEmotionStateCopyWith<$Res> implements $ReflectEmotionStateCopyWith<$Res> {
  factory _$ReflectEmotionStateCopyWith(_ReflectEmotionState value, $Res Function(_ReflectEmotionState) _then) = __$ReflectEmotionStateCopyWithImpl;
@override @useResult
$Res call({
 UserModel? userModel, ChildModel? childModel, List<ChildModel>? children, WeekRange? selectedWeek, List<MoodLogModel> logs, ApiResultStatus emotionsLogApiResult, ApiResultStatus apiResultStatus, ApiResultStatus childrenListApiResult
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get emotionsLogApiResult;@override $ApiResultStatusCopyWith<dynamic, $Res> get apiResultStatus;@override $ApiResultStatusCopyWith<dynamic, $Res> get childrenListApiResult;

}
/// @nodoc
class __$ReflectEmotionStateCopyWithImpl<$Res>
    implements _$ReflectEmotionStateCopyWith<$Res> {
  __$ReflectEmotionStateCopyWithImpl(this._self, this._then);

  final _ReflectEmotionState _self;
  final $Res Function(_ReflectEmotionState) _then;

/// Create a copy of ReflectEmotionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userModel = freezed,Object? childModel = freezed,Object? children = freezed,Object? selectedWeek = freezed,Object? logs = null,Object? emotionsLogApiResult = null,Object? apiResultStatus = null,Object? childrenListApiResult = null,}) {
  return _then(_ReflectEmotionState(
userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,childModel: freezed == childModel ? _self.childModel : childModel // ignore: cast_nullable_to_non_nullable
as ChildModel?,children: freezed == children ? _self._children : children // ignore: cast_nullable_to_non_nullable
as List<ChildModel>?,selectedWeek: freezed == selectedWeek ? _self.selectedWeek : selectedWeek // ignore: cast_nullable_to_non_nullable
as WeekRange?,logs: null == logs ? _self._logs : logs // ignore: cast_nullable_to_non_nullable
as List<MoodLogModel>,emotionsLogApiResult: null == emotionsLogApiResult ? _self.emotionsLogApiResult : emotionsLogApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,apiResultStatus: null == apiResultStatus ? _self.apiResultStatus : apiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,childrenListApiResult: null == childrenListApiResult ? _self.childrenListApiResult : childrenListApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,
  ));
}

/// Create a copy of ReflectEmotionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get emotionsLogApiResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.emotionsLogApiResult, (value) {
    return _then(_self.copyWith(emotionsLogApiResult: value));
  });
}/// Create a copy of ReflectEmotionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get apiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.apiResultStatus, (value) {
    return _then(_self.copyWith(apiResultStatus: value));
  });
}/// Create a copy of ReflectEmotionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get childrenListApiResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.childrenListApiResult, (value) {
    return _then(_self.copyWith(childrenListApiResult: value));
  });
}
}

// dart format on
