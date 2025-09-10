// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfileState {

 bool get dailyEmotionCheck; bool get todaysPlayIdea; bool get scheduleReminder;
/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileStateCopyWith<ProfileState> get copyWith => _$ProfileStateCopyWithImpl<ProfileState>(this as ProfileState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileState&&(identical(other.dailyEmotionCheck, dailyEmotionCheck) || other.dailyEmotionCheck == dailyEmotionCheck)&&(identical(other.todaysPlayIdea, todaysPlayIdea) || other.todaysPlayIdea == todaysPlayIdea)&&(identical(other.scheduleReminder, scheduleReminder) || other.scheduleReminder == scheduleReminder));
}


@override
int get hashCode => Object.hash(runtimeType,dailyEmotionCheck,todaysPlayIdea,scheduleReminder);

@override
String toString() {
  return 'ProfileState(dailyEmotionCheck: $dailyEmotionCheck, todaysPlayIdea: $todaysPlayIdea, scheduleReminder: $scheduleReminder)';
}


}

/// @nodoc
abstract mixin class $ProfileStateCopyWith<$Res>  {
  factory $ProfileStateCopyWith(ProfileState value, $Res Function(ProfileState) _then) = _$ProfileStateCopyWithImpl;
@useResult
$Res call({
 bool dailyEmotionCheck, bool todaysPlayIdea, bool scheduleReminder
});




}
/// @nodoc
class _$ProfileStateCopyWithImpl<$Res>
    implements $ProfileStateCopyWith<$Res> {
  _$ProfileStateCopyWithImpl(this._self, this._then);

  final ProfileState _self;
  final $Res Function(ProfileState) _then;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dailyEmotionCheck = null,Object? todaysPlayIdea = null,Object? scheduleReminder = null,}) {
  return _then(_self.copyWith(
dailyEmotionCheck: null == dailyEmotionCheck ? _self.dailyEmotionCheck : dailyEmotionCheck // ignore: cast_nullable_to_non_nullable
as bool,todaysPlayIdea: null == todaysPlayIdea ? _self.todaysPlayIdea : todaysPlayIdea // ignore: cast_nullable_to_non_nullable
as bool,scheduleReminder: null == scheduleReminder ? _self.scheduleReminder : scheduleReminder // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileState].
extension ProfileStatePatterns on ProfileState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileState value)  $default,){
final _that = this;
switch (_that) {
case _ProfileState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileState value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool dailyEmotionCheck,  bool todaysPlayIdea,  bool scheduleReminder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileState() when $default != null:
return $default(_that.dailyEmotionCheck,_that.todaysPlayIdea,_that.scheduleReminder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool dailyEmotionCheck,  bool todaysPlayIdea,  bool scheduleReminder)  $default,) {final _that = this;
switch (_that) {
case _ProfileState():
return $default(_that.dailyEmotionCheck,_that.todaysPlayIdea,_that.scheduleReminder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool dailyEmotionCheck,  bool todaysPlayIdea,  bool scheduleReminder)?  $default,) {final _that = this;
switch (_that) {
case _ProfileState() when $default != null:
return $default(_that.dailyEmotionCheck,_that.todaysPlayIdea,_that.scheduleReminder);case _:
  return null;

}
}

}

/// @nodoc


class _ProfileState implements ProfileState {
  const _ProfileState({this.dailyEmotionCheck = false, this.todaysPlayIdea = false, this.scheduleReminder = false});
  

@override@JsonKey() final  bool dailyEmotionCheck;
@override@JsonKey() final  bool todaysPlayIdea;
@override@JsonKey() final  bool scheduleReminder;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileStateCopyWith<_ProfileState> get copyWith => __$ProfileStateCopyWithImpl<_ProfileState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileState&&(identical(other.dailyEmotionCheck, dailyEmotionCheck) || other.dailyEmotionCheck == dailyEmotionCheck)&&(identical(other.todaysPlayIdea, todaysPlayIdea) || other.todaysPlayIdea == todaysPlayIdea)&&(identical(other.scheduleReminder, scheduleReminder) || other.scheduleReminder == scheduleReminder));
}


@override
int get hashCode => Object.hash(runtimeType,dailyEmotionCheck,todaysPlayIdea,scheduleReminder);

@override
String toString() {
  return 'ProfileState(dailyEmotionCheck: $dailyEmotionCheck, todaysPlayIdea: $todaysPlayIdea, scheduleReminder: $scheduleReminder)';
}


}

/// @nodoc
abstract mixin class _$ProfileStateCopyWith<$Res> implements $ProfileStateCopyWith<$Res> {
  factory _$ProfileStateCopyWith(_ProfileState value, $Res Function(_ProfileState) _then) = __$ProfileStateCopyWithImpl;
@override @useResult
$Res call({
 bool dailyEmotionCheck, bool todaysPlayIdea, bool scheduleReminder
});




}
/// @nodoc
class __$ProfileStateCopyWithImpl<$Res>
    implements _$ProfileStateCopyWith<$Res> {
  __$ProfileStateCopyWithImpl(this._self, this._then);

  final _ProfileState _self;
  final $Res Function(_ProfileState) _then;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dailyEmotionCheck = null,Object? todaysPlayIdea = null,Object? scheduleReminder = null,}) {
  return _then(_ProfileState(
dailyEmotionCheck: null == dailyEmotionCheck ? _self.dailyEmotionCheck : dailyEmotionCheck // ignore: cast_nullable_to_non_nullable
as bool,todaysPlayIdea: null == todaysPlayIdea ? _self.todaysPlayIdea : todaysPlayIdea // ignore: cast_nullable_to_non_nullable
as bool,scheduleReminder: null == scheduleReminder ? _self.scheduleReminder : scheduleReminder // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
