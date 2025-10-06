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

 String get chatText; String get selectedNetworkImage; String? get conversationId; ApiResultStatus get createConversationApiResult; ApiResultStatus get createResponseApiResult; ApiResultStatus get getConversationApiResult; ApiResultStatus get imageUploadApiResult; List<ChatModel> get chatList; File? get selectedFile; UserModel? get userModel; Reference? get firebaseFileReference;
/// Create a copy of ChatDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatDetailStateCopyWith<ChatDetailState> get copyWith => _$ChatDetailStateCopyWithImpl<ChatDetailState>(this as ChatDetailState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatDetailState&&(identical(other.chatText, chatText) || other.chatText == chatText)&&(identical(other.selectedNetworkImage, selectedNetworkImage) || other.selectedNetworkImage == selectedNetworkImage)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.createConversationApiResult, createConversationApiResult) || other.createConversationApiResult == createConversationApiResult)&&(identical(other.createResponseApiResult, createResponseApiResult) || other.createResponseApiResult == createResponseApiResult)&&(identical(other.getConversationApiResult, getConversationApiResult) || other.getConversationApiResult == getConversationApiResult)&&(identical(other.imageUploadApiResult, imageUploadApiResult) || other.imageUploadApiResult == imageUploadApiResult)&&const DeepCollectionEquality().equals(other.chatList, chatList)&&(identical(other.selectedFile, selectedFile) || other.selectedFile == selectedFile)&&(identical(other.userModel, userModel) || other.userModel == userModel)&&(identical(other.firebaseFileReference, firebaseFileReference) || other.firebaseFileReference == firebaseFileReference));
}


@override
int get hashCode => Object.hash(runtimeType,chatText,selectedNetworkImage,conversationId,createConversationApiResult,createResponseApiResult,getConversationApiResult,imageUploadApiResult,const DeepCollectionEquality().hash(chatList),selectedFile,userModel,firebaseFileReference);

@override
String toString() {
  return 'ChatDetailState(chatText: $chatText, selectedNetworkImage: $selectedNetworkImage, conversationId: $conversationId, createConversationApiResult: $createConversationApiResult, createResponseApiResult: $createResponseApiResult, getConversationApiResult: $getConversationApiResult, imageUploadApiResult: $imageUploadApiResult, chatList: $chatList, selectedFile: $selectedFile, userModel: $userModel, firebaseFileReference: $firebaseFileReference)';
}


}

/// @nodoc
abstract mixin class $ChatDetailStateCopyWith<$Res>  {
  factory $ChatDetailStateCopyWith(ChatDetailState value, $Res Function(ChatDetailState) _then) = _$ChatDetailStateCopyWithImpl;
@useResult
$Res call({
 String chatText, String selectedNetworkImage, String? conversationId, ApiResultStatus createConversationApiResult, ApiResultStatus createResponseApiResult, ApiResultStatus getConversationApiResult, ApiResultStatus imageUploadApiResult, List<ChatModel> chatList, File? selectedFile, UserModel? userModel, Reference? firebaseFileReference
});


$ApiResultStatusCopyWith<dynamic, $Res> get createConversationApiResult;$ApiResultStatusCopyWith<dynamic, $Res> get createResponseApiResult;$ApiResultStatusCopyWith<dynamic, $Res> get getConversationApiResult;$ApiResultStatusCopyWith<dynamic, $Res> get imageUploadApiResult;

}
/// @nodoc
class _$ChatDetailStateCopyWithImpl<$Res>
    implements $ChatDetailStateCopyWith<$Res> {
  _$ChatDetailStateCopyWithImpl(this._self, this._then);

  final ChatDetailState _self;
  final $Res Function(ChatDetailState) _then;

/// Create a copy of ChatDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? chatText = null,Object? selectedNetworkImage = null,Object? conversationId = freezed,Object? createConversationApiResult = null,Object? createResponseApiResult = null,Object? getConversationApiResult = null,Object? imageUploadApiResult = null,Object? chatList = null,Object? selectedFile = freezed,Object? userModel = freezed,Object? firebaseFileReference = freezed,}) {
  return _then(_self.copyWith(
chatText: null == chatText ? _self.chatText : chatText // ignore: cast_nullable_to_non_nullable
as String,selectedNetworkImage: null == selectedNetworkImage ? _self.selectedNetworkImage : selectedNetworkImage // ignore: cast_nullable_to_non_nullable
as String,conversationId: freezed == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String?,createConversationApiResult: null == createConversationApiResult ? _self.createConversationApiResult : createConversationApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,createResponseApiResult: null == createResponseApiResult ? _self.createResponseApiResult : createResponseApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,getConversationApiResult: null == getConversationApiResult ? _self.getConversationApiResult : getConversationApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,imageUploadApiResult: null == imageUploadApiResult ? _self.imageUploadApiResult : imageUploadApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,chatList: null == chatList ? _self.chatList : chatList // ignore: cast_nullable_to_non_nullable
as List<ChatModel>,selectedFile: freezed == selectedFile ? _self.selectedFile : selectedFile // ignore: cast_nullable_to_non_nullable
as File?,userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,firebaseFileReference: freezed == firebaseFileReference ? _self.firebaseFileReference : firebaseFileReference // ignore: cast_nullable_to_non_nullable
as Reference?,
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
$ApiResultStatusCopyWith<dynamic, $Res> get createResponseApiResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.createResponseApiResult, (value) {
    return _then(_self.copyWith(createResponseApiResult: value));
  });
}/// Create a copy of ChatDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get getConversationApiResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.getConversationApiResult, (value) {
    return _then(_self.copyWith(getConversationApiResult: value));
  });
}/// Create a copy of ChatDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get imageUploadApiResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.imageUploadApiResult, (value) {
    return _then(_self.copyWith(imageUploadApiResult: value));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String chatText,  String selectedNetworkImage,  String? conversationId,  ApiResultStatus createConversationApiResult,  ApiResultStatus createResponseApiResult,  ApiResultStatus getConversationApiResult,  ApiResultStatus imageUploadApiResult,  List<ChatModel> chatList,  File? selectedFile,  UserModel? userModel,  Reference? firebaseFileReference)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatDetailState() when $default != null:
return $default(_that.chatText,_that.selectedNetworkImage,_that.conversationId,_that.createConversationApiResult,_that.createResponseApiResult,_that.getConversationApiResult,_that.imageUploadApiResult,_that.chatList,_that.selectedFile,_that.userModel,_that.firebaseFileReference);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String chatText,  String selectedNetworkImage,  String? conversationId,  ApiResultStatus createConversationApiResult,  ApiResultStatus createResponseApiResult,  ApiResultStatus getConversationApiResult,  ApiResultStatus imageUploadApiResult,  List<ChatModel> chatList,  File? selectedFile,  UserModel? userModel,  Reference? firebaseFileReference)  $default,) {final _that = this;
switch (_that) {
case _ChatDetailState():
return $default(_that.chatText,_that.selectedNetworkImage,_that.conversationId,_that.createConversationApiResult,_that.createResponseApiResult,_that.getConversationApiResult,_that.imageUploadApiResult,_that.chatList,_that.selectedFile,_that.userModel,_that.firebaseFileReference);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String chatText,  String selectedNetworkImage,  String? conversationId,  ApiResultStatus createConversationApiResult,  ApiResultStatus createResponseApiResult,  ApiResultStatus getConversationApiResult,  ApiResultStatus imageUploadApiResult,  List<ChatModel> chatList,  File? selectedFile,  UserModel? userModel,  Reference? firebaseFileReference)?  $default,) {final _that = this;
switch (_that) {
case _ChatDetailState() when $default != null:
return $default(_that.chatText,_that.selectedNetworkImage,_that.conversationId,_that.createConversationApiResult,_that.createResponseApiResult,_that.getConversationApiResult,_that.imageUploadApiResult,_that.chatList,_that.selectedFile,_that.userModel,_that.firebaseFileReference);case _:
  return null;

}
}

}

/// @nodoc


class _ChatDetailState implements ChatDetailState {
  const _ChatDetailState({this.chatText = "", this.selectedNetworkImage = "", this.conversationId, this.createConversationApiResult = const ApiResultStatus.initial(), this.createResponseApiResult = const ApiResultStatus.initial(), this.getConversationApiResult = const ApiResultStatus.initial(), this.imageUploadApiResult = const ApiResultStatus.initial(), final  List<ChatModel> chatList = const [], this.selectedFile, this.userModel, this.firebaseFileReference}): _chatList = chatList;
  

@override@JsonKey() final  String chatText;
@override@JsonKey() final  String selectedNetworkImage;
@override final  String? conversationId;
@override@JsonKey() final  ApiResultStatus createConversationApiResult;
@override@JsonKey() final  ApiResultStatus createResponseApiResult;
@override@JsonKey() final  ApiResultStatus getConversationApiResult;
@override@JsonKey() final  ApiResultStatus imageUploadApiResult;
 final  List<ChatModel> _chatList;
@override@JsonKey() List<ChatModel> get chatList {
  if (_chatList is EqualUnmodifiableListView) return _chatList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_chatList);
}

@override final  File? selectedFile;
@override final  UserModel? userModel;
@override final  Reference? firebaseFileReference;

/// Create a copy of ChatDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatDetailStateCopyWith<_ChatDetailState> get copyWith => __$ChatDetailStateCopyWithImpl<_ChatDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatDetailState&&(identical(other.chatText, chatText) || other.chatText == chatText)&&(identical(other.selectedNetworkImage, selectedNetworkImage) || other.selectedNetworkImage == selectedNetworkImage)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.createConversationApiResult, createConversationApiResult) || other.createConversationApiResult == createConversationApiResult)&&(identical(other.createResponseApiResult, createResponseApiResult) || other.createResponseApiResult == createResponseApiResult)&&(identical(other.getConversationApiResult, getConversationApiResult) || other.getConversationApiResult == getConversationApiResult)&&(identical(other.imageUploadApiResult, imageUploadApiResult) || other.imageUploadApiResult == imageUploadApiResult)&&const DeepCollectionEquality().equals(other._chatList, _chatList)&&(identical(other.selectedFile, selectedFile) || other.selectedFile == selectedFile)&&(identical(other.userModel, userModel) || other.userModel == userModel)&&(identical(other.firebaseFileReference, firebaseFileReference) || other.firebaseFileReference == firebaseFileReference));
}


@override
int get hashCode => Object.hash(runtimeType,chatText,selectedNetworkImage,conversationId,createConversationApiResult,createResponseApiResult,getConversationApiResult,imageUploadApiResult,const DeepCollectionEquality().hash(_chatList),selectedFile,userModel,firebaseFileReference);

@override
String toString() {
  return 'ChatDetailState(chatText: $chatText, selectedNetworkImage: $selectedNetworkImage, conversationId: $conversationId, createConversationApiResult: $createConversationApiResult, createResponseApiResult: $createResponseApiResult, getConversationApiResult: $getConversationApiResult, imageUploadApiResult: $imageUploadApiResult, chatList: $chatList, selectedFile: $selectedFile, userModel: $userModel, firebaseFileReference: $firebaseFileReference)';
}


}

/// @nodoc
abstract mixin class _$ChatDetailStateCopyWith<$Res> implements $ChatDetailStateCopyWith<$Res> {
  factory _$ChatDetailStateCopyWith(_ChatDetailState value, $Res Function(_ChatDetailState) _then) = __$ChatDetailStateCopyWithImpl;
@override @useResult
$Res call({
 String chatText, String selectedNetworkImage, String? conversationId, ApiResultStatus createConversationApiResult, ApiResultStatus createResponseApiResult, ApiResultStatus getConversationApiResult, ApiResultStatus imageUploadApiResult, List<ChatModel> chatList, File? selectedFile, UserModel? userModel, Reference? firebaseFileReference
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get createConversationApiResult;@override $ApiResultStatusCopyWith<dynamic, $Res> get createResponseApiResult;@override $ApiResultStatusCopyWith<dynamic, $Res> get getConversationApiResult;@override $ApiResultStatusCopyWith<dynamic, $Res> get imageUploadApiResult;

}
/// @nodoc
class __$ChatDetailStateCopyWithImpl<$Res>
    implements _$ChatDetailStateCopyWith<$Res> {
  __$ChatDetailStateCopyWithImpl(this._self, this._then);

  final _ChatDetailState _self;
  final $Res Function(_ChatDetailState) _then;

/// Create a copy of ChatDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? chatText = null,Object? selectedNetworkImage = null,Object? conversationId = freezed,Object? createConversationApiResult = null,Object? createResponseApiResult = null,Object? getConversationApiResult = null,Object? imageUploadApiResult = null,Object? chatList = null,Object? selectedFile = freezed,Object? userModel = freezed,Object? firebaseFileReference = freezed,}) {
  return _then(_ChatDetailState(
chatText: null == chatText ? _self.chatText : chatText // ignore: cast_nullable_to_non_nullable
as String,selectedNetworkImage: null == selectedNetworkImage ? _self.selectedNetworkImage : selectedNetworkImage // ignore: cast_nullable_to_non_nullable
as String,conversationId: freezed == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String?,createConversationApiResult: null == createConversationApiResult ? _self.createConversationApiResult : createConversationApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,createResponseApiResult: null == createResponseApiResult ? _self.createResponseApiResult : createResponseApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,getConversationApiResult: null == getConversationApiResult ? _self.getConversationApiResult : getConversationApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,imageUploadApiResult: null == imageUploadApiResult ? _self.imageUploadApiResult : imageUploadApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,chatList: null == chatList ? _self._chatList : chatList // ignore: cast_nullable_to_non_nullable
as List<ChatModel>,selectedFile: freezed == selectedFile ? _self.selectedFile : selectedFile // ignore: cast_nullable_to_non_nullable
as File?,userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,firebaseFileReference: freezed == firebaseFileReference ? _self.firebaseFileReference : firebaseFileReference // ignore: cast_nullable_to_non_nullable
as Reference?,
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
$ApiResultStatusCopyWith<dynamic, $Res> get createResponseApiResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.createResponseApiResult, (value) {
    return _then(_self.copyWith(createResponseApiResult: value));
  });
}/// Create a copy of ChatDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get getConversationApiResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.getConversationApiResult, (value) {
    return _then(_self.copyWith(getConversationApiResult: value));
  });
}/// Create a copy of ChatDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get imageUploadApiResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.imageUploadApiResult, (value) {
    return _then(_self.copyWith(imageUploadApiResult: value));
  });
}
}

// dart format on
