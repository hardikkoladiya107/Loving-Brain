// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'guide_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GuideListState {

 bool get isLoading; String get supportArea; List<GuideProfileModel> get guides; ApiResultStatus<dynamic> get fetchStatus;
/// Create a copy of GuideListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GuideListStateCopyWith<GuideListState> get copyWith => _$GuideListStateCopyWithImpl<GuideListState>(this as GuideListState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as GuideListState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GuideListState&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.supportArea, _this.supportArea) || other.supportArea == _this.supportArea)&&const DeepCollectionEquality().equals(other.guides, _this.guides)&&(identical(other.fetchStatus, _this.fetchStatus) || other.fetchStatus == _this.fetchStatus));
}


@override
int get hashCode {
  final _this = this as GuideListState;
  return Object.hash(runtimeType,_this.isLoading,_this.supportArea,const DeepCollectionEquality().hash(_this.guides),_this.fetchStatus);
}

@override
String toString() {
  final _this = this as GuideListState;
  return 'GuideListState(isLoading: ${_this.isLoading}, supportArea: ${_this.supportArea}, guides: ${_this.guides}, fetchStatus: ${_this.fetchStatus})';
}


}

/// @nodoc
abstract mixin class $GuideListStateCopyWith<$Res>  {
  factory $GuideListStateCopyWith(GuideListState value, $Res Function(GuideListState) _then) = _$GuideListStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, String supportArea, List<GuideProfileModel> guides, ApiResultStatus<dynamic> fetchStatus
});


$ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus;

}
/// @nodoc
class _$GuideListStateCopyWithImpl<$Res>
    implements $GuideListStateCopyWith<$Res> {
  _$GuideListStateCopyWithImpl(this._self, this._then);

  final GuideListState _self;
  final $Res Function(GuideListState) _then;

/// Create a copy of GuideListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? supportArea = null,Object? guides = null,Object? fetchStatus = null,}) {
  return _then(GuideListState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,supportArea: null == supportArea ? _self.supportArea : supportArea // ignore: cast_nullable_to_non_nullable
as String,guides: null == guides ? _self.guides : guides // ignore: cast_nullable_to_non_nullable
as List<GuideProfileModel>,fetchStatus: null == fetchStatus ? _self.fetchStatus : fetchStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}
/// Create a copy of GuideListState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.fetchStatus, (value) {
    return _then(_self.copyWith(fetchStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [GuideListState].
extension GuideListStatePatterns on GuideListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GuideListState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GuideListState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GuideListState value)  $default,){
final _that = this;
switch (_that) {
case _GuideListState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GuideListState value)?  $default,){
final _that = this;
switch (_that) {
case _GuideListState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  String supportArea,  List<GuideProfileModel> guides,  ApiResultStatus<dynamic> fetchStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GuideListState() when $default != null:
return $default(_that.isLoading,_that.supportArea,_that.guides,_that.fetchStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  String supportArea,  List<GuideProfileModel> guides,  ApiResultStatus<dynamic> fetchStatus)  $default,) {final _that = this;
switch (_that) {
case _GuideListState():
return $default(_that.isLoading,_that.supportArea,_that.guides,_that.fetchStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  String supportArea,  List<GuideProfileModel> guides,  ApiResultStatus<dynamic> fetchStatus)?  $default,) {final _that = this;
switch (_that) {
case _GuideListState() when $default != null:
return $default(_that.isLoading,_that.supportArea,_that.guides,_that.fetchStatus);case _:
  return null;

}
}

}

/// @nodoc


class _GuideListState implements GuideListState {
  const _GuideListState({this.isLoading = false, this.supportArea = '',  List<GuideProfileModel> guides = const [], this.fetchStatus = const ApiResultStatus.initial()}): _guides = guides;
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  String supportArea;
 final  List<GuideProfileModel> _guides;
@override@JsonKey() List<GuideProfileModel> get guides {
  if (_guides is EqualUnmodifiableListView) return _guides;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_guides);
}

@override@JsonKey() final  ApiResultStatus<dynamic> fetchStatus;

/// Create a copy of GuideListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GuideListStateCopyWith<_GuideListState> get copyWith => __$GuideListStateCopyWithImpl<_GuideListState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GuideListState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.supportArea, supportArea) || other.supportArea == supportArea)&&const DeepCollectionEquality().equals(other.guides, _guides)&&(identical(other.fetchStatus, fetchStatus) || other.fetchStatus == fetchStatus));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isLoading,supportArea,const DeepCollectionEquality().hash(_guides),fetchStatus);
}

@override
String toString() {
    return 'GuideListState(isLoading: $isLoading, supportArea: $supportArea, guides: $guides, fetchStatus: $fetchStatus)';
}


}

/// @nodoc
abstract mixin class _$GuideListStateCopyWith<$Res> implements $GuideListStateCopyWith<$Res> {
  factory _$GuideListStateCopyWith(_GuideListState value, $Res Function(_GuideListState) _then) = __$GuideListStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, String supportArea, List<GuideProfileModel> guides, ApiResultStatus<dynamic> fetchStatus
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get fetchStatus;

}
/// @nodoc
class __$GuideListStateCopyWithImpl<$Res>
    implements _$GuideListStateCopyWith<$Res> {
  __$GuideListStateCopyWithImpl(this._self, this._then);

  final _GuideListState _self;
  final $Res Function(_GuideListState) _then;

/// Create a copy of GuideListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? supportArea = null,Object? guides = null,Object? fetchStatus = null,}) {
  return _then(_GuideListState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,supportArea: null == supportArea ? _self.supportArea : supportArea // ignore: cast_nullable_to_non_nullable
as String,guides: null == guides ? _self._guides : guides // ignore: cast_nullable_to_non_nullable
as List<GuideProfileModel>,fetchStatus: null == fetchStatus ? _self.fetchStatus : fetchStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}

/// Create a copy of GuideListState
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
