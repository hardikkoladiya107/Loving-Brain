// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'brainy_saved_guidance_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BrainySavedGuidanceState {

 List<BrainySavedItem> get sleepItems; List<BrainySavedItem> get behaviourItems; List<BrainySavedItem> get parentWellbeingItems;
/// Create a copy of BrainySavedGuidanceState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BrainySavedGuidanceStateCopyWith<BrainySavedGuidanceState> get copyWith => _$BrainySavedGuidanceStateCopyWithImpl<BrainySavedGuidanceState>(this as BrainySavedGuidanceState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BrainySavedGuidanceState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BrainySavedGuidanceState&&const DeepCollectionEquality().equals(other.sleepItems, _this.sleepItems)&&const DeepCollectionEquality().equals(other.behaviourItems, _this.behaviourItems)&&const DeepCollectionEquality().equals(other.parentWellbeingItems, _this.parentWellbeingItems));
}


@override
int get hashCode {
  final _this = this as BrainySavedGuidanceState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.sleepItems),const DeepCollectionEquality().hash(_this.behaviourItems),const DeepCollectionEquality().hash(_this.parentWellbeingItems));
}

@override
String toString() {
  final _this = this as BrainySavedGuidanceState;
  return 'BrainySavedGuidanceState(sleepItems: ${_this.sleepItems}, behaviourItems: ${_this.behaviourItems}, parentWellbeingItems: ${_this.parentWellbeingItems})';
}


}

/// @nodoc
abstract mixin class $BrainySavedGuidanceStateCopyWith<$Res>  {
  factory $BrainySavedGuidanceStateCopyWith(BrainySavedGuidanceState value, $Res Function(BrainySavedGuidanceState) _then) = _$BrainySavedGuidanceStateCopyWithImpl;
@useResult
$Res call({
 List<BrainySavedItem> sleepItems, List<BrainySavedItem> behaviourItems, List<BrainySavedItem> parentWellbeingItems
});




}
/// @nodoc
class _$BrainySavedGuidanceStateCopyWithImpl<$Res>
    implements $BrainySavedGuidanceStateCopyWith<$Res> {
  _$BrainySavedGuidanceStateCopyWithImpl(this._self, this._then);

  final BrainySavedGuidanceState _self;
  final $Res Function(BrainySavedGuidanceState) _then;

/// Create a copy of BrainySavedGuidanceState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sleepItems = null,Object? behaviourItems = null,Object? parentWellbeingItems = null,}) {
  return _then(BrainySavedGuidanceState(
sleepItems: null == sleepItems ? _self.sleepItems : sleepItems // ignore: cast_nullable_to_non_nullable
as List<BrainySavedItem>,behaviourItems: null == behaviourItems ? _self.behaviourItems : behaviourItems // ignore: cast_nullable_to_non_nullable
as List<BrainySavedItem>,parentWellbeingItems: null == parentWellbeingItems ? _self.parentWellbeingItems : parentWellbeingItems // ignore: cast_nullable_to_non_nullable
as List<BrainySavedItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [BrainySavedGuidanceState].
extension BrainySavedGuidanceStatePatterns on BrainySavedGuidanceState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BrainySavedGuidanceState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BrainySavedGuidanceState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BrainySavedGuidanceState value)  $default,){
final _that = this;
switch (_that) {
case _BrainySavedGuidanceState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BrainySavedGuidanceState value)?  $default,){
final _that = this;
switch (_that) {
case _BrainySavedGuidanceState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<BrainySavedItem> sleepItems,  List<BrainySavedItem> behaviourItems,  List<BrainySavedItem> parentWellbeingItems)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BrainySavedGuidanceState() when $default != null:
return $default(_that.sleepItems,_that.behaviourItems,_that.parentWellbeingItems);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<BrainySavedItem> sleepItems,  List<BrainySavedItem> behaviourItems,  List<BrainySavedItem> parentWellbeingItems)  $default,) {final _that = this;
switch (_that) {
case _BrainySavedGuidanceState():
return $default(_that.sleepItems,_that.behaviourItems,_that.parentWellbeingItems);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<BrainySavedItem> sleepItems,  List<BrainySavedItem> behaviourItems,  List<BrainySavedItem> parentWellbeingItems)?  $default,) {final _that = this;
switch (_that) {
case _BrainySavedGuidanceState() when $default != null:
return $default(_that.sleepItems,_that.behaviourItems,_that.parentWellbeingItems);case _:
  return null;

}
}

}

/// @nodoc


class _BrainySavedGuidanceState implements BrainySavedGuidanceState {
  const _BrainySavedGuidanceState({ List<BrainySavedItem> sleepItems = const [],  List<BrainySavedItem> behaviourItems = const [],  List<BrainySavedItem> parentWellbeingItems = const []}): _sleepItems = sleepItems,_behaviourItems = behaviourItems,_parentWellbeingItems = parentWellbeingItems;
  

 final  List<BrainySavedItem> _sleepItems;
@override@JsonKey() List<BrainySavedItem> get sleepItems {
  if (_sleepItems is EqualUnmodifiableListView) return _sleepItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sleepItems);
}

 final  List<BrainySavedItem> _behaviourItems;
@override@JsonKey() List<BrainySavedItem> get behaviourItems {
  if (_behaviourItems is EqualUnmodifiableListView) return _behaviourItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_behaviourItems);
}

 final  List<BrainySavedItem> _parentWellbeingItems;
@override@JsonKey() List<BrainySavedItem> get parentWellbeingItems {
  if (_parentWellbeingItems is EqualUnmodifiableListView) return _parentWellbeingItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_parentWellbeingItems);
}


/// Create a copy of BrainySavedGuidanceState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BrainySavedGuidanceStateCopyWith<_BrainySavedGuidanceState> get copyWith => __$BrainySavedGuidanceStateCopyWithImpl<_BrainySavedGuidanceState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BrainySavedGuidanceState&&const DeepCollectionEquality().equals(other.sleepItems, _sleepItems)&&const DeepCollectionEquality().equals(other.behaviourItems, _behaviourItems)&&const DeepCollectionEquality().equals(other.parentWellbeingItems, _parentWellbeingItems));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_sleepItems),const DeepCollectionEquality().hash(_behaviourItems),const DeepCollectionEquality().hash(_parentWellbeingItems));
}

@override
String toString() {
    return 'BrainySavedGuidanceState(sleepItems: $sleepItems, behaviourItems: $behaviourItems, parentWellbeingItems: $parentWellbeingItems)';
}


}

/// @nodoc
abstract mixin class _$BrainySavedGuidanceStateCopyWith<$Res> implements $BrainySavedGuidanceStateCopyWith<$Res> {
  factory _$BrainySavedGuidanceStateCopyWith(_BrainySavedGuidanceState value, $Res Function(_BrainySavedGuidanceState) _then) = __$BrainySavedGuidanceStateCopyWithImpl;
@override @useResult
$Res call({
 List<BrainySavedItem> sleepItems, List<BrainySavedItem> behaviourItems, List<BrainySavedItem> parentWellbeingItems
});




}
/// @nodoc
class __$BrainySavedGuidanceStateCopyWithImpl<$Res>
    implements _$BrainySavedGuidanceStateCopyWith<$Res> {
  __$BrainySavedGuidanceStateCopyWithImpl(this._self, this._then);

  final _BrainySavedGuidanceState _self;
  final $Res Function(_BrainySavedGuidanceState) _then;

/// Create a copy of BrainySavedGuidanceState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sleepItems = null,Object? behaviourItems = null,Object? parentWellbeingItems = null,}) {
  return _then(_BrainySavedGuidanceState(
sleepItems: null == sleepItems ? _self._sleepItems : sleepItems // ignore: cast_nullable_to_non_nullable
as List<BrainySavedItem>,behaviourItems: null == behaviourItems ? _self._behaviourItems : behaviourItems // ignore: cast_nullable_to_non_nullable
as List<BrainySavedItem>,parentWellbeingItems: null == parentWellbeingItems ? _self._parentWellbeingItems : parentWellbeingItems // ignore: cast_nullable_to_non_nullable
as List<BrainySavedItem>,
  ));
}


}

// dart format on
