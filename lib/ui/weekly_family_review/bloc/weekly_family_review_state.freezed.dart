// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weekly_family_review_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WeeklyFamilyReviewState {

 ChildModel? get child; WeeklyInsightsResult? get insights; ActiveExperimentModel? get activeExperiment; ApiResultStatus<dynamic> get fetchStatus; ApiResultStatus<dynamic> get saveStatus;
/// Create a copy of WeeklyFamilyReviewState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeeklyFamilyReviewStateCopyWith<WeeklyFamilyReviewState> get copyWith => _$WeeklyFamilyReviewStateCopyWithImpl<WeeklyFamilyReviewState>(this as WeeklyFamilyReviewState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as WeeklyFamilyReviewState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeeklyFamilyReviewState&&(identical(other.child, _this.child) || other.child == _this.child)&&(identical(other.insights, _this.insights) || other.insights == _this.insights)&&(identical(other.activeExperiment, _this.activeExperiment) || other.activeExperiment == _this.activeExperiment)&&(identical(other.fetchStatus, _this.fetchStatus) || other.fetchStatus == _this.fetchStatus)&&(identical(other.saveStatus, _this.saveStatus) || other.saveStatus == _this.saveStatus));
}


@override
int get hashCode {
  final _this = this as WeeklyFamilyReviewState;
  return Object.hash(runtimeType,_this.child,_this.insights,_this.activeExperiment,_this.fetchStatus,_this.saveStatus);
}

@override
String toString() {
  final _this = this as WeeklyFamilyReviewState;
  return 'WeeklyFamilyReviewState(child: ${_this.child}, insights: ${_this.insights}, activeExperiment: ${_this.activeExperiment}, fetchStatus: ${_this.fetchStatus}, saveStatus: ${_this.saveStatus})';
}


}

/// @nodoc
abstract mixin class $WeeklyFamilyReviewStateCopyWith<$Res>  {
  factory $WeeklyFamilyReviewStateCopyWith(WeeklyFamilyReviewState value, $Res Function(WeeklyFamilyReviewState) _then) = _$WeeklyFamilyReviewStateCopyWithImpl;
@useResult
$Res call({
 ChildModel? child, WeeklyInsightsResult? insights, ActiveExperimentModel? activeExperiment, ApiResultStatus<dynamic> fetchStatus, ApiResultStatus<dynamic> saveStatus
});


$ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus;$ApiResultStatusCopyWith<dynamic, $Res> get saveStatus;

}
/// @nodoc
class _$WeeklyFamilyReviewStateCopyWithImpl<$Res>
    implements $WeeklyFamilyReviewStateCopyWith<$Res> {
  _$WeeklyFamilyReviewStateCopyWithImpl(this._self, this._then);

  final WeeklyFamilyReviewState _self;
  final $Res Function(WeeklyFamilyReviewState) _then;

/// Create a copy of WeeklyFamilyReviewState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? child = freezed,Object? insights = freezed,Object? activeExperiment = freezed,Object? fetchStatus = null,Object? saveStatus = null,}) {
  return _then(WeeklyFamilyReviewState(
child: freezed == child ? _self.child : child // ignore: cast_nullable_to_non_nullable
as ChildModel?,insights: freezed == insights ? _self.insights : insights // ignore: cast_nullable_to_non_nullable
as WeeklyInsightsResult?,activeExperiment: freezed == activeExperiment ? _self.activeExperiment : activeExperiment // ignore: cast_nullable_to_non_nullable
as ActiveExperimentModel?,fetchStatus: null == fetchStatus ? _self.fetchStatus : fetchStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,saveStatus: null == saveStatus ? _self.saveStatus : saveStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}
/// Create a copy of WeeklyFamilyReviewState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.fetchStatus, (value) {
    return _then(_self.copyWith(fetchStatus: value));
  });
}/// Create a copy of WeeklyFamilyReviewState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get saveStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.saveStatus, (value) {
    return _then(_self.copyWith(saveStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [WeeklyFamilyReviewState].
extension WeeklyFamilyReviewStatePatterns on WeeklyFamilyReviewState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeeklyFamilyReviewState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeeklyFamilyReviewState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeeklyFamilyReviewState value)  $default,){
final _that = this;
switch (_that) {
case _WeeklyFamilyReviewState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeeklyFamilyReviewState value)?  $default,){
final _that = this;
switch (_that) {
case _WeeklyFamilyReviewState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ChildModel? child,  WeeklyInsightsResult? insights,  ActiveExperimentModel? activeExperiment,  ApiResultStatus<dynamic> fetchStatus,  ApiResultStatus<dynamic> saveStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeeklyFamilyReviewState() when $default != null:
return $default(_that.child,_that.insights,_that.activeExperiment,_that.fetchStatus,_that.saveStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ChildModel? child,  WeeklyInsightsResult? insights,  ActiveExperimentModel? activeExperiment,  ApiResultStatus<dynamic> fetchStatus,  ApiResultStatus<dynamic> saveStatus)  $default,) {final _that = this;
switch (_that) {
case _WeeklyFamilyReviewState():
return $default(_that.child,_that.insights,_that.activeExperiment,_that.fetchStatus,_that.saveStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ChildModel? child,  WeeklyInsightsResult? insights,  ActiveExperimentModel? activeExperiment,  ApiResultStatus<dynamic> fetchStatus,  ApiResultStatus<dynamic> saveStatus)?  $default,) {final _that = this;
switch (_that) {
case _WeeklyFamilyReviewState() when $default != null:
return $default(_that.child,_that.insights,_that.activeExperiment,_that.fetchStatus,_that.saveStatus);case _:
  return null;

}
}

}

/// @nodoc


class _WeeklyFamilyReviewState implements WeeklyFamilyReviewState {
  const _WeeklyFamilyReviewState({this.child, this.insights, this.activeExperiment, this.fetchStatus = const ApiResultStatus.initial(), this.saveStatus = const ApiResultStatus.initial()});
  

@override final  ChildModel? child;
@override final  WeeklyInsightsResult? insights;
@override final  ActiveExperimentModel? activeExperiment;
@override@JsonKey() final  ApiResultStatus<dynamic> fetchStatus;
@override@JsonKey() final  ApiResultStatus<dynamic> saveStatus;

/// Create a copy of WeeklyFamilyReviewState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeeklyFamilyReviewStateCopyWith<_WeeklyFamilyReviewState> get copyWith => __$WeeklyFamilyReviewStateCopyWithImpl<_WeeklyFamilyReviewState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeeklyFamilyReviewState&&(identical(other.child, child) || other.child == child)&&(identical(other.insights, insights) || other.insights == insights)&&(identical(other.activeExperiment, activeExperiment) || other.activeExperiment == activeExperiment)&&(identical(other.fetchStatus, fetchStatus) || other.fetchStatus == fetchStatus)&&(identical(other.saveStatus, saveStatus) || other.saveStatus == saveStatus));
}


@override
int get hashCode {
    return Object.hash(runtimeType,child,insights,activeExperiment,fetchStatus,saveStatus);
}

@override
String toString() {
    return 'WeeklyFamilyReviewState(child: $child, insights: $insights, activeExperiment: $activeExperiment, fetchStatus: $fetchStatus, saveStatus: $saveStatus)';
}


}

/// @nodoc
abstract mixin class _$WeeklyFamilyReviewStateCopyWith<$Res> implements $WeeklyFamilyReviewStateCopyWith<$Res> {
  factory _$WeeklyFamilyReviewStateCopyWith(_WeeklyFamilyReviewState value, $Res Function(_WeeklyFamilyReviewState) _then) = __$WeeklyFamilyReviewStateCopyWithImpl;
@override @useResult
$Res call({
 ChildModel? child, WeeklyInsightsResult? insights, ActiveExperimentModel? activeExperiment, ApiResultStatus<dynamic> fetchStatus, ApiResultStatus<dynamic> saveStatus
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus;@override $ApiResultStatusCopyWith<dynamic, $Res> get saveStatus;

}
/// @nodoc
class __$WeeklyFamilyReviewStateCopyWithImpl<$Res>
    implements _$WeeklyFamilyReviewStateCopyWith<$Res> {
  __$WeeklyFamilyReviewStateCopyWithImpl(this._self, this._then);

  final _WeeklyFamilyReviewState _self;
  final $Res Function(_WeeklyFamilyReviewState) _then;

/// Create a copy of WeeklyFamilyReviewState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? child = freezed,Object? insights = freezed,Object? activeExperiment = freezed,Object? fetchStatus = null,Object? saveStatus = null,}) {
  return _then(_WeeklyFamilyReviewState(
child: freezed == child ? _self.child : child // ignore: cast_nullable_to_non_nullable
as ChildModel?,insights: freezed == insights ? _self.insights : insights // ignore: cast_nullable_to_non_nullable
as WeeklyInsightsResult?,activeExperiment: freezed == activeExperiment ? _self.activeExperiment : activeExperiment // ignore: cast_nullable_to_non_nullable
as ActiveExperimentModel?,fetchStatus: null == fetchStatus ? _self.fetchStatus : fetchStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,saveStatus: null == saveStatus ? _self.saveStatus : saveStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}

/// Create a copy of WeeklyFamilyReviewState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.fetchStatus, (value) {
    return _then(_self.copyWith(fetchStatus: value));
  });
}/// Create a copy of WeeklyFamilyReviewState
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
