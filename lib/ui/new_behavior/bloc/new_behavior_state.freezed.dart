// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'new_behavior_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NewBehaviorState {

 String get selectedBehaviour; String get tellUsMoreText; String get tellUsMoreError; String get behaviourError; List<BehaviourCategoryModel> get behaviourCategoryList; List<BehaviourModel> get behaviourList; UserModel? get userModel; ApiResultStatus get getBehaviourApiResultStatus; ApiResultStatus get addBehaviourApiResultStatus;
/// Create a copy of NewBehaviorState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NewBehaviorStateCopyWith<NewBehaviorState> get copyWith => _$NewBehaviorStateCopyWithImpl<NewBehaviorState>(this as NewBehaviorState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NewBehaviorState&&(identical(other.selectedBehaviour, selectedBehaviour) || other.selectedBehaviour == selectedBehaviour)&&(identical(other.tellUsMoreText, tellUsMoreText) || other.tellUsMoreText == tellUsMoreText)&&(identical(other.tellUsMoreError, tellUsMoreError) || other.tellUsMoreError == tellUsMoreError)&&(identical(other.behaviourError, behaviourError) || other.behaviourError == behaviourError)&&const DeepCollectionEquality().equals(other.behaviourCategoryList, behaviourCategoryList)&&const DeepCollectionEquality().equals(other.behaviourList, behaviourList)&&(identical(other.userModel, userModel) || other.userModel == userModel)&&(identical(other.getBehaviourApiResultStatus, getBehaviourApiResultStatus) || other.getBehaviourApiResultStatus == getBehaviourApiResultStatus)&&(identical(other.addBehaviourApiResultStatus, addBehaviourApiResultStatus) || other.addBehaviourApiResultStatus == addBehaviourApiResultStatus));
}


@override
int get hashCode => Object.hash(runtimeType,selectedBehaviour,tellUsMoreText,tellUsMoreError,behaviourError,const DeepCollectionEquality().hash(behaviourCategoryList),const DeepCollectionEquality().hash(behaviourList),userModel,getBehaviourApiResultStatus,addBehaviourApiResultStatus);

@override
String toString() {
  return 'NewBehaviorState(selectedBehaviour: $selectedBehaviour, tellUsMoreText: $tellUsMoreText, tellUsMoreError: $tellUsMoreError, behaviourError: $behaviourError, behaviourCategoryList: $behaviourCategoryList, behaviourList: $behaviourList, userModel: $userModel, getBehaviourApiResultStatus: $getBehaviourApiResultStatus, addBehaviourApiResultStatus: $addBehaviourApiResultStatus)';
}


}

/// @nodoc
abstract mixin class $NewBehaviorStateCopyWith<$Res>  {
  factory $NewBehaviorStateCopyWith(NewBehaviorState value, $Res Function(NewBehaviorState) _then) = _$NewBehaviorStateCopyWithImpl;
@useResult
$Res call({
 String selectedBehaviour, String tellUsMoreText, String tellUsMoreError, String behaviourError, List<BehaviourCategoryModel> behaviourCategoryList, List<BehaviourModel> behaviourList, UserModel? userModel, ApiResultStatus getBehaviourApiResultStatus, ApiResultStatus addBehaviourApiResultStatus
});


$ApiResultStatusCopyWith<dynamic, $Res> get getBehaviourApiResultStatus;$ApiResultStatusCopyWith<dynamic, $Res> get addBehaviourApiResultStatus;

}
/// @nodoc
class _$NewBehaviorStateCopyWithImpl<$Res>
    implements $NewBehaviorStateCopyWith<$Res> {
  _$NewBehaviorStateCopyWithImpl(this._self, this._then);

  final NewBehaviorState _self;
  final $Res Function(NewBehaviorState) _then;

/// Create a copy of NewBehaviorState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selectedBehaviour = null,Object? tellUsMoreText = null,Object? tellUsMoreError = null,Object? behaviourError = null,Object? behaviourCategoryList = null,Object? behaviourList = null,Object? userModel = freezed,Object? getBehaviourApiResultStatus = null,Object? addBehaviourApiResultStatus = null,}) {
  return _then(_self.copyWith(
selectedBehaviour: null == selectedBehaviour ? _self.selectedBehaviour : selectedBehaviour // ignore: cast_nullable_to_non_nullable
as String,tellUsMoreText: null == tellUsMoreText ? _self.tellUsMoreText : tellUsMoreText // ignore: cast_nullable_to_non_nullable
as String,tellUsMoreError: null == tellUsMoreError ? _self.tellUsMoreError : tellUsMoreError // ignore: cast_nullable_to_non_nullable
as String,behaviourError: null == behaviourError ? _self.behaviourError : behaviourError // ignore: cast_nullable_to_non_nullable
as String,behaviourCategoryList: null == behaviourCategoryList ? _self.behaviourCategoryList : behaviourCategoryList // ignore: cast_nullable_to_non_nullable
as List<BehaviourCategoryModel>,behaviourList: null == behaviourList ? _self.behaviourList : behaviourList // ignore: cast_nullable_to_non_nullable
as List<BehaviourModel>,userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,getBehaviourApiResultStatus: null == getBehaviourApiResultStatus ? _self.getBehaviourApiResultStatus : getBehaviourApiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,addBehaviourApiResultStatus: null == addBehaviourApiResultStatus ? _self.addBehaviourApiResultStatus : addBehaviourApiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,
  ));
}
/// Create a copy of NewBehaviorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get getBehaviourApiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.getBehaviourApiResultStatus, (value) {
    return _then(_self.copyWith(getBehaviourApiResultStatus: value));
  });
}/// Create a copy of NewBehaviorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get addBehaviourApiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.addBehaviourApiResultStatus, (value) {
    return _then(_self.copyWith(addBehaviourApiResultStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [NewBehaviorState].
extension NewBehaviorStatePatterns on NewBehaviorState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NewBehaviorState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NewBehaviorState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NewBehaviorState value)  $default,){
final _that = this;
switch (_that) {
case _NewBehaviorState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NewBehaviorState value)?  $default,){
final _that = this;
switch (_that) {
case _NewBehaviorState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String selectedBehaviour,  String tellUsMoreText,  String tellUsMoreError,  String behaviourError,  List<BehaviourCategoryModel> behaviourCategoryList,  List<BehaviourModel> behaviourList,  UserModel? userModel,  ApiResultStatus getBehaviourApiResultStatus,  ApiResultStatus addBehaviourApiResultStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NewBehaviorState() when $default != null:
return $default(_that.selectedBehaviour,_that.tellUsMoreText,_that.tellUsMoreError,_that.behaviourError,_that.behaviourCategoryList,_that.behaviourList,_that.userModel,_that.getBehaviourApiResultStatus,_that.addBehaviourApiResultStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String selectedBehaviour,  String tellUsMoreText,  String tellUsMoreError,  String behaviourError,  List<BehaviourCategoryModel> behaviourCategoryList,  List<BehaviourModel> behaviourList,  UserModel? userModel,  ApiResultStatus getBehaviourApiResultStatus,  ApiResultStatus addBehaviourApiResultStatus)  $default,) {final _that = this;
switch (_that) {
case _NewBehaviorState():
return $default(_that.selectedBehaviour,_that.tellUsMoreText,_that.tellUsMoreError,_that.behaviourError,_that.behaviourCategoryList,_that.behaviourList,_that.userModel,_that.getBehaviourApiResultStatus,_that.addBehaviourApiResultStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String selectedBehaviour,  String tellUsMoreText,  String tellUsMoreError,  String behaviourError,  List<BehaviourCategoryModel> behaviourCategoryList,  List<BehaviourModel> behaviourList,  UserModel? userModel,  ApiResultStatus getBehaviourApiResultStatus,  ApiResultStatus addBehaviourApiResultStatus)?  $default,) {final _that = this;
switch (_that) {
case _NewBehaviorState() when $default != null:
return $default(_that.selectedBehaviour,_that.tellUsMoreText,_that.tellUsMoreError,_that.behaviourError,_that.behaviourCategoryList,_that.behaviourList,_that.userModel,_that.getBehaviourApiResultStatus,_that.addBehaviourApiResultStatus);case _:
  return null;

}
}

}

/// @nodoc


class _NewBehaviorState implements NewBehaviorState {
  const _NewBehaviorState({this.selectedBehaviour = "", this.tellUsMoreText = "", this.tellUsMoreError = "", this.behaviourError = "", final  List<BehaviourCategoryModel> behaviourCategoryList = const [], final  List<BehaviourModel> behaviourList = const [], this.userModel, this.getBehaviourApiResultStatus = const ApiResultStatus.initial(), this.addBehaviourApiResultStatus = const ApiResultStatus.initial()}): _behaviourCategoryList = behaviourCategoryList,_behaviourList = behaviourList;
  

@override@JsonKey() final  String selectedBehaviour;
@override@JsonKey() final  String tellUsMoreText;
@override@JsonKey() final  String tellUsMoreError;
@override@JsonKey() final  String behaviourError;
 final  List<BehaviourCategoryModel> _behaviourCategoryList;
@override@JsonKey() List<BehaviourCategoryModel> get behaviourCategoryList {
  if (_behaviourCategoryList is EqualUnmodifiableListView) return _behaviourCategoryList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_behaviourCategoryList);
}

 final  List<BehaviourModel> _behaviourList;
@override@JsonKey() List<BehaviourModel> get behaviourList {
  if (_behaviourList is EqualUnmodifiableListView) return _behaviourList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_behaviourList);
}

@override final  UserModel? userModel;
@override@JsonKey() final  ApiResultStatus getBehaviourApiResultStatus;
@override@JsonKey() final  ApiResultStatus addBehaviourApiResultStatus;

/// Create a copy of NewBehaviorState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NewBehaviorStateCopyWith<_NewBehaviorState> get copyWith => __$NewBehaviorStateCopyWithImpl<_NewBehaviorState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NewBehaviorState&&(identical(other.selectedBehaviour, selectedBehaviour) || other.selectedBehaviour == selectedBehaviour)&&(identical(other.tellUsMoreText, tellUsMoreText) || other.tellUsMoreText == tellUsMoreText)&&(identical(other.tellUsMoreError, tellUsMoreError) || other.tellUsMoreError == tellUsMoreError)&&(identical(other.behaviourError, behaviourError) || other.behaviourError == behaviourError)&&const DeepCollectionEquality().equals(other._behaviourCategoryList, _behaviourCategoryList)&&const DeepCollectionEquality().equals(other._behaviourList, _behaviourList)&&(identical(other.userModel, userModel) || other.userModel == userModel)&&(identical(other.getBehaviourApiResultStatus, getBehaviourApiResultStatus) || other.getBehaviourApiResultStatus == getBehaviourApiResultStatus)&&(identical(other.addBehaviourApiResultStatus, addBehaviourApiResultStatus) || other.addBehaviourApiResultStatus == addBehaviourApiResultStatus));
}


@override
int get hashCode => Object.hash(runtimeType,selectedBehaviour,tellUsMoreText,tellUsMoreError,behaviourError,const DeepCollectionEquality().hash(_behaviourCategoryList),const DeepCollectionEquality().hash(_behaviourList),userModel,getBehaviourApiResultStatus,addBehaviourApiResultStatus);

@override
String toString() {
  return 'NewBehaviorState(selectedBehaviour: $selectedBehaviour, tellUsMoreText: $tellUsMoreText, tellUsMoreError: $tellUsMoreError, behaviourError: $behaviourError, behaviourCategoryList: $behaviourCategoryList, behaviourList: $behaviourList, userModel: $userModel, getBehaviourApiResultStatus: $getBehaviourApiResultStatus, addBehaviourApiResultStatus: $addBehaviourApiResultStatus)';
}


}

/// @nodoc
abstract mixin class _$NewBehaviorStateCopyWith<$Res> implements $NewBehaviorStateCopyWith<$Res> {
  factory _$NewBehaviorStateCopyWith(_NewBehaviorState value, $Res Function(_NewBehaviorState) _then) = __$NewBehaviorStateCopyWithImpl;
@override @useResult
$Res call({
 String selectedBehaviour, String tellUsMoreText, String tellUsMoreError, String behaviourError, List<BehaviourCategoryModel> behaviourCategoryList, List<BehaviourModel> behaviourList, UserModel? userModel, ApiResultStatus getBehaviourApiResultStatus, ApiResultStatus addBehaviourApiResultStatus
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get getBehaviourApiResultStatus;@override $ApiResultStatusCopyWith<dynamic, $Res> get addBehaviourApiResultStatus;

}
/// @nodoc
class __$NewBehaviorStateCopyWithImpl<$Res>
    implements _$NewBehaviorStateCopyWith<$Res> {
  __$NewBehaviorStateCopyWithImpl(this._self, this._then);

  final _NewBehaviorState _self;
  final $Res Function(_NewBehaviorState) _then;

/// Create a copy of NewBehaviorState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectedBehaviour = null,Object? tellUsMoreText = null,Object? tellUsMoreError = null,Object? behaviourError = null,Object? behaviourCategoryList = null,Object? behaviourList = null,Object? userModel = freezed,Object? getBehaviourApiResultStatus = null,Object? addBehaviourApiResultStatus = null,}) {
  return _then(_NewBehaviorState(
selectedBehaviour: null == selectedBehaviour ? _self.selectedBehaviour : selectedBehaviour // ignore: cast_nullable_to_non_nullable
as String,tellUsMoreText: null == tellUsMoreText ? _self.tellUsMoreText : tellUsMoreText // ignore: cast_nullable_to_non_nullable
as String,tellUsMoreError: null == tellUsMoreError ? _self.tellUsMoreError : tellUsMoreError // ignore: cast_nullable_to_non_nullable
as String,behaviourError: null == behaviourError ? _self.behaviourError : behaviourError // ignore: cast_nullable_to_non_nullable
as String,behaviourCategoryList: null == behaviourCategoryList ? _self._behaviourCategoryList : behaviourCategoryList // ignore: cast_nullable_to_non_nullable
as List<BehaviourCategoryModel>,behaviourList: null == behaviourList ? _self._behaviourList : behaviourList // ignore: cast_nullable_to_non_nullable
as List<BehaviourModel>,userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,getBehaviourApiResultStatus: null == getBehaviourApiResultStatus ? _self.getBehaviourApiResultStatus : getBehaviourApiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,addBehaviourApiResultStatus: null == addBehaviourApiResultStatus ? _self.addBehaviourApiResultStatus : addBehaviourApiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,
  ));
}

/// Create a copy of NewBehaviorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get getBehaviourApiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.getBehaviourApiResultStatus, (value) {
    return _then(_self.copyWith(getBehaviourApiResultStatus: value));
  });
}/// Create a copy of NewBehaviorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get addBehaviourApiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.addBehaviourApiResultStatus, (value) {
    return _then(_self.copyWith(addBehaviourApiResultStatus: value));
  });
}
}

// dart format on
