// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'guide_profile_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GuideProfileState {

 bool get isLoading; GuideProfileModel? get guide; ApiResultStatus<dynamic> get fetchStatus;
/// Create a copy of GuideProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GuideProfileStateCopyWith<GuideProfileState> get copyWith => _$GuideProfileStateCopyWithImpl<GuideProfileState>(this as GuideProfileState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as GuideProfileState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GuideProfileState&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.guide, _this.guide) || other.guide == _this.guide)&&(identical(other.fetchStatus, _this.fetchStatus) || other.fetchStatus == _this.fetchStatus));
}


@override
int get hashCode {
  final _this = this as GuideProfileState;
  return Object.hash(runtimeType,_this.isLoading,_this.guide,_this.fetchStatus);
}

@override
String toString() {
  final _this = this as GuideProfileState;
  return 'GuideProfileState(isLoading: ${_this.isLoading}, guide: ${_this.guide}, fetchStatus: ${_this.fetchStatus})';
}


}

/// @nodoc
abstract mixin class $GuideProfileStateCopyWith<$Res>  {
  factory $GuideProfileStateCopyWith(GuideProfileState value, $Res Function(GuideProfileState) _then) = _$GuideProfileStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, GuideProfileModel? guide, ApiResultStatus<dynamic> fetchStatus
});


$ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus;

}
/// @nodoc
class _$GuideProfileStateCopyWithImpl<$Res>
    implements $GuideProfileStateCopyWith<$Res> {
  _$GuideProfileStateCopyWithImpl(this._self, this._then);

  final GuideProfileState _self;
  final $Res Function(GuideProfileState) _then;

/// Create a copy of GuideProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? guide = freezed,Object? fetchStatus = null,}) {
  return _then(GuideProfileState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,guide: freezed == guide ? _self.guide : guide // ignore: cast_nullable_to_non_nullable
as GuideProfileModel?,fetchStatus: null == fetchStatus ? _self.fetchStatus : fetchStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}
/// Create a copy of GuideProfileState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.fetchStatus, (value) {
    return _then(_self.copyWith(fetchStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [GuideProfileState].
extension GuideProfileStatePatterns on GuideProfileState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GuideProfileState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GuideProfileState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GuideProfileState value)  $default,){
final _that = this;
switch (_that) {
case _GuideProfileState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GuideProfileState value)?  $default,){
final _that = this;
switch (_that) {
case _GuideProfileState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  GuideProfileModel? guide,  ApiResultStatus<dynamic> fetchStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GuideProfileState() when $default != null:
return $default(_that.isLoading,_that.guide,_that.fetchStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  GuideProfileModel? guide,  ApiResultStatus<dynamic> fetchStatus)  $default,) {final _that = this;
switch (_that) {
case _GuideProfileState():
return $default(_that.isLoading,_that.guide,_that.fetchStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  GuideProfileModel? guide,  ApiResultStatus<dynamic> fetchStatus)?  $default,) {final _that = this;
switch (_that) {
case _GuideProfileState() when $default != null:
return $default(_that.isLoading,_that.guide,_that.fetchStatus);case _:
  return null;

}
}

}

/// @nodoc


class _GuideProfileState implements GuideProfileState {
  const _GuideProfileState({this.isLoading = false, this.guide, this.fetchStatus = const ApiResultStatus.initial()});
  

@override@JsonKey() final  bool isLoading;
@override final  GuideProfileModel? guide;
@override@JsonKey() final  ApiResultStatus<dynamic> fetchStatus;

/// Create a copy of GuideProfileState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GuideProfileStateCopyWith<_GuideProfileState> get copyWith => __$GuideProfileStateCopyWithImpl<_GuideProfileState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GuideProfileState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.guide, guide) || other.guide == guide)&&(identical(other.fetchStatus, fetchStatus) || other.fetchStatus == fetchStatus));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isLoading,guide,fetchStatus);
}

@override
String toString() {
    return 'GuideProfileState(isLoading: $isLoading, guide: $guide, fetchStatus: $fetchStatus)';
}


}

/// @nodoc
abstract mixin class _$GuideProfileStateCopyWith<$Res> implements $GuideProfileStateCopyWith<$Res> {
  factory _$GuideProfileStateCopyWith(_GuideProfileState value, $Res Function(_GuideProfileState) _then) = __$GuideProfileStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, GuideProfileModel? guide, ApiResultStatus<dynamic> fetchStatus
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus;

}
/// @nodoc
class __$GuideProfileStateCopyWithImpl<$Res>
    implements _$GuideProfileStateCopyWith<$Res> {
  __$GuideProfileStateCopyWithImpl(this._self, this._then);

  final _GuideProfileState _self;
  final $Res Function(_GuideProfileState) _then;

/// Create a copy of GuideProfileState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? guide = freezed,Object? fetchStatus = null,}) {
  return _then(_GuideProfileState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,guide: freezed == guide ? _self.guide : guide // ignore: cast_nullable_to_non_nullable
as GuideProfileModel?,fetchStatus: null == fetchStatus ? _self.fetchStatus : fetchStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}

/// Create a copy of GuideProfileState
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
