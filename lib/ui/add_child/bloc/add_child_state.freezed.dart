// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_child_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AddChildState {

 String get name; String get dob; DateTime? get childDob; String get concerns; String get location; List<String> get selectedConcerns; ApiResultStatus<dynamic> get saveStatus;
/// Create a copy of AddChildState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddChildStateCopyWith<AddChildState> get copyWith => _$AddChildStateCopyWithImpl<AddChildState>(this as AddChildState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AddChildState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddChildState&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.dob, _this.dob) || other.dob == _this.dob)&&(identical(other.childDob, _this.childDob) || other.childDob == _this.childDob)&&(identical(other.concerns, _this.concerns) || other.concerns == _this.concerns)&&(identical(other.location, _this.location) || other.location == _this.location)&&const DeepCollectionEquality().equals(other.selectedConcerns, _this.selectedConcerns)&&(identical(other.saveStatus, _this.saveStatus) || other.saveStatus == _this.saveStatus));
}


@override
int get hashCode {
  final _this = this as AddChildState;
  return Object.hash(runtimeType,_this.name,_this.dob,_this.childDob,_this.concerns,_this.location,const DeepCollectionEquality().hash(_this.selectedConcerns),_this.saveStatus);
}

@override
String toString() {
  final _this = this as AddChildState;
  return 'AddChildState(name: ${_this.name}, dob: ${_this.dob}, childDob: ${_this.childDob}, concerns: ${_this.concerns}, location: ${_this.location}, selectedConcerns: ${_this.selectedConcerns}, saveStatus: ${_this.saveStatus})';
}


}

/// @nodoc
abstract mixin class $AddChildStateCopyWith<$Res>  {
  factory $AddChildStateCopyWith(AddChildState value, $Res Function(AddChildState) _then) = _$AddChildStateCopyWithImpl;
@useResult
$Res call({
 String name, String dob, DateTime? childDob, String concerns, String location, List<String> selectedConcerns, ApiResultStatus<dynamic> saveStatus
});


$ApiResultStatusCopyWith<dynamic, $Res> get saveStatus;

}
/// @nodoc
class _$AddChildStateCopyWithImpl<$Res>
    implements $AddChildStateCopyWith<$Res> {
  _$AddChildStateCopyWithImpl(this._self, this._then);

  final AddChildState _self;
  final $Res Function(AddChildState) _then;

/// Create a copy of AddChildState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? dob = null,Object? childDob = freezed,Object? concerns = null,Object? location = null,Object? selectedConcerns = null,Object? saveStatus = null,}) {
  return _then(AddChildState(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,dob: null == dob ? _self.dob : dob // ignore: cast_nullable_to_non_nullable
as String,childDob: freezed == childDob ? _self.childDob : childDob // ignore: cast_nullable_to_non_nullable
as DateTime?,concerns: null == concerns ? _self.concerns : concerns // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,selectedConcerns: null == selectedConcerns ? _self.selectedConcerns : selectedConcerns // ignore: cast_nullable_to_non_nullable
as List<String>,saveStatus: null == saveStatus ? _self.saveStatus : saveStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}
/// Create a copy of AddChildState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get saveStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.saveStatus, (value) {
    return _then(_self.copyWith(saveStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [AddChildState].
extension AddChildStatePatterns on AddChildState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AddChildState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddChildState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AddChildState value)  $default,){
final _that = this;
switch (_that) {
case _AddChildState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AddChildState value)?  $default,){
final _that = this;
switch (_that) {
case _AddChildState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String dob,  DateTime? childDob,  String concerns,  String location,  List<String> selectedConcerns,  ApiResultStatus<dynamic> saveStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AddChildState() when $default != null:
return $default(_that.name,_that.dob,_that.childDob,_that.concerns,_that.location,_that.selectedConcerns,_that.saveStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String dob,  DateTime? childDob,  String concerns,  String location,  List<String> selectedConcerns,  ApiResultStatus<dynamic> saveStatus)  $default,) {final _that = this;
switch (_that) {
case _AddChildState():
return $default(_that.name,_that.dob,_that.childDob,_that.concerns,_that.location,_that.selectedConcerns,_that.saveStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String dob,  DateTime? childDob,  String concerns,  String location,  List<String> selectedConcerns,  ApiResultStatus<dynamic> saveStatus)?  $default,) {final _that = this;
switch (_that) {
case _AddChildState() when $default != null:
return $default(_that.name,_that.dob,_that.childDob,_that.concerns,_that.location,_that.selectedConcerns,_that.saveStatus);case _:
  return null;

}
}

}

/// @nodoc


class _AddChildState implements AddChildState {
  const _AddChildState({this.name = '', this.dob = '', this.childDob, this.concerns = '', this.location = '',  List<String> selectedConcerns = const <String>[], this.saveStatus = const ApiResultStatus.initial()}): _selectedConcerns = selectedConcerns;
  

@override@JsonKey() final  String name;
@override@JsonKey() final  String dob;
@override final  DateTime? childDob;
@override@JsonKey() final  String concerns;
@override@JsonKey() final  String location;
 final  List<String> _selectedConcerns;
@override@JsonKey() List<String> get selectedConcerns {
  if (_selectedConcerns is EqualUnmodifiableListView) return _selectedConcerns;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedConcerns);
}

@override@JsonKey() final  ApiResultStatus<dynamic> saveStatus;

/// Create a copy of AddChildState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddChildStateCopyWith<_AddChildState> get copyWith => __$AddChildStateCopyWithImpl<_AddChildState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddChildState&&(identical(other.name, name) || other.name == name)&&(identical(other.dob, dob) || other.dob == dob)&&(identical(other.childDob, childDob) || other.childDob == childDob)&&(identical(other.concerns, concerns) || other.concerns == concerns)&&(identical(other.location, location) || other.location == location)&&const DeepCollectionEquality().equals(other.selectedConcerns, _selectedConcerns)&&(identical(other.saveStatus, saveStatus) || other.saveStatus == saveStatus));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name,dob,childDob,concerns,location,const DeepCollectionEquality().hash(_selectedConcerns),saveStatus);
}

@override
String toString() {
    return 'AddChildState(name: $name, dob: $dob, childDob: $childDob, concerns: $concerns, location: $location, selectedConcerns: $selectedConcerns, saveStatus: $saveStatus)';
}


}

/// @nodoc
abstract mixin class _$AddChildStateCopyWith<$Res> implements $AddChildStateCopyWith<$Res> {
  factory _$AddChildStateCopyWith(_AddChildState value, $Res Function(_AddChildState) _then) = __$AddChildStateCopyWithImpl;
@override @useResult
$Res call({
 String name, String dob, DateTime? childDob, String concerns, String location, List<String> selectedConcerns, ApiResultStatus<dynamic> saveStatus
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get saveStatus;

}
/// @nodoc
class __$AddChildStateCopyWithImpl<$Res>
    implements _$AddChildStateCopyWith<$Res> {
  __$AddChildStateCopyWithImpl(this._self, this._then);

  final _AddChildState _self;
  final $Res Function(_AddChildState) _then;

/// Create a copy of AddChildState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? dob = null,Object? childDob = freezed,Object? concerns = null,Object? location = null,Object? selectedConcerns = null,Object? saveStatus = null,}) {
  return _then(_AddChildState(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,dob: null == dob ? _self.dob : dob // ignore: cast_nullable_to_non_nullable
as String,childDob: freezed == childDob ? _self.childDob : childDob // ignore: cast_nullable_to_non_nullable
as DateTime?,concerns: null == concerns ? _self.concerns : concerns // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,selectedConcerns: null == selectedConcerns ? _self._selectedConcerns : selectedConcerns // ignore: cast_nullable_to_non_nullable
as List<String>,saveStatus: null == saveStatus ? _self.saveStatus : saveStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,
  ));
}

/// Create a copy of AddChildState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get saveStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.saveStatus, (value) {
    return _then(_self.copyWith(saveStatus: value));
  });
}
}

// dart format on
