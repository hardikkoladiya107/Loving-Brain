// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_chat_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AiChatState {

 String get chatText;
/// Create a copy of AiChatState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiChatStateCopyWith<AiChatState> get copyWith => _$AiChatStateCopyWithImpl<AiChatState>(this as AiChatState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiChatState&&(identical(other.chatText, chatText) || other.chatText == chatText));
}


@override
int get hashCode => Object.hash(runtimeType,chatText);

@override
String toString() {
  return 'AiChatState(chatText: $chatText)';
}


}

/// @nodoc
abstract mixin class $AiChatStateCopyWith<$Res>  {
  factory $AiChatStateCopyWith(AiChatState value, $Res Function(AiChatState) _then) = _$AiChatStateCopyWithImpl;
@useResult
$Res call({
 String chatText
});




}
/// @nodoc
class _$AiChatStateCopyWithImpl<$Res>
    implements $AiChatStateCopyWith<$Res> {
  _$AiChatStateCopyWithImpl(this._self, this._then);

  final AiChatState _self;
  final $Res Function(AiChatState) _then;

/// Create a copy of AiChatState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? chatText = null,}) {
  return _then(_self.copyWith(
chatText: null == chatText ? _self.chatText : chatText // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AiChatState].
extension AiChatStatePatterns on AiChatState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiChatState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiChatState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiChatState value)  $default,){
final _that = this;
switch (_that) {
case _AiChatState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiChatState value)?  $default,){
final _that = this;
switch (_that) {
case _AiChatState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String chatText)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiChatState() when $default != null:
return $default(_that.chatText);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String chatText)  $default,) {final _that = this;
switch (_that) {
case _AiChatState():
return $default(_that.chatText);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String chatText)?  $default,) {final _that = this;
switch (_that) {
case _AiChatState() when $default != null:
return $default(_that.chatText);case _:
  return null;

}
}

}

/// @nodoc


class _AiChatState implements AiChatState {
  const _AiChatState({this.chatText = ""});
  

@override@JsonKey() final  String chatText;

/// Create a copy of AiChatState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiChatStateCopyWith<_AiChatState> get copyWith => __$AiChatStateCopyWithImpl<_AiChatState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiChatState&&(identical(other.chatText, chatText) || other.chatText == chatText));
}


@override
int get hashCode => Object.hash(runtimeType,chatText);

@override
String toString() {
  return 'AiChatState(chatText: $chatText)';
}


}

/// @nodoc
abstract mixin class _$AiChatStateCopyWith<$Res> implements $AiChatStateCopyWith<$Res> {
  factory _$AiChatStateCopyWith(_AiChatState value, $Res Function(_AiChatState) _then) = __$AiChatStateCopyWithImpl;
@override @useResult
$Res call({
 String chatText
});




}
/// @nodoc
class __$AiChatStateCopyWithImpl<$Res>
    implements _$AiChatStateCopyWith<$Res> {
  __$AiChatStateCopyWithImpl(this._self, this._then);

  final _AiChatState _self;
  final $Res Function(_AiChatState) _then;

/// Create a copy of AiChatState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? chatText = null,}) {
  return _then(_AiChatState(
chatText: null == chatText ? _self.chatText : chatText // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
