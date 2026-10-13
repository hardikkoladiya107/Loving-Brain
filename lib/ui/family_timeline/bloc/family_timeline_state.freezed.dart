// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'family_timeline_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FamilyTimelineState {

 List<TimelineEventModel> get allEvents; List<TimelineEventModel> get filteredEvents; String get selectedFilter; ChildModel? get child; int get weeksWithLovingBrain; int get averageBedtimeShiftMinutes; ApiResultStatus<dynamic> get fetchStatus;
/// Create a copy of FamilyTimelineState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FamilyTimelineStateCopyWith<FamilyTimelineState> get copyWith => _$FamilyTimelineStateCopyWithImpl<FamilyTimelineState>(this as FamilyTimelineState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FamilyTimelineState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FamilyTimelineState&&const DeepCollectionEquality().equals(other.allEvents, _this.allEvents)&&const DeepCollectionEquality().equals(other.filteredEvents, _this.filteredEvents)&&(identical(other.selectedFilter, _this.selectedFilter) || other.selectedFilter == _this.selectedFilter)&&(identical(other.child, _this.child) || other.child == _this.child)&&(identical(other.weeksWithLovingBrain, _this.weeksWithLovingBrain) || other.weeksWithLovingBrain == _this.weeksWithLovingBrain)&&(identical(other.averageBedtimeShiftMinutes, _this.averageBedtimeShiftMinutes) || other.averageBedtimeShiftMinutes == _this.averageBedtimeShiftMinutes)&&(identical(other.fetchStatus, _this.fetchStatus) || other.fetchStatus == _this.fetchStatus));
}


@override
int get hashCode {
  final _this = this as FamilyTimelineState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.allEvents),const DeepCollectionEquality().hash(_this.filteredEvents),_this.selectedFilter,_this.child,_this.weeksWithLovingBrain,_this.averageBedtimeShiftMinutes,_this.fetchStatus);
}

@override
String toString() {
  final _this = this as FamilyTimelineState;
  return 'FamilyTimelineState(allEvents: ${_this.allEvents}, filteredEvents: ${_this.filteredEvents}, selectedFilter: ${_this.selectedFilter}, child: ${_this.child}, weeksWithLovingBrain: ${_this.weeksWithLovingBrain}, averageBedtimeShiftMinutes: ${_this.averageBedtimeShiftMinutes}, fetchStatus: ${_this.fetchStatus})';
}


}

/// @nodoc
abstract mixin class $FamilyTimelineStateCopyWith<$Res>  {
  factory $FamilyTimelineStateCopyWith(FamilyTimelineState value, $Res Function(FamilyTimelineState) _then) = _$FamilyTimelineStateCopyWithImpl;
@useResult
$Res call({
 List<TimelineEventModel> allEvents, List<TimelineEventModel> filteredEvents, String selectedFilter, ChildModel? child, int weeksWithLovingBrain, int averageBedtimeShiftMinutes, ApiResultStatus<dynamic> fetchStatus
});


$ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus;

}
/// @nodoc
class _$FamilyTimelineStateCopyWithImpl<$Res>
    implements $FamilyTimelineStateCopyWith<$Res> {
  _$FamilyTimelineStateCopyWithImpl(this._self, this._then);

  final FamilyTimelineState _self;
  final $Res Function(FamilyTimelineState) _then;

/// Create a copy of FamilyTimelineState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? allEvents = null,Object? filteredEvents = null,Object? selectedFilter = null,Object? child = freezed,Object? weeksWithLovingBrain = null,Object? averageBedtimeShiftMinutes = null,Object? fetchStatus = null,}) {
  return _then(FamilyTimelineState(
allEvents: null == allEvents ? _self.allEvents : allEvents // ignore: cast_nullable_to_non_nullable
as List<TimelineEventModel>,filteredEvents: null == filteredEvents ? _self.filteredEvents : filteredEvents // ignore: cast_nullable_to_non_nullable
as List<TimelineEventModel>,selectedFilter: null == selectedFilter ? _self.selectedFilter : selectedFilter // ignore: cast_nullable_to_non_nullable
as String,child: freezed == child ? _self.child : child // ignore: cast_nullable_to_non_nullable
as ChildModel?,weeksWithLovingBrain: null == weeksWithLovingBrain ? _self.weeksWithLovingBrain : weeksWithLovingBrain // ignore: cast_nullable_to_non_nullable
as int,averageBedtimeShiftMinutes: null == averageBedtimeShiftMinutes ? _self.averageBedtimeShiftMinutes : averageBedtimeShiftMinutes // ignore: cast_nullable_to_non_nullable
as int,fetchStatus: null == fetchStatus ? _self.fetchStatus : fetchStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}
/// Create a copy of FamilyTimelineState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.fetchStatus, (value) {
    return _then(_self.copyWith(fetchStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [FamilyTimelineState].
extension FamilyTimelineStatePatterns on FamilyTimelineState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FamilyTimelineState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FamilyTimelineState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FamilyTimelineState value)  $default,){
final _that = this;
switch (_that) {
case _FamilyTimelineState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FamilyTimelineState value)?  $default,){
final _that = this;
switch (_that) {
case _FamilyTimelineState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TimelineEventModel> allEvents,  List<TimelineEventModel> filteredEvents,  String selectedFilter,  ChildModel? child,  int weeksWithLovingBrain,  int averageBedtimeShiftMinutes,  ApiResultStatus<dynamic> fetchStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FamilyTimelineState() when $default != null:
return $default(_that.allEvents,_that.filteredEvents,_that.selectedFilter,_that.child,_that.weeksWithLovingBrain,_that.averageBedtimeShiftMinutes,_that.fetchStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TimelineEventModel> allEvents,  List<TimelineEventModel> filteredEvents,  String selectedFilter,  ChildModel? child,  int weeksWithLovingBrain,  int averageBedtimeShiftMinutes,  ApiResultStatus<dynamic> fetchStatus)  $default,) {final _that = this;
switch (_that) {
case _FamilyTimelineState():
return $default(_that.allEvents,_that.filteredEvents,_that.selectedFilter,_that.child,_that.weeksWithLovingBrain,_that.averageBedtimeShiftMinutes,_that.fetchStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TimelineEventModel> allEvents,  List<TimelineEventModel> filteredEvents,  String selectedFilter,  ChildModel? child,  int weeksWithLovingBrain,  int averageBedtimeShiftMinutes,  ApiResultStatus<dynamic> fetchStatus)?  $default,) {final _that = this;
switch (_that) {
case _FamilyTimelineState() when $default != null:
return $default(_that.allEvents,_that.filteredEvents,_that.selectedFilter,_that.child,_that.weeksWithLovingBrain,_that.averageBedtimeShiftMinutes,_that.fetchStatus);case _:
  return null;

}
}

}

/// @nodoc


class _FamilyTimelineState implements FamilyTimelineState {
  const _FamilyTimelineState({ List<TimelineEventModel> allEvents = const [],  List<TimelineEventModel> filteredEvents = const [], this.selectedFilter = 'All', this.child, this.weeksWithLovingBrain = 5, this.averageBedtimeShiftMinutes = 22, this.fetchStatus = const ApiResultStatus.initial()}): _allEvents = allEvents,_filteredEvents = filteredEvents;
  

 final  List<TimelineEventModel> _allEvents;
@override@JsonKey() List<TimelineEventModel> get allEvents {
  if (_allEvents is EqualUnmodifiableListView) return _allEvents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allEvents);
}

 final  List<TimelineEventModel> _filteredEvents;
@override@JsonKey() List<TimelineEventModel> get filteredEvents {
  if (_filteredEvents is EqualUnmodifiableListView) return _filteredEvents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_filteredEvents);
}

@override@JsonKey() final  String selectedFilter;
@override final  ChildModel? child;
@override@JsonKey() final  int weeksWithLovingBrain;
@override@JsonKey() final  int averageBedtimeShiftMinutes;
@override@JsonKey() final  ApiResultStatus<dynamic> fetchStatus;

/// Create a copy of FamilyTimelineState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FamilyTimelineStateCopyWith<_FamilyTimelineState> get copyWith => __$FamilyTimelineStateCopyWithImpl<_FamilyTimelineState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FamilyTimelineState&&const DeepCollectionEquality().equals(other.allEvents, _allEvents)&&const DeepCollectionEquality().equals(other.filteredEvents, _filteredEvents)&&(identical(other.selectedFilter, selectedFilter) || other.selectedFilter == selectedFilter)&&(identical(other.child, child) || other.child == child)&&(identical(other.weeksWithLovingBrain, weeksWithLovingBrain) || other.weeksWithLovingBrain == weeksWithLovingBrain)&&(identical(other.averageBedtimeShiftMinutes, averageBedtimeShiftMinutes) || other.averageBedtimeShiftMinutes == averageBedtimeShiftMinutes)&&(identical(other.fetchStatus, fetchStatus) || other.fetchStatus == fetchStatus));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_allEvents),const DeepCollectionEquality().hash(_filteredEvents),selectedFilter,child,weeksWithLovingBrain,averageBedtimeShiftMinutes,fetchStatus);
}

@override
String toString() {
    return 'FamilyTimelineState(allEvents: $allEvents, filteredEvents: $filteredEvents, selectedFilter: $selectedFilter, child: $child, weeksWithLovingBrain: $weeksWithLovingBrain, averageBedtimeShiftMinutes: $averageBedtimeShiftMinutes, fetchStatus: $fetchStatus)';
}


}

/// @nodoc
abstract mixin class _$FamilyTimelineStateCopyWith<$Res> implements $FamilyTimelineStateCopyWith<$Res> {
  factory _$FamilyTimelineStateCopyWith(_FamilyTimelineState value, $Res Function(_FamilyTimelineState) _then) = __$FamilyTimelineStateCopyWithImpl;
@override @useResult
$Res call({
 List<TimelineEventModel> allEvents, List<TimelineEventModel> filteredEvents, String selectedFilter, ChildModel? child, int weeksWithLovingBrain, int averageBedtimeShiftMinutes, ApiResultStatus<dynamic> fetchStatus
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus;

}
/// @nodoc
class __$FamilyTimelineStateCopyWithImpl<$Res>
    implements _$FamilyTimelineStateCopyWith<$Res> {
  __$FamilyTimelineStateCopyWithImpl(this._self, this._then);

  final _FamilyTimelineState _self;
  final $Res Function(_FamilyTimelineState) _then;

/// Create a copy of FamilyTimelineState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? allEvents = null,Object? filteredEvents = null,Object? selectedFilter = null,Object? child = freezed,Object? weeksWithLovingBrain = null,Object? averageBedtimeShiftMinutes = null,Object? fetchStatus = null,}) {
  return _then(_FamilyTimelineState(
allEvents: null == allEvents ? _self._allEvents : allEvents // ignore: cast_nullable_to_non_nullable
as List<TimelineEventModel>,filteredEvents: null == filteredEvents ? _self._filteredEvents : filteredEvents // ignore: cast_nullable_to_non_nullable
as List<TimelineEventModel>,selectedFilter: null == selectedFilter ? _self.selectedFilter : selectedFilter // ignore: cast_nullable_to_non_nullable
as String,child: freezed == child ? _self.child : child // ignore: cast_nullable_to_non_nullable
as ChildModel?,weeksWithLovingBrain: null == weeksWithLovingBrain ? _self.weeksWithLovingBrain : weeksWithLovingBrain // ignore: cast_nullable_to_non_nullable
as int,averageBedtimeShiftMinutes: null == averageBedtimeShiftMinutes ? _self.averageBedtimeShiftMinutes : averageBedtimeShiftMinutes // ignore: cast_nullable_to_non_nullable
as int,fetchStatus: null == fetchStatus ? _self.fetchStatus : fetchStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}

/// Create a copy of FamilyTimelineState
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
