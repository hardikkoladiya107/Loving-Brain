// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'write_your_thought_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WriteYourThoughtState {

 UserModel? get userModel; ApiResultStatus get apiResultStatus; String get thoughtsText; String get thoughtsErrorText; List<JournalModel> get journalList;
/// Create a copy of WriteYourThoughtState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WriteYourThoughtStateCopyWith<WriteYourThoughtState> get copyWith => _$WriteYourThoughtStateCopyWithImpl<WriteYourThoughtState>(this as WriteYourThoughtState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WriteYourThoughtState&&(identical(other.userModel, userModel) || other.userModel == userModel)&&(identical(other.apiResultStatus, apiResultStatus) || other.apiResultStatus == apiResultStatus)&&(identical(other.thoughtsText, thoughtsText) || other.thoughtsText == thoughtsText)&&(identical(other.thoughtsErrorText, thoughtsErrorText) || other.thoughtsErrorText == thoughtsErrorText)&&const DeepCollectionEquality().equals(other.journalList, journalList));
}


@override
int get hashCode => Object.hash(runtimeType,userModel,apiResultStatus,thoughtsText,thoughtsErrorText,const DeepCollectionEquality().hash(journalList));

@override
String toString() {
  return 'WriteYourThoughtState(userModel: $userModel, apiResultStatus: $apiResultStatus, thoughtsText: $thoughtsText, thoughtsErrorText: $thoughtsErrorText, journalList: $journalList)';
}


}

/// @nodoc
abstract mixin class $WriteYourThoughtStateCopyWith<$Res>  {
  factory $WriteYourThoughtStateCopyWith(WriteYourThoughtState value, $Res Function(WriteYourThoughtState) _then) = _$WriteYourThoughtStateCopyWithImpl;
@useResult
$Res call({
 UserModel? userModel, ApiResultStatus apiResultStatus, String thoughtsText, String thoughtsErrorText, List<JournalModel> journalList
});


$ApiResultStatusCopyWith<dynamic, $Res> get apiResultStatus;

}
/// @nodoc
class _$WriteYourThoughtStateCopyWithImpl<$Res>
    implements $WriteYourThoughtStateCopyWith<$Res> {
  _$WriteYourThoughtStateCopyWithImpl(this._self, this._then);

  final WriteYourThoughtState _self;
  final $Res Function(WriteYourThoughtState) _then;

/// Create a copy of WriteYourThoughtState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userModel = freezed,Object? apiResultStatus = null,Object? thoughtsText = null,Object? thoughtsErrorText = null,Object? journalList = null,}) {
  return _then(_self.copyWith(
userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,apiResultStatus: null == apiResultStatus ? _self.apiResultStatus : apiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,thoughtsText: null == thoughtsText ? _self.thoughtsText : thoughtsText // ignore: cast_nullable_to_non_nullable
as String,thoughtsErrorText: null == thoughtsErrorText ? _self.thoughtsErrorText : thoughtsErrorText // ignore: cast_nullable_to_non_nullable
as String,journalList: null == journalList ? _self.journalList : journalList // ignore: cast_nullable_to_non_nullable
as List<JournalModel>,
  ));
}
/// Create a copy of WriteYourThoughtState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get apiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.apiResultStatus, (value) {
    return _then(_self.copyWith(apiResultStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [WriteYourThoughtState].
extension WriteYourThoughtStatePatterns on WriteYourThoughtState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WriteYourThoughtState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WriteYourThoughtState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WriteYourThoughtState value)  $default,){
final _that = this;
switch (_that) {
case _WriteYourThoughtState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WriteYourThoughtState value)?  $default,){
final _that = this;
switch (_that) {
case _WriteYourThoughtState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UserModel? userModel,  ApiResultStatus apiResultStatus,  String thoughtsText,  String thoughtsErrorText,  List<JournalModel> journalList)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WriteYourThoughtState() when $default != null:
return $default(_that.userModel,_that.apiResultStatus,_that.thoughtsText,_that.thoughtsErrorText,_that.journalList);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UserModel? userModel,  ApiResultStatus apiResultStatus,  String thoughtsText,  String thoughtsErrorText,  List<JournalModel> journalList)  $default,) {final _that = this;
switch (_that) {
case _WriteYourThoughtState():
return $default(_that.userModel,_that.apiResultStatus,_that.thoughtsText,_that.thoughtsErrorText,_that.journalList);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UserModel? userModel,  ApiResultStatus apiResultStatus,  String thoughtsText,  String thoughtsErrorText,  List<JournalModel> journalList)?  $default,) {final _that = this;
switch (_that) {
case _WriteYourThoughtState() when $default != null:
return $default(_that.userModel,_that.apiResultStatus,_that.thoughtsText,_that.thoughtsErrorText,_that.journalList);case _:
  return null;

}
}

}

/// @nodoc


class _WriteYourThoughtState implements WriteYourThoughtState {
  const _WriteYourThoughtState({this.userModel, this.apiResultStatus = const ApiResultStatus.initial(), this.thoughtsText = "", this.thoughtsErrorText = "", final  List<JournalModel> journalList = const []}): _journalList = journalList;
  

@override final  UserModel? userModel;
@override@JsonKey() final  ApiResultStatus apiResultStatus;
@override@JsonKey() final  String thoughtsText;
@override@JsonKey() final  String thoughtsErrorText;
 final  List<JournalModel> _journalList;
@override@JsonKey() List<JournalModel> get journalList {
  if (_journalList is EqualUnmodifiableListView) return _journalList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_journalList);
}


/// Create a copy of WriteYourThoughtState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WriteYourThoughtStateCopyWith<_WriteYourThoughtState> get copyWith => __$WriteYourThoughtStateCopyWithImpl<_WriteYourThoughtState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WriteYourThoughtState&&(identical(other.userModel, userModel) || other.userModel == userModel)&&(identical(other.apiResultStatus, apiResultStatus) || other.apiResultStatus == apiResultStatus)&&(identical(other.thoughtsText, thoughtsText) || other.thoughtsText == thoughtsText)&&(identical(other.thoughtsErrorText, thoughtsErrorText) || other.thoughtsErrorText == thoughtsErrorText)&&const DeepCollectionEquality().equals(other._journalList, _journalList));
}


@override
int get hashCode => Object.hash(runtimeType,userModel,apiResultStatus,thoughtsText,thoughtsErrorText,const DeepCollectionEquality().hash(_journalList));

@override
String toString() {
  return 'WriteYourThoughtState(userModel: $userModel, apiResultStatus: $apiResultStatus, thoughtsText: $thoughtsText, thoughtsErrorText: $thoughtsErrorText, journalList: $journalList)';
}


}

/// @nodoc
abstract mixin class _$WriteYourThoughtStateCopyWith<$Res> implements $WriteYourThoughtStateCopyWith<$Res> {
  factory _$WriteYourThoughtStateCopyWith(_WriteYourThoughtState value, $Res Function(_WriteYourThoughtState) _then) = __$WriteYourThoughtStateCopyWithImpl;
@override @useResult
$Res call({
 UserModel? userModel, ApiResultStatus apiResultStatus, String thoughtsText, String thoughtsErrorText, List<JournalModel> journalList
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get apiResultStatus;

}
/// @nodoc
class __$WriteYourThoughtStateCopyWithImpl<$Res>
    implements _$WriteYourThoughtStateCopyWith<$Res> {
  __$WriteYourThoughtStateCopyWithImpl(this._self, this._then);

  final _WriteYourThoughtState _self;
  final $Res Function(_WriteYourThoughtState) _then;

/// Create a copy of WriteYourThoughtState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userModel = freezed,Object? apiResultStatus = null,Object? thoughtsText = null,Object? thoughtsErrorText = null,Object? journalList = null,}) {
  return _then(_WriteYourThoughtState(
userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,apiResultStatus: null == apiResultStatus ? _self.apiResultStatus : apiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,thoughtsText: null == thoughtsText ? _self.thoughtsText : thoughtsText // ignore: cast_nullable_to_non_nullable
as String,thoughtsErrorText: null == thoughtsErrorText ? _self.thoughtsErrorText : thoughtsErrorText // ignore: cast_nullable_to_non_nullable
as String,journalList: null == journalList ? _self._journalList : journalList // ignore: cast_nullable_to_non_nullable
as List<JournalModel>,
  ));
}

/// Create a copy of WriteYourThoughtState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get apiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.apiResultStatus, (value) {
    return _then(_self.copyWith(apiResultStatus: value));
  });
}
}

// dart format on
