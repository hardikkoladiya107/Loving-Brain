// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_preferences_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationPreferencesModel {

 bool get sleepReminders; bool get checkInReminders; bool get mentorshipUpdates; bool get weeklyReview; String get quietHoursStart; String get quietHoursEnd; int get maxDailyCap;
/// Create a copy of NotificationPreferencesModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationPreferencesModelCopyWith<NotificationPreferencesModel> get copyWith => _$NotificationPreferencesModelCopyWithImpl<NotificationPreferencesModel>(this as NotificationPreferencesModel, _$identity);

  /// Serializes this NotificationPreferencesModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NotificationPreferencesModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationPreferencesModel&&(identical(other.sleepReminders, _this.sleepReminders) || other.sleepReminders == _this.sleepReminders)&&(identical(other.checkInReminders, _this.checkInReminders) || other.checkInReminders == _this.checkInReminders)&&(identical(other.mentorshipUpdates, _this.mentorshipUpdates) || other.mentorshipUpdates == _this.mentorshipUpdates)&&(identical(other.weeklyReview, _this.weeklyReview) || other.weeklyReview == _this.weeklyReview)&&(identical(other.quietHoursStart, _this.quietHoursStart) || other.quietHoursStart == _this.quietHoursStart)&&(identical(other.quietHoursEnd, _this.quietHoursEnd) || other.quietHoursEnd == _this.quietHoursEnd)&&(identical(other.maxDailyCap, _this.maxDailyCap) || other.maxDailyCap == _this.maxDailyCap));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NotificationPreferencesModel;
  return Object.hash(runtimeType,_this.sleepReminders,_this.checkInReminders,_this.mentorshipUpdates,_this.weeklyReview,_this.quietHoursStart,_this.quietHoursEnd,_this.maxDailyCap);
}

@override
String toString() {
  final _this = this as NotificationPreferencesModel;
  return 'NotificationPreferencesModel(sleepReminders: ${_this.sleepReminders}, checkInReminders: ${_this.checkInReminders}, mentorshipUpdates: ${_this.mentorshipUpdates}, weeklyReview: ${_this.weeklyReview}, quietHoursStart: ${_this.quietHoursStart}, quietHoursEnd: ${_this.quietHoursEnd}, maxDailyCap: ${_this.maxDailyCap})';
}


}

/// @nodoc
abstract mixin class $NotificationPreferencesModelCopyWith<$Res>  {
  factory $NotificationPreferencesModelCopyWith(NotificationPreferencesModel value, $Res Function(NotificationPreferencesModel) _then) = _$NotificationPreferencesModelCopyWithImpl;
@useResult
$Res call({
 bool sleepReminders, bool checkInReminders, bool mentorshipUpdates, bool weeklyReview, String quietHoursStart, String quietHoursEnd, int maxDailyCap
});




}
/// @nodoc
class _$NotificationPreferencesModelCopyWithImpl<$Res>
    implements $NotificationPreferencesModelCopyWith<$Res> {
  _$NotificationPreferencesModelCopyWithImpl(this._self, this._then);

  final NotificationPreferencesModel _self;
  final $Res Function(NotificationPreferencesModel) _then;

/// Create a copy of NotificationPreferencesModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sleepReminders = null,Object? checkInReminders = null,Object? mentorshipUpdates = null,Object? weeklyReview = null,Object? quietHoursStart = null,Object? quietHoursEnd = null,Object? maxDailyCap = null,}) {
  return _then(NotificationPreferencesModel(
sleepReminders: null == sleepReminders ? _self.sleepReminders : sleepReminders // ignore: cast_nullable_to_non_nullable
as bool,checkInReminders: null == checkInReminders ? _self.checkInReminders : checkInReminders // ignore: cast_nullable_to_non_nullable
as bool,mentorshipUpdates: null == mentorshipUpdates ? _self.mentorshipUpdates : mentorshipUpdates // ignore: cast_nullable_to_non_nullable
as bool,weeklyReview: null == weeklyReview ? _self.weeklyReview : weeklyReview // ignore: cast_nullable_to_non_nullable
as bool,quietHoursStart: null == quietHoursStart ? _self.quietHoursStart : quietHoursStart // ignore: cast_nullable_to_non_nullable
as String,quietHoursEnd: null == quietHoursEnd ? _self.quietHoursEnd : quietHoursEnd // ignore: cast_nullable_to_non_nullable
as String,maxDailyCap: null == maxDailyCap ? _self.maxDailyCap : maxDailyCap // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationPreferencesModel].
extension NotificationPreferencesModelPatterns on NotificationPreferencesModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationPreferencesModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationPreferencesModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationPreferencesModel value)  $default,){
final _that = this;
switch (_that) {
case _NotificationPreferencesModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationPreferencesModel value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationPreferencesModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool sleepReminders,  bool checkInReminders,  bool mentorshipUpdates,  bool weeklyReview,  String quietHoursStart,  String quietHoursEnd,  int maxDailyCap)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationPreferencesModel() when $default != null:
return $default(_that.sleepReminders,_that.checkInReminders,_that.mentorshipUpdates,_that.weeklyReview,_that.quietHoursStart,_that.quietHoursEnd,_that.maxDailyCap);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool sleepReminders,  bool checkInReminders,  bool mentorshipUpdates,  bool weeklyReview,  String quietHoursStart,  String quietHoursEnd,  int maxDailyCap)  $default,) {final _that = this;
switch (_that) {
case _NotificationPreferencesModel():
return $default(_that.sleepReminders,_that.checkInReminders,_that.mentorshipUpdates,_that.weeklyReview,_that.quietHoursStart,_that.quietHoursEnd,_that.maxDailyCap);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool sleepReminders,  bool checkInReminders,  bool mentorshipUpdates,  bool weeklyReview,  String quietHoursStart,  String quietHoursEnd,  int maxDailyCap)?  $default,) {final _that = this;
switch (_that) {
case _NotificationPreferencesModel() when $default != null:
return $default(_that.sleepReminders,_that.checkInReminders,_that.mentorshipUpdates,_that.weeklyReview,_that.quietHoursStart,_that.quietHoursEnd,_that.maxDailyCap);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationPreferencesModel extends NotificationPreferencesModel {
  const _NotificationPreferencesModel({this.sleepReminders = true, this.checkInReminders = true, this.mentorshipUpdates = false, this.weeklyReview = true, this.quietHoursStart = '21:00', this.quietHoursEnd = '07:00', this.maxDailyCap = 3}): super._();
  factory _NotificationPreferencesModel.fromJson(Map<String, dynamic> json) => _$NotificationPreferencesModelFromJson(json);

@override@JsonKey() final  bool sleepReminders;
@override@JsonKey() final  bool checkInReminders;
@override@JsonKey() final  bool mentorshipUpdates;
@override@JsonKey() final  bool weeklyReview;
@override@JsonKey() final  String quietHoursStart;
@override@JsonKey() final  String quietHoursEnd;
@override@JsonKey() final  int maxDailyCap;

/// Create a copy of NotificationPreferencesModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationPreferencesModelCopyWith<_NotificationPreferencesModel> get copyWith => __$NotificationPreferencesModelCopyWithImpl<_NotificationPreferencesModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationPreferencesModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationPreferencesModel&&(identical(other.sleepReminders, sleepReminders) || other.sleepReminders == sleepReminders)&&(identical(other.checkInReminders, checkInReminders) || other.checkInReminders == checkInReminders)&&(identical(other.mentorshipUpdates, mentorshipUpdates) || other.mentorshipUpdates == mentorshipUpdates)&&(identical(other.weeklyReview, weeklyReview) || other.weeklyReview == weeklyReview)&&(identical(other.quietHoursStart, quietHoursStart) || other.quietHoursStart == quietHoursStart)&&(identical(other.quietHoursEnd, quietHoursEnd) || other.quietHoursEnd == quietHoursEnd)&&(identical(other.maxDailyCap, maxDailyCap) || other.maxDailyCap == maxDailyCap));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,sleepReminders,checkInReminders,mentorshipUpdates,weeklyReview,quietHoursStart,quietHoursEnd,maxDailyCap);
}

@override
String toString() {
    return 'NotificationPreferencesModel(sleepReminders: $sleepReminders, checkInReminders: $checkInReminders, mentorshipUpdates: $mentorshipUpdates, weeklyReview: $weeklyReview, quietHoursStart: $quietHoursStart, quietHoursEnd: $quietHoursEnd, maxDailyCap: $maxDailyCap)';
}


}

/// @nodoc
abstract mixin class _$NotificationPreferencesModelCopyWith<$Res> implements $NotificationPreferencesModelCopyWith<$Res> {
  factory _$NotificationPreferencesModelCopyWith(_NotificationPreferencesModel value, $Res Function(_NotificationPreferencesModel) _then) = __$NotificationPreferencesModelCopyWithImpl;
@override @useResult
$Res call({
 bool sleepReminders, bool checkInReminders, bool mentorshipUpdates, bool weeklyReview, String quietHoursStart, String quietHoursEnd, int maxDailyCap
});




}
/// @nodoc
class __$NotificationPreferencesModelCopyWithImpl<$Res>
    implements _$NotificationPreferencesModelCopyWith<$Res> {
  __$NotificationPreferencesModelCopyWithImpl(this._self, this._then);

  final _NotificationPreferencesModel _self;
  final $Res Function(_NotificationPreferencesModel) _then;

/// Create a copy of NotificationPreferencesModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sleepReminders = null,Object? checkInReminders = null,Object? mentorshipUpdates = null,Object? weeklyReview = null,Object? quietHoursStart = null,Object? quietHoursEnd = null,Object? maxDailyCap = null,}) {
  return _then(_NotificationPreferencesModel(
sleepReminders: null == sleepReminders ? _self.sleepReminders : sleepReminders // ignore: cast_nullable_to_non_nullable
as bool,checkInReminders: null == checkInReminders ? _self.checkInReminders : checkInReminders // ignore: cast_nullable_to_non_nullable
as bool,mentorshipUpdates: null == mentorshipUpdates ? _self.mentorshipUpdates : mentorshipUpdates // ignore: cast_nullable_to_non_nullable
as bool,weeklyReview: null == weeklyReview ? _self.weeklyReview : weeklyReview // ignore: cast_nullable_to_non_nullable
as bool,quietHoursStart: null == quietHoursStart ? _self.quietHoursStart : quietHoursStart // ignore: cast_nullable_to_non_nullable
as String,quietHoursEnd: null == quietHoursEnd ? _self.quietHoursEnd : quietHoursEnd // ignore: cast_nullable_to_non_nullable
as String,maxDailyCap: null == maxDailyCap ? _self.maxDailyCap : maxDailyCap // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
