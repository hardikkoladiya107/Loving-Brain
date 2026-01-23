// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'connect_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ConnectDetailState {

 String get currentPrompt;// Keeping as fallback or while loading/error
 PromptModel? get promptModel; Color get selectedColor; List<DrawingStroke> get allStrokes; ApiResultStatus get getPromptApiResultStatus; DrawingStroke? get currentStroke;
/// Create a copy of ConnectDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConnectDetailStateCopyWith<ConnectDetailState> get copyWith => _$ConnectDetailStateCopyWithImpl<ConnectDetailState>(this as ConnectDetailState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConnectDetailState&&(identical(other.currentPrompt, currentPrompt) || other.currentPrompt == currentPrompt)&&(identical(other.promptModel, promptModel) || other.promptModel == promptModel)&&(identical(other.selectedColor, selectedColor) || other.selectedColor == selectedColor)&&const DeepCollectionEquality().equals(other.allStrokes, allStrokes)&&(identical(other.getPromptApiResultStatus, getPromptApiResultStatus) || other.getPromptApiResultStatus == getPromptApiResultStatus)&&(identical(other.currentStroke, currentStroke) || other.currentStroke == currentStroke));
}


@override
int get hashCode => Object.hash(runtimeType,currentPrompt,promptModel,selectedColor,const DeepCollectionEquality().hash(allStrokes),getPromptApiResultStatus,currentStroke);

@override
String toString() {
  return 'ConnectDetailState(currentPrompt: $currentPrompt, promptModel: $promptModel, selectedColor: $selectedColor, allStrokes: $allStrokes, getPromptApiResultStatus: $getPromptApiResultStatus, currentStroke: $currentStroke)';
}


}

/// @nodoc
abstract mixin class $ConnectDetailStateCopyWith<$Res>  {
  factory $ConnectDetailStateCopyWith(ConnectDetailState value, $Res Function(ConnectDetailState) _then) = _$ConnectDetailStateCopyWithImpl;
@useResult
$Res call({
 String currentPrompt, PromptModel? promptModel, Color selectedColor, List<DrawingStroke> allStrokes, ApiResultStatus getPromptApiResultStatus, DrawingStroke? currentStroke
});


$ApiResultStatusCopyWith<dynamic, $Res> get getPromptApiResultStatus;

}
/// @nodoc
class _$ConnectDetailStateCopyWithImpl<$Res>
    implements $ConnectDetailStateCopyWith<$Res> {
  _$ConnectDetailStateCopyWithImpl(this._self, this._then);

  final ConnectDetailState _self;
  final $Res Function(ConnectDetailState) _then;

/// Create a copy of ConnectDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentPrompt = null,Object? promptModel = freezed,Object? selectedColor = null,Object? allStrokes = null,Object? getPromptApiResultStatus = null,Object? currentStroke = freezed,}) {
  return _then(_self.copyWith(
currentPrompt: null == currentPrompt ? _self.currentPrompt : currentPrompt // ignore: cast_nullable_to_non_nullable
as String,promptModel: freezed == promptModel ? _self.promptModel : promptModel // ignore: cast_nullable_to_non_nullable
as PromptModel?,selectedColor: null == selectedColor ? _self.selectedColor : selectedColor // ignore: cast_nullable_to_non_nullable
as Color,allStrokes: null == allStrokes ? _self.allStrokes : allStrokes // ignore: cast_nullable_to_non_nullable
as List<DrawingStroke>,getPromptApiResultStatus: null == getPromptApiResultStatus ? _self.getPromptApiResultStatus : getPromptApiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,currentStroke: freezed == currentStroke ? _self.currentStroke : currentStroke // ignore: cast_nullable_to_non_nullable
as DrawingStroke?,
  ));
}
/// Create a copy of ConnectDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get getPromptApiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.getPromptApiResultStatus, (value) {
    return _then(_self.copyWith(getPromptApiResultStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [ConnectDetailState].
extension ConnectDetailStatePatterns on ConnectDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConnectDetailState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConnectDetailState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConnectDetailState value)  $default,){
final _that = this;
switch (_that) {
case _ConnectDetailState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConnectDetailState value)?  $default,){
final _that = this;
switch (_that) {
case _ConnectDetailState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String currentPrompt,  PromptModel? promptModel,  Color selectedColor,  List<DrawingStroke> allStrokes,  ApiResultStatus getPromptApiResultStatus,  DrawingStroke? currentStroke)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConnectDetailState() when $default != null:
return $default(_that.currentPrompt,_that.promptModel,_that.selectedColor,_that.allStrokes,_that.getPromptApiResultStatus,_that.currentStroke);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String currentPrompt,  PromptModel? promptModel,  Color selectedColor,  List<DrawingStroke> allStrokes,  ApiResultStatus getPromptApiResultStatus,  DrawingStroke? currentStroke)  $default,) {final _that = this;
switch (_that) {
case _ConnectDetailState():
return $default(_that.currentPrompt,_that.promptModel,_that.selectedColor,_that.allStrokes,_that.getPromptApiResultStatus,_that.currentStroke);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String currentPrompt,  PromptModel? promptModel,  Color selectedColor,  List<DrawingStroke> allStrokes,  ApiResultStatus getPromptApiResultStatus,  DrawingStroke? currentStroke)?  $default,) {final _that = this;
switch (_that) {
case _ConnectDetailState() when $default != null:
return $default(_that.currentPrompt,_that.promptModel,_that.selectedColor,_that.allStrokes,_that.getPromptApiResultStatus,_that.currentStroke);case _:
  return null;

}
}

}

/// @nodoc


class _ConnectDetailState implements ConnectDetailState {
  const _ConnectDetailState({this.currentPrompt = "Draw what makes you feel calm", this.promptModel, this.selectedColor = Colors.blue, final  List<DrawingStroke> allStrokes = const [], this.getPromptApiResultStatus = const ApiResultStatus.initial(), this.currentStroke}): _allStrokes = allStrokes;
  

@override@JsonKey() final  String currentPrompt;
// Keeping as fallback or while loading/error
@override final  PromptModel? promptModel;
@override@JsonKey() final  Color selectedColor;
 final  List<DrawingStroke> _allStrokes;
@override@JsonKey() List<DrawingStroke> get allStrokes {
  if (_allStrokes is EqualUnmodifiableListView) return _allStrokes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allStrokes);
}

@override@JsonKey() final  ApiResultStatus getPromptApiResultStatus;
@override final  DrawingStroke? currentStroke;

/// Create a copy of ConnectDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConnectDetailStateCopyWith<_ConnectDetailState> get copyWith => __$ConnectDetailStateCopyWithImpl<_ConnectDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConnectDetailState&&(identical(other.currentPrompt, currentPrompt) || other.currentPrompt == currentPrompt)&&(identical(other.promptModel, promptModel) || other.promptModel == promptModel)&&(identical(other.selectedColor, selectedColor) || other.selectedColor == selectedColor)&&const DeepCollectionEquality().equals(other._allStrokes, _allStrokes)&&(identical(other.getPromptApiResultStatus, getPromptApiResultStatus) || other.getPromptApiResultStatus == getPromptApiResultStatus)&&(identical(other.currentStroke, currentStroke) || other.currentStroke == currentStroke));
}


@override
int get hashCode => Object.hash(runtimeType,currentPrompt,promptModel,selectedColor,const DeepCollectionEquality().hash(_allStrokes),getPromptApiResultStatus,currentStroke);

@override
String toString() {
  return 'ConnectDetailState(currentPrompt: $currentPrompt, promptModel: $promptModel, selectedColor: $selectedColor, allStrokes: $allStrokes, getPromptApiResultStatus: $getPromptApiResultStatus, currentStroke: $currentStroke)';
}


}

/// @nodoc
abstract mixin class _$ConnectDetailStateCopyWith<$Res> implements $ConnectDetailStateCopyWith<$Res> {
  factory _$ConnectDetailStateCopyWith(_ConnectDetailState value, $Res Function(_ConnectDetailState) _then) = __$ConnectDetailStateCopyWithImpl;
@override @useResult
$Res call({
 String currentPrompt, PromptModel? promptModel, Color selectedColor, List<DrawingStroke> allStrokes, ApiResultStatus getPromptApiResultStatus, DrawingStroke? currentStroke
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get getPromptApiResultStatus;

}
/// @nodoc
class __$ConnectDetailStateCopyWithImpl<$Res>
    implements _$ConnectDetailStateCopyWith<$Res> {
  __$ConnectDetailStateCopyWithImpl(this._self, this._then);

  final _ConnectDetailState _self;
  final $Res Function(_ConnectDetailState) _then;

/// Create a copy of ConnectDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentPrompt = null,Object? promptModel = freezed,Object? selectedColor = null,Object? allStrokes = null,Object? getPromptApiResultStatus = null,Object? currentStroke = freezed,}) {
  return _then(_ConnectDetailState(
currentPrompt: null == currentPrompt ? _self.currentPrompt : currentPrompt // ignore: cast_nullable_to_non_nullable
as String,promptModel: freezed == promptModel ? _self.promptModel : promptModel // ignore: cast_nullable_to_non_nullable
as PromptModel?,selectedColor: null == selectedColor ? _self.selectedColor : selectedColor // ignore: cast_nullable_to_non_nullable
as Color,allStrokes: null == allStrokes ? _self._allStrokes : allStrokes // ignore: cast_nullable_to_non_nullable
as List<DrawingStroke>,getPromptApiResultStatus: null == getPromptApiResultStatus ? _self.getPromptApiResultStatus : getPromptApiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,currentStroke: freezed == currentStroke ? _self.currentStroke : currentStroke // ignore: cast_nullable_to_non_nullable
as DrawingStroke?,
  ));
}

/// Create a copy of ConnectDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get getPromptApiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.getPromptApiResultStatus, (value) {
    return _then(_self.copyWith(getPromptApiResultStatus: value));
  });
}
}

// dart format on
