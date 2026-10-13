// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_session_plan_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PostSessionPlanState {

 bool get isLoading; PostSessionPlanModel? get plan; ApiResultStatus<dynamic> get fetchStatus;
/// Create a copy of PostSessionPlanState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostSessionPlanStateCopyWith<PostSessionPlanState> get copyWith => _$PostSessionPlanStateCopyWithImpl<PostSessionPlanState>(this as PostSessionPlanState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PostSessionPlanState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostSessionPlanState&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.plan, _this.plan) || other.plan == _this.plan)&&(identical(other.fetchStatus, _this.fetchStatus) || other.fetchStatus == _this.fetchStatus));
}


@override
int get hashCode {
  final _this = this as PostSessionPlanState;
  return Object.hash(runtimeType,_this.isLoading,_this.plan,_this.fetchStatus);
}

@override
String toString() {
  final _this = this as PostSessionPlanState;
  return 'PostSessionPlanState(isLoading: ${_this.isLoading}, plan: ${_this.plan}, fetchStatus: ${_this.fetchStatus})';
}


}

/// @nodoc
abstract mixin class $PostSessionPlanStateCopyWith<$Res>  {
  factory $PostSessionPlanStateCopyWith(PostSessionPlanState value, $Res Function(PostSessionPlanState) _then) = _$PostSessionPlanStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, PostSessionPlanModel? plan, ApiResultStatus<dynamic> fetchStatus
});


$ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus;

}
/// @nodoc
class _$PostSessionPlanStateCopyWithImpl<$Res>
    implements $PostSessionPlanStateCopyWith<$Res> {
  _$PostSessionPlanStateCopyWithImpl(this._self, this._then);

  final PostSessionPlanState _self;
  final $Res Function(PostSessionPlanState) _then;

/// Create a copy of PostSessionPlanState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? plan = freezed,Object? fetchStatus = null,}) {
  return _then(PostSessionPlanState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,plan: freezed == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as PostSessionPlanModel?,fetchStatus: null == fetchStatus ? _self.fetchStatus : fetchStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}
/// Create a copy of PostSessionPlanState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.fetchStatus, (value) {
    return _then(_self.copyWith(fetchStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [PostSessionPlanState].
extension PostSessionPlanStatePatterns on PostSessionPlanState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostSessionPlanState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostSessionPlanState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostSessionPlanState value)  $default,){
final _that = this;
switch (_that) {
case _PostSessionPlanState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostSessionPlanState value)?  $default,){
final _that = this;
switch (_that) {
case _PostSessionPlanState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  PostSessionPlanModel? plan,  ApiResultStatus<dynamic> fetchStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostSessionPlanState() when $default != null:
return $default(_that.isLoading,_that.plan,_that.fetchStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  PostSessionPlanModel? plan,  ApiResultStatus<dynamic> fetchStatus)  $default,) {final _that = this;
switch (_that) {
case _PostSessionPlanState():
return $default(_that.isLoading,_that.plan,_that.fetchStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  PostSessionPlanModel? plan,  ApiResultStatus<dynamic> fetchStatus)?  $default,) {final _that = this;
switch (_that) {
case _PostSessionPlanState() when $default != null:
return $default(_that.isLoading,_that.plan,_that.fetchStatus);case _:
  return null;

}
}

}

/// @nodoc


class _PostSessionPlanState implements PostSessionPlanState {
  const _PostSessionPlanState({this.isLoading = false, this.plan, this.fetchStatus = const ApiResultStatus.initial()});
  

@override@JsonKey() final  bool isLoading;
@override final  PostSessionPlanModel? plan;
@override@JsonKey() final  ApiResultStatus<dynamic> fetchStatus;

/// Create a copy of PostSessionPlanState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostSessionPlanStateCopyWith<_PostSessionPlanState> get copyWith => __$PostSessionPlanStateCopyWithImpl<_PostSessionPlanState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostSessionPlanState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.plan, plan) || other.plan == plan)&&(identical(other.fetchStatus, fetchStatus) || other.fetchStatus == fetchStatus));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isLoading,plan,fetchStatus);
}

@override
String toString() {
    return 'PostSessionPlanState(isLoading: $isLoading, plan: $plan, fetchStatus: $fetchStatus)';
}


}

/// @nodoc
abstract mixin class _$PostSessionPlanStateCopyWith<$Res> implements $PostSessionPlanStateCopyWith<$Res> {
  factory _$PostSessionPlanStateCopyWith(_PostSessionPlanState value, $Res Function(_PostSessionPlanState) _then) = __$PostSessionPlanStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, PostSessionPlanModel? plan, ApiResultStatus<dynamic> fetchStatus
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus;

}
/// @nodoc
class __$PostSessionPlanStateCopyWithImpl<$Res>
    implements _$PostSessionPlanStateCopyWith<$Res> {
  __$PostSessionPlanStateCopyWithImpl(this._self, this._then);

  final _PostSessionPlanState _self;
  final $Res Function(_PostSessionPlanState) _then;

/// Create a copy of PostSessionPlanState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? plan = freezed,Object? fetchStatus = null,}) {
  return _then(_PostSessionPlanState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,plan: freezed == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as PostSessionPlanModel?,fetchStatus: null == fetchStatus ? _self.fetchStatus : fetchStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}

/// Create a copy of PostSessionPlanState
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
