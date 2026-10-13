// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'harder_week_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HarderWeekState {

 ChildModel? get child; WeeklyInsightsResult? get insights; ApiResultStatus<dynamic> get fetchStatus;
/// Create a copy of HarderWeekState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HarderWeekStateCopyWith<HarderWeekState> get copyWith => _$HarderWeekStateCopyWithImpl<HarderWeekState>(this as HarderWeekState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as HarderWeekState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HarderWeekState&&(identical(other.child, _this.child) || other.child == _this.child)&&(identical(other.insights, _this.insights) || other.insights == _this.insights)&&(identical(other.fetchStatus, _this.fetchStatus) || other.fetchStatus == _this.fetchStatus));
}


@override
int get hashCode {
  final _this = this as HarderWeekState;
  return Object.hash(runtimeType,_this.child,_this.insights,_this.fetchStatus);
}

@override
String toString() {
  final _this = this as HarderWeekState;
  return 'HarderWeekState(child: ${_this.child}, insights: ${_this.insights}, fetchStatus: ${_this.fetchStatus})';
}


}

/// @nodoc
abstract mixin class $HarderWeekStateCopyWith<$Res>  {
  factory $HarderWeekStateCopyWith(HarderWeekState value, $Res Function(HarderWeekState) _then) = _$HarderWeekStateCopyWithImpl;
@useResult
$Res call({
 ChildModel? child, WeeklyInsightsResult? insights, ApiResultStatus<dynamic> fetchStatus
});


$ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus;

}
/// @nodoc
class _$HarderWeekStateCopyWithImpl<$Res>
    implements $HarderWeekStateCopyWith<$Res> {
  _$HarderWeekStateCopyWithImpl(this._self, this._then);

  final HarderWeekState _self;
  final $Res Function(HarderWeekState) _then;

/// Create a copy of HarderWeekState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? child = freezed,Object? insights = freezed,Object? fetchStatus = null,}) {
  return _then(HarderWeekState(
child: freezed == child ? _self.child : child // ignore: cast_nullable_to_non_nullable
as ChildModel?,insights: freezed == insights ? _self.insights : insights // ignore: cast_nullable_to_non_nullable
as WeeklyInsightsResult?,fetchStatus: null == fetchStatus ? _self.fetchStatus : fetchStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}
/// Create a copy of HarderWeekState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.fetchStatus, (value) {
    return _then(_self.copyWith(fetchStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [HarderWeekState].
extension HarderWeekStatePatterns on HarderWeekState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HarderWeekState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HarderWeekState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HarderWeekState value)  $default,){
final _that = this;
switch (_that) {
case _HarderWeekState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HarderWeekState value)?  $default,){
final _that = this;
switch (_that) {
case _HarderWeekState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ChildModel? child,  WeeklyInsightsResult? insights,  ApiResultStatus<dynamic> fetchStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HarderWeekState() when $default != null:
return $default(_that.child,_that.insights,_that.fetchStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ChildModel? child,  WeeklyInsightsResult? insights,  ApiResultStatus<dynamic> fetchStatus)  $default,) {final _that = this;
switch (_that) {
case _HarderWeekState():
return $default(_that.child,_that.insights,_that.fetchStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ChildModel? child,  WeeklyInsightsResult? insights,  ApiResultStatus<dynamic> fetchStatus)?  $default,) {final _that = this;
switch (_that) {
case _HarderWeekState() when $default != null:
return $default(_that.child,_that.insights,_that.fetchStatus);case _:
  return null;

}
}

}

/// @nodoc


class _HarderWeekState implements HarderWeekState {
  const _HarderWeekState({this.child, this.insights, this.fetchStatus = const ApiResultStatus.initial()});
  

@override final  ChildModel? child;
@override final  WeeklyInsightsResult? insights;
@override@JsonKey() final  ApiResultStatus<dynamic> fetchStatus;

/// Create a copy of HarderWeekState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HarderWeekStateCopyWith<_HarderWeekState> get copyWith => __$HarderWeekStateCopyWithImpl<_HarderWeekState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HarderWeekState&&(identical(other.child, child) || other.child == child)&&(identical(other.insights, insights) || other.insights == insights)&&(identical(other.fetchStatus, fetchStatus) || other.fetchStatus == fetchStatus));
}


@override
int get hashCode {
    return Object.hash(runtimeType,child,insights,fetchStatus);
}

@override
String toString() {
    return 'HarderWeekState(child: $child, insights: $insights, fetchStatus: $fetchStatus)';
}


}

/// @nodoc
abstract mixin class _$HarderWeekStateCopyWith<$Res> implements $HarderWeekStateCopyWith<$Res> {
  factory _$HarderWeekStateCopyWith(_HarderWeekState value, $Res Function(_HarderWeekState) _then) = __$HarderWeekStateCopyWithImpl;
@override @useResult
$Res call({
 ChildModel? child, WeeklyInsightsResult? insights, ApiResultStatus<dynamic> fetchStatus
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus;

}
/// @nodoc
class __$HarderWeekStateCopyWithImpl<$Res>
    implements _$HarderWeekStateCopyWith<$Res> {
  __$HarderWeekStateCopyWithImpl(this._self, this._then);

  final _HarderWeekState _self;
  final $Res Function(_HarderWeekState) _then;

/// Create a copy of HarderWeekState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? child = freezed,Object? insights = freezed,Object? fetchStatus = null,}) {
  return _then(_HarderWeekState(
child: freezed == child ? _self.child : child // ignore: cast_nullable_to_non_nullable
as ChildModel?,insights: freezed == insights ? _self.insights : insights // ignore: cast_nullable_to_non_nullable
as WeeklyInsightsResult?,fetchStatus: null == fetchStatus ? _self.fetchStatus : fetchStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}

/// Create a copy of HarderWeekState
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
