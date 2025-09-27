// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChatDetailState {

 String get chatText; String? get conversationId; ApiResultStatus get createConversationApiResult; ApiResultStatus get getAllConversationApiResult; ApiResultStatus get createResponseApiResult; ApiResultStatus get saveConversationResponseApiResult; List<ConversationItem> get conversationList;
/// Create a copy of ChatDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatDetailStateCopyWith<ChatDetailState> get copyWith => _$ChatDetailStateCopyWithImpl<ChatDetailState>(this as ChatDetailState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatDetailState&&(identical(other.chatText, chatText) || other.chatText == chatText)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.createConversationApiResult, createConversationApiResult) || other.createConversationApiResult == createConversationApiResult)&&(identical(other.getAllConversationApiResult, getAllConversationApiResult) || other.getAllConversationApiResult == getAllConversationApiResult)&&(identical(other.createResponseApiResult, createResponseApiResult) || other.createResponseApiResult == createResponseApiResult)&&(identical(other.saveConversationResponseApiResult, saveConversationResponseApiResult) || other.saveConversationResponseApiResult == saveConversationResponseApiResult)&&const DeepCollectionEquality().equals(other.conversationList, conversationList));
}


@override
int get hashCode => Object.hash(runtimeType,chatText,conversationId,createConversationApiResult,getAllConversationApiResult,createResponseApiResult,saveConversationResponseApiResult,const DeepCollectionEquality().hash(conversationList));

@override
String toString() {
  return 'ChatDetailState(chatText: $chatText, conversationId: $conversationId, createConversationApiResult: $createConversationApiResult, getAllConversationApiResult: $getAllConversationApiResult, createResponseApiResult: $createResponseApiResult, saveConversationResponseApiResult: $saveConversationResponseApiResult, conversationList: $conversationList)';
}


}

/// @nodoc
abstract mixin class $ChatDetailStateCopyWith<$Res>  {
  factory $ChatDetailStateCopyWith(ChatDetailState value, $Res Function(ChatDetailState) _then) = _$ChatDetailStateCopyWithImpl;
@useResult
$Res call({
 String chatText, String? conversationId, ApiResultStatus createConversationApiResult, ApiResultStatus getAllConversationApiResult, ApiResultStatus createResponseApiResult, ApiResultStatus saveConversationResponseApiResult, List<ConversationItem> conversationList
});


$ApiResultStatusCopyWith<dynamic, $Res> get createConversationApiResult;$ApiResultStatusCopyWith<dynamic, $Res> get getAllConversationApiResult;$ApiResultStatusCopyWith<dynamic, $Res> get createResponseApiResult;$ApiResultStatusCopyWith<dynamic, $Res> get saveConversationResponseApiResult;

}
/// @nodoc
class _$ChatDetailStateCopyWithImpl<$Res>
    implements $ChatDetailStateCopyWith<$Res> {
  _$ChatDetailStateCopyWithImpl(this._self, this._then);

  final ChatDetailState _self;
  final $Res Function(ChatDetailState) _then;

/// Create a copy of ChatDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? chatText = null,Object? conversationId = freezed,Object? createConversationApiResult = null,Object? getAllConversationApiResult = null,Object? createResponseApiResult = null,Object? saveConversationResponseApiResult = null,Object? conversationList = null,}) {
  return _then(_self.copyWith(
chatText: null == chatText ? _self.chatText : chatText // ignore: cast_nullable_to_non_nullable
as String,conversationId: freezed == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String?,createConversationApiResult: null == createConversationApiResult ? _self.createConversationApiResult : createConversationApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,getAllConversationApiResult: null == getAllConversationApiResult ? _self.getAllConversationApiResult : getAllConversationApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,createResponseApiResult: null == createResponseApiResult ? _self.createResponseApiResult : createResponseApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,saveConversationResponseApiResult: null == saveConversationResponseApiResult ? _self.saveConversationResponseApiResult : saveConversationResponseApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,conversationList: null == conversationList ? _self.conversationList : conversationList // ignore: cast_nullable_to_non_nullable
as List<ConversationItem>,
  ));
}
/// Create a copy of ChatDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get createConversationApiResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.createConversationApiResult, (value) {
    return _then(_self.copyWith(createConversationApiResult: value));
  });
}/// Create a copy of ChatDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get getAllConversationApiResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.getAllConversationApiResult, (value) {
    return _then(_self.copyWith(getAllConversationApiResult: value));
  });
}/// Create a copy of ChatDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get createResponseApiResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.createResponseApiResult, (value) {
    return _then(_self.copyWith(createResponseApiResult: value));
  });
}/// Create a copy of ChatDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get saveConversationResponseApiResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.saveConversationResponseApiResult, (value) {
    return _then(_self.copyWith(saveConversationResponseApiResult: value));
  });
}
}


/// Adds pattern-matching-related methods to [ChatDetailState].
extension ChatDetailStatePatterns on ChatDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatDetailState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatDetailState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatDetailState value)  $default,){
final _that = this;
switch (_that) {
case _ChatDetailState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatDetailState value)?  $default,){
final _that = this;
switch (_that) {
case _ChatDetailState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String chatText,  String? conversationId,  ApiResultStatus createConversationApiResult,  ApiResultStatus getAllConversationApiResult,  ApiResultStatus createResponseApiResult,  ApiResultStatus saveConversationResponseApiResult,  List<ConversationItem> conversationList)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatDetailState() when $default != null:
return $default(_that.chatText,_that.conversationId,_that.createConversationApiResult,_that.getAllConversationApiResult,_that.createResponseApiResult,_that.saveConversationResponseApiResult,_that.conversationList);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String chatText,  String? conversationId,  ApiResultStatus createConversationApiResult,  ApiResultStatus getAllConversationApiResult,  ApiResultStatus createResponseApiResult,  ApiResultStatus saveConversationResponseApiResult,  List<ConversationItem> conversationList)  $default,) {final _that = this;
switch (_that) {
case _ChatDetailState():
return $default(_that.chatText,_that.conversationId,_that.createConversationApiResult,_that.getAllConversationApiResult,_that.createResponseApiResult,_that.saveConversationResponseApiResult,_that.conversationList);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String chatText,  String? conversationId,  ApiResultStatus createConversationApiResult,  ApiResultStatus getAllConversationApiResult,  ApiResultStatus createResponseApiResult,  ApiResultStatus saveConversationResponseApiResult,  List<ConversationItem> conversationList)?  $default,) {final _that = this;
switch (_that) {
case _ChatDetailState() when $default != null:
return $default(_that.chatText,_that.conversationId,_that.createConversationApiResult,_that.getAllConversationApiResult,_that.createResponseApiResult,_that.saveConversationResponseApiResult,_that.conversationList);case _:
  return null;

}
}

}

/// @nodoc


class _ChatDetailState implements ChatDetailState {
  const _ChatDetailState({this.chatText = "", this.conversationId, this.createConversationApiResult = const ApiResultStatus.initial(), this.getAllConversationApiResult = const ApiResultStatus.initial(), this.createResponseApiResult = const ApiResultStatus.initial(), this.saveConversationResponseApiResult = const ApiResultStatus.initial(), final  List<ConversationItem> conversationList = const []}): _conversationList = conversationList;
  

@override@JsonKey() final  String chatText;
@override final  String? conversationId;
@override@JsonKey() final  ApiResultStatus createConversationApiResult;
@override@JsonKey() final  ApiResultStatus getAllConversationApiResult;
@override@JsonKey() final  ApiResultStatus createResponseApiResult;
@override@JsonKey() final  ApiResultStatus saveConversationResponseApiResult;
 final  List<ConversationItem> _conversationList;
@override@JsonKey() List<ConversationItem> get conversationList {
  if (_conversationList is EqualUnmodifiableListView) return _conversationList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_conversationList);
}


/// Create a copy of ChatDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatDetailStateCopyWith<_ChatDetailState> get copyWith => __$ChatDetailStateCopyWithImpl<_ChatDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatDetailState&&(identical(other.chatText, chatText) || other.chatText == chatText)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.createConversationApiResult, createConversationApiResult) || other.createConversationApiResult == createConversationApiResult)&&(identical(other.getAllConversationApiResult, getAllConversationApiResult) || other.getAllConversationApiResult == getAllConversationApiResult)&&(identical(other.createResponseApiResult, createResponseApiResult) || other.createResponseApiResult == createResponseApiResult)&&(identical(other.saveConversationResponseApiResult, saveConversationResponseApiResult) || other.saveConversationResponseApiResult == saveConversationResponseApiResult)&&const DeepCollectionEquality().equals(other._conversationList, _conversationList));
}


@override
int get hashCode => Object.hash(runtimeType,chatText,conversationId,createConversationApiResult,getAllConversationApiResult,createResponseApiResult,saveConversationResponseApiResult,const DeepCollectionEquality().hash(_conversationList));

@override
String toString() {
  return 'ChatDetailState(chatText: $chatText, conversationId: $conversationId, createConversationApiResult: $createConversationApiResult, getAllConversationApiResult: $getAllConversationApiResult, createResponseApiResult: $createResponseApiResult, saveConversationResponseApiResult: $saveConversationResponseApiResult, conversationList: $conversationList)';
}


}

/// @nodoc
abstract mixin class _$ChatDetailStateCopyWith<$Res> implements $ChatDetailStateCopyWith<$Res> {
  factory _$ChatDetailStateCopyWith(_ChatDetailState value, $Res Function(_ChatDetailState) _then) = __$ChatDetailStateCopyWithImpl;
@override @useResult
$Res call({
 String chatText, String? conversationId, ApiResultStatus createConversationApiResult, ApiResultStatus getAllConversationApiResult, ApiResultStatus createResponseApiResult, ApiResultStatus saveConversationResponseApiResult, List<ConversationItem> conversationList
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get createConversationApiResult;@override $ApiResultStatusCopyWith<dynamic, $Res> get getAllConversationApiResult;@override $ApiResultStatusCopyWith<dynamic, $Res> get createResponseApiResult;@override $ApiResultStatusCopyWith<dynamic, $Res> get saveConversationResponseApiResult;

}
/// @nodoc
class __$ChatDetailStateCopyWithImpl<$Res>
    implements _$ChatDetailStateCopyWith<$Res> {
  __$ChatDetailStateCopyWithImpl(this._self, this._then);

  final _ChatDetailState _self;
  final $Res Function(_ChatDetailState) _then;

/// Create a copy of ChatDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? chatText = null,Object? conversationId = freezed,Object? createConversationApiResult = null,Object? getAllConversationApiResult = null,Object? createResponseApiResult = null,Object? saveConversationResponseApiResult = null,Object? conversationList = null,}) {
  return _then(_ChatDetailState(
chatText: null == chatText ? _self.chatText : chatText // ignore: cast_nullable_to_non_nullable
as String,conversationId: freezed == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String?,createConversationApiResult: null == createConversationApiResult ? _self.createConversationApiResult : createConversationApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,getAllConversationApiResult: null == getAllConversationApiResult ? _self.getAllConversationApiResult : getAllConversationApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,createResponseApiResult: null == createResponseApiResult ? _self.createResponseApiResult : createResponseApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,saveConversationResponseApiResult: null == saveConversationResponseApiResult ? _self.saveConversationResponseApiResult : saveConversationResponseApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,conversationList: null == conversationList ? _self._conversationList : conversationList // ignore: cast_nullable_to_non_nullable
as List<ConversationItem>,
  ));
}

/// Create a copy of ChatDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get createConversationApiResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.createConversationApiResult, (value) {
    return _then(_self.copyWith(createConversationApiResult: value));
  });
}/// Create a copy of ChatDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get getAllConversationApiResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.getAllConversationApiResult, (value) {
    return _then(_self.copyWith(getAllConversationApiResult: value));
  });
}/// Create a copy of ChatDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get createResponseApiResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.createResponseApiResult, (value) {
    return _then(_self.copyWith(createResponseApiResult: value));
  });
}/// Create a copy of ChatDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get saveConversationResponseApiResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.saveConversationResponseApiResult, (value) {
    return _then(_self.copyWith(saveConversationResponseApiResult: value));
  });
}
}

// dart format on
