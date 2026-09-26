// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'manage_children_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ManageChildrenState {

 UserModel? get userModel; List<ChildModel> get children; ApiResultStatus<dynamic> get loadStatus; ApiResultStatus<dynamic> get setDefaultStatus; ApiResultStatus<dynamic> get deleteChildStatus;
/// Create a copy of ManageChildrenState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ManageChildrenStateCopyWith<ManageChildrenState> get copyWith => _$ManageChildrenStateCopyWithImpl<ManageChildrenState>(this as ManageChildrenState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ManageChildrenState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ManageChildrenState&&(identical(other.userModel, _this.userModel) || other.userModel == _this.userModel)&&const DeepCollectionEquality().equals(other.children, _this.children)&&(identical(other.loadStatus, _this.loadStatus) || other.loadStatus == _this.loadStatus)&&(identical(other.setDefaultStatus, _this.setDefaultStatus) || other.setDefaultStatus == _this.setDefaultStatus)&&(identical(other.deleteChildStatus, _this.deleteChildStatus) || other.deleteChildStatus == _this.deleteChildStatus));
}


@override
int get hashCode {
  final _this = this as ManageChildrenState;
  return Object.hash(runtimeType,_this.userModel,const DeepCollectionEquality().hash(_this.children),_this.loadStatus,_this.setDefaultStatus,_this.deleteChildStatus);
}

@override
String toString() {
  final _this = this as ManageChildrenState;
  return 'ManageChildrenState(userModel: ${_this.userModel}, children: ${_this.children}, loadStatus: ${_this.loadStatus}, setDefaultStatus: ${_this.setDefaultStatus}, deleteChildStatus: ${_this.deleteChildStatus})';
}


}

/// @nodoc
abstract mixin class $ManageChildrenStateCopyWith<$Res>  {
  factory $ManageChildrenStateCopyWith(ManageChildrenState value, $Res Function(ManageChildrenState) _then) = _$ManageChildrenStateCopyWithImpl;
@useResult
$Res call({
 UserModel? userModel, List<ChildModel> children, ApiResultStatus<dynamic> loadStatus, ApiResultStatus<dynamic> setDefaultStatus, ApiResultStatus<dynamic> deleteChildStatus
});


$ApiResultStatusCopyWith<dynamic, $Res> get loadStatus;$ApiResultStatusCopyWith<dynamic, $Res> get setDefaultStatus;$ApiResultStatusCopyWith<dynamic, $Res> get deleteChildStatus;

}
/// @nodoc
class _$ManageChildrenStateCopyWithImpl<$Res>
    implements $ManageChildrenStateCopyWith<$Res> {
  _$ManageChildrenStateCopyWithImpl(this._self, this._then);

  final ManageChildrenState _self;
  final $Res Function(ManageChildrenState) _then;

/// Create a copy of ManageChildrenState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userModel = freezed,Object? children = null,Object? loadStatus = null,Object? setDefaultStatus = null,Object? deleteChildStatus = null,}) {
  return _then(ManageChildrenState(
userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,children: null == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as List<ChildModel>,loadStatus: null == loadStatus ? _self.loadStatus : loadStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,setDefaultStatus: null == setDefaultStatus ? _self.setDefaultStatus : setDefaultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,deleteChildStatus: null == deleteChildStatus ? _self.deleteChildStatus : deleteChildStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}
/// Create a copy of ManageChildrenState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get loadStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.loadStatus, (value) {
    return _then(_self.copyWith(loadStatus: value));
  });
}/// Create a copy of ManageChildrenState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get setDefaultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.setDefaultStatus, (value) {
    return _then(_self.copyWith(setDefaultStatus: value));
  });
}/// Create a copy of ManageChildrenState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get deleteChildStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.deleteChildStatus, (value) {
    return _then(_self.copyWith(deleteChildStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [ManageChildrenState].
extension ManageChildrenStatePatterns on ManageChildrenState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ManageChildrenState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ManageChildrenState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ManageChildrenState value)  $default,){
final _that = this;
switch (_that) {
case _ManageChildrenState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ManageChildrenState value)?  $default,){
final _that = this;
switch (_that) {
case _ManageChildrenState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UserModel? userModel,  List<ChildModel> children,  ApiResultStatus<dynamic> loadStatus,  ApiResultStatus<dynamic> setDefaultStatus,  ApiResultStatus<dynamic> deleteChildStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ManageChildrenState() when $default != null:
return $default(_that.userModel,_that.children,_that.loadStatus,_that.setDefaultStatus,_that.deleteChildStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UserModel? userModel,  List<ChildModel> children,  ApiResultStatus<dynamic> loadStatus,  ApiResultStatus<dynamic> setDefaultStatus,  ApiResultStatus<dynamic> deleteChildStatus)  $default,) {final _that = this;
switch (_that) {
case _ManageChildrenState():
return $default(_that.userModel,_that.children,_that.loadStatus,_that.setDefaultStatus,_that.deleteChildStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UserModel? userModel,  List<ChildModel> children,  ApiResultStatus<dynamic> loadStatus,  ApiResultStatus<dynamic> setDefaultStatus,  ApiResultStatus<dynamic> deleteChildStatus)?  $default,) {final _that = this;
switch (_that) {
case _ManageChildrenState() when $default != null:
return $default(_that.userModel,_that.children,_that.loadStatus,_that.setDefaultStatus,_that.deleteChildStatus);case _:
  return null;

}
}

}

/// @nodoc


class _ManageChildrenState implements ManageChildrenState {
  const _ManageChildrenState({this.userModel,  List<ChildModel> children = const [], this.loadStatus = const ApiResultStatus.initial(), this.setDefaultStatus = const ApiResultStatus.initial(), this.deleteChildStatus = const ApiResultStatus.initial()}): _children = children;
  

@override final  UserModel? userModel;
 final  List<ChildModel> _children;
@override@JsonKey() List<ChildModel> get children {
  if (_children is EqualUnmodifiableListView) return _children;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_children);
}

@override@JsonKey() final  ApiResultStatus<dynamic> loadStatus;
@override@JsonKey() final  ApiResultStatus<dynamic> setDefaultStatus;
@override@JsonKey() final  ApiResultStatus<dynamic> deleteChildStatus;

/// Create a copy of ManageChildrenState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ManageChildrenStateCopyWith<_ManageChildrenState> get copyWith => __$ManageChildrenStateCopyWithImpl<_ManageChildrenState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ManageChildrenState&&(identical(other.userModel, userModel) || other.userModel == userModel)&&const DeepCollectionEquality().equals(other.children, _children)&&(identical(other.loadStatus, loadStatus) || other.loadStatus == loadStatus)&&(identical(other.setDefaultStatus, setDefaultStatus) || other.setDefaultStatus == setDefaultStatus)&&(identical(other.deleteChildStatus, deleteChildStatus) || other.deleteChildStatus == deleteChildStatus));
}


@override
int get hashCode {
    return Object.hash(runtimeType,userModel,const DeepCollectionEquality().hash(_children),loadStatus,setDefaultStatus,deleteChildStatus);
}

@override
String toString() {
    return 'ManageChildrenState(userModel: $userModel, children: $children, loadStatus: $loadStatus, setDefaultStatus: $setDefaultStatus, deleteChildStatus: $deleteChildStatus)';
}


}

/// @nodoc
abstract mixin class _$ManageChildrenStateCopyWith<$Res> implements $ManageChildrenStateCopyWith<$Res> {
  factory _$ManageChildrenStateCopyWith(_ManageChildrenState value, $Res Function(_ManageChildrenState) _then) = __$ManageChildrenStateCopyWithImpl;
@override @useResult
$Res call({
 UserModel? userModel, List<ChildModel> children, ApiResultStatus<dynamic> loadStatus, ApiResultStatus<dynamic> setDefaultStatus, ApiResultStatus<dynamic> deleteChildStatus
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get loadStatus;@override $ApiResultStatusCopyWith<dynamic, $Res> get setDefaultStatus;@override $ApiResultStatusCopyWith<dynamic, $Res> get deleteChildStatus;

}
/// @nodoc
class __$ManageChildrenStateCopyWithImpl<$Res>
    implements _$ManageChildrenStateCopyWith<$Res> {
  __$ManageChildrenStateCopyWithImpl(this._self, this._then);

  final _ManageChildrenState _self;
  final $Res Function(_ManageChildrenState) _then;

/// Create a copy of ManageChildrenState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userModel = freezed,Object? children = null,Object? loadStatus = null,Object? setDefaultStatus = null,Object? deleteChildStatus = null,}) {
  return _then(_ManageChildrenState(
userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,children: null == children ? _self._children : children // ignore: cast_nullable_to_non_nullable
as List<ChildModel>,loadStatus: null == loadStatus ? _self.loadStatus : loadStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,setDefaultStatus: null == setDefaultStatus ? _self.setDefaultStatus : setDefaultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,deleteChildStatus: null == deleteChildStatus ? _self.deleteChildStatus : deleteChildStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}

/// Create a copy of ManageChildrenState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get loadStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.loadStatus, (value) {
    return _then(_self.copyWith(loadStatus: value));
  });
}/// Create a copy of ManageChildrenState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get setDefaultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.setDefaultStatus, (value) {
    return _then(_self.copyWith(setDefaultStatus: value));
  });
}/// Create a copy of ManageChildrenState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get deleteChildStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.deleteChildStatus, (value) {
    return _then(_self.copyWith(deleteChildStatus: value));
  });
}
}

// dart format on
