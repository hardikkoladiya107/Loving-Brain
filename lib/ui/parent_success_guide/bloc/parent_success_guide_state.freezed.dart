// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parent_success_guide_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ParentSuccessGuideState {

 bool get isLoading; GuideProfileModel? get guide; List<String> get activeGoals; List<MentorshipRequestModel> get pendingRequests; ApiResultStatus<dynamic> get fetchStatus;
/// Create a copy of ParentSuccessGuideState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParentSuccessGuideStateCopyWith<ParentSuccessGuideState> get copyWith => _$ParentSuccessGuideStateCopyWithImpl<ParentSuccessGuideState>(this as ParentSuccessGuideState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ParentSuccessGuideState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParentSuccessGuideState&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.guide, _this.guide) || other.guide == _this.guide)&&const DeepCollectionEquality().equals(other.activeGoals, _this.activeGoals)&&const DeepCollectionEquality().equals(other.pendingRequests, _this.pendingRequests)&&(identical(other.fetchStatus, _this.fetchStatus) || other.fetchStatus == _this.fetchStatus));
}


@override
int get hashCode {
  final _this = this as ParentSuccessGuideState;
  return Object.hash(runtimeType,_this.isLoading,_this.guide,const DeepCollectionEquality().hash(_this.activeGoals),const DeepCollectionEquality().hash(_this.pendingRequests),_this.fetchStatus);
}

@override
String toString() {
  final _this = this as ParentSuccessGuideState;
  return 'ParentSuccessGuideState(isLoading: ${_this.isLoading}, guide: ${_this.guide}, activeGoals: ${_this.activeGoals}, pendingRequests: ${_this.pendingRequests}, fetchStatus: ${_this.fetchStatus})';
}


}

/// @nodoc
abstract mixin class $ParentSuccessGuideStateCopyWith<$Res>  {
  factory $ParentSuccessGuideStateCopyWith(ParentSuccessGuideState value, $Res Function(ParentSuccessGuideState) _then) = _$ParentSuccessGuideStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, GuideProfileModel? guide, List<String> activeGoals, List<MentorshipRequestModel> pendingRequests, ApiResultStatus<dynamic> fetchStatus
});


$ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus;

}
/// @nodoc
class _$ParentSuccessGuideStateCopyWithImpl<$Res>
    implements $ParentSuccessGuideStateCopyWith<$Res> {
  _$ParentSuccessGuideStateCopyWithImpl(this._self, this._then);

  final ParentSuccessGuideState _self;
  final $Res Function(ParentSuccessGuideState) _then;

/// Create a copy of ParentSuccessGuideState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? guide = freezed,Object? activeGoals = null,Object? pendingRequests = null,Object? fetchStatus = null,}) {
  return _then(ParentSuccessGuideState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,guide: freezed == guide ? _self.guide : guide // ignore: cast_nullable_to_non_nullable
as GuideProfileModel?,activeGoals: null == activeGoals ? _self.activeGoals : activeGoals // ignore: cast_nullable_to_non_nullable
as List<String>,pendingRequests: null == pendingRequests ? _self.pendingRequests : pendingRequests // ignore: cast_nullable_to_non_nullable
as List<MentorshipRequestModel>,fetchStatus: null == fetchStatus ? _self.fetchStatus : fetchStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}
/// Create a copy of ParentSuccessGuideState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.fetchStatus, (value) {
    return _then(_self.copyWith(fetchStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [ParentSuccessGuideState].
extension ParentSuccessGuideStatePatterns on ParentSuccessGuideState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParentSuccessGuideState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParentSuccessGuideState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParentSuccessGuideState value)  $default,){
final _that = this;
switch (_that) {
case _ParentSuccessGuideState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParentSuccessGuideState value)?  $default,){
final _that = this;
switch (_that) {
case _ParentSuccessGuideState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  GuideProfileModel? guide,  List<String> activeGoals,  List<MentorshipRequestModel> pendingRequests,  ApiResultStatus<dynamic> fetchStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParentSuccessGuideState() when $default != null:
return $default(_that.isLoading,_that.guide,_that.activeGoals,_that.pendingRequests,_that.fetchStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  GuideProfileModel? guide,  List<String> activeGoals,  List<MentorshipRequestModel> pendingRequests,  ApiResultStatus<dynamic> fetchStatus)  $default,) {final _that = this;
switch (_that) {
case _ParentSuccessGuideState():
return $default(_that.isLoading,_that.guide,_that.activeGoals,_that.pendingRequests,_that.fetchStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  GuideProfileModel? guide,  List<String> activeGoals,  List<MentorshipRequestModel> pendingRequests,  ApiResultStatus<dynamic> fetchStatus)?  $default,) {final _that = this;
switch (_that) {
case _ParentSuccessGuideState() when $default != null:
return $default(_that.isLoading,_that.guide,_that.activeGoals,_that.pendingRequests,_that.fetchStatus);case _:
  return null;

}
}

}

/// @nodoc


class _ParentSuccessGuideState implements ParentSuccessGuideState {
  const _ParentSuccessGuideState({this.isLoading = false, this.guide,  List<String> activeGoals = const <String>['Shift bedtime by 15 minutes', 'Consistent evening wind-down routine'],  List<MentorshipRequestModel> pendingRequests = const <MentorshipRequestModel>[], this.fetchStatus = const ApiResultStatus.initial()}): _activeGoals = activeGoals,_pendingRequests = pendingRequests;
  

@override@JsonKey() final  bool isLoading;
@override final  GuideProfileModel? guide;
 final  List<String> _activeGoals;
@override@JsonKey() List<String> get activeGoals {
  if (_activeGoals is EqualUnmodifiableListView) return _activeGoals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_activeGoals);
}

 final  List<MentorshipRequestModel> _pendingRequests;
@override@JsonKey() List<MentorshipRequestModel> get pendingRequests {
  if (_pendingRequests is EqualUnmodifiableListView) return _pendingRequests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pendingRequests);
}

@override@JsonKey() final  ApiResultStatus<dynamic> fetchStatus;

/// Create a copy of ParentSuccessGuideState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParentSuccessGuideStateCopyWith<_ParentSuccessGuideState> get copyWith => __$ParentSuccessGuideStateCopyWithImpl<_ParentSuccessGuideState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParentSuccessGuideState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.guide, guide) || other.guide == guide)&&const DeepCollectionEquality().equals(other.activeGoals, _activeGoals)&&const DeepCollectionEquality().equals(other.pendingRequests, _pendingRequests)&&(identical(other.fetchStatus, fetchStatus) || other.fetchStatus == fetchStatus));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isLoading,guide,const DeepCollectionEquality().hash(_activeGoals),const DeepCollectionEquality().hash(_pendingRequests),fetchStatus);
}

@override
String toString() {
    return 'ParentSuccessGuideState(isLoading: $isLoading, guide: $guide, activeGoals: $activeGoals, pendingRequests: $pendingRequests, fetchStatus: $fetchStatus)';
}


}

/// @nodoc
abstract mixin class _$ParentSuccessGuideStateCopyWith<$Res> implements $ParentSuccessGuideStateCopyWith<$Res> {
  factory _$ParentSuccessGuideStateCopyWith(_ParentSuccessGuideState value, $Res Function(_ParentSuccessGuideState) _then) = __$ParentSuccessGuideStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, GuideProfileModel? guide, List<String> activeGoals, List<MentorshipRequestModel> pendingRequests, ApiResultStatus<dynamic> fetchStatus
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus;

}
/// @nodoc
class __$ParentSuccessGuideStateCopyWithImpl<$Res>
    implements _$ParentSuccessGuideStateCopyWith<$Res> {
  __$ParentSuccessGuideStateCopyWithImpl(this._self, this._then);

  final _ParentSuccessGuideState _self;
  final $Res Function(_ParentSuccessGuideState) _then;

/// Create a copy of ParentSuccessGuideState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? guide = freezed,Object? activeGoals = null,Object? pendingRequests = null,Object? fetchStatus = null,}) {
  return _then(_ParentSuccessGuideState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,guide: freezed == guide ? _self.guide : guide // ignore: cast_nullable_to_non_nullable
as GuideProfileModel?,activeGoals: null == activeGoals ? _self._activeGoals : activeGoals // ignore: cast_nullable_to_non_nullable
as List<String>,pendingRequests: null == pendingRequests ? _self._pendingRequests : pendingRequests // ignore: cast_nullable_to_non_nullable
as List<MentorshipRequestModel>,fetchStatus: null == fetchStatus ? _self.fetchStatus : fetchStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}

/// Create a copy of ParentSuccessGuideState
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
