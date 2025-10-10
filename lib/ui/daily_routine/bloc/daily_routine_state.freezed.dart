// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_routine_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DailyRoutineState {

 UserModel? get userModel; ChildModel? get childModel; DateTime? get selectedDateTime; String get descriptionText; String get selectedType; String get timeError; String get descriptionError; String get typeError; ApiResultStatus get getRoutineTypeApiResult; ApiResultStatus get addRoutineApiResult; List<RoutineCategoryModel> get routineCategoryList; List<RoutineModel> get routinesList;
/// Create a copy of DailyRoutineState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyRoutineStateCopyWith<DailyRoutineState> get copyWith => _$DailyRoutineStateCopyWithImpl<DailyRoutineState>(this as DailyRoutineState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyRoutineState&&(identical(other.userModel, userModel) || other.userModel == userModel)&&(identical(other.childModel, childModel) || other.childModel == childModel)&&(identical(other.selectedDateTime, selectedDateTime) || other.selectedDateTime == selectedDateTime)&&(identical(other.descriptionText, descriptionText) || other.descriptionText == descriptionText)&&(identical(other.selectedType, selectedType) || other.selectedType == selectedType)&&(identical(other.timeError, timeError) || other.timeError == timeError)&&(identical(other.descriptionError, descriptionError) || other.descriptionError == descriptionError)&&(identical(other.typeError, typeError) || other.typeError == typeError)&&(identical(other.getRoutineTypeApiResult, getRoutineTypeApiResult) || other.getRoutineTypeApiResult == getRoutineTypeApiResult)&&(identical(other.addRoutineApiResult, addRoutineApiResult) || other.addRoutineApiResult == addRoutineApiResult)&&const DeepCollectionEquality().equals(other.routineCategoryList, routineCategoryList)&&const DeepCollectionEquality().equals(other.routinesList, routinesList));
}


@override
int get hashCode => Object.hash(runtimeType,userModel,childModel,selectedDateTime,descriptionText,selectedType,timeError,descriptionError,typeError,getRoutineTypeApiResult,addRoutineApiResult,const DeepCollectionEquality().hash(routineCategoryList),const DeepCollectionEquality().hash(routinesList));

@override
String toString() {
  return 'DailyRoutineState(userModel: $userModel, childModel: $childModel, selectedDateTime: $selectedDateTime, descriptionText: $descriptionText, selectedType: $selectedType, timeError: $timeError, descriptionError: $descriptionError, typeError: $typeError, getRoutineTypeApiResult: $getRoutineTypeApiResult, addRoutineApiResult: $addRoutineApiResult, routineCategoryList: $routineCategoryList, routinesList: $routinesList)';
}


}

/// @nodoc
abstract mixin class $DailyRoutineStateCopyWith<$Res>  {
  factory $DailyRoutineStateCopyWith(DailyRoutineState value, $Res Function(DailyRoutineState) _then) = _$DailyRoutineStateCopyWithImpl;
@useResult
$Res call({
 UserModel? userModel, ChildModel? childModel, DateTime? selectedDateTime, String descriptionText, String selectedType, String timeError, String descriptionError, String typeError, ApiResultStatus getRoutineTypeApiResult, ApiResultStatus addRoutineApiResult, List<RoutineCategoryModel> routineCategoryList, List<RoutineModel> routinesList
});


$ApiResultStatusCopyWith<dynamic, $Res> get getRoutineTypeApiResult;$ApiResultStatusCopyWith<dynamic, $Res> get addRoutineApiResult;

}
/// @nodoc
class _$DailyRoutineStateCopyWithImpl<$Res>
    implements $DailyRoutineStateCopyWith<$Res> {
  _$DailyRoutineStateCopyWithImpl(this._self, this._then);

  final DailyRoutineState _self;
  final $Res Function(DailyRoutineState) _then;

/// Create a copy of DailyRoutineState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userModel = freezed,Object? childModel = freezed,Object? selectedDateTime = freezed,Object? descriptionText = null,Object? selectedType = null,Object? timeError = null,Object? descriptionError = null,Object? typeError = null,Object? getRoutineTypeApiResult = null,Object? addRoutineApiResult = null,Object? routineCategoryList = null,Object? routinesList = null,}) {
  return _then(_self.copyWith(
userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,childModel: freezed == childModel ? _self.childModel : childModel // ignore: cast_nullable_to_non_nullable
as ChildModel?,selectedDateTime: freezed == selectedDateTime ? _self.selectedDateTime : selectedDateTime // ignore: cast_nullable_to_non_nullable
as DateTime?,descriptionText: null == descriptionText ? _self.descriptionText : descriptionText // ignore: cast_nullable_to_non_nullable
as String,selectedType: null == selectedType ? _self.selectedType : selectedType // ignore: cast_nullable_to_non_nullable
as String,timeError: null == timeError ? _self.timeError : timeError // ignore: cast_nullable_to_non_nullable
as String,descriptionError: null == descriptionError ? _self.descriptionError : descriptionError // ignore: cast_nullable_to_non_nullable
as String,typeError: null == typeError ? _self.typeError : typeError // ignore: cast_nullable_to_non_nullable
as String,getRoutineTypeApiResult: null == getRoutineTypeApiResult ? _self.getRoutineTypeApiResult : getRoutineTypeApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,addRoutineApiResult: null == addRoutineApiResult ? _self.addRoutineApiResult : addRoutineApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,routineCategoryList: null == routineCategoryList ? _self.routineCategoryList : routineCategoryList // ignore: cast_nullable_to_non_nullable
as List<RoutineCategoryModel>,routinesList: null == routinesList ? _self.routinesList : routinesList // ignore: cast_nullable_to_non_nullable
as List<RoutineModel>,
  ));
}
/// Create a copy of DailyRoutineState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get getRoutineTypeApiResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.getRoutineTypeApiResult, (value) {
    return _then(_self.copyWith(getRoutineTypeApiResult: value));
  });
}/// Create a copy of DailyRoutineState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get addRoutineApiResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.addRoutineApiResult, (value) {
    return _then(_self.copyWith(addRoutineApiResult: value));
  });
}
}


/// Adds pattern-matching-related methods to [DailyRoutineState].
extension DailyRoutineStatePatterns on DailyRoutineState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyRoutineState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyRoutineState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyRoutineState value)  $default,){
final _that = this;
switch (_that) {
case _DailyRoutineState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyRoutineState value)?  $default,){
final _that = this;
switch (_that) {
case _DailyRoutineState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UserModel? userModel,  ChildModel? childModel,  DateTime? selectedDateTime,  String descriptionText,  String selectedType,  String timeError,  String descriptionError,  String typeError,  ApiResultStatus getRoutineTypeApiResult,  ApiResultStatus addRoutineApiResult,  List<RoutineCategoryModel> routineCategoryList,  List<RoutineModel> routinesList)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyRoutineState() when $default != null:
return $default(_that.userModel,_that.childModel,_that.selectedDateTime,_that.descriptionText,_that.selectedType,_that.timeError,_that.descriptionError,_that.typeError,_that.getRoutineTypeApiResult,_that.addRoutineApiResult,_that.routineCategoryList,_that.routinesList);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UserModel? userModel,  ChildModel? childModel,  DateTime? selectedDateTime,  String descriptionText,  String selectedType,  String timeError,  String descriptionError,  String typeError,  ApiResultStatus getRoutineTypeApiResult,  ApiResultStatus addRoutineApiResult,  List<RoutineCategoryModel> routineCategoryList,  List<RoutineModel> routinesList)  $default,) {final _that = this;
switch (_that) {
case _DailyRoutineState():
return $default(_that.userModel,_that.childModel,_that.selectedDateTime,_that.descriptionText,_that.selectedType,_that.timeError,_that.descriptionError,_that.typeError,_that.getRoutineTypeApiResult,_that.addRoutineApiResult,_that.routineCategoryList,_that.routinesList);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UserModel? userModel,  ChildModel? childModel,  DateTime? selectedDateTime,  String descriptionText,  String selectedType,  String timeError,  String descriptionError,  String typeError,  ApiResultStatus getRoutineTypeApiResult,  ApiResultStatus addRoutineApiResult,  List<RoutineCategoryModel> routineCategoryList,  List<RoutineModel> routinesList)?  $default,) {final _that = this;
switch (_that) {
case _DailyRoutineState() when $default != null:
return $default(_that.userModel,_that.childModel,_that.selectedDateTime,_that.descriptionText,_that.selectedType,_that.timeError,_that.descriptionError,_that.typeError,_that.getRoutineTypeApiResult,_that.addRoutineApiResult,_that.routineCategoryList,_that.routinesList);case _:
  return null;

}
}

}

/// @nodoc


class _DailyRoutineState implements DailyRoutineState {
  const _DailyRoutineState({this.userModel, this.childModel, this.selectedDateTime, this.descriptionText = "", this.selectedType = "", this.timeError = "", this.descriptionError = "", this.typeError = "", this.getRoutineTypeApiResult = const ApiResultStatus.initial(), this.addRoutineApiResult = const ApiResultStatus.initial(), final  List<RoutineCategoryModel> routineCategoryList = const [], final  List<RoutineModel> routinesList = const []}): _routineCategoryList = routineCategoryList,_routinesList = routinesList;
  

@override final  UserModel? userModel;
@override final  ChildModel? childModel;
@override final  DateTime? selectedDateTime;
@override@JsonKey() final  String descriptionText;
@override@JsonKey() final  String selectedType;
@override@JsonKey() final  String timeError;
@override@JsonKey() final  String descriptionError;
@override@JsonKey() final  String typeError;
@override@JsonKey() final  ApiResultStatus getRoutineTypeApiResult;
@override@JsonKey() final  ApiResultStatus addRoutineApiResult;
 final  List<RoutineCategoryModel> _routineCategoryList;
@override@JsonKey() List<RoutineCategoryModel> get routineCategoryList {
  if (_routineCategoryList is EqualUnmodifiableListView) return _routineCategoryList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_routineCategoryList);
}

 final  List<RoutineModel> _routinesList;
@override@JsonKey() List<RoutineModel> get routinesList {
  if (_routinesList is EqualUnmodifiableListView) return _routinesList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_routinesList);
}


/// Create a copy of DailyRoutineState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyRoutineStateCopyWith<_DailyRoutineState> get copyWith => __$DailyRoutineStateCopyWithImpl<_DailyRoutineState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyRoutineState&&(identical(other.userModel, userModel) || other.userModel == userModel)&&(identical(other.childModel, childModel) || other.childModel == childModel)&&(identical(other.selectedDateTime, selectedDateTime) || other.selectedDateTime == selectedDateTime)&&(identical(other.descriptionText, descriptionText) || other.descriptionText == descriptionText)&&(identical(other.selectedType, selectedType) || other.selectedType == selectedType)&&(identical(other.timeError, timeError) || other.timeError == timeError)&&(identical(other.descriptionError, descriptionError) || other.descriptionError == descriptionError)&&(identical(other.typeError, typeError) || other.typeError == typeError)&&(identical(other.getRoutineTypeApiResult, getRoutineTypeApiResult) || other.getRoutineTypeApiResult == getRoutineTypeApiResult)&&(identical(other.addRoutineApiResult, addRoutineApiResult) || other.addRoutineApiResult == addRoutineApiResult)&&const DeepCollectionEquality().equals(other._routineCategoryList, _routineCategoryList)&&const DeepCollectionEquality().equals(other._routinesList, _routinesList));
}


@override
int get hashCode => Object.hash(runtimeType,userModel,childModel,selectedDateTime,descriptionText,selectedType,timeError,descriptionError,typeError,getRoutineTypeApiResult,addRoutineApiResult,const DeepCollectionEquality().hash(_routineCategoryList),const DeepCollectionEquality().hash(_routinesList));

@override
String toString() {
  return 'DailyRoutineState(userModel: $userModel, childModel: $childModel, selectedDateTime: $selectedDateTime, descriptionText: $descriptionText, selectedType: $selectedType, timeError: $timeError, descriptionError: $descriptionError, typeError: $typeError, getRoutineTypeApiResult: $getRoutineTypeApiResult, addRoutineApiResult: $addRoutineApiResult, routineCategoryList: $routineCategoryList, routinesList: $routinesList)';
}


}

/// @nodoc
abstract mixin class _$DailyRoutineStateCopyWith<$Res> implements $DailyRoutineStateCopyWith<$Res> {
  factory _$DailyRoutineStateCopyWith(_DailyRoutineState value, $Res Function(_DailyRoutineState) _then) = __$DailyRoutineStateCopyWithImpl;
@override @useResult
$Res call({
 UserModel? userModel, ChildModel? childModel, DateTime? selectedDateTime, String descriptionText, String selectedType, String timeError, String descriptionError, String typeError, ApiResultStatus getRoutineTypeApiResult, ApiResultStatus addRoutineApiResult, List<RoutineCategoryModel> routineCategoryList, List<RoutineModel> routinesList
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get getRoutineTypeApiResult;@override $ApiResultStatusCopyWith<dynamic, $Res> get addRoutineApiResult;

}
/// @nodoc
class __$DailyRoutineStateCopyWithImpl<$Res>
    implements _$DailyRoutineStateCopyWith<$Res> {
  __$DailyRoutineStateCopyWithImpl(this._self, this._then);

  final _DailyRoutineState _self;
  final $Res Function(_DailyRoutineState) _then;

/// Create a copy of DailyRoutineState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userModel = freezed,Object? childModel = freezed,Object? selectedDateTime = freezed,Object? descriptionText = null,Object? selectedType = null,Object? timeError = null,Object? descriptionError = null,Object? typeError = null,Object? getRoutineTypeApiResult = null,Object? addRoutineApiResult = null,Object? routineCategoryList = null,Object? routinesList = null,}) {
  return _then(_DailyRoutineState(
userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,childModel: freezed == childModel ? _self.childModel : childModel // ignore: cast_nullable_to_non_nullable
as ChildModel?,selectedDateTime: freezed == selectedDateTime ? _self.selectedDateTime : selectedDateTime // ignore: cast_nullable_to_non_nullable
as DateTime?,descriptionText: null == descriptionText ? _self.descriptionText : descriptionText // ignore: cast_nullable_to_non_nullable
as String,selectedType: null == selectedType ? _self.selectedType : selectedType // ignore: cast_nullable_to_non_nullable
as String,timeError: null == timeError ? _self.timeError : timeError // ignore: cast_nullable_to_non_nullable
as String,descriptionError: null == descriptionError ? _self.descriptionError : descriptionError // ignore: cast_nullable_to_non_nullable
as String,typeError: null == typeError ? _self.typeError : typeError // ignore: cast_nullable_to_non_nullable
as String,getRoutineTypeApiResult: null == getRoutineTypeApiResult ? _self.getRoutineTypeApiResult : getRoutineTypeApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,addRoutineApiResult: null == addRoutineApiResult ? _self.addRoutineApiResult : addRoutineApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,routineCategoryList: null == routineCategoryList ? _self._routineCategoryList : routineCategoryList // ignore: cast_nullable_to_non_nullable
as List<RoutineCategoryModel>,routinesList: null == routinesList ? _self._routinesList : routinesList // ignore: cast_nullable_to_non_nullable
as List<RoutineModel>,
  ));
}

/// Create a copy of DailyRoutineState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get getRoutineTypeApiResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.getRoutineTypeApiResult, (value) {
    return _then(_self.copyWith(getRoutineTypeApiResult: value));
  });
}/// Create a copy of DailyRoutineState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get addRoutineApiResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.addRoutineApiResult, (value) {
    return _then(_self.copyWith(addRoutineApiResult: value));
  });
}
}

// dart format on
