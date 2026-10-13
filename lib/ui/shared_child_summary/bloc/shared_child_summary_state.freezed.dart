// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shared_child_summary_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SharedChildSummaryState {

 bool get isLoading; String get childName; String get partnerName; String get todaysPlanTitle; String get todaysPlanSubtitle; List<HandoverLogItem> get recentUpdates; String get activeWeeklyFocus; String get handoverNote; ApiResultStatus<dynamic> get fetchStatus;
/// Create a copy of SharedChildSummaryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SharedChildSummaryStateCopyWith<SharedChildSummaryState> get copyWith => _$SharedChildSummaryStateCopyWithImpl<SharedChildSummaryState>(this as SharedChildSummaryState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SharedChildSummaryState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SharedChildSummaryState&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.childName, _this.childName) || other.childName == _this.childName)&&(identical(other.partnerName, _this.partnerName) || other.partnerName == _this.partnerName)&&(identical(other.todaysPlanTitle, _this.todaysPlanTitle) || other.todaysPlanTitle == _this.todaysPlanTitle)&&(identical(other.todaysPlanSubtitle, _this.todaysPlanSubtitle) || other.todaysPlanSubtitle == _this.todaysPlanSubtitle)&&const DeepCollectionEquality().equals(other.recentUpdates, _this.recentUpdates)&&(identical(other.activeWeeklyFocus, _this.activeWeeklyFocus) || other.activeWeeklyFocus == _this.activeWeeklyFocus)&&(identical(other.handoverNote, _this.handoverNote) || other.handoverNote == _this.handoverNote)&&(identical(other.fetchStatus, _this.fetchStatus) || other.fetchStatus == _this.fetchStatus));
}


@override
int get hashCode {
  final _this = this as SharedChildSummaryState;
  return Object.hash(runtimeType,_this.isLoading,_this.childName,_this.partnerName,_this.todaysPlanTitle,_this.todaysPlanSubtitle,const DeepCollectionEquality().hash(_this.recentUpdates),_this.activeWeeklyFocus,_this.handoverNote,_this.fetchStatus);
}

@override
String toString() {
  final _this = this as SharedChildSummaryState;
  return 'SharedChildSummaryState(isLoading: ${_this.isLoading}, childName: ${_this.childName}, partnerName: ${_this.partnerName}, todaysPlanTitle: ${_this.todaysPlanTitle}, todaysPlanSubtitle: ${_this.todaysPlanSubtitle}, recentUpdates: ${_this.recentUpdates}, activeWeeklyFocus: ${_this.activeWeeklyFocus}, handoverNote: ${_this.handoverNote}, fetchStatus: ${_this.fetchStatus})';
}


}

/// @nodoc
abstract mixin class $SharedChildSummaryStateCopyWith<$Res>  {
  factory $SharedChildSummaryStateCopyWith(SharedChildSummaryState value, $Res Function(SharedChildSummaryState) _then) = _$SharedChildSummaryStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, String childName, String partnerName, String todaysPlanTitle, String todaysPlanSubtitle, List<HandoverLogItem> recentUpdates, String activeWeeklyFocus, String handoverNote, ApiResultStatus<dynamic> fetchStatus
});


$ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus;

}
/// @nodoc
class _$SharedChildSummaryStateCopyWithImpl<$Res>
    implements $SharedChildSummaryStateCopyWith<$Res> {
  _$SharedChildSummaryStateCopyWithImpl(this._self, this._then);

  final SharedChildSummaryState _self;
  final $Res Function(SharedChildSummaryState) _then;

/// Create a copy of SharedChildSummaryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? childName = null,Object? partnerName = null,Object? todaysPlanTitle = null,Object? todaysPlanSubtitle = null,Object? recentUpdates = null,Object? activeWeeklyFocus = null,Object? handoverNote = null,Object? fetchStatus = null,}) {
  return _then(SharedChildSummaryState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,childName: null == childName ? _self.childName : childName // ignore: cast_nullable_to_non_nullable
as String,partnerName: null == partnerName ? _self.partnerName : partnerName // ignore: cast_nullable_to_non_nullable
as String,todaysPlanTitle: null == todaysPlanTitle ? _self.todaysPlanTitle : todaysPlanTitle // ignore: cast_nullable_to_non_nullable
as String,todaysPlanSubtitle: null == todaysPlanSubtitle ? _self.todaysPlanSubtitle : todaysPlanSubtitle // ignore: cast_nullable_to_non_nullable
as String,recentUpdates: null == recentUpdates ? _self.recentUpdates : recentUpdates // ignore: cast_nullable_to_non_nullable
as List<HandoverLogItem>,activeWeeklyFocus: null == activeWeeklyFocus ? _self.activeWeeklyFocus : activeWeeklyFocus // ignore: cast_nullable_to_non_nullable
as String,handoverNote: null == handoverNote ? _self.handoverNote : handoverNote // ignore: cast_nullable_to_non_nullable
as String,fetchStatus: null == fetchStatus ? _self.fetchStatus : fetchStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}
/// Create a copy of SharedChildSummaryState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.fetchStatus, (value) {
    return _then(_self.copyWith(fetchStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [SharedChildSummaryState].
extension SharedChildSummaryStatePatterns on SharedChildSummaryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SharedChildSummaryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SharedChildSummaryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SharedChildSummaryState value)  $default,){
final _that = this;
switch (_that) {
case _SharedChildSummaryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SharedChildSummaryState value)?  $default,){
final _that = this;
switch (_that) {
case _SharedChildSummaryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  String childName,  String partnerName,  String todaysPlanTitle,  String todaysPlanSubtitle,  List<HandoverLogItem> recentUpdates,  String activeWeeklyFocus,  String handoverNote,  ApiResultStatus<dynamic> fetchStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SharedChildSummaryState() when $default != null:
return $default(_that.isLoading,_that.childName,_that.partnerName,_that.todaysPlanTitle,_that.todaysPlanSubtitle,_that.recentUpdates,_that.activeWeeklyFocus,_that.handoverNote,_that.fetchStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  String childName,  String partnerName,  String todaysPlanTitle,  String todaysPlanSubtitle,  List<HandoverLogItem> recentUpdates,  String activeWeeklyFocus,  String handoverNote,  ApiResultStatus<dynamic> fetchStatus)  $default,) {final _that = this;
switch (_that) {
case _SharedChildSummaryState():
return $default(_that.isLoading,_that.childName,_that.partnerName,_that.todaysPlanTitle,_that.todaysPlanSubtitle,_that.recentUpdates,_that.activeWeeklyFocus,_that.handoverNote,_that.fetchStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  String childName,  String partnerName,  String todaysPlanTitle,  String todaysPlanSubtitle,  List<HandoverLogItem> recentUpdates,  String activeWeeklyFocus,  String handoverNote,  ApiResultStatus<dynamic> fetchStatus)?  $default,) {final _that = this;
switch (_that) {
case _SharedChildSummaryState() when $default != null:
return $default(_that.isLoading,_that.childName,_that.partnerName,_that.todaysPlanTitle,_that.todaysPlanSubtitle,_that.recentUpdates,_that.activeWeeklyFocus,_that.handoverNote,_that.fetchStatus);case _:
  return null;

}
}

}

/// @nodoc


class _SharedChildSummaryState implements SharedChildSummaryState {
  const _SharedChildSummaryState({this.isLoading = false, this.childName = 'your child', this.partnerName = 'Ravi', this.todaysPlanTitle = 'Wind-down at 7:30 PM', this.todaysPlanSubtitle = 'Sleep window 7:45 – 8:15 PM.',  List<HandoverLogItem> recentUpdates = const <HandoverLogItem>[HandoverLogItem(authorName: 'Ravi', isPartner: true, actionDescription: 'logged a nap', timeAgo: '3h ago'), HandoverLogItem(authorName: 'You', isPartner: false, actionDescription: 'logged bedtime', timeAgo: 'yesterday')], this.activeWeeklyFocus = 'Move bedtime 15 minutes earlier and protect calm wind-down.', this.handoverNote = 'Both seeing the same picture. Health notes and private reflections remain private by default.', this.fetchStatus = const ApiResultStatus.initial()}): _recentUpdates = recentUpdates;
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  String childName;
@override@JsonKey() final  String partnerName;
@override@JsonKey() final  String todaysPlanTitle;
@override@JsonKey() final  String todaysPlanSubtitle;
 final  List<HandoverLogItem> _recentUpdates;
@override@JsonKey() List<HandoverLogItem> get recentUpdates {
  if (_recentUpdates is EqualUnmodifiableListView) return _recentUpdates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentUpdates);
}

@override@JsonKey() final  String activeWeeklyFocus;
@override@JsonKey() final  String handoverNote;
@override@JsonKey() final  ApiResultStatus<dynamic> fetchStatus;

/// Create a copy of SharedChildSummaryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SharedChildSummaryStateCopyWith<_SharedChildSummaryState> get copyWith => __$SharedChildSummaryStateCopyWithImpl<_SharedChildSummaryState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SharedChildSummaryState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.childName, childName) || other.childName == childName)&&(identical(other.partnerName, partnerName) || other.partnerName == partnerName)&&(identical(other.todaysPlanTitle, todaysPlanTitle) || other.todaysPlanTitle == todaysPlanTitle)&&(identical(other.todaysPlanSubtitle, todaysPlanSubtitle) || other.todaysPlanSubtitle == todaysPlanSubtitle)&&const DeepCollectionEquality().equals(other.recentUpdates, _recentUpdates)&&(identical(other.activeWeeklyFocus, activeWeeklyFocus) || other.activeWeeklyFocus == activeWeeklyFocus)&&(identical(other.handoverNote, handoverNote) || other.handoverNote == handoverNote)&&(identical(other.fetchStatus, fetchStatus) || other.fetchStatus == fetchStatus));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isLoading,childName,partnerName,todaysPlanTitle,todaysPlanSubtitle,const DeepCollectionEquality().hash(_recentUpdates),activeWeeklyFocus,handoverNote,fetchStatus);
}

@override
String toString() {
    return 'SharedChildSummaryState(isLoading: $isLoading, childName: $childName, partnerName: $partnerName, todaysPlanTitle: $todaysPlanTitle, todaysPlanSubtitle: $todaysPlanSubtitle, recentUpdates: $recentUpdates, activeWeeklyFocus: $activeWeeklyFocus, handoverNote: $handoverNote, fetchStatus: $fetchStatus)';
}


}

/// @nodoc
abstract mixin class _$SharedChildSummaryStateCopyWith<$Res> implements $SharedChildSummaryStateCopyWith<$Res> {
  factory _$SharedChildSummaryStateCopyWith(_SharedChildSummaryState value, $Res Function(_SharedChildSummaryState) _then) = __$SharedChildSummaryStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, String childName, String partnerName, String todaysPlanTitle, String todaysPlanSubtitle, List<HandoverLogItem> recentUpdates, String activeWeeklyFocus, String handoverNote, ApiResultStatus<dynamic> fetchStatus
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus;

}
/// @nodoc
class __$SharedChildSummaryStateCopyWithImpl<$Res>
    implements _$SharedChildSummaryStateCopyWith<$Res> {
  __$SharedChildSummaryStateCopyWithImpl(this._self, this._then);

  final _SharedChildSummaryState _self;
  final $Res Function(_SharedChildSummaryState) _then;

/// Create a copy of SharedChildSummaryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? childName = null,Object? partnerName = null,Object? todaysPlanTitle = null,Object? todaysPlanSubtitle = null,Object? recentUpdates = null,Object? activeWeeklyFocus = null,Object? handoverNote = null,Object? fetchStatus = null,}) {
  return _then(_SharedChildSummaryState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,childName: null == childName ? _self.childName : childName // ignore: cast_nullable_to_non_nullable
as String,partnerName: null == partnerName ? _self.partnerName : partnerName // ignore: cast_nullable_to_non_nullable
as String,todaysPlanTitle: null == todaysPlanTitle ? _self.todaysPlanTitle : todaysPlanTitle // ignore: cast_nullable_to_non_nullable
as String,todaysPlanSubtitle: null == todaysPlanSubtitle ? _self.todaysPlanSubtitle : todaysPlanSubtitle // ignore: cast_nullable_to_non_nullable
as String,recentUpdates: null == recentUpdates ? _self._recentUpdates : recentUpdates // ignore: cast_nullable_to_non_nullable
as List<HandoverLogItem>,activeWeeklyFocus: null == activeWeeklyFocus ? _self.activeWeeklyFocus : activeWeeklyFocus // ignore: cast_nullable_to_non_nullable
as String,handoverNote: null == handoverNote ? _self.handoverNote : handoverNote // ignore: cast_nullable_to_non_nullable
as String,fetchStatus: null == fetchStatus ? _self.fetchStatus : fetchStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}

/// Create a copy of SharedChildSummaryState
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
