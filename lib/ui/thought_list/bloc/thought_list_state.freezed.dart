// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'thought_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ThoughtListState {

 UserModel? get userModel; List<JournalModel> get journalList;
/// Create a copy of ThoughtListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ThoughtListStateCopyWith<ThoughtListState> get copyWith => _$ThoughtListStateCopyWithImpl<ThoughtListState>(this as ThoughtListState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ThoughtListState&&(identical(other.userModel, userModel) || other.userModel == userModel)&&const DeepCollectionEquality().equals(other.journalList, journalList));
}


@override
int get hashCode => Object.hash(runtimeType,userModel,const DeepCollectionEquality().hash(journalList));

@override
String toString() {
  return 'ThoughtListState(userModel: $userModel, journalList: $journalList)';
}


}

/// @nodoc
abstract mixin class $ThoughtListStateCopyWith<$Res>  {
  factory $ThoughtListStateCopyWith(ThoughtListState value, $Res Function(ThoughtListState) _then) = _$ThoughtListStateCopyWithImpl;
@useResult
$Res call({
 UserModel? userModel, List<JournalModel> journalList
});




}
/// @nodoc
class _$ThoughtListStateCopyWithImpl<$Res>
    implements $ThoughtListStateCopyWith<$Res> {
  _$ThoughtListStateCopyWithImpl(this._self, this._then);

  final ThoughtListState _self;
  final $Res Function(ThoughtListState) _then;

/// Create a copy of ThoughtListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userModel = freezed,Object? journalList = null,}) {
  return _then(_self.copyWith(
userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,journalList: null == journalList ? _self.journalList : journalList // ignore: cast_nullable_to_non_nullable
as List<JournalModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [ThoughtListState].
extension ThoughtListStatePatterns on ThoughtListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ThoughtListState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ThoughtListState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ThoughtListState value)  $default,){
final _that = this;
switch (_that) {
case _ThoughtListState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ThoughtListState value)?  $default,){
final _that = this;
switch (_that) {
case _ThoughtListState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UserModel? userModel,  List<JournalModel> journalList)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ThoughtListState() when $default != null:
return $default(_that.userModel,_that.journalList);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UserModel? userModel,  List<JournalModel> journalList)  $default,) {final _that = this;
switch (_that) {
case _ThoughtListState():
return $default(_that.userModel,_that.journalList);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UserModel? userModel,  List<JournalModel> journalList)?  $default,) {final _that = this;
switch (_that) {
case _ThoughtListState() when $default != null:
return $default(_that.userModel,_that.journalList);case _:
  return null;

}
}

}

/// @nodoc


class _ThoughtListState implements ThoughtListState {
  const _ThoughtListState({this.userModel, final  List<JournalModel> journalList = const []}): _journalList = journalList;
  

@override final  UserModel? userModel;
 final  List<JournalModel> _journalList;
@override@JsonKey() List<JournalModel> get journalList {
  if (_journalList is EqualUnmodifiableListView) return _journalList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_journalList);
}


/// Create a copy of ThoughtListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ThoughtListStateCopyWith<_ThoughtListState> get copyWith => __$ThoughtListStateCopyWithImpl<_ThoughtListState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ThoughtListState&&(identical(other.userModel, userModel) || other.userModel == userModel)&&const DeepCollectionEquality().equals(other._journalList, _journalList));
}


@override
int get hashCode => Object.hash(runtimeType,userModel,const DeepCollectionEquality().hash(_journalList));

@override
String toString() {
  return 'ThoughtListState(userModel: $userModel, journalList: $journalList)';
}


}

/// @nodoc
abstract mixin class _$ThoughtListStateCopyWith<$Res> implements $ThoughtListStateCopyWith<$Res> {
  factory _$ThoughtListStateCopyWith(_ThoughtListState value, $Res Function(_ThoughtListState) _then) = __$ThoughtListStateCopyWithImpl;
@override @useResult
$Res call({
 UserModel? userModel, List<JournalModel> journalList
});




}
/// @nodoc
class __$ThoughtListStateCopyWithImpl<$Res>
    implements _$ThoughtListStateCopyWith<$Res> {
  __$ThoughtListStateCopyWithImpl(this._self, this._then);

  final _ThoughtListState _self;
  final $Res Function(_ThoughtListState) _then;

/// Create a copy of ThoughtListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userModel = freezed,Object? journalList = null,}) {
  return _then(_ThoughtListState(
userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,journalList: null == journalList ? _self._journalList : journalList // ignore: cast_nullable_to_non_nullable
as List<JournalModel>,
  ));
}


}

// dart format on
