// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'brainy_conversation_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BrainyConversationState {

 List<BrainyMessage> get messages; bool get isTyping;
/// Create a copy of BrainyConversationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BrainyConversationStateCopyWith<BrainyConversationState> get copyWith => _$BrainyConversationStateCopyWithImpl<BrainyConversationState>(this as BrainyConversationState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BrainyConversationState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BrainyConversationState&&const DeepCollectionEquality().equals(other.messages, _this.messages)&&(identical(other.isTyping, _this.isTyping) || other.isTyping == _this.isTyping));
}


@override
int get hashCode {
  final _this = this as BrainyConversationState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.messages),_this.isTyping);
}

@override
String toString() {
  final _this = this as BrainyConversationState;
  return 'BrainyConversationState(messages: ${_this.messages}, isTyping: ${_this.isTyping})';
}


}

/// @nodoc
abstract mixin class $BrainyConversationStateCopyWith<$Res>  {
  factory $BrainyConversationStateCopyWith(BrainyConversationState value, $Res Function(BrainyConversationState) _then) = _$BrainyConversationStateCopyWithImpl;
@useResult
$Res call({
 List<BrainyMessage> messages, bool isTyping
});




}
/// @nodoc
class _$BrainyConversationStateCopyWithImpl<$Res>
    implements $BrainyConversationStateCopyWith<$Res> {
  _$BrainyConversationStateCopyWithImpl(this._self, this._then);

  final BrainyConversationState _self;
  final $Res Function(BrainyConversationState) _then;

/// Create a copy of BrainyConversationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? messages = null,Object? isTyping = null,}) {
  return _then(BrainyConversationState(
messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<BrainyMessage>,isTyping: null == isTyping ? _self.isTyping : isTyping // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [BrainyConversationState].
extension BrainyConversationStatePatterns on BrainyConversationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BrainyConversationState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BrainyConversationState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BrainyConversationState value)  $default,){
final _that = this;
switch (_that) {
case _BrainyConversationState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BrainyConversationState value)?  $default,){
final _that = this;
switch (_that) {
case _BrainyConversationState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<BrainyMessage> messages,  bool isTyping)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BrainyConversationState() when $default != null:
return $default(_that.messages,_that.isTyping);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<BrainyMessage> messages,  bool isTyping)  $default,) {final _that = this;
switch (_that) {
case _BrainyConversationState():
return $default(_that.messages,_that.isTyping);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<BrainyMessage> messages,  bool isTyping)?  $default,) {final _that = this;
switch (_that) {
case _BrainyConversationState() when $default != null:
return $default(_that.messages,_that.isTyping);case _:
  return null;

}
}

}

/// @nodoc


class _BrainyConversationState implements BrainyConversationState {
  const _BrainyConversationState({ List<BrainyMessage> messages = const [], this.isTyping = false}): _messages = messages;
  

 final  List<BrainyMessage> _messages;
@override@JsonKey() List<BrainyMessage> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}

@override@JsonKey() final  bool isTyping;

/// Create a copy of BrainyConversationState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BrainyConversationStateCopyWith<_BrainyConversationState> get copyWith => __$BrainyConversationStateCopyWithImpl<_BrainyConversationState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BrainyConversationState&&const DeepCollectionEquality().equals(other.messages, _messages)&&(identical(other.isTyping, isTyping) || other.isTyping == isTyping));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_messages),isTyping);
}

@override
String toString() {
    return 'BrainyConversationState(messages: $messages, isTyping: $isTyping)';
}


}

/// @nodoc
abstract mixin class _$BrainyConversationStateCopyWith<$Res> implements $BrainyConversationStateCopyWith<$Res> {
  factory _$BrainyConversationStateCopyWith(_BrainyConversationState value, $Res Function(_BrainyConversationState) _then) = __$BrainyConversationStateCopyWithImpl;
@override @useResult
$Res call({
 List<BrainyMessage> messages, bool isTyping
});




}
/// @nodoc
class __$BrainyConversationStateCopyWithImpl<$Res>
    implements _$BrainyConversationStateCopyWith<$Res> {
  __$BrainyConversationStateCopyWithImpl(this._self, this._then);

  final _BrainyConversationState _self;
  final $Res Function(_BrainyConversationState) _then;

/// Create a copy of BrainyConversationState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? messages = null,Object? isTyping = null,}) {
  return _then(_BrainyConversationState(
messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<BrainyMessage>,isTyping: null == isTyping ? _self.isTyping : isTyping // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
