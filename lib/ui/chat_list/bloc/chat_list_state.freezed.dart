// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChatListState {

 String get message; UserModel? get userModel; ApiResultStatus get getConversationsApiResult; ApiResultStatus get deleteConversationsApiResult; List<ConversationListItem> get conversationList;
/// Create a copy of ChatListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatListStateCopyWith<ChatListState> get copyWith => _$ChatListStateCopyWithImpl<ChatListState>(this as ChatListState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatListState&&(identical(other.message, message) || other.message == message)&&(identical(other.userModel, userModel) || other.userModel == userModel)&&(identical(other.getConversationsApiResult, getConversationsApiResult) || other.getConversationsApiResult == getConversationsApiResult)&&(identical(other.deleteConversationsApiResult, deleteConversationsApiResult) || other.deleteConversationsApiResult == deleteConversationsApiResult)&&const DeepCollectionEquality().equals(other.conversationList, conversationList));
}


@override
int get hashCode => Object.hash(runtimeType,message,userModel,getConversationsApiResult,deleteConversationsApiResult,const DeepCollectionEquality().hash(conversationList));

@override
String toString() {
  return 'ChatListState(message: $message, userModel: $userModel, getConversationsApiResult: $getConversationsApiResult, deleteConversationsApiResult: $deleteConversationsApiResult, conversationList: $conversationList)';
}


}

/// @nodoc
abstract mixin class $ChatListStateCopyWith<$Res>  {
  factory $ChatListStateCopyWith(ChatListState value, $Res Function(ChatListState) _then) = _$ChatListStateCopyWithImpl;
@useResult
$Res call({
 String message, UserModel? userModel, ApiResultStatus getConversationsApiResult, ApiResultStatus deleteConversationsApiResult, List<ConversationListItem> conversationList
});


$ApiResultStatusCopyWith<dynamic, $Res> get getConversationsApiResult;$ApiResultStatusCopyWith<dynamic, $Res> get deleteConversationsApiResult;

}
/// @nodoc
class _$ChatListStateCopyWithImpl<$Res>
    implements $ChatListStateCopyWith<$Res> {
  _$ChatListStateCopyWithImpl(this._self, this._then);

  final ChatListState _self;
  final $Res Function(ChatListState) _then;

/// Create a copy of ChatListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,Object? userModel = freezed,Object? getConversationsApiResult = null,Object? deleteConversationsApiResult = null,Object? conversationList = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,getConversationsApiResult: null == getConversationsApiResult ? _self.getConversationsApiResult : getConversationsApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,deleteConversationsApiResult: null == deleteConversationsApiResult ? _self.deleteConversationsApiResult : deleteConversationsApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,conversationList: null == conversationList ? _self.conversationList : conversationList // ignore: cast_nullable_to_non_nullable
as List<ConversationListItem>,
  ));
}
/// Create a copy of ChatListState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get getConversationsApiResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.getConversationsApiResult, (value) {
    return _then(_self.copyWith(getConversationsApiResult: value));
  });
}/// Create a copy of ChatListState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get deleteConversationsApiResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.deleteConversationsApiResult, (value) {
    return _then(_self.copyWith(deleteConversationsApiResult: value));
  });
}
}


/// Adds pattern-matching-related methods to [ChatListState].
extension ChatListStatePatterns on ChatListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatListState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatListState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatListState value)  $default,){
final _that = this;
switch (_that) {
case _ChatListState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatListState value)?  $default,){
final _that = this;
switch (_that) {
case _ChatListState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String message,  UserModel? userModel,  ApiResultStatus getConversationsApiResult,  ApiResultStatus deleteConversationsApiResult,  List<ConversationListItem> conversationList)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatListState() when $default != null:
return $default(_that.message,_that.userModel,_that.getConversationsApiResult,_that.deleteConversationsApiResult,_that.conversationList);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String message,  UserModel? userModel,  ApiResultStatus getConversationsApiResult,  ApiResultStatus deleteConversationsApiResult,  List<ConversationListItem> conversationList)  $default,) {final _that = this;
switch (_that) {
case _ChatListState():
return $default(_that.message,_that.userModel,_that.getConversationsApiResult,_that.deleteConversationsApiResult,_that.conversationList);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String message,  UserModel? userModel,  ApiResultStatus getConversationsApiResult,  ApiResultStatus deleteConversationsApiResult,  List<ConversationListItem> conversationList)?  $default,) {final _that = this;
switch (_that) {
case _ChatListState() when $default != null:
return $default(_that.message,_that.userModel,_that.getConversationsApiResult,_that.deleteConversationsApiResult,_that.conversationList);case _:
  return null;

}
}

}

/// @nodoc


class _ChatListState implements ChatListState {
  const _ChatListState({this.message = "", this.userModel, this.getConversationsApiResult = const ApiResultStatus.initial(), this.deleteConversationsApiResult = const ApiResultStatus.initial(), final  List<ConversationListItem> conversationList = const []}): _conversationList = conversationList;
  

@override@JsonKey() final  String message;
@override final  UserModel? userModel;
@override@JsonKey() final  ApiResultStatus getConversationsApiResult;
@override@JsonKey() final  ApiResultStatus deleteConversationsApiResult;
 final  List<ConversationListItem> _conversationList;
@override@JsonKey() List<ConversationListItem> get conversationList {
  if (_conversationList is EqualUnmodifiableListView) return _conversationList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_conversationList);
}


/// Create a copy of ChatListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatListStateCopyWith<_ChatListState> get copyWith => __$ChatListStateCopyWithImpl<_ChatListState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatListState&&(identical(other.message, message) || other.message == message)&&(identical(other.userModel, userModel) || other.userModel == userModel)&&(identical(other.getConversationsApiResult, getConversationsApiResult) || other.getConversationsApiResult == getConversationsApiResult)&&(identical(other.deleteConversationsApiResult, deleteConversationsApiResult) || other.deleteConversationsApiResult == deleteConversationsApiResult)&&const DeepCollectionEquality().equals(other._conversationList, _conversationList));
}


@override
int get hashCode => Object.hash(runtimeType,message,userModel,getConversationsApiResult,deleteConversationsApiResult,const DeepCollectionEquality().hash(_conversationList));

@override
String toString() {
  return 'ChatListState(message: $message, userModel: $userModel, getConversationsApiResult: $getConversationsApiResult, deleteConversationsApiResult: $deleteConversationsApiResult, conversationList: $conversationList)';
}


}

/// @nodoc
abstract mixin class _$ChatListStateCopyWith<$Res> implements $ChatListStateCopyWith<$Res> {
  factory _$ChatListStateCopyWith(_ChatListState value, $Res Function(_ChatListState) _then) = __$ChatListStateCopyWithImpl;
@override @useResult
$Res call({
 String message, UserModel? userModel, ApiResultStatus getConversationsApiResult, ApiResultStatus deleteConversationsApiResult, List<ConversationListItem> conversationList
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get getConversationsApiResult;@override $ApiResultStatusCopyWith<dynamic, $Res> get deleteConversationsApiResult;

}
/// @nodoc
class __$ChatListStateCopyWithImpl<$Res>
    implements _$ChatListStateCopyWith<$Res> {
  __$ChatListStateCopyWithImpl(this._self, this._then);

  final _ChatListState _self;
  final $Res Function(_ChatListState) _then;

/// Create a copy of ChatListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? userModel = freezed,Object? getConversationsApiResult = null,Object? deleteConversationsApiResult = null,Object? conversationList = null,}) {
  return _then(_ChatListState(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,getConversationsApiResult: null == getConversationsApiResult ? _self.getConversationsApiResult : getConversationsApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,deleteConversationsApiResult: null == deleteConversationsApiResult ? _self.deleteConversationsApiResult : deleteConversationsApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,conversationList: null == conversationList ? _self._conversationList : conversationList // ignore: cast_nullable_to_non_nullable
as List<ConversationListItem>,
  ));
}

/// Create a copy of ChatListState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get getConversationsApiResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.getConversationsApiResult, (value) {
    return _then(_self.copyWith(getConversationsApiResult: value));
  });
}/// Create a copy of ChatListState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get deleteConversationsApiResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.deleteConversationsApiResult, (value) {
    return _then(_self.copyWith(deleteConversationsApiResult: value));
  });
}
}

// dart format on
