// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'journal_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$JournalState {

 UserModel? get userModel; ChildModel? get childModel; List<TimelineEventModel> get todayEvents; int get readinessScore; bool get readyNow; bool get moodLoggedToday; double get sleepHoursLastNight; List<MilestoneModel> get milestones; Set<int> get unlockedChapters; bool get exportUnlocked; ApiResultStatus get loadStatus;
/// Create a copy of JournalState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JournalStateCopyWith<JournalState> get copyWith => _$JournalStateCopyWithImpl<JournalState>(this as JournalState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JournalState&&(identical(other.userModel, userModel) || other.userModel == userModel)&&(identical(other.childModel, childModel) || other.childModel == childModel)&&const DeepCollectionEquality().equals(other.todayEvents, todayEvents)&&(identical(other.readinessScore, readinessScore) || other.readinessScore == readinessScore)&&(identical(other.readyNow, readyNow) || other.readyNow == readyNow)&&(identical(other.moodLoggedToday, moodLoggedToday) || other.moodLoggedToday == moodLoggedToday)&&(identical(other.sleepHoursLastNight, sleepHoursLastNight) || other.sleepHoursLastNight == sleepHoursLastNight)&&const DeepCollectionEquality().equals(other.milestones, milestones)&&const DeepCollectionEquality().equals(other.unlockedChapters, unlockedChapters)&&(identical(other.exportUnlocked, exportUnlocked) || other.exportUnlocked == exportUnlocked)&&(identical(other.loadStatus, loadStatus) || other.loadStatus == loadStatus));
}


@override
int get hashCode => Object.hash(runtimeType,userModel,childModel,const DeepCollectionEquality().hash(todayEvents),readinessScore,readyNow,moodLoggedToday,sleepHoursLastNight,const DeepCollectionEquality().hash(milestones),const DeepCollectionEquality().hash(unlockedChapters),exportUnlocked,loadStatus);

@override
String toString() {
  return 'JournalState(userModel: $userModel, childModel: $childModel, todayEvents: $todayEvents, readinessScore: $readinessScore, readyNow: $readyNow, moodLoggedToday: $moodLoggedToday, sleepHoursLastNight: $sleepHoursLastNight, milestones: $milestones, unlockedChapters: $unlockedChapters, exportUnlocked: $exportUnlocked, loadStatus: $loadStatus)';
}


}

/// @nodoc
abstract mixin class $JournalStateCopyWith<$Res>  {
  factory $JournalStateCopyWith(JournalState value, $Res Function(JournalState) _then) = _$JournalStateCopyWithImpl;
@useResult
$Res call({
 UserModel? userModel, ChildModel? childModel, List<TimelineEventModel> todayEvents, int readinessScore, bool readyNow, bool moodLoggedToday, double sleepHoursLastNight, List<MilestoneModel> milestones, Set<int> unlockedChapters, bool exportUnlocked, ApiResultStatus loadStatus
});


$ApiResultStatusCopyWith<dynamic, $Res> get loadStatus;

}
/// @nodoc
class _$JournalStateCopyWithImpl<$Res>
    implements $JournalStateCopyWith<$Res> {
  _$JournalStateCopyWithImpl(this._self, this._then);

  final JournalState _self;
  final $Res Function(JournalState) _then;

/// Create a copy of JournalState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userModel = freezed,Object? childModel = freezed,Object? todayEvents = null,Object? readinessScore = null,Object? readyNow = null,Object? moodLoggedToday = null,Object? sleepHoursLastNight = null,Object? milestones = null,Object? unlockedChapters = null,Object? exportUnlocked = null,Object? loadStatus = null,}) {
  return _then(_self.copyWith(
userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,childModel: freezed == childModel ? _self.childModel : childModel // ignore: cast_nullable_to_non_nullable
as ChildModel?,todayEvents: null == todayEvents ? _self.todayEvents : todayEvents // ignore: cast_nullable_to_non_nullable
as List<TimelineEventModel>,readinessScore: null == readinessScore ? _self.readinessScore : readinessScore // ignore: cast_nullable_to_non_nullable
as int,readyNow: null == readyNow ? _self.readyNow : readyNow // ignore: cast_nullable_to_non_nullable
as bool,moodLoggedToday: null == moodLoggedToday ? _self.moodLoggedToday : moodLoggedToday // ignore: cast_nullable_to_non_nullable
as bool,sleepHoursLastNight: null == sleepHoursLastNight ? _self.sleepHoursLastNight : sleepHoursLastNight // ignore: cast_nullable_to_non_nullable
as double,milestones: null == milestones ? _self.milestones : milestones // ignore: cast_nullable_to_non_nullable
as List<MilestoneModel>,unlockedChapters: null == unlockedChapters ? _self.unlockedChapters : unlockedChapters // ignore: cast_nullable_to_non_nullable
as Set<int>,exportUnlocked: null == exportUnlocked ? _self.exportUnlocked : exportUnlocked // ignore: cast_nullable_to_non_nullable
as bool,loadStatus: null == loadStatus ? _self.loadStatus : loadStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,
  ));
}
/// Create a copy of JournalState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get loadStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.loadStatus, (value) {
    return _then(_self.copyWith(loadStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [JournalState].
extension JournalStatePatterns on JournalState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JournalState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JournalState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JournalState value)  $default,){
final _that = this;
switch (_that) {
case _JournalState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JournalState value)?  $default,){
final _that = this;
switch (_that) {
case _JournalState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UserModel? userModel,  ChildModel? childModel,  List<TimelineEventModel> todayEvents,  int readinessScore,  bool readyNow,  bool moodLoggedToday,  double sleepHoursLastNight,  List<MilestoneModel> milestones,  Set<int> unlockedChapters,  bool exportUnlocked,  ApiResultStatus loadStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JournalState() when $default != null:
return $default(_that.userModel,_that.childModel,_that.todayEvents,_that.readinessScore,_that.readyNow,_that.moodLoggedToday,_that.sleepHoursLastNight,_that.milestones,_that.unlockedChapters,_that.exportUnlocked,_that.loadStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UserModel? userModel,  ChildModel? childModel,  List<TimelineEventModel> todayEvents,  int readinessScore,  bool readyNow,  bool moodLoggedToday,  double sleepHoursLastNight,  List<MilestoneModel> milestones,  Set<int> unlockedChapters,  bool exportUnlocked,  ApiResultStatus loadStatus)  $default,) {final _that = this;
switch (_that) {
case _JournalState():
return $default(_that.userModel,_that.childModel,_that.todayEvents,_that.readinessScore,_that.readyNow,_that.moodLoggedToday,_that.sleepHoursLastNight,_that.milestones,_that.unlockedChapters,_that.exportUnlocked,_that.loadStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UserModel? userModel,  ChildModel? childModel,  List<TimelineEventModel> todayEvents,  int readinessScore,  bool readyNow,  bool moodLoggedToday,  double sleepHoursLastNight,  List<MilestoneModel> milestones,  Set<int> unlockedChapters,  bool exportUnlocked,  ApiResultStatus loadStatus)?  $default,) {final _that = this;
switch (_that) {
case _JournalState() when $default != null:
return $default(_that.userModel,_that.childModel,_that.todayEvents,_that.readinessScore,_that.readyNow,_that.moodLoggedToday,_that.sleepHoursLastNight,_that.milestones,_that.unlockedChapters,_that.exportUnlocked,_that.loadStatus);case _:
  return null;

}
}

}

/// @nodoc


class _JournalState implements JournalState {
  const _JournalState({this.userModel, this.childModel, final  List<TimelineEventModel> todayEvents = const <TimelineEventModel>[], this.readinessScore = 0, this.readyNow = false, this.moodLoggedToday = false, this.sleepHoursLastNight = 0.0, final  List<MilestoneModel> milestones = const <MilestoneModel>[], final  Set<int> unlockedChapters = const <int>{}, this.exportUnlocked = false, this.loadStatus = const ApiResultStatus.initial()}): _todayEvents = todayEvents,_milestones = milestones,_unlockedChapters = unlockedChapters;
  

@override final  UserModel? userModel;
@override final  ChildModel? childModel;
 final  List<TimelineEventModel> _todayEvents;
@override@JsonKey() List<TimelineEventModel> get todayEvents {
  if (_todayEvents is EqualUnmodifiableListView) return _todayEvents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_todayEvents);
}

@override@JsonKey() final  int readinessScore;
@override@JsonKey() final  bool readyNow;
@override@JsonKey() final  bool moodLoggedToday;
@override@JsonKey() final  double sleepHoursLastNight;
 final  List<MilestoneModel> _milestones;
@override@JsonKey() List<MilestoneModel> get milestones {
  if (_milestones is EqualUnmodifiableListView) return _milestones;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_milestones);
}

 final  Set<int> _unlockedChapters;
@override@JsonKey() Set<int> get unlockedChapters {
  if (_unlockedChapters is EqualUnmodifiableSetView) return _unlockedChapters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_unlockedChapters);
}

@override@JsonKey() final  bool exportUnlocked;
@override@JsonKey() final  ApiResultStatus loadStatus;

/// Create a copy of JournalState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JournalStateCopyWith<_JournalState> get copyWith => __$JournalStateCopyWithImpl<_JournalState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JournalState&&(identical(other.userModel, userModel) || other.userModel == userModel)&&(identical(other.childModel, childModel) || other.childModel == childModel)&&const DeepCollectionEquality().equals(other._todayEvents, _todayEvents)&&(identical(other.readinessScore, readinessScore) || other.readinessScore == readinessScore)&&(identical(other.readyNow, readyNow) || other.readyNow == readyNow)&&(identical(other.moodLoggedToday, moodLoggedToday) || other.moodLoggedToday == moodLoggedToday)&&(identical(other.sleepHoursLastNight, sleepHoursLastNight) || other.sleepHoursLastNight == sleepHoursLastNight)&&const DeepCollectionEquality().equals(other._milestones, _milestones)&&const DeepCollectionEquality().equals(other._unlockedChapters, _unlockedChapters)&&(identical(other.exportUnlocked, exportUnlocked) || other.exportUnlocked == exportUnlocked)&&(identical(other.loadStatus, loadStatus) || other.loadStatus == loadStatus));
}


@override
int get hashCode => Object.hash(runtimeType,userModel,childModel,const DeepCollectionEquality().hash(_todayEvents),readinessScore,readyNow,moodLoggedToday,sleepHoursLastNight,const DeepCollectionEquality().hash(_milestones),const DeepCollectionEquality().hash(_unlockedChapters),exportUnlocked,loadStatus);

@override
String toString() {
  return 'JournalState(userModel: $userModel, childModel: $childModel, todayEvents: $todayEvents, readinessScore: $readinessScore, readyNow: $readyNow, moodLoggedToday: $moodLoggedToday, sleepHoursLastNight: $sleepHoursLastNight, milestones: $milestones, unlockedChapters: $unlockedChapters, exportUnlocked: $exportUnlocked, loadStatus: $loadStatus)';
}


}

/// @nodoc
abstract mixin class _$JournalStateCopyWith<$Res> implements $JournalStateCopyWith<$Res> {
  factory _$JournalStateCopyWith(_JournalState value, $Res Function(_JournalState) _then) = __$JournalStateCopyWithImpl;
@override @useResult
$Res call({
 UserModel? userModel, ChildModel? childModel, List<TimelineEventModel> todayEvents, int readinessScore, bool readyNow, bool moodLoggedToday, double sleepHoursLastNight, List<MilestoneModel> milestones, Set<int> unlockedChapters, bool exportUnlocked, ApiResultStatus loadStatus
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get loadStatus;

}
/// @nodoc
class __$JournalStateCopyWithImpl<$Res>
    implements _$JournalStateCopyWith<$Res> {
  __$JournalStateCopyWithImpl(this._self, this._then);

  final _JournalState _self;
  final $Res Function(_JournalState) _then;

/// Create a copy of JournalState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userModel = freezed,Object? childModel = freezed,Object? todayEvents = null,Object? readinessScore = null,Object? readyNow = null,Object? moodLoggedToday = null,Object? sleepHoursLastNight = null,Object? milestones = null,Object? unlockedChapters = null,Object? exportUnlocked = null,Object? loadStatus = null,}) {
  return _then(_JournalState(
userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,childModel: freezed == childModel ? _self.childModel : childModel // ignore: cast_nullable_to_non_nullable
as ChildModel?,todayEvents: null == todayEvents ? _self._todayEvents : todayEvents // ignore: cast_nullable_to_non_nullable
as List<TimelineEventModel>,readinessScore: null == readinessScore ? _self.readinessScore : readinessScore // ignore: cast_nullable_to_non_nullable
as int,readyNow: null == readyNow ? _self.readyNow : readyNow // ignore: cast_nullable_to_non_nullable
as bool,moodLoggedToday: null == moodLoggedToday ? _self.moodLoggedToday : moodLoggedToday // ignore: cast_nullable_to_non_nullable
as bool,sleepHoursLastNight: null == sleepHoursLastNight ? _self.sleepHoursLastNight : sleepHoursLastNight // ignore: cast_nullable_to_non_nullable
as double,milestones: null == milestones ? _self._milestones : milestones // ignore: cast_nullable_to_non_nullable
as List<MilestoneModel>,unlockedChapters: null == unlockedChapters ? _self._unlockedChapters : unlockedChapters // ignore: cast_nullable_to_non_nullable
as Set<int>,exportUnlocked: null == exportUnlocked ? _self.exportUnlocked : exportUnlocked // ignore: cast_nullable_to_non_nullable
as bool,loadStatus: null == loadStatus ? _self.loadStatus : loadStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,
  ));
}

/// Create a copy of JournalState
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
