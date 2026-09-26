// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'child_profile_v2_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChildProfileV2State {

 ChildModel? get childModel; String get name; String get age; String get conditions; String get dob; String get concerns; String get location; ApiResultStatus<String> get saveStatus;
/// Create a copy of ChildProfileV2State
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChildProfileV2StateCopyWith<ChildProfileV2State> get copyWith => _$ChildProfileV2StateCopyWithImpl<ChildProfileV2State>(this as ChildProfileV2State, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ChildProfileV2State;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChildProfileV2State&&(identical(other.childModel, _this.childModel) || other.childModel == _this.childModel)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.age, _this.age) || other.age == _this.age)&&(identical(other.conditions, _this.conditions) || other.conditions == _this.conditions)&&(identical(other.dob, _this.dob) || other.dob == _this.dob)&&(identical(other.concerns, _this.concerns) || other.concerns == _this.concerns)&&(identical(other.location, _this.location) || other.location == _this.location)&&(identical(other.saveStatus, _this.saveStatus) || other.saveStatus == _this.saveStatus));
}


@override
int get hashCode {
  final _this = this as ChildProfileV2State;
  return Object.hash(runtimeType,_this.childModel,_this.name,_this.age,_this.conditions,_this.dob,_this.concerns,_this.location,_this.saveStatus);
}

@override
String toString() {
  final _this = this as ChildProfileV2State;
  return 'ChildProfileV2State(childModel: ${_this.childModel}, name: ${_this.name}, age: ${_this.age}, conditions: ${_this.conditions}, dob: ${_this.dob}, concerns: ${_this.concerns}, location: ${_this.location}, saveStatus: ${_this.saveStatus})';
}


}

/// @nodoc
abstract mixin class $ChildProfileV2StateCopyWith<$Res>  {
  factory $ChildProfileV2StateCopyWith(ChildProfileV2State value, $Res Function(ChildProfileV2State) _then) = _$ChildProfileV2StateCopyWithImpl;
@useResult
$Res call({
 ChildModel? childModel, String name, String age, String conditions, String dob, String concerns, String location, ApiResultStatus<String> saveStatus
});


$ApiResultStatusCopyWith<String, $Res> get saveStatus;

}
/// @nodoc
class _$ChildProfileV2StateCopyWithImpl<$Res>
    implements $ChildProfileV2StateCopyWith<$Res> {
  _$ChildProfileV2StateCopyWithImpl(this._self, this._then);

  final ChildProfileV2State _self;
  final $Res Function(ChildProfileV2State) _then;

/// Create a copy of ChildProfileV2State
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? childModel = freezed,Object? name = null,Object? age = null,Object? conditions = null,Object? dob = null,Object? concerns = null,Object? location = null,Object? saveStatus = null,}) {
  return _then(ChildProfileV2State(
childModel: freezed == childModel ? _self.childModel : childModel // ignore: cast_nullable_to_non_nullable
as ChildModel?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as String,conditions: null == conditions ? _self.conditions : conditions // ignore: cast_nullable_to_non_nullable
as String,dob: null == dob ? _self.dob : dob // ignore: cast_nullable_to_non_nullable
as String,concerns: null == concerns ? _self.concerns : concerns // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,saveStatus: null == saveStatus ? _self.saveStatus : saveStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<String>,
  ));
}
/// Create a copy of ChildProfileV2State
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<String, $Res> get saveStatus {
  
  return $ApiResultStatusCopyWith<String, $Res>(_self.saveStatus, (value) {
    return _then(_self.copyWith(saveStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [ChildProfileV2State].
extension ChildProfileV2StatePatterns on ChildProfileV2State {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChildProfileV2State value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChildProfileV2State() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChildProfileV2State value)  $default,){
final _that = this;
switch (_that) {
case _ChildProfileV2State():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChildProfileV2State value)?  $default,){
final _that = this;
switch (_that) {
case _ChildProfileV2State() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ChildModel? childModel,  String name,  String age,  String conditions,  String dob,  String concerns,  String location,  ApiResultStatus<String> saveStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChildProfileV2State() when $default != null:
return $default(_that.childModel,_that.name,_that.age,_that.conditions,_that.dob,_that.concerns,_that.location,_that.saveStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ChildModel? childModel,  String name,  String age,  String conditions,  String dob,  String concerns,  String location,  ApiResultStatus<String> saveStatus)  $default,) {final _that = this;
switch (_that) {
case _ChildProfileV2State():
return $default(_that.childModel,_that.name,_that.age,_that.conditions,_that.dob,_that.concerns,_that.location,_that.saveStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ChildModel? childModel,  String name,  String age,  String conditions,  String dob,  String concerns,  String location,  ApiResultStatus<String> saveStatus)?  $default,) {final _that = this;
switch (_that) {
case _ChildProfileV2State() when $default != null:
return $default(_that.childModel,_that.name,_that.age,_that.conditions,_that.dob,_that.concerns,_that.location,_that.saveStatus);case _:
  return null;

}
}

}

/// @nodoc


class _ChildProfileV2State implements ChildProfileV2State {
  const _ChildProfileV2State({this.childModel, this.name = '', this.age = '', this.conditions = '', this.dob = '', this.concerns = '', this.location = '', this.saveStatus = const ApiResultStatus<String>.initial()});
  

@override final  ChildModel? childModel;
@override@JsonKey() final  String name;
@override@JsonKey() final  String age;
@override@JsonKey() final  String conditions;
@override@JsonKey() final  String dob;
@override@JsonKey() final  String concerns;
@override@JsonKey() final  String location;
@override@JsonKey() final  ApiResultStatus<String> saveStatus;

/// Create a copy of ChildProfileV2State
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChildProfileV2StateCopyWith<_ChildProfileV2State> get copyWith => __$ChildProfileV2StateCopyWithImpl<_ChildProfileV2State>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChildProfileV2State&&(identical(other.childModel, childModel) || other.childModel == childModel)&&(identical(other.name, name) || other.name == name)&&(identical(other.age, age) || other.age == age)&&(identical(other.conditions, conditions) || other.conditions == conditions)&&(identical(other.dob, dob) || other.dob == dob)&&(identical(other.concerns, concerns) || other.concerns == concerns)&&(identical(other.location, location) || other.location == location)&&(identical(other.saveStatus, saveStatus) || other.saveStatus == saveStatus));
}


@override
int get hashCode {
    return Object.hash(runtimeType,childModel,name,age,conditions,dob,concerns,location,saveStatus);
}

@override
String toString() {
    return 'ChildProfileV2State(childModel: $childModel, name: $name, age: $age, conditions: $conditions, dob: $dob, concerns: $concerns, location: $location, saveStatus: $saveStatus)';
}


}

/// @nodoc
abstract mixin class _$ChildProfileV2StateCopyWith<$Res> implements $ChildProfileV2StateCopyWith<$Res> {
  factory _$ChildProfileV2StateCopyWith(_ChildProfileV2State value, $Res Function(_ChildProfileV2State) _then) = __$ChildProfileV2StateCopyWithImpl;
@override @useResult
$Res call({
 ChildModel? childModel, String name, String age, String conditions, String dob, String concerns, String location, ApiResultStatus<String> saveStatus
});


@override $ApiResultStatusCopyWith<String, $Res> get saveStatus;

}
/// @nodoc
class __$ChildProfileV2StateCopyWithImpl<$Res>
    implements _$ChildProfileV2StateCopyWith<$Res> {
  __$ChildProfileV2StateCopyWithImpl(this._self, this._then);

  final _ChildProfileV2State _self;
  final $Res Function(_ChildProfileV2State) _then;

/// Create a copy of ChildProfileV2State
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? childModel = freezed,Object? name = null,Object? age = null,Object? conditions = null,Object? dob = null,Object? concerns = null,Object? location = null,Object? saveStatus = null,}) {
  return _then(_ChildProfileV2State(
childModel: freezed == childModel ? _self.childModel : childModel // ignore: cast_nullable_to_non_nullable
as ChildModel?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as String,conditions: null == conditions ? _self.conditions : conditions // ignore: cast_nullable_to_non_nullable
as String,dob: null == dob ? _self.dob : dob // ignore: cast_nullable_to_non_nullable
as String,concerns: null == concerns ? _self.concerns : concerns // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,saveStatus: null == saveStatus ? _self.saveStatus : saveStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<String>,
  ));
}

/// Create a copy of ChildProfileV2State
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<String, $Res> get saveStatus {
  
  return $ApiResultStatusCopyWith<String, $Res>(_self.saveStatus, (value) {
    return _then(_self.copyWith(saveStatus: value));
  });
}
}

// dart format on
