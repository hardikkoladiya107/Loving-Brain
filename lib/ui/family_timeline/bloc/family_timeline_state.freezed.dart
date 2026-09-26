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

 List<TimelineEvent> get events;
/// Create a copy of FamilyTimelineState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FamilyTimelineStateCopyWith<FamilyTimelineState> get copyWith => _$FamilyTimelineStateCopyWithImpl<FamilyTimelineState>(this as FamilyTimelineState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FamilyTimelineState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FamilyTimelineState&&const DeepCollectionEquality().equals(other.events, _this.events));
}


@override
int get hashCode {
  final _this = this as FamilyTimelineState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.events));
}

@override
String toString() {
  final _this = this as FamilyTimelineState;
  return 'FamilyTimelineState(events: ${_this.events})';
}


}

/// @nodoc
abstract mixin class $FamilyTimelineStateCopyWith<$Res>  {
  factory $FamilyTimelineStateCopyWith(FamilyTimelineState value, $Res Function(FamilyTimelineState) _then) = _$FamilyTimelineStateCopyWithImpl;
@useResult
$Res call({
 List<TimelineEvent> events
});




}
/// @nodoc
class _$FamilyTimelineStateCopyWithImpl<$Res>
    implements $FamilyTimelineStateCopyWith<$Res> {
  _$FamilyTimelineStateCopyWithImpl(this._self, this._then);

  final FamilyTimelineState _self;
  final $Res Function(FamilyTimelineState) _then;

/// Create a copy of FamilyTimelineState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? events = null,}) {
  return _then(FamilyTimelineState(
events: null == events ? _self.events : events // ignore: cast_nullable_to_non_nullable
as List<TimelineEvent>,
  ));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TimelineEvent> events)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FamilyTimelineState() when $default != null:
return $default(_that.events);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TimelineEvent> events)  $default,) {final _that = this;
switch (_that) {
case _FamilyTimelineState():
return $default(_that.events);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TimelineEvent> events)?  $default,) {final _that = this;
switch (_that) {
case _FamilyTimelineState() when $default != null:
return $default(_that.events);case _:
  return null;

}
}

}

/// @nodoc


class _FamilyTimelineState implements FamilyTimelineState {
  const _FamilyTimelineState({ List<TimelineEvent> events = const []}): _events = events;
  

 final  List<TimelineEvent> _events;
@override@JsonKey() List<TimelineEvent> get events {
  if (_events is EqualUnmodifiableListView) return _events;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_events);
}


/// Create a copy of FamilyTimelineState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FamilyTimelineStateCopyWith<_FamilyTimelineState> get copyWith => __$FamilyTimelineStateCopyWithImpl<_FamilyTimelineState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FamilyTimelineState&&const DeepCollectionEquality().equals(other.events, _events));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_events));
}

@override
String toString() {
    return 'FamilyTimelineState(events: $events)';
}


}

/// @nodoc
abstract mixin class _$FamilyTimelineStateCopyWith<$Res> implements $FamilyTimelineStateCopyWith<$Res> {
  factory _$FamilyTimelineStateCopyWith(_FamilyTimelineState value, $Res Function(_FamilyTimelineState) _then) = __$FamilyTimelineStateCopyWithImpl;
@override @useResult
$Res call({
 List<TimelineEvent> events
});




}
/// @nodoc
class __$FamilyTimelineStateCopyWithImpl<$Res>
    implements _$FamilyTimelineStateCopyWith<$Res> {
  __$FamilyTimelineStateCopyWithImpl(this._self, this._then);

  final _FamilyTimelineState _self;
  final $Res Function(_FamilyTimelineState) _then;

/// Create a copy of FamilyTimelineState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? events = null,}) {
  return _then(_FamilyTimelineState(
events: null == events ? _self._events : events // ignore: cast_nullable_to_non_nullable
as List<TimelineEvent>,
  ));
}


}

// dart format on
