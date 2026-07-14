// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'link_co_parent_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LinkCoParentState {

 String get selectedTab; String? get coParentEmail; String? get coParentEmailError; String? get selectChildrenError; bool get calenderAndEvent; bool get childEssentials; String get selectedChild; ApiResultStatus get getApiResultStatus; ApiResultStatus get createInvitation; UserModel? get userModel; List<ChildModel> get children; List<ChildModel> get selectedChildren;/// True when Firestore invite was created but Brevo email delivery failed.
 bool get emailDeliveryFailed;
/// Create a copy of LinkCoParentState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LinkCoParentStateCopyWith<LinkCoParentState> get copyWith => _$LinkCoParentStateCopyWithImpl<LinkCoParentState>(this as LinkCoParentState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LinkCoParentState&&(identical(other.selectedTab, selectedTab) || other.selectedTab == selectedTab)&&(identical(other.coParentEmail, coParentEmail) || other.coParentEmail == coParentEmail)&&(identical(other.coParentEmailError, coParentEmailError) || other.coParentEmailError == coParentEmailError)&&(identical(other.selectChildrenError, selectChildrenError) || other.selectChildrenError == selectChildrenError)&&(identical(other.calenderAndEvent, calenderAndEvent) || other.calenderAndEvent == calenderAndEvent)&&(identical(other.childEssentials, childEssentials) || other.childEssentials == childEssentials)&&(identical(other.selectedChild, selectedChild) || other.selectedChild == selectedChild)&&(identical(other.getApiResultStatus, getApiResultStatus) || other.getApiResultStatus == getApiResultStatus)&&(identical(other.createInvitation, createInvitation) || other.createInvitation == createInvitation)&&(identical(other.userModel, userModel) || other.userModel == userModel)&&const DeepCollectionEquality().equals(other.children, children)&&const DeepCollectionEquality().equals(other.selectedChildren, selectedChildren)&&(identical(other.emailDeliveryFailed, emailDeliveryFailed) || other.emailDeliveryFailed == emailDeliveryFailed));
}


@override
int get hashCode => Object.hash(runtimeType,selectedTab,coParentEmail,coParentEmailError,selectChildrenError,calenderAndEvent,childEssentials,selectedChild,getApiResultStatus,createInvitation,userModel,const DeepCollectionEquality().hash(children),const DeepCollectionEquality().hash(selectedChildren),emailDeliveryFailed);

@override
String toString() {
  return 'LinkCoParentState(selectedTab: $selectedTab, coParentEmail: $coParentEmail, coParentEmailError: $coParentEmailError, selectChildrenError: $selectChildrenError, calenderAndEvent: $calenderAndEvent, childEssentials: $childEssentials, selectedChild: $selectedChild, getApiResultStatus: $getApiResultStatus, createInvitation: $createInvitation, userModel: $userModel, children: $children, selectedChildren: $selectedChildren, emailDeliveryFailed: $emailDeliveryFailed)';
}


}

/// @nodoc
abstract mixin class $LinkCoParentStateCopyWith<$Res>  {
  factory $LinkCoParentStateCopyWith(LinkCoParentState value, $Res Function(LinkCoParentState) _then) = _$LinkCoParentStateCopyWithImpl;
@useResult
$Res call({
 String selectedTab, String? coParentEmail, String? coParentEmailError, String? selectChildrenError, bool calenderAndEvent, bool childEssentials, String selectedChild, ApiResultStatus getApiResultStatus, ApiResultStatus createInvitation, UserModel? userModel, List<ChildModel> children, List<ChildModel> selectedChildren, bool emailDeliveryFailed
});


$ApiResultStatusCopyWith<dynamic, $Res> get getApiResultStatus;$ApiResultStatusCopyWith<dynamic, $Res> get createInvitation;

}
/// @nodoc
class _$LinkCoParentStateCopyWithImpl<$Res>
    implements $LinkCoParentStateCopyWith<$Res> {
  _$LinkCoParentStateCopyWithImpl(this._self, this._then);

  final LinkCoParentState _self;
  final $Res Function(LinkCoParentState) _then;

/// Create a copy of LinkCoParentState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selectedTab = null,Object? coParentEmail = freezed,Object? coParentEmailError = freezed,Object? selectChildrenError = freezed,Object? calenderAndEvent = null,Object? childEssentials = null,Object? selectedChild = null,Object? getApiResultStatus = null,Object? createInvitation = null,Object? userModel = freezed,Object? children = null,Object? selectedChildren = null,Object? emailDeliveryFailed = null,}) {
  return _then(_self.copyWith(
selectedTab: null == selectedTab ? _self.selectedTab : selectedTab // ignore: cast_nullable_to_non_nullable
as String,coParentEmail: freezed == coParentEmail ? _self.coParentEmail : coParentEmail // ignore: cast_nullable_to_non_nullable
as String?,coParentEmailError: freezed == coParentEmailError ? _self.coParentEmailError : coParentEmailError // ignore: cast_nullable_to_non_nullable
as String?,selectChildrenError: freezed == selectChildrenError ? _self.selectChildrenError : selectChildrenError // ignore: cast_nullable_to_non_nullable
as String?,calenderAndEvent: null == calenderAndEvent ? _self.calenderAndEvent : calenderAndEvent // ignore: cast_nullable_to_non_nullable
as bool,childEssentials: null == childEssentials ? _self.childEssentials : childEssentials // ignore: cast_nullable_to_non_nullable
as bool,selectedChild: null == selectedChild ? _self.selectedChild : selectedChild // ignore: cast_nullable_to_non_nullable
as String,getApiResultStatus: null == getApiResultStatus ? _self.getApiResultStatus : getApiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,createInvitation: null == createInvitation ? _self.createInvitation : createInvitation // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,children: null == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as List<ChildModel>,selectedChildren: null == selectedChildren ? _self.selectedChildren : selectedChildren // ignore: cast_nullable_to_non_nullable
as List<ChildModel>,emailDeliveryFailed: null == emailDeliveryFailed ? _self.emailDeliveryFailed : emailDeliveryFailed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of LinkCoParentState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get getApiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.getApiResultStatus, (value) {
    return _then(_self.copyWith(getApiResultStatus: value));
  });
}/// Create a copy of LinkCoParentState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get createInvitation {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.createInvitation, (value) {
    return _then(_self.copyWith(createInvitation: value));
  });
}
}


/// Adds pattern-matching-related methods to [LinkCoParentState].
extension LinkCoParentStatePatterns on LinkCoParentState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LinkCoParentState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LinkCoParentState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LinkCoParentState value)  $default,){
final _that = this;
switch (_that) {
case _LinkCoParentState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LinkCoParentState value)?  $default,){
final _that = this;
switch (_that) {
case _LinkCoParentState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String selectedTab,  String? coParentEmail,  String? coParentEmailError,  String? selectChildrenError,  bool calenderAndEvent,  bool childEssentials,  String selectedChild,  ApiResultStatus getApiResultStatus,  ApiResultStatus createInvitation,  UserModel? userModel,  List<ChildModel> children,  List<ChildModel> selectedChildren,  bool emailDeliveryFailed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LinkCoParentState() when $default != null:
return $default(_that.selectedTab,_that.coParentEmail,_that.coParentEmailError,_that.selectChildrenError,_that.calenderAndEvent,_that.childEssentials,_that.selectedChild,_that.getApiResultStatus,_that.createInvitation,_that.userModel,_that.children,_that.selectedChildren,_that.emailDeliveryFailed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String selectedTab,  String? coParentEmail,  String? coParentEmailError,  String? selectChildrenError,  bool calenderAndEvent,  bool childEssentials,  String selectedChild,  ApiResultStatus getApiResultStatus,  ApiResultStatus createInvitation,  UserModel? userModel,  List<ChildModel> children,  List<ChildModel> selectedChildren,  bool emailDeliveryFailed)  $default,) {final _that = this;
switch (_that) {
case _LinkCoParentState():
return $default(_that.selectedTab,_that.coParentEmail,_that.coParentEmailError,_that.selectChildrenError,_that.calenderAndEvent,_that.childEssentials,_that.selectedChild,_that.getApiResultStatus,_that.createInvitation,_that.userModel,_that.children,_that.selectedChildren,_that.emailDeliveryFailed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String selectedTab,  String? coParentEmail,  String? coParentEmailError,  String? selectChildrenError,  bool calenderAndEvent,  bool childEssentials,  String selectedChild,  ApiResultStatus getApiResultStatus,  ApiResultStatus createInvitation,  UserModel? userModel,  List<ChildModel> children,  List<ChildModel> selectedChildren,  bool emailDeliveryFailed)?  $default,) {final _that = this;
switch (_that) {
case _LinkCoParentState() when $default != null:
return $default(_that.selectedTab,_that.coParentEmail,_that.coParentEmailError,_that.selectChildrenError,_that.calenderAndEvent,_that.childEssentials,_that.selectedChild,_that.getApiResultStatus,_that.createInvitation,_that.userModel,_that.children,_that.selectedChildren,_that.emailDeliveryFailed);case _:
  return null;

}
}

}

/// @nodoc


class _LinkCoParentState implements LinkCoParentState {
  const _LinkCoParentState({this.selectedTab = "EMAIL", this.coParentEmail = "", this.coParentEmailError = "", this.selectChildrenError = "", this.calenderAndEvent = false, this.childEssentials = false, this.selectedChild = "", this.getApiResultStatus = const ApiResultStatus.initial(), this.createInvitation = const ApiResultStatus.initial(), this.userModel, final  List<ChildModel> children = const [], final  List<ChildModel> selectedChildren = const [], this.emailDeliveryFailed = false}): _children = children,_selectedChildren = selectedChildren;
  

@override@JsonKey() final  String selectedTab;
@override@JsonKey() final  String? coParentEmail;
@override@JsonKey() final  String? coParentEmailError;
@override@JsonKey() final  String? selectChildrenError;
@override@JsonKey() final  bool calenderAndEvent;
@override@JsonKey() final  bool childEssentials;
@override@JsonKey() final  String selectedChild;
@override@JsonKey() final  ApiResultStatus getApiResultStatus;
@override@JsonKey() final  ApiResultStatus createInvitation;
@override final  UserModel? userModel;
 final  List<ChildModel> _children;
@override@JsonKey() List<ChildModel> get children {
  if (_children is EqualUnmodifiableListView) return _children;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_children);
}

 final  List<ChildModel> _selectedChildren;
@override@JsonKey() List<ChildModel> get selectedChildren {
  if (_selectedChildren is EqualUnmodifiableListView) return _selectedChildren;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedChildren);
}

/// True when Firestore invite was created but Brevo email delivery failed.
@override@JsonKey() final  bool emailDeliveryFailed;

/// Create a copy of LinkCoParentState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LinkCoParentStateCopyWith<_LinkCoParentState> get copyWith => __$LinkCoParentStateCopyWithImpl<_LinkCoParentState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LinkCoParentState&&(identical(other.selectedTab, selectedTab) || other.selectedTab == selectedTab)&&(identical(other.coParentEmail, coParentEmail) || other.coParentEmail == coParentEmail)&&(identical(other.coParentEmailError, coParentEmailError) || other.coParentEmailError == coParentEmailError)&&(identical(other.selectChildrenError, selectChildrenError) || other.selectChildrenError == selectChildrenError)&&(identical(other.calenderAndEvent, calenderAndEvent) || other.calenderAndEvent == calenderAndEvent)&&(identical(other.childEssentials, childEssentials) || other.childEssentials == childEssentials)&&(identical(other.selectedChild, selectedChild) || other.selectedChild == selectedChild)&&(identical(other.getApiResultStatus, getApiResultStatus) || other.getApiResultStatus == getApiResultStatus)&&(identical(other.createInvitation, createInvitation) || other.createInvitation == createInvitation)&&(identical(other.userModel, userModel) || other.userModel == userModel)&&const DeepCollectionEquality().equals(other._children, _children)&&const DeepCollectionEquality().equals(other._selectedChildren, _selectedChildren)&&(identical(other.emailDeliveryFailed, emailDeliveryFailed) || other.emailDeliveryFailed == emailDeliveryFailed));
}


@override
int get hashCode => Object.hash(runtimeType,selectedTab,coParentEmail,coParentEmailError,selectChildrenError,calenderAndEvent,childEssentials,selectedChild,getApiResultStatus,createInvitation,userModel,const DeepCollectionEquality().hash(_children),const DeepCollectionEquality().hash(_selectedChildren),emailDeliveryFailed);

@override
String toString() {
  return 'LinkCoParentState(selectedTab: $selectedTab, coParentEmail: $coParentEmail, coParentEmailError: $coParentEmailError, selectChildrenError: $selectChildrenError, calenderAndEvent: $calenderAndEvent, childEssentials: $childEssentials, selectedChild: $selectedChild, getApiResultStatus: $getApiResultStatus, createInvitation: $createInvitation, userModel: $userModel, children: $children, selectedChildren: $selectedChildren, emailDeliveryFailed: $emailDeliveryFailed)';
}


}

/// @nodoc
abstract mixin class _$LinkCoParentStateCopyWith<$Res> implements $LinkCoParentStateCopyWith<$Res> {
  factory _$LinkCoParentStateCopyWith(_LinkCoParentState value, $Res Function(_LinkCoParentState) _then) = __$LinkCoParentStateCopyWithImpl;
@override @useResult
$Res call({
 String selectedTab, String? coParentEmail, String? coParentEmailError, String? selectChildrenError, bool calenderAndEvent, bool childEssentials, String selectedChild, ApiResultStatus getApiResultStatus, ApiResultStatus createInvitation, UserModel? userModel, List<ChildModel> children, List<ChildModel> selectedChildren, bool emailDeliveryFailed
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get getApiResultStatus;@override $ApiResultStatusCopyWith<dynamic, $Res> get createInvitation;

}
/// @nodoc
class __$LinkCoParentStateCopyWithImpl<$Res>
    implements _$LinkCoParentStateCopyWith<$Res> {
  __$LinkCoParentStateCopyWithImpl(this._self, this._then);

  final _LinkCoParentState _self;
  final $Res Function(_LinkCoParentState) _then;

/// Create a copy of LinkCoParentState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectedTab = null,Object? coParentEmail = freezed,Object? coParentEmailError = freezed,Object? selectChildrenError = freezed,Object? calenderAndEvent = null,Object? childEssentials = null,Object? selectedChild = null,Object? getApiResultStatus = null,Object? createInvitation = null,Object? userModel = freezed,Object? children = null,Object? selectedChildren = null,Object? emailDeliveryFailed = null,}) {
  return _then(_LinkCoParentState(
selectedTab: null == selectedTab ? _self.selectedTab : selectedTab // ignore: cast_nullable_to_non_nullable
as String,coParentEmail: freezed == coParentEmail ? _self.coParentEmail : coParentEmail // ignore: cast_nullable_to_non_nullable
as String?,coParentEmailError: freezed == coParentEmailError ? _self.coParentEmailError : coParentEmailError // ignore: cast_nullable_to_non_nullable
as String?,selectChildrenError: freezed == selectChildrenError ? _self.selectChildrenError : selectChildrenError // ignore: cast_nullable_to_non_nullable
as String?,calenderAndEvent: null == calenderAndEvent ? _self.calenderAndEvent : calenderAndEvent // ignore: cast_nullable_to_non_nullable
as bool,childEssentials: null == childEssentials ? _self.childEssentials : childEssentials // ignore: cast_nullable_to_non_nullable
as bool,selectedChild: null == selectedChild ? _self.selectedChild : selectedChild // ignore: cast_nullable_to_non_nullable
as String,getApiResultStatus: null == getApiResultStatus ? _self.getApiResultStatus : getApiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,createInvitation: null == createInvitation ? _self.createInvitation : createInvitation // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,children: null == children ? _self._children : children // ignore: cast_nullable_to_non_nullable
as List<ChildModel>,selectedChildren: null == selectedChildren ? _self._selectedChildren : selectedChildren // ignore: cast_nullable_to_non_nullable
as List<ChildModel>,emailDeliveryFailed: null == emailDeliveryFailed ? _self.emailDeliveryFailed : emailDeliveryFailed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of LinkCoParentState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get getApiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.getApiResultStatus, (value) {
    return _then(_self.copyWith(getApiResultStatus: value));
  });
}/// Create a copy of LinkCoParentState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get createInvitation {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.createInvitation, (value) {
    return _then(_self.copyWith(createInvitation: value));
  });
}
}

// dart format on
