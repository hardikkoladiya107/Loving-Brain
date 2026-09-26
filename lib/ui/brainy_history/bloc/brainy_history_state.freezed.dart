// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'brainy_history_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BrainyHistoryState {

 List<BrainyHistoryItem> get thisWeekHistory; List<BrainyHistoryItem> get earlierHistory;
/// Create a copy of BrainyHistoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BrainyHistoryStateCopyWith<BrainyHistoryState> get copyWith => _$BrainyHistoryStateCopyWithImpl<BrainyHistoryState>(this as BrainyHistoryState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BrainyHistoryState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BrainyHistoryState&&const DeepCollectionEquality().equals(other.thisWeekHistory, _this.thisWeekHistory)&&const DeepCollectionEquality().equals(other.earlierHistory, _this.earlierHistory));
}


@override
int get hashCode {
  final _this = this as BrainyHistoryState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.thisWeekHistory),const DeepCollectionEquality().hash(_this.earlierHistory));
}

@override
String toString() {
  final _this = this as BrainyHistoryState;
  return 'BrainyHistoryState(thisWeekHistory: ${_this.thisWeekHistory}, earlierHistory: ${_this.earlierHistory})';
}


}

/// @nodoc
abstract mixin class $BrainyHistoryStateCopyWith<$Res>  {
  factory $BrainyHistoryStateCopyWith(BrainyHistoryState value, $Res Function(BrainyHistoryState) _then) = _$BrainyHistoryStateCopyWithImpl;
@useResult
$Res call({
 List<BrainyHistoryItem> thisWeekHistory, List<BrainyHistoryItem> earlierHistory
});




}
/// @nodoc
class _$BrainyHistoryStateCopyWithImpl<$Res>
    implements $BrainyHistoryStateCopyWith<$Res> {
  _$BrainyHistoryStateCopyWithImpl(this._self, this._then);

  final BrainyHistoryState _self;
  final $Res Function(BrainyHistoryState) _then;

/// Create a copy of BrainyHistoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? thisWeekHistory = null,Object? earlierHistory = null,}) {
  return _then(BrainyHistoryState(
thisWeekHistory: null == thisWeekHistory ? _self.thisWeekHistory : thisWeekHistory // ignore: cast_nullable_to_non_nullable
as List<BrainyHistoryItem>,earlierHistory: null == earlierHistory ? _self.earlierHistory : earlierHistory // ignore: cast_nullable_to_non_nullable
as List<BrainyHistoryItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [BrainyHistoryState].
extension BrainyHistoryStatePatterns on BrainyHistoryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BrainyHistoryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BrainyHistoryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BrainyHistoryState value)  $default,){
final _that = this;
switch (_that) {
case _BrainyHistoryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BrainyHistoryState value)?  $default,){
final _that = this;
switch (_that) {
case _BrainyHistoryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<BrainyHistoryItem> thisWeekHistory,  List<BrainyHistoryItem> earlierHistory)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BrainyHistoryState() when $default != null:
return $default(_that.thisWeekHistory,_that.earlierHistory);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<BrainyHistoryItem> thisWeekHistory,  List<BrainyHistoryItem> earlierHistory)  $default,) {final _that = this;
switch (_that) {
case _BrainyHistoryState():
return $default(_that.thisWeekHistory,_that.earlierHistory);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<BrainyHistoryItem> thisWeekHistory,  List<BrainyHistoryItem> earlierHistory)?  $default,) {final _that = this;
switch (_that) {
case _BrainyHistoryState() when $default != null:
return $default(_that.thisWeekHistory,_that.earlierHistory);case _:
  return null;

}
}

}

/// @nodoc


class _BrainyHistoryState implements BrainyHistoryState {
  const _BrainyHistoryState({ List<BrainyHistoryItem> thisWeekHistory = const [],  List<BrainyHistoryItem> earlierHistory = const []}): _thisWeekHistory = thisWeekHistory,_earlierHistory = earlierHistory;
  

 final  List<BrainyHistoryItem> _thisWeekHistory;
@override@JsonKey() List<BrainyHistoryItem> get thisWeekHistory {
  if (_thisWeekHistory is EqualUnmodifiableListView) return _thisWeekHistory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_thisWeekHistory);
}

 final  List<BrainyHistoryItem> _earlierHistory;
@override@JsonKey() List<BrainyHistoryItem> get earlierHistory {
  if (_earlierHistory is EqualUnmodifiableListView) return _earlierHistory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_earlierHistory);
}


/// Create a copy of BrainyHistoryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BrainyHistoryStateCopyWith<_BrainyHistoryState> get copyWith => __$BrainyHistoryStateCopyWithImpl<_BrainyHistoryState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BrainyHistoryState&&const DeepCollectionEquality().equals(other.thisWeekHistory, _thisWeekHistory)&&const DeepCollectionEquality().equals(other.earlierHistory, _earlierHistory));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_thisWeekHistory),const DeepCollectionEquality().hash(_earlierHistory));
}

@override
String toString() {
    return 'BrainyHistoryState(thisWeekHistory: $thisWeekHistory, earlierHistory: $earlierHistory)';
}


}

/// @nodoc
abstract mixin class _$BrainyHistoryStateCopyWith<$Res> implements $BrainyHistoryStateCopyWith<$Res> {
  factory _$BrainyHistoryStateCopyWith(_BrainyHistoryState value, $Res Function(_BrainyHistoryState) _then) = __$BrainyHistoryStateCopyWithImpl;
@override @useResult
$Res call({
 List<BrainyHistoryItem> thisWeekHistory, List<BrainyHistoryItem> earlierHistory
});




}
/// @nodoc
class __$BrainyHistoryStateCopyWithImpl<$Res>
    implements _$BrainyHistoryStateCopyWith<$Res> {
  __$BrainyHistoryStateCopyWithImpl(this._self, this._then);

  final _BrainyHistoryState _self;
  final $Res Function(_BrainyHistoryState) _then;

/// Create a copy of BrainyHistoryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? thisWeekHistory = null,Object? earlierHistory = null,}) {
  return _then(_BrainyHistoryState(
thisWeekHistory: null == thisWeekHistory ? _self._thisWeekHistory : thisWeekHistory // ignore: cast_nullable_to_non_nullable
as List<BrainyHistoryItem>,earlierHistory: null == earlierHistory ? _self._earlierHistory : earlierHistory // ignore: cast_nullable_to_non_nullable
as List<BrainyHistoryItem>,
  ));
}


}

// dart format on
