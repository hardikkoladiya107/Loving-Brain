// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'brainy_home_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BrainyHomeState {

 String get selectedTopic;
/// Create a copy of BrainyHomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BrainyHomeStateCopyWith<BrainyHomeState> get copyWith => _$BrainyHomeStateCopyWithImpl<BrainyHomeState>(this as BrainyHomeState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BrainyHomeState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BrainyHomeState&&(identical(other.selectedTopic, _this.selectedTopic) || other.selectedTopic == _this.selectedTopic));
}


@override
int get hashCode {
  final _this = this as BrainyHomeState;
  return Object.hash(runtimeType,_this.selectedTopic);
}

@override
String toString() {
  final _this = this as BrainyHomeState;
  return 'BrainyHomeState(selectedTopic: ${_this.selectedTopic})';
}


}

/// @nodoc
abstract mixin class $BrainyHomeStateCopyWith<$Res>  {
  factory $BrainyHomeStateCopyWith(BrainyHomeState value, $Res Function(BrainyHomeState) _then) = _$BrainyHomeStateCopyWithImpl;
@useResult
$Res call({
 String selectedTopic
});




}
/// @nodoc
class _$BrainyHomeStateCopyWithImpl<$Res>
    implements $BrainyHomeStateCopyWith<$Res> {
  _$BrainyHomeStateCopyWithImpl(this._self, this._then);

  final BrainyHomeState _self;
  final $Res Function(BrainyHomeState) _then;

/// Create a copy of BrainyHomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selectedTopic = null,}) {
  return _then(BrainyHomeState(
selectedTopic: null == selectedTopic ? _self.selectedTopic : selectedTopic // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BrainyHomeState].
extension BrainyHomeStatePatterns on BrainyHomeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BrainyHomeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BrainyHomeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BrainyHomeState value)  $default,){
final _that = this;
switch (_that) {
case _BrainyHomeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BrainyHomeState value)?  $default,){
final _that = this;
switch (_that) {
case _BrainyHomeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String selectedTopic)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BrainyHomeState() when $default != null:
return $default(_that.selectedTopic);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String selectedTopic)  $default,) {final _that = this;
switch (_that) {
case _BrainyHomeState():
return $default(_that.selectedTopic);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String selectedTopic)?  $default,) {final _that = this;
switch (_that) {
case _BrainyHomeState() when $default != null:
return $default(_that.selectedTopic);case _:
  return null;

}
}

}

/// @nodoc


class _BrainyHomeState implements BrainyHomeState {
  const _BrainyHomeState({this.selectedTopic = 'Behaviour'});
  

@override@JsonKey() final  String selectedTopic;

/// Create a copy of BrainyHomeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BrainyHomeStateCopyWith<_BrainyHomeState> get copyWith => __$BrainyHomeStateCopyWithImpl<_BrainyHomeState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BrainyHomeState&&(identical(other.selectedTopic, selectedTopic) || other.selectedTopic == selectedTopic));
}


@override
int get hashCode {
    return Object.hash(runtimeType,selectedTopic);
}

@override
String toString() {
    return 'BrainyHomeState(selectedTopic: $selectedTopic)';
}


}

/// @nodoc
abstract mixin class _$BrainyHomeStateCopyWith<$Res> implements $BrainyHomeStateCopyWith<$Res> {
  factory _$BrainyHomeStateCopyWith(_BrainyHomeState value, $Res Function(_BrainyHomeState) _then) = __$BrainyHomeStateCopyWithImpl;
@override @useResult
$Res call({
 String selectedTopic
});




}
/// @nodoc
class __$BrainyHomeStateCopyWithImpl<$Res>
    implements _$BrainyHomeStateCopyWith<$Res> {
  __$BrainyHomeStateCopyWithImpl(this._self, this._then);

  final _BrainyHomeState _self;
  final $Res Function(_BrainyHomeState) _then;

/// Create a copy of BrainyHomeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectedTopic = null,}) {
  return _then(_BrainyHomeState(
selectedTopic: null == selectedTopic ? _self.selectedTopic : selectedTopic // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
