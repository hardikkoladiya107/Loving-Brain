// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'consistency_recognition_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ConsistencyRecognitionState {

 int get daysCheckedIn; ChildModel? get child; ApiResultStatus<dynamic> get fetchStatus;
/// Create a copy of ConsistencyRecognitionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConsistencyRecognitionStateCopyWith<ConsistencyRecognitionState> get copyWith => _$ConsistencyRecognitionStateCopyWithImpl<ConsistencyRecognitionState>(this as ConsistencyRecognitionState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ConsistencyRecognitionState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConsistencyRecognitionState&&(identical(other.daysCheckedIn, _this.daysCheckedIn) || other.daysCheckedIn == _this.daysCheckedIn)&&(identical(other.child, _this.child) || other.child == _this.child)&&(identical(other.fetchStatus, _this.fetchStatus) || other.fetchStatus == _this.fetchStatus));
}


@override
int get hashCode {
  final _this = this as ConsistencyRecognitionState;
  return Object.hash(runtimeType,_this.daysCheckedIn,_this.child,_this.fetchStatus);
}

@override
String toString() {
  final _this = this as ConsistencyRecognitionState;
  return 'ConsistencyRecognitionState(daysCheckedIn: ${_this.daysCheckedIn}, child: ${_this.child}, fetchStatus: ${_this.fetchStatus})';
}


}

/// @nodoc
abstract mixin class $ConsistencyRecognitionStateCopyWith<$Res>  {
  factory $ConsistencyRecognitionStateCopyWith(ConsistencyRecognitionState value, $Res Function(ConsistencyRecognitionState) _then) = _$ConsistencyRecognitionStateCopyWithImpl;
@useResult
$Res call({
 int daysCheckedIn, ChildModel? child, ApiResultStatus<dynamic> fetchStatus
});


$ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus;

}
/// @nodoc
class _$ConsistencyRecognitionStateCopyWithImpl<$Res>
    implements $ConsistencyRecognitionStateCopyWith<$Res> {
  _$ConsistencyRecognitionStateCopyWithImpl(this._self, this._then);

  final ConsistencyRecognitionState _self;
  final $Res Function(ConsistencyRecognitionState) _then;

/// Create a copy of ConsistencyRecognitionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? daysCheckedIn = null,Object? child = freezed,Object? fetchStatus = null,}) {
  return _then(ConsistencyRecognitionState(
daysCheckedIn: null == daysCheckedIn ? _self.daysCheckedIn : daysCheckedIn // ignore: cast_nullable_to_non_nullable
as int,child: freezed == child ? _self.child : child // ignore: cast_nullable_to_non_nullable
as ChildModel?,fetchStatus: null == fetchStatus ? _self.fetchStatus : fetchStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}
/// Create a copy of ConsistencyRecognitionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.fetchStatus, (value) {
    return _then(_self.copyWith(fetchStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [ConsistencyRecognitionState].
extension ConsistencyRecognitionStatePatterns on ConsistencyRecognitionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConsistencyRecognitionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConsistencyRecognitionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConsistencyRecognitionState value)  $default,){
final _that = this;
switch (_that) {
case _ConsistencyRecognitionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConsistencyRecognitionState value)?  $default,){
final _that = this;
switch (_that) {
case _ConsistencyRecognitionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int daysCheckedIn,  ChildModel? child,  ApiResultStatus<dynamic> fetchStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConsistencyRecognitionState() when $default != null:
return $default(_that.daysCheckedIn,_that.child,_that.fetchStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int daysCheckedIn,  ChildModel? child,  ApiResultStatus<dynamic> fetchStatus)  $default,) {final _that = this;
switch (_that) {
case _ConsistencyRecognitionState():
return $default(_that.daysCheckedIn,_that.child,_that.fetchStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int daysCheckedIn,  ChildModel? child,  ApiResultStatus<dynamic> fetchStatus)?  $default,) {final _that = this;
switch (_that) {
case _ConsistencyRecognitionState() when $default != null:
return $default(_that.daysCheckedIn,_that.child,_that.fetchStatus);case _:
  return null;

}
}

}

/// @nodoc


class _ConsistencyRecognitionState implements ConsistencyRecognitionState {
  const _ConsistencyRecognitionState({this.daysCheckedIn = 5, this.child, this.fetchStatus = const ApiResultStatus.initial()});
  

@override@JsonKey() final  int daysCheckedIn;
@override final  ChildModel? child;
@override@JsonKey() final  ApiResultStatus<dynamic> fetchStatus;

/// Create a copy of ConsistencyRecognitionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConsistencyRecognitionStateCopyWith<_ConsistencyRecognitionState> get copyWith => __$ConsistencyRecognitionStateCopyWithImpl<_ConsistencyRecognitionState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConsistencyRecognitionState&&(identical(other.daysCheckedIn, daysCheckedIn) || other.daysCheckedIn == daysCheckedIn)&&(identical(other.child, child) || other.child == child)&&(identical(other.fetchStatus, fetchStatus) || other.fetchStatus == fetchStatus));
}


@override
int get hashCode {
    return Object.hash(runtimeType,daysCheckedIn,child,fetchStatus);
}

@override
String toString() {
    return 'ConsistencyRecognitionState(daysCheckedIn: $daysCheckedIn, child: $child, fetchStatus: $fetchStatus)';
}


}

/// @nodoc
abstract mixin class _$ConsistencyRecognitionStateCopyWith<$Res> implements $ConsistencyRecognitionStateCopyWith<$Res> {
  factory _$ConsistencyRecognitionStateCopyWith(_ConsistencyRecognitionState value, $Res Function(_ConsistencyRecognitionState) _then) = __$ConsistencyRecognitionStateCopyWithImpl;
@override @useResult
$Res call({
 int daysCheckedIn, ChildModel? child, ApiResultStatus<dynamic> fetchStatus
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus;

}
/// @nodoc
class __$ConsistencyRecognitionStateCopyWithImpl<$Res>
    implements _$ConsistencyRecognitionStateCopyWith<$Res> {
  __$ConsistencyRecognitionStateCopyWithImpl(this._self, this._then);

  final _ConsistencyRecognitionState _self;
  final $Res Function(_ConsistencyRecognitionState) _then;

/// Create a copy of ConsistencyRecognitionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? daysCheckedIn = null,Object? child = freezed,Object? fetchStatus = null,}) {
  return _then(_ConsistencyRecognitionState(
daysCheckedIn: null == daysCheckedIn ? _self.daysCheckedIn : daysCheckedIn // ignore: cast_nullable_to_non_nullable
as int,child: freezed == child ? _self.child : child // ignore: cast_nullable_to_non_nullable
as ChildModel?,fetchStatus: null == fetchStatus ? _self.fetchStatus : fetchStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}

/// Create a copy of ConsistencyRecognitionState
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
