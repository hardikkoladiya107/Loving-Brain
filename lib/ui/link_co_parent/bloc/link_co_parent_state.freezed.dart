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

 String get selectedTab; String? get coParentEmail; bool get calenderAndEvent; bool get childEssentials; String get selectedChild;
/// Create a copy of LinkCoParentState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LinkCoParentStateCopyWith<LinkCoParentState> get copyWith => _$LinkCoParentStateCopyWithImpl<LinkCoParentState>(this as LinkCoParentState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LinkCoParentState&&(identical(other.selectedTab, selectedTab) || other.selectedTab == selectedTab)&&(identical(other.coParentEmail, coParentEmail) || other.coParentEmail == coParentEmail)&&(identical(other.calenderAndEvent, calenderAndEvent) || other.calenderAndEvent == calenderAndEvent)&&(identical(other.childEssentials, childEssentials) || other.childEssentials == childEssentials)&&(identical(other.selectedChild, selectedChild) || other.selectedChild == selectedChild));
}


@override
int get hashCode => Object.hash(runtimeType,selectedTab,coParentEmail,calenderAndEvent,childEssentials,selectedChild);

@override
String toString() {
  return 'LinkCoParentState(selectedTab: $selectedTab, coParentEmail: $coParentEmail, calenderAndEvent: $calenderAndEvent, childEssentials: $childEssentials, selectedChild: $selectedChild)';
}


}

/// @nodoc
abstract mixin class $LinkCoParentStateCopyWith<$Res>  {
  factory $LinkCoParentStateCopyWith(LinkCoParentState value, $Res Function(LinkCoParentState) _then) = _$LinkCoParentStateCopyWithImpl;
@useResult
$Res call({
 String selectedTab, String? coParentEmail, bool calenderAndEvent, bool childEssentials, String selectedChild
});




}
/// @nodoc
class _$LinkCoParentStateCopyWithImpl<$Res>
    implements $LinkCoParentStateCopyWith<$Res> {
  _$LinkCoParentStateCopyWithImpl(this._self, this._then);

  final LinkCoParentState _self;
  final $Res Function(LinkCoParentState) _then;

/// Create a copy of LinkCoParentState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selectedTab = null,Object? coParentEmail = freezed,Object? calenderAndEvent = null,Object? childEssentials = null,Object? selectedChild = null,}) {
  return _then(_self.copyWith(
selectedTab: null == selectedTab ? _self.selectedTab : selectedTab // ignore: cast_nullable_to_non_nullable
as String,coParentEmail: freezed == coParentEmail ? _self.coParentEmail : coParentEmail // ignore: cast_nullable_to_non_nullable
as String?,calenderAndEvent: null == calenderAndEvent ? _self.calenderAndEvent : calenderAndEvent // ignore: cast_nullable_to_non_nullable
as bool,childEssentials: null == childEssentials ? _self.childEssentials : childEssentials // ignore: cast_nullable_to_non_nullable
as bool,selectedChild: null == selectedChild ? _self.selectedChild : selectedChild // ignore: cast_nullable_to_non_nullable
as String,
  ));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String selectedTab,  String? coParentEmail,  bool calenderAndEvent,  bool childEssentials,  String selectedChild)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LinkCoParentState() when $default != null:
return $default(_that.selectedTab,_that.coParentEmail,_that.calenderAndEvent,_that.childEssentials,_that.selectedChild);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String selectedTab,  String? coParentEmail,  bool calenderAndEvent,  bool childEssentials,  String selectedChild)  $default,) {final _that = this;
switch (_that) {
case _LinkCoParentState():
return $default(_that.selectedTab,_that.coParentEmail,_that.calenderAndEvent,_that.childEssentials,_that.selectedChild);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String selectedTab,  String? coParentEmail,  bool calenderAndEvent,  bool childEssentials,  String selectedChild)?  $default,) {final _that = this;
switch (_that) {
case _LinkCoParentState() when $default != null:
return $default(_that.selectedTab,_that.coParentEmail,_that.calenderAndEvent,_that.childEssentials,_that.selectedChild);case _:
  return null;

}
}

}

/// @nodoc


class _LinkCoParentState implements LinkCoParentState {
  const _LinkCoParentState({this.selectedTab = "EMAIL", this.coParentEmail = "", this.calenderAndEvent = false, this.childEssentials = false, this.selectedChild = ""});
  

@override@JsonKey() final  String selectedTab;
@override@JsonKey() final  String? coParentEmail;
@override@JsonKey() final  bool calenderAndEvent;
@override@JsonKey() final  bool childEssentials;
@override@JsonKey() final  String selectedChild;

/// Create a copy of LinkCoParentState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LinkCoParentStateCopyWith<_LinkCoParentState> get copyWith => __$LinkCoParentStateCopyWithImpl<_LinkCoParentState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LinkCoParentState&&(identical(other.selectedTab, selectedTab) || other.selectedTab == selectedTab)&&(identical(other.coParentEmail, coParentEmail) || other.coParentEmail == coParentEmail)&&(identical(other.calenderAndEvent, calenderAndEvent) || other.calenderAndEvent == calenderAndEvent)&&(identical(other.childEssentials, childEssentials) || other.childEssentials == childEssentials)&&(identical(other.selectedChild, selectedChild) || other.selectedChild == selectedChild));
}


@override
int get hashCode => Object.hash(runtimeType,selectedTab,coParentEmail,calenderAndEvent,childEssentials,selectedChild);

@override
String toString() {
  return 'LinkCoParentState(selectedTab: $selectedTab, coParentEmail: $coParentEmail, calenderAndEvent: $calenderAndEvent, childEssentials: $childEssentials, selectedChild: $selectedChild)';
}


}

/// @nodoc
abstract mixin class _$LinkCoParentStateCopyWith<$Res> implements $LinkCoParentStateCopyWith<$Res> {
  factory _$LinkCoParentStateCopyWith(_LinkCoParentState value, $Res Function(_LinkCoParentState) _then) = __$LinkCoParentStateCopyWithImpl;
@override @useResult
$Res call({
 String selectedTab, String? coParentEmail, bool calenderAndEvent, bool childEssentials, String selectedChild
});




}
/// @nodoc
class __$LinkCoParentStateCopyWithImpl<$Res>
    implements _$LinkCoParentStateCopyWith<$Res> {
  __$LinkCoParentStateCopyWithImpl(this._self, this._then);

  final _LinkCoParentState _self;
  final $Res Function(_LinkCoParentState) _then;

/// Create a copy of LinkCoParentState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectedTab = null,Object? coParentEmail = freezed,Object? calenderAndEvent = null,Object? childEssentials = null,Object? selectedChild = null,}) {
  return _then(_LinkCoParentState(
selectedTab: null == selectedTab ? _self.selectedTab : selectedTab // ignore: cast_nullable_to_non_nullable
as String,coParentEmail: freezed == coParentEmail ? _self.coParentEmail : coParentEmail // ignore: cast_nullable_to_non_nullable
as String?,calenderAndEvent: null == calenderAndEvent ? _self.calenderAndEvent : calenderAndEvent // ignore: cast_nullable_to_non_nullable
as bool,childEssentials: null == childEssentials ? _self.childEssentials : childEssentials // ignore: cast_nullable_to_non_nullable
as bool,selectedChild: null == selectedChild ? _self.selectedChild : selectedChild // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
