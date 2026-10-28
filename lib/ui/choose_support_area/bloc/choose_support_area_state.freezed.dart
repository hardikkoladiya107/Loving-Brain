// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'choose_support_area_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChooseSupportAreaState {

 int get selectedIndex; List<String> get areas;
/// Create a copy of ChooseSupportAreaState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChooseSupportAreaStateCopyWith<ChooseSupportAreaState> get copyWith => _$ChooseSupportAreaStateCopyWithImpl<ChooseSupportAreaState>(this as ChooseSupportAreaState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ChooseSupportAreaState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChooseSupportAreaState&&(identical(other.selectedIndex, _this.selectedIndex) || other.selectedIndex == _this.selectedIndex)&&const DeepCollectionEquality().equals(other.areas, _this.areas));
}


@override
int get hashCode {
  final _this = this as ChooseSupportAreaState;
  return Object.hash(runtimeType,_this.selectedIndex,const DeepCollectionEquality().hash(_this.areas));
}

@override
String toString() {
  final _this = this as ChooseSupportAreaState;
  return 'ChooseSupportAreaState(selectedIndex: ${_this.selectedIndex}, areas: ${_this.areas})';
}


}

/// @nodoc
abstract mixin class $ChooseSupportAreaStateCopyWith<$Res>  {
  factory $ChooseSupportAreaStateCopyWith(ChooseSupportAreaState value, $Res Function(ChooseSupportAreaState) _then) = _$ChooseSupportAreaStateCopyWithImpl;
@useResult
$Res call({
 int selectedIndex, List<String> areas
});




}
/// @nodoc
class _$ChooseSupportAreaStateCopyWithImpl<$Res>
    implements $ChooseSupportAreaStateCopyWith<$Res> {
  _$ChooseSupportAreaStateCopyWithImpl(this._self, this._then);

  final ChooseSupportAreaState _self;
  final $Res Function(ChooseSupportAreaState) _then;

/// Create a copy of ChooseSupportAreaState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selectedIndex = null,Object? areas = null,}) {
  return _then(ChooseSupportAreaState(
selectedIndex: null == selectedIndex ? _self.selectedIndex : selectedIndex // ignore: cast_nullable_to_non_nullable
as int,areas: null == areas ? _self.areas : areas // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ChooseSupportAreaState].
extension ChooseSupportAreaStatePatterns on ChooseSupportAreaState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChooseSupportAreaState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChooseSupportAreaState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChooseSupportAreaState value)  $default,){
final _that = this;
switch (_that) {
case _ChooseSupportAreaState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChooseSupportAreaState value)?  $default,){
final _that = this;
switch (_that) {
case _ChooseSupportAreaState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int selectedIndex,  List<String> areas)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChooseSupportAreaState() when $default != null:
return $default(_that.selectedIndex,_that.areas);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int selectedIndex,  List<String> areas)  $default,) {final _that = this;
switch (_that) {
case _ChooseSupportAreaState():
return $default(_that.selectedIndex,_that.areas);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int selectedIndex,  List<String> areas)?  $default,) {final _that = this;
switch (_that) {
case _ChooseSupportAreaState() when $default != null:
return $default(_that.selectedIndex,_that.areas);case _:
  return null;

}
}

}

/// @nodoc


class _ChooseSupportAreaState implements ChooseSupportAreaState {
  const _ChooseSupportAreaState({this.selectedIndex = -1,  List<String> areas = const <String>['Sleep', 'Behaviour', 'Parent Wellbeing', 'Co-parenting', 'General Parenting']}): _areas = areas;
  

@override@JsonKey() final  int selectedIndex;
 final  List<String> _areas;
@override@JsonKey() List<String> get areas {
  if (_areas is EqualUnmodifiableListView) return _areas;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_areas);
}


/// Create a copy of ChooseSupportAreaState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChooseSupportAreaStateCopyWith<_ChooseSupportAreaState> get copyWith => __$ChooseSupportAreaStateCopyWithImpl<_ChooseSupportAreaState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChooseSupportAreaState&&(identical(other.selectedIndex, selectedIndex) || other.selectedIndex == selectedIndex)&&const DeepCollectionEquality().equals(other.areas, _areas));
}


@override
int get hashCode {
    return Object.hash(runtimeType,selectedIndex,const DeepCollectionEquality().hash(_areas));
}

@override
String toString() {
    return 'ChooseSupportAreaState(selectedIndex: $selectedIndex, areas: $areas)';
}


}

/// @nodoc
abstract mixin class _$ChooseSupportAreaStateCopyWith<$Res> implements $ChooseSupportAreaStateCopyWith<$Res> {
  factory _$ChooseSupportAreaStateCopyWith(_ChooseSupportAreaState value, $Res Function(_ChooseSupportAreaState) _then) = __$ChooseSupportAreaStateCopyWithImpl;
@override @useResult
$Res call({
 int selectedIndex, List<String> areas
});




}
/// @nodoc
class __$ChooseSupportAreaStateCopyWithImpl<$Res>
    implements _$ChooseSupportAreaStateCopyWith<$Res> {
  __$ChooseSupportAreaStateCopyWithImpl(this._self, this._then);

  final _ChooseSupportAreaState _self;
  final $Res Function(_ChooseSupportAreaState) _then;

/// Create a copy of ChooseSupportAreaState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectedIndex = null,Object? areas = null,}) {
  return _then(_ChooseSupportAreaState(
selectedIndex: null == selectedIndex ? _self.selectedIndex : selectedIndex // ignore: cast_nullable_to_non_nullable
as int,areas: null == areas ? _self._areas : areas // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
