// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mentorship_landing_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MentorshipLandingState {

 bool get isLoading; bool get isAvailable; List<String> get supportAreas; ApiResultStatus<dynamic> get fetchStatus;
/// Create a copy of MentorshipLandingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MentorshipLandingStateCopyWith<MentorshipLandingState> get copyWith => _$MentorshipLandingStateCopyWithImpl<MentorshipLandingState>(this as MentorshipLandingState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MentorshipLandingState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MentorshipLandingState&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.isAvailable, _this.isAvailable) || other.isAvailable == _this.isAvailable)&&const DeepCollectionEquality().equals(other.supportAreas, _this.supportAreas)&&(identical(other.fetchStatus, _this.fetchStatus) || other.fetchStatus == _this.fetchStatus));
}


@override
int get hashCode {
  final _this = this as MentorshipLandingState;
  return Object.hash(runtimeType,_this.isLoading,_this.isAvailable,const DeepCollectionEquality().hash(_this.supportAreas),_this.fetchStatus);
}

@override
String toString() {
  final _this = this as MentorshipLandingState;
  return 'MentorshipLandingState(isLoading: ${_this.isLoading}, isAvailable: ${_this.isAvailable}, supportAreas: ${_this.supportAreas}, fetchStatus: ${_this.fetchStatus})';
}


}

/// @nodoc
abstract mixin class $MentorshipLandingStateCopyWith<$Res>  {
  factory $MentorshipLandingStateCopyWith(MentorshipLandingState value, $Res Function(MentorshipLandingState) _then) = _$MentorshipLandingStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool isAvailable, List<String> supportAreas, ApiResultStatus<dynamic> fetchStatus
});


$ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus;

}
/// @nodoc
class _$MentorshipLandingStateCopyWithImpl<$Res>
    implements $MentorshipLandingStateCopyWith<$Res> {
  _$MentorshipLandingStateCopyWithImpl(this._self, this._then);

  final MentorshipLandingState _self;
  final $Res Function(MentorshipLandingState) _then;

/// Create a copy of MentorshipLandingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? isAvailable = null,Object? supportAreas = null,Object? fetchStatus = null,}) {
  return _then(MentorshipLandingState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,supportAreas: null == supportAreas ? _self.supportAreas : supportAreas // ignore: cast_nullable_to_non_nullable
as List<String>,fetchStatus: null == fetchStatus ? _self.fetchStatus : fetchStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}
/// Create a copy of MentorshipLandingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.fetchStatus, (value) {
    return _then(_self.copyWith(fetchStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [MentorshipLandingState].
extension MentorshipLandingStatePatterns on MentorshipLandingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MentorshipLandingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MentorshipLandingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MentorshipLandingState value)  $default,){
final _that = this;
switch (_that) {
case _MentorshipLandingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MentorshipLandingState value)?  $default,){
final _that = this;
switch (_that) {
case _MentorshipLandingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool isAvailable,  List<String> supportAreas,  ApiResultStatus<dynamic> fetchStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MentorshipLandingState() when $default != null:
return $default(_that.isLoading,_that.isAvailable,_that.supportAreas,_that.fetchStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool isAvailable,  List<String> supportAreas,  ApiResultStatus<dynamic> fetchStatus)  $default,) {final _that = this;
switch (_that) {
case _MentorshipLandingState():
return $default(_that.isLoading,_that.isAvailable,_that.supportAreas,_that.fetchStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool isAvailable,  List<String> supportAreas,  ApiResultStatus<dynamic> fetchStatus)?  $default,) {final _that = this;
switch (_that) {
case _MentorshipLandingState() when $default != null:
return $default(_that.isLoading,_that.isAvailable,_that.supportAreas,_that.fetchStatus);case _:
  return null;

}
}

}

/// @nodoc


class _MentorshipLandingState implements MentorshipLandingState {
  const _MentorshipLandingState({this.isLoading = false, this.isAvailable = true,  List<String> supportAreas = const <String>['Sleep', 'Behaviour', 'Parent Calm & Confidence', 'Co-parenting Support'], this.fetchStatus = const ApiResultStatus.initial()}): _supportAreas = supportAreas;
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isAvailable;
 final  List<String> _supportAreas;
@override@JsonKey() List<String> get supportAreas {
  if (_supportAreas is EqualUnmodifiableListView) return _supportAreas;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_supportAreas);
}

@override@JsonKey() final  ApiResultStatus<dynamic> fetchStatus;

/// Create a copy of MentorshipLandingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MentorshipLandingStateCopyWith<_MentorshipLandingState> get copyWith => __$MentorshipLandingStateCopyWithImpl<_MentorshipLandingState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MentorshipLandingState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&const DeepCollectionEquality().equals(other.supportAreas, _supportAreas)&&(identical(other.fetchStatus, fetchStatus) || other.fetchStatus == fetchStatus));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isLoading,isAvailable,const DeepCollectionEquality().hash(_supportAreas),fetchStatus);
}

@override
String toString() {
    return 'MentorshipLandingState(isLoading: $isLoading, isAvailable: $isAvailable, supportAreas: $supportAreas, fetchStatus: $fetchStatus)';
}


}

/// @nodoc
abstract mixin class _$MentorshipLandingStateCopyWith<$Res> implements $MentorshipLandingStateCopyWith<$Res> {
  factory _$MentorshipLandingStateCopyWith(_MentorshipLandingState value, $Res Function(_MentorshipLandingState) _then) = __$MentorshipLandingStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool isAvailable, List<String> supportAreas, ApiResultStatus<dynamic> fetchStatus
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus;

}
/// @nodoc
class __$MentorshipLandingStateCopyWithImpl<$Res>
    implements _$MentorshipLandingStateCopyWith<$Res> {
  __$MentorshipLandingStateCopyWithImpl(this._self, this._then);

  final _MentorshipLandingState _self;
  final $Res Function(_MentorshipLandingState) _then;

/// Create a copy of MentorshipLandingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? isAvailable = null,Object? supportAreas = null,Object? fetchStatus = null,}) {
  return _then(_MentorshipLandingState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,supportAreas: null == supportAreas ? _self._supportAreas : supportAreas // ignore: cast_nullable_to_non_nullable
as List<String>,fetchStatus: null == fetchStatus ? _self.fetchStatus : fetchStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}

/// Create a copy of MentorshipLandingState
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
