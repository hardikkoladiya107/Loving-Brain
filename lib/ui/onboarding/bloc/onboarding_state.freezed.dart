// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OnboardingState {

 int get currentPage; int get totalPages; String get parentName; String get parentRole; String get preferredLanguage; String get location; String get primaryConcern; List<String> get concerns; bool get isMoreThanOneSelected; String get successGoal; String get childName; String get dateOfBirth; DateTime? get childDob; String get childGender; String get usualWakeTime; String get usualBedtime; int get usualNaps; String get nightWakings; List<String> get difficultTimes; List<String> get possibleTriggers; ApiResultStatus get completeStatus;
/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingStateCopyWith<OnboardingState> get copyWith => _$OnboardingStateCopyWithImpl<OnboardingState>(this as OnboardingState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingState&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.parentName, parentName) || other.parentName == parentName)&&(identical(other.parentRole, parentRole) || other.parentRole == parentRole)&&(identical(other.preferredLanguage, preferredLanguage) || other.preferredLanguage == preferredLanguage)&&(identical(other.location, location) || other.location == location)&&(identical(other.primaryConcern, primaryConcern) || other.primaryConcern == primaryConcern)&&const DeepCollectionEquality().equals(other.concerns, concerns)&&(identical(other.isMoreThanOneSelected, isMoreThanOneSelected) || other.isMoreThanOneSelected == isMoreThanOneSelected)&&(identical(other.successGoal, successGoal) || other.successGoal == successGoal)&&(identical(other.childName, childName) || other.childName == childName)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.childDob, childDob) || other.childDob == childDob)&&(identical(other.childGender, childGender) || other.childGender == childGender)&&(identical(other.usualWakeTime, usualWakeTime) || other.usualWakeTime == usualWakeTime)&&(identical(other.usualBedtime, usualBedtime) || other.usualBedtime == usualBedtime)&&(identical(other.usualNaps, usualNaps) || other.usualNaps == usualNaps)&&(identical(other.nightWakings, nightWakings) || other.nightWakings == nightWakings)&&const DeepCollectionEquality().equals(other.difficultTimes, difficultTimes)&&const DeepCollectionEquality().equals(other.possibleTriggers, possibleTriggers)&&(identical(other.completeStatus, completeStatus) || other.completeStatus == completeStatus));
}


@override
int get hashCode => Object.hashAll([runtimeType,currentPage,totalPages,parentName,parentRole,preferredLanguage,location,primaryConcern,const DeepCollectionEquality().hash(concerns),isMoreThanOneSelected,successGoal,childName,dateOfBirth,childDob,childGender,usualWakeTime,usualBedtime,usualNaps,nightWakings,const DeepCollectionEquality().hash(difficultTimes),const DeepCollectionEquality().hash(possibleTriggers),completeStatus]);

@override
String toString() {
  return 'OnboardingState(currentPage: $currentPage, totalPages: $totalPages, parentName: $parentName, parentRole: $parentRole, preferredLanguage: $preferredLanguage, location: $location, primaryConcern: $primaryConcern, concerns: $concerns, isMoreThanOneSelected: $isMoreThanOneSelected, successGoal: $successGoal, childName: $childName, dateOfBirth: $dateOfBirth, childDob: $childDob, childGender: $childGender, usualWakeTime: $usualWakeTime, usualBedtime: $usualBedtime, usualNaps: $usualNaps, nightWakings: $nightWakings, difficultTimes: $difficultTimes, possibleTriggers: $possibleTriggers, completeStatus: $completeStatus)';
}


}

/// @nodoc
abstract mixin class $OnboardingStateCopyWith<$Res>  {
  factory $OnboardingStateCopyWith(OnboardingState value, $Res Function(OnboardingState) _then) = _$OnboardingStateCopyWithImpl;
@useResult
$Res call({
 int currentPage, int totalPages, String parentName, String parentRole, String preferredLanguage, String location, String primaryConcern, List<String> concerns, bool isMoreThanOneSelected, String successGoal, String childName, String dateOfBirth, DateTime? childDob, String childGender, String usualWakeTime, String usualBedtime, int usualNaps, String nightWakings, List<String> difficultTimes, List<String> possibleTriggers, ApiResultStatus completeStatus
});


$ApiResultStatusCopyWith<dynamic, $Res> get completeStatus;

}
/// @nodoc
class _$OnboardingStateCopyWithImpl<$Res>
    implements $OnboardingStateCopyWith<$Res> {
  _$OnboardingStateCopyWithImpl(this._self, this._then);

  final OnboardingState _self;
  final $Res Function(OnboardingState) _then;

/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentPage = null,Object? totalPages = null,Object? parentName = null,Object? parentRole = null,Object? preferredLanguage = null,Object? location = null,Object? primaryConcern = null,Object? concerns = null,Object? isMoreThanOneSelected = null,Object? successGoal = null,Object? childName = null,Object? dateOfBirth = null,Object? childDob = freezed,Object? childGender = null,Object? usualWakeTime = null,Object? usualBedtime = null,Object? usualNaps = null,Object? nightWakings = null,Object? difficultTimes = null,Object? possibleTriggers = null,Object? completeStatus = null,}) {
  return _then(_self.copyWith(
currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,parentName: null == parentName ? _self.parentName : parentName // ignore: cast_nullable_to_non_nullable
as String,parentRole: null == parentRole ? _self.parentRole : parentRole // ignore: cast_nullable_to_non_nullable
as String,preferredLanguage: null == preferredLanguage ? _self.preferredLanguage : preferredLanguage // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,primaryConcern: null == primaryConcern ? _self.primaryConcern : primaryConcern // ignore: cast_nullable_to_non_nullable
as String,concerns: null == concerns ? _self.concerns : concerns // ignore: cast_nullable_to_non_nullable
as List<String>,isMoreThanOneSelected: null == isMoreThanOneSelected ? _self.isMoreThanOneSelected : isMoreThanOneSelected // ignore: cast_nullable_to_non_nullable
as bool,successGoal: null == successGoal ? _self.successGoal : successGoal // ignore: cast_nullable_to_non_nullable
as String,childName: null == childName ? _self.childName : childName // ignore: cast_nullable_to_non_nullable
as String,dateOfBirth: null == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as String,childDob: freezed == childDob ? _self.childDob : childDob // ignore: cast_nullable_to_non_nullable
as DateTime?,childGender: null == childGender ? _self.childGender : childGender // ignore: cast_nullable_to_non_nullable
as String,usualWakeTime: null == usualWakeTime ? _self.usualWakeTime : usualWakeTime // ignore: cast_nullable_to_non_nullable
as String,usualBedtime: null == usualBedtime ? _self.usualBedtime : usualBedtime // ignore: cast_nullable_to_non_nullable
as String,usualNaps: null == usualNaps ? _self.usualNaps : usualNaps // ignore: cast_nullable_to_non_nullable
as int,nightWakings: null == nightWakings ? _self.nightWakings : nightWakings // ignore: cast_nullable_to_non_nullable
as String,difficultTimes: null == difficultTimes ? _self.difficultTimes : difficultTimes // ignore: cast_nullable_to_non_nullable
as List<String>,possibleTriggers: null == possibleTriggers ? _self.possibleTriggers : possibleTriggers // ignore: cast_nullable_to_non_nullable
as List<String>,completeStatus: null == completeStatus ? _self.completeStatus : completeStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,
  ));
}
/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get completeStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.completeStatus, (value) {
    return _then(_self.copyWith(completeStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [OnboardingState].
extension OnboardingStatePatterns on OnboardingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingState value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingState value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int currentPage,  int totalPages,  String parentName,  String parentRole,  String preferredLanguage,  String location,  String primaryConcern,  List<String> concerns,  bool isMoreThanOneSelected,  String successGoal,  String childName,  String dateOfBirth,  DateTime? childDob,  String childGender,  String usualWakeTime,  String usualBedtime,  int usualNaps,  String nightWakings,  List<String> difficultTimes,  List<String> possibleTriggers,  ApiResultStatus completeStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
return $default(_that.currentPage,_that.totalPages,_that.parentName,_that.parentRole,_that.preferredLanguage,_that.location,_that.primaryConcern,_that.concerns,_that.isMoreThanOneSelected,_that.successGoal,_that.childName,_that.dateOfBirth,_that.childDob,_that.childGender,_that.usualWakeTime,_that.usualBedtime,_that.usualNaps,_that.nightWakings,_that.difficultTimes,_that.possibleTriggers,_that.completeStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int currentPage,  int totalPages,  String parentName,  String parentRole,  String preferredLanguage,  String location,  String primaryConcern,  List<String> concerns,  bool isMoreThanOneSelected,  String successGoal,  String childName,  String dateOfBirth,  DateTime? childDob,  String childGender,  String usualWakeTime,  String usualBedtime,  int usualNaps,  String nightWakings,  List<String> difficultTimes,  List<String> possibleTriggers,  ApiResultStatus completeStatus)  $default,) {final _that = this;
switch (_that) {
case _OnboardingState():
return $default(_that.currentPage,_that.totalPages,_that.parentName,_that.parentRole,_that.preferredLanguage,_that.location,_that.primaryConcern,_that.concerns,_that.isMoreThanOneSelected,_that.successGoal,_that.childName,_that.dateOfBirth,_that.childDob,_that.childGender,_that.usualWakeTime,_that.usualBedtime,_that.usualNaps,_that.nightWakings,_that.difficultTimes,_that.possibleTriggers,_that.completeStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int currentPage,  int totalPages,  String parentName,  String parentRole,  String preferredLanguage,  String location,  String primaryConcern,  List<String> concerns,  bool isMoreThanOneSelected,  String successGoal,  String childName,  String dateOfBirth,  DateTime? childDob,  String childGender,  String usualWakeTime,  String usualBedtime,  int usualNaps,  String nightWakings,  List<String> difficultTimes,  List<String> possibleTriggers,  ApiResultStatus completeStatus)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
return $default(_that.currentPage,_that.totalPages,_that.parentName,_that.parentRole,_that.preferredLanguage,_that.location,_that.primaryConcern,_that.concerns,_that.isMoreThanOneSelected,_that.successGoal,_that.childName,_that.dateOfBirth,_that.childDob,_that.childGender,_that.usualWakeTime,_that.usualBedtime,_that.usualNaps,_that.nightWakings,_that.difficultTimes,_that.possibleTriggers,_that.completeStatus);case _:
  return null;

}
}

}

/// @nodoc


class _OnboardingState implements OnboardingState {
  const _OnboardingState({this.currentPage = 0, this.totalPages = 6, this.parentName = 'Russell Sprout', this.parentRole = 'Mother', this.preferredLanguage = 'English', this.location = 'Chennai, India (GMT+5:30)', this.primaryConcern = 'Sleep', final  List<String> concerns = const <String>['Sleep'], this.isMoreThanOneSelected = false, this.successGoal = 'Easier bedtimes', this.childName = 'Ingredia Nutrisha', this.dateOfBirth = '14 March 2024', this.childDob, this.childGender = 'Girl', this.usualWakeTime = '6:45 AM', this.usualBedtime = '8:15 PM', this.usualNaps = 2, this.nightWakings = '1-2', final  List<String> difficultTimes = const <String>['Before meals', 'Bedtime'], final  List<String> possibleTriggers = const <String>['Tiredness', 'Overstimulation'], this.completeStatus = const ApiResultStatus.initial()}): _concerns = concerns,_difficultTimes = difficultTimes,_possibleTriggers = possibleTriggers;
  

@override@JsonKey() final  int currentPage;
@override@JsonKey() final  int totalPages;
@override@JsonKey() final  String parentName;
@override@JsonKey() final  String parentRole;
@override@JsonKey() final  String preferredLanguage;
@override@JsonKey() final  String location;
@override@JsonKey() final  String primaryConcern;
 final  List<String> _concerns;
@override@JsonKey() List<String> get concerns {
  if (_concerns is EqualUnmodifiableListView) return _concerns;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_concerns);
}

@override@JsonKey() final  bool isMoreThanOneSelected;
@override@JsonKey() final  String successGoal;
@override@JsonKey() final  String childName;
@override@JsonKey() final  String dateOfBirth;
@override final  DateTime? childDob;
@override@JsonKey() final  String childGender;
@override@JsonKey() final  String usualWakeTime;
@override@JsonKey() final  String usualBedtime;
@override@JsonKey() final  int usualNaps;
@override@JsonKey() final  String nightWakings;
 final  List<String> _difficultTimes;
@override@JsonKey() List<String> get difficultTimes {
  if (_difficultTimes is EqualUnmodifiableListView) return _difficultTimes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_difficultTimes);
}

 final  List<String> _possibleTriggers;
@override@JsonKey() List<String> get possibleTriggers {
  if (_possibleTriggers is EqualUnmodifiableListView) return _possibleTriggers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_possibleTriggers);
}

@override@JsonKey() final  ApiResultStatus completeStatus;

/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingStateCopyWith<_OnboardingState> get copyWith => __$OnboardingStateCopyWithImpl<_OnboardingState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingState&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.parentName, parentName) || other.parentName == parentName)&&(identical(other.parentRole, parentRole) || other.parentRole == parentRole)&&(identical(other.preferredLanguage, preferredLanguage) || other.preferredLanguage == preferredLanguage)&&(identical(other.location, location) || other.location == location)&&(identical(other.primaryConcern, primaryConcern) || other.primaryConcern == primaryConcern)&&const DeepCollectionEquality().equals(other._concerns, _concerns)&&(identical(other.isMoreThanOneSelected, isMoreThanOneSelected) || other.isMoreThanOneSelected == isMoreThanOneSelected)&&(identical(other.successGoal, successGoal) || other.successGoal == successGoal)&&(identical(other.childName, childName) || other.childName == childName)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.childDob, childDob) || other.childDob == childDob)&&(identical(other.childGender, childGender) || other.childGender == childGender)&&(identical(other.usualWakeTime, usualWakeTime) || other.usualWakeTime == usualWakeTime)&&(identical(other.usualBedtime, usualBedtime) || other.usualBedtime == usualBedtime)&&(identical(other.usualNaps, usualNaps) || other.usualNaps == usualNaps)&&(identical(other.nightWakings, nightWakings) || other.nightWakings == nightWakings)&&const DeepCollectionEquality().equals(other._difficultTimes, _difficultTimes)&&const DeepCollectionEquality().equals(other._possibleTriggers, _possibleTriggers)&&(identical(other.completeStatus, completeStatus) || other.completeStatus == completeStatus));
}


@override
int get hashCode => Object.hashAll([runtimeType,currentPage,totalPages,parentName,parentRole,preferredLanguage,location,primaryConcern,const DeepCollectionEquality().hash(_concerns),isMoreThanOneSelected,successGoal,childName,dateOfBirth,childDob,childGender,usualWakeTime,usualBedtime,usualNaps,nightWakings,const DeepCollectionEquality().hash(_difficultTimes),const DeepCollectionEquality().hash(_possibleTriggers),completeStatus]);

@override
String toString() {
  return 'OnboardingState(currentPage: $currentPage, totalPages: $totalPages, parentName: $parentName, parentRole: $parentRole, preferredLanguage: $preferredLanguage, location: $location, primaryConcern: $primaryConcern, concerns: $concerns, isMoreThanOneSelected: $isMoreThanOneSelected, successGoal: $successGoal, childName: $childName, dateOfBirth: $dateOfBirth, childDob: $childDob, childGender: $childGender, usualWakeTime: $usualWakeTime, usualBedtime: $usualBedtime, usualNaps: $usualNaps, nightWakings: $nightWakings, difficultTimes: $difficultTimes, possibleTriggers: $possibleTriggers, completeStatus: $completeStatus)';
}


}

/// @nodoc
abstract mixin class _$OnboardingStateCopyWith<$Res> implements $OnboardingStateCopyWith<$Res> {
  factory _$OnboardingStateCopyWith(_OnboardingState value, $Res Function(_OnboardingState) _then) = __$OnboardingStateCopyWithImpl;
@override @useResult
$Res call({
 int currentPage, int totalPages, String parentName, String parentRole, String preferredLanguage, String location, String primaryConcern, List<String> concerns, bool isMoreThanOneSelected, String successGoal, String childName, String dateOfBirth, DateTime? childDob, String childGender, String usualWakeTime, String usualBedtime, int usualNaps, String nightWakings, List<String> difficultTimes, List<String> possibleTriggers, ApiResultStatus completeStatus
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get completeStatus;

}
/// @nodoc
class __$OnboardingStateCopyWithImpl<$Res>
    implements _$OnboardingStateCopyWith<$Res> {
  __$OnboardingStateCopyWithImpl(this._self, this._then);

  final _OnboardingState _self;
  final $Res Function(_OnboardingState) _then;

/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentPage = null,Object? totalPages = null,Object? parentName = null,Object? parentRole = null,Object? preferredLanguage = null,Object? location = null,Object? primaryConcern = null,Object? concerns = null,Object? isMoreThanOneSelected = null,Object? successGoal = null,Object? childName = null,Object? dateOfBirth = null,Object? childDob = freezed,Object? childGender = null,Object? usualWakeTime = null,Object? usualBedtime = null,Object? usualNaps = null,Object? nightWakings = null,Object? difficultTimes = null,Object? possibleTriggers = null,Object? completeStatus = null,}) {
  return _then(_OnboardingState(
currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,parentName: null == parentName ? _self.parentName : parentName // ignore: cast_nullable_to_non_nullable
as String,parentRole: null == parentRole ? _self.parentRole : parentRole // ignore: cast_nullable_to_non_nullable
as String,preferredLanguage: null == preferredLanguage ? _self.preferredLanguage : preferredLanguage // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,primaryConcern: null == primaryConcern ? _self.primaryConcern : primaryConcern // ignore: cast_nullable_to_non_nullable
as String,concerns: null == concerns ? _self._concerns : concerns // ignore: cast_nullable_to_non_nullable
as List<String>,isMoreThanOneSelected: null == isMoreThanOneSelected ? _self.isMoreThanOneSelected : isMoreThanOneSelected // ignore: cast_nullable_to_non_nullable
as bool,successGoal: null == successGoal ? _self.successGoal : successGoal // ignore: cast_nullable_to_non_nullable
as String,childName: null == childName ? _self.childName : childName // ignore: cast_nullable_to_non_nullable
as String,dateOfBirth: null == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as String,childDob: freezed == childDob ? _self.childDob : childDob // ignore: cast_nullable_to_non_nullable
as DateTime?,childGender: null == childGender ? _self.childGender : childGender // ignore: cast_nullable_to_non_nullable
as String,usualWakeTime: null == usualWakeTime ? _self.usualWakeTime : usualWakeTime // ignore: cast_nullable_to_non_nullable
as String,usualBedtime: null == usualBedtime ? _self.usualBedtime : usualBedtime // ignore: cast_nullable_to_non_nullable
as String,usualNaps: null == usualNaps ? _self.usualNaps : usualNaps // ignore: cast_nullable_to_non_nullable
as int,nightWakings: null == nightWakings ? _self.nightWakings : nightWakings // ignore: cast_nullable_to_non_nullable
as String,difficultTimes: null == difficultTimes ? _self._difficultTimes : difficultTimes // ignore: cast_nullable_to_non_nullable
as List<String>,possibleTriggers: null == possibleTriggers ? _self._possibleTriggers : possibleTriggers // ignore: cast_nullable_to_non_nullable
as List<String>,completeStatus: null == completeStatus ? _self.completeStatus : completeStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,
  ));
}

/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get completeStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.completeStatus, (value) {
    return _then(_self.copyWith(completeStatus: value));
  });
}
}

// dart format on
