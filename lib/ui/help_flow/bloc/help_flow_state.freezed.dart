// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'help_flow_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HelpFlowState {

 UserModel? get userModel; ChildModel? get childModel; ChildState? get childState; String get selectedProblemType; String get contextLine; String get primaryAction; List<String> get steps; String get fallbackText; int get solutionIndex; int get failedAttempts; bool get showEscalationHint; ApiResultStatus get saveApiResultStatus;
/// Create a copy of HelpFlowState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HelpFlowStateCopyWith<HelpFlowState> get copyWith => _$HelpFlowStateCopyWithImpl<HelpFlowState>(this as HelpFlowState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HelpFlowState&&(identical(other.userModel, userModel) || other.userModel == userModel)&&(identical(other.childModel, childModel) || other.childModel == childModel)&&(identical(other.childState, childState) || other.childState == childState)&&(identical(other.selectedProblemType, selectedProblemType) || other.selectedProblemType == selectedProblemType)&&(identical(other.contextLine, contextLine) || other.contextLine == contextLine)&&(identical(other.primaryAction, primaryAction) || other.primaryAction == primaryAction)&&const DeepCollectionEquality().equals(other.steps, steps)&&(identical(other.fallbackText, fallbackText) || other.fallbackText == fallbackText)&&(identical(other.solutionIndex, solutionIndex) || other.solutionIndex == solutionIndex)&&(identical(other.failedAttempts, failedAttempts) || other.failedAttempts == failedAttempts)&&(identical(other.showEscalationHint, showEscalationHint) || other.showEscalationHint == showEscalationHint)&&(identical(other.saveApiResultStatus, saveApiResultStatus) || other.saveApiResultStatus == saveApiResultStatus));
}


@override
int get hashCode => Object.hash(runtimeType,userModel,childModel,childState,selectedProblemType,contextLine,primaryAction,const DeepCollectionEquality().hash(steps),fallbackText,solutionIndex,failedAttempts,showEscalationHint,saveApiResultStatus);

@override
String toString() {
  return 'HelpFlowState(userModel: $userModel, childModel: $childModel, childState: $childState, selectedProblemType: $selectedProblemType, contextLine: $contextLine, primaryAction: $primaryAction, steps: $steps, fallbackText: $fallbackText, solutionIndex: $solutionIndex, failedAttempts: $failedAttempts, showEscalationHint: $showEscalationHint, saveApiResultStatus: $saveApiResultStatus)';
}


}

/// @nodoc
abstract mixin class $HelpFlowStateCopyWith<$Res>  {
  factory $HelpFlowStateCopyWith(HelpFlowState value, $Res Function(HelpFlowState) _then) = _$HelpFlowStateCopyWithImpl;
@useResult
$Res call({
 UserModel? userModel, ChildModel? childModel, ChildState? childState, String selectedProblemType, String contextLine, String primaryAction, List<String> steps, String fallbackText, int solutionIndex, int failedAttempts, bool showEscalationHint, ApiResultStatus saveApiResultStatus
});


$ApiResultStatusCopyWith<dynamic, $Res> get saveApiResultStatus;

}
/// @nodoc
class _$HelpFlowStateCopyWithImpl<$Res>
    implements $HelpFlowStateCopyWith<$Res> {
  _$HelpFlowStateCopyWithImpl(this._self, this._then);

  final HelpFlowState _self;
  final $Res Function(HelpFlowState) _then;

/// Create a copy of HelpFlowState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userModel = freezed,Object? childModel = freezed,Object? childState = freezed,Object? selectedProblemType = null,Object? contextLine = null,Object? primaryAction = null,Object? steps = null,Object? fallbackText = null,Object? solutionIndex = null,Object? failedAttempts = null,Object? showEscalationHint = null,Object? saveApiResultStatus = null,}) {
  return _then(_self.copyWith(
userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,childModel: freezed == childModel ? _self.childModel : childModel // ignore: cast_nullable_to_non_nullable
as ChildModel?,childState: freezed == childState ? _self.childState : childState // ignore: cast_nullable_to_non_nullable
as ChildState?,selectedProblemType: null == selectedProblemType ? _self.selectedProblemType : selectedProblemType // ignore: cast_nullable_to_non_nullable
as String,contextLine: null == contextLine ? _self.contextLine : contextLine // ignore: cast_nullable_to_non_nullable
as String,primaryAction: null == primaryAction ? _self.primaryAction : primaryAction // ignore: cast_nullable_to_non_nullable
as String,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as List<String>,fallbackText: null == fallbackText ? _self.fallbackText : fallbackText // ignore: cast_nullable_to_non_nullable
as String,solutionIndex: null == solutionIndex ? _self.solutionIndex : solutionIndex // ignore: cast_nullable_to_non_nullable
as int,failedAttempts: null == failedAttempts ? _self.failedAttempts : failedAttempts // ignore: cast_nullable_to_non_nullable
as int,showEscalationHint: null == showEscalationHint ? _self.showEscalationHint : showEscalationHint // ignore: cast_nullable_to_non_nullable
as bool,saveApiResultStatus: null == saveApiResultStatus ? _self.saveApiResultStatus : saveApiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,
  ));
}
/// Create a copy of HelpFlowState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get saveApiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.saveApiResultStatus, (value) {
    return _then(_self.copyWith(saveApiResultStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [HelpFlowState].
extension HelpFlowStatePatterns on HelpFlowState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HelpFlowState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HelpFlowState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HelpFlowState value)  $default,){
final _that = this;
switch (_that) {
case _HelpFlowState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HelpFlowState value)?  $default,){
final _that = this;
switch (_that) {
case _HelpFlowState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UserModel? userModel,  ChildModel? childModel,  ChildState? childState,  String selectedProblemType,  String contextLine,  String primaryAction,  List<String> steps,  String fallbackText,  int solutionIndex,  int failedAttempts,  bool showEscalationHint,  ApiResultStatus saveApiResultStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HelpFlowState() when $default != null:
return $default(_that.userModel,_that.childModel,_that.childState,_that.selectedProblemType,_that.contextLine,_that.primaryAction,_that.steps,_that.fallbackText,_that.solutionIndex,_that.failedAttempts,_that.showEscalationHint,_that.saveApiResultStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UserModel? userModel,  ChildModel? childModel,  ChildState? childState,  String selectedProblemType,  String contextLine,  String primaryAction,  List<String> steps,  String fallbackText,  int solutionIndex,  int failedAttempts,  bool showEscalationHint,  ApiResultStatus saveApiResultStatus)  $default,) {final _that = this;
switch (_that) {
case _HelpFlowState():
return $default(_that.userModel,_that.childModel,_that.childState,_that.selectedProblemType,_that.contextLine,_that.primaryAction,_that.steps,_that.fallbackText,_that.solutionIndex,_that.failedAttempts,_that.showEscalationHint,_that.saveApiResultStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UserModel? userModel,  ChildModel? childModel,  ChildState? childState,  String selectedProblemType,  String contextLine,  String primaryAction,  List<String> steps,  String fallbackText,  int solutionIndex,  int failedAttempts,  bool showEscalationHint,  ApiResultStatus saveApiResultStatus)?  $default,) {final _that = this;
switch (_that) {
case _HelpFlowState() when $default != null:
return $default(_that.userModel,_that.childModel,_that.childState,_that.selectedProblemType,_that.contextLine,_that.primaryAction,_that.steps,_that.fallbackText,_that.solutionIndex,_that.failedAttempts,_that.showEscalationHint,_that.saveApiResultStatus);case _:
  return null;

}
}

}

/// @nodoc


class _HelpFlowState implements HelpFlowState {
  const _HelpFlowState({this.userModel, this.childModel, this.childState, this.selectedProblemType = '', this.contextLine = '', this.primaryAction = '', final  List<String> steps = const <String>[], this.fallbackText = '', this.solutionIndex = 0, this.failedAttempts = 0, this.showEscalationHint = false, this.saveApiResultStatus = const ApiResultStatus.initial()}): _steps = steps;
  

@override final  UserModel? userModel;
@override final  ChildModel? childModel;
@override final  ChildState? childState;
@override@JsonKey() final  String selectedProblemType;
@override@JsonKey() final  String contextLine;
@override@JsonKey() final  String primaryAction;
 final  List<String> _steps;
@override@JsonKey() List<String> get steps {
  if (_steps is EqualUnmodifiableListView) return _steps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_steps);
}

@override@JsonKey() final  String fallbackText;
@override@JsonKey() final  int solutionIndex;
@override@JsonKey() final  int failedAttempts;
@override@JsonKey() final  bool showEscalationHint;
@override@JsonKey() final  ApiResultStatus saveApiResultStatus;

/// Create a copy of HelpFlowState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HelpFlowStateCopyWith<_HelpFlowState> get copyWith => __$HelpFlowStateCopyWithImpl<_HelpFlowState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HelpFlowState&&(identical(other.userModel, userModel) || other.userModel == userModel)&&(identical(other.childModel, childModel) || other.childModel == childModel)&&(identical(other.childState, childState) || other.childState == childState)&&(identical(other.selectedProblemType, selectedProblemType) || other.selectedProblemType == selectedProblemType)&&(identical(other.contextLine, contextLine) || other.contextLine == contextLine)&&(identical(other.primaryAction, primaryAction) || other.primaryAction == primaryAction)&&const DeepCollectionEquality().equals(other._steps, _steps)&&(identical(other.fallbackText, fallbackText) || other.fallbackText == fallbackText)&&(identical(other.solutionIndex, solutionIndex) || other.solutionIndex == solutionIndex)&&(identical(other.failedAttempts, failedAttempts) || other.failedAttempts == failedAttempts)&&(identical(other.showEscalationHint, showEscalationHint) || other.showEscalationHint == showEscalationHint)&&(identical(other.saveApiResultStatus, saveApiResultStatus) || other.saveApiResultStatus == saveApiResultStatus));
}


@override
int get hashCode => Object.hash(runtimeType,userModel,childModel,childState,selectedProblemType,contextLine,primaryAction,const DeepCollectionEquality().hash(_steps),fallbackText,solutionIndex,failedAttempts,showEscalationHint,saveApiResultStatus);

@override
String toString() {
  return 'HelpFlowState(userModel: $userModel, childModel: $childModel, childState: $childState, selectedProblemType: $selectedProblemType, contextLine: $contextLine, primaryAction: $primaryAction, steps: $steps, fallbackText: $fallbackText, solutionIndex: $solutionIndex, failedAttempts: $failedAttempts, showEscalationHint: $showEscalationHint, saveApiResultStatus: $saveApiResultStatus)';
}


}

/// @nodoc
abstract mixin class _$HelpFlowStateCopyWith<$Res> implements $HelpFlowStateCopyWith<$Res> {
  factory _$HelpFlowStateCopyWith(_HelpFlowState value, $Res Function(_HelpFlowState) _then) = __$HelpFlowStateCopyWithImpl;
@override @useResult
$Res call({
 UserModel? userModel, ChildModel? childModel, ChildState? childState, String selectedProblemType, String contextLine, String primaryAction, List<String> steps, String fallbackText, int solutionIndex, int failedAttempts, bool showEscalationHint, ApiResultStatus saveApiResultStatus
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get saveApiResultStatus;

}
/// @nodoc
class __$HelpFlowStateCopyWithImpl<$Res>
    implements _$HelpFlowStateCopyWith<$Res> {
  __$HelpFlowStateCopyWithImpl(this._self, this._then);

  final _HelpFlowState _self;
  final $Res Function(_HelpFlowState) _then;

/// Create a copy of HelpFlowState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userModel = freezed,Object? childModel = freezed,Object? childState = freezed,Object? selectedProblemType = null,Object? contextLine = null,Object? primaryAction = null,Object? steps = null,Object? fallbackText = null,Object? solutionIndex = null,Object? failedAttempts = null,Object? showEscalationHint = null,Object? saveApiResultStatus = null,}) {
  return _then(_HelpFlowState(
userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,childModel: freezed == childModel ? _self.childModel : childModel // ignore: cast_nullable_to_non_nullable
as ChildModel?,childState: freezed == childState ? _self.childState : childState // ignore: cast_nullable_to_non_nullable
as ChildState?,selectedProblemType: null == selectedProblemType ? _self.selectedProblemType : selectedProblemType // ignore: cast_nullable_to_non_nullable
as String,contextLine: null == contextLine ? _self.contextLine : contextLine // ignore: cast_nullable_to_non_nullable
as String,primaryAction: null == primaryAction ? _self.primaryAction : primaryAction // ignore: cast_nullable_to_non_nullable
as String,steps: null == steps ? _self._steps : steps // ignore: cast_nullable_to_non_nullable
as List<String>,fallbackText: null == fallbackText ? _self.fallbackText : fallbackText // ignore: cast_nullable_to_non_nullable
as String,solutionIndex: null == solutionIndex ? _self.solutionIndex : solutionIndex // ignore: cast_nullable_to_non_nullable
as int,failedAttempts: null == failedAttempts ? _self.failedAttempts : failedAttempts // ignore: cast_nullable_to_non_nullable
as int,showEscalationHint: null == showEscalationHint ? _self.showEscalationHint : showEscalationHint // ignore: cast_nullable_to_non_nullable
as bool,saveApiResultStatus: null == saveApiResultStatus ? _self.saveApiResultStatus : saveApiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,
  ));
}

/// Create a copy of HelpFlowState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get saveApiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.saveApiResultStatus, (value) {
    return _then(_self.copyWith(saveApiResultStatus: value));
  });
}
}

// dart format on
