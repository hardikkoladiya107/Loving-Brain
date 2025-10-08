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

 String get chatText; String get selectedAudioUrl; String get selectedNetworkImage; String? get conversationId; File? get audioRecordedFile; ApiResultStatus get createConversationApiResult; ApiResultStatus get createResponseApiResult; ApiResultStatus get getConversationApiResult; ApiResultStatus get imageUploadApiResult; ApiResultStatus get audioUploadApiResult; Duration get currentAudioDuration; Duration get totalAudioDuration; bool get isRecording; List<ChatModel> get chatList; File? get selectedFile; UserModel? get userModel; Reference? get firebaseFileReference; Reference? get firebaseAudioFileReference; PlayerState? get audioPlayerState;
/// Create a copy of ChatDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatDetailStateCopyWith<ChatDetailState> get copyWith => _$ChatDetailStateCopyWithImpl<ChatDetailState>(this as ChatDetailState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatDetailState&&(identical(other.chatText, chatText) || other.chatText == chatText)&&(identical(other.selectedAudioUrl, selectedAudioUrl) || other.selectedAudioUrl == selectedAudioUrl)&&(identical(other.selectedNetworkImage, selectedNetworkImage) || other.selectedNetworkImage == selectedNetworkImage)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.audioRecordedFile, audioRecordedFile) || other.audioRecordedFile == audioRecordedFile)&&(identical(other.createConversationApiResult, createConversationApiResult) || other.createConversationApiResult == createConversationApiResult)&&(identical(other.createResponseApiResult, createResponseApiResult) || other.createResponseApiResult == createResponseApiResult)&&(identical(other.getConversationApiResult, getConversationApiResult) || other.getConversationApiResult == getConversationApiResult)&&(identical(other.imageUploadApiResult, imageUploadApiResult) || other.imageUploadApiResult == imageUploadApiResult)&&(identical(other.audioUploadApiResult, audioUploadApiResult) || other.audioUploadApiResult == audioUploadApiResult)&&(identical(other.currentAudioDuration, currentAudioDuration) || other.currentAudioDuration == currentAudioDuration)&&(identical(other.totalAudioDuration, totalAudioDuration) || other.totalAudioDuration == totalAudioDuration)&&(identical(other.isRecording, isRecording) || other.isRecording == isRecording)&&const DeepCollectionEquality().equals(other.chatList, chatList)&&(identical(other.selectedFile, selectedFile) || other.selectedFile == selectedFile)&&(identical(other.userModel, userModel) || other.userModel == userModel)&&(identical(other.firebaseFileReference, firebaseFileReference) || other.firebaseFileReference == firebaseFileReference)&&(identical(other.firebaseAudioFileReference, firebaseAudioFileReference) || other.firebaseAudioFileReference == firebaseAudioFileReference)&&(identical(other.audioPlayerState, audioPlayerState) || other.audioPlayerState == audioPlayerState));
}


@override
int get hashCode => Object.hashAll([runtimeType,chatText,selectedAudioUrl,selectedNetworkImage,conversationId,audioRecordedFile,createConversationApiResult,createResponseApiResult,getConversationApiResult,imageUploadApiResult,audioUploadApiResult,currentAudioDuration,totalAudioDuration,isRecording,const DeepCollectionEquality().hash(chatList),selectedFile,userModel,firebaseFileReference,firebaseAudioFileReference,audioPlayerState]);

@override
String toString() {
  return 'ChatDetailState(chatText: $chatText, selectedAudioUrl: $selectedAudioUrl, selectedNetworkImage: $selectedNetworkImage, conversationId: $conversationId, audioRecordedFile: $audioRecordedFile, createConversationApiResult: $createConversationApiResult, createResponseApiResult: $createResponseApiResult, getConversationApiResult: $getConversationApiResult, imageUploadApiResult: $imageUploadApiResult, audioUploadApiResult: $audioUploadApiResult, currentAudioDuration: $currentAudioDuration, totalAudioDuration: $totalAudioDuration, isRecording: $isRecording, chatList: $chatList, selectedFile: $selectedFile, userModel: $userModel, firebaseFileReference: $firebaseFileReference, firebaseAudioFileReference: $firebaseAudioFileReference, audioPlayerState: $audioPlayerState)';
}


}

/// @nodoc
abstract mixin class $ChatDetailStateCopyWith<$Res>  {
  factory $ChatDetailStateCopyWith(ChatDetailState value, $Res Function(ChatDetailState) _then) = _$ChatDetailStateCopyWithImpl;
@useResult
$Res call({
 String chatText, String selectedAudioUrl, String selectedNetworkImage, String? conversationId, File? audioRecordedFile, ApiResultStatus createConversationApiResult, ApiResultStatus createResponseApiResult, ApiResultStatus getConversationApiResult, ApiResultStatus imageUploadApiResult, ApiResultStatus audioUploadApiResult, Duration currentAudioDuration, Duration totalAudioDuration, bool isRecording, List<ChatModel> chatList, File? selectedFile, UserModel? userModel, Reference? firebaseFileReference, Reference? firebaseAudioFileReference, PlayerState? audioPlayerState
});


$ApiResultStatusCopyWith<dynamic, $Res> get createConversationApiResult;$ApiResultStatusCopyWith<dynamic, $Res> get createResponseApiResult;$ApiResultStatusCopyWith<dynamic, $Res> get getConversationApiResult;$ApiResultStatusCopyWith<dynamic, $Res> get imageUploadApiResult;$ApiResultStatusCopyWith<dynamic, $Res> get audioUploadApiResult;

}
/// @nodoc
class _$ChatDetailStateCopyWithImpl<$Res>
    implements $ChatDetailStateCopyWith<$Res> {
  _$ChatDetailStateCopyWithImpl(this._self, this._then);

  final ChatDetailState _self;
  final $Res Function(ChatDetailState) _then;

/// Create a copy of ChatDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? chatText = null,Object? selectedAudioUrl = null,Object? selectedNetworkImage = null,Object? conversationId = freezed,Object? audioRecordedFile = freezed,Object? createConversationApiResult = null,Object? createResponseApiResult = null,Object? getConversationApiResult = null,Object? imageUploadApiResult = null,Object? audioUploadApiResult = null,Object? currentAudioDuration = null,Object? totalAudioDuration = null,Object? isRecording = null,Object? chatList = null,Object? selectedFile = freezed,Object? userModel = freezed,Object? firebaseFileReference = freezed,Object? firebaseAudioFileReference = freezed,Object? audioPlayerState = freezed,}) {
  return _then(_self.copyWith(
chatText: null == chatText ? _self.chatText : chatText // ignore: cast_nullable_to_non_nullable
as String,selectedAudioUrl: null == selectedAudioUrl ? _self.selectedAudioUrl : selectedAudioUrl // ignore: cast_nullable_to_non_nullable
as String,selectedNetworkImage: null == selectedNetworkImage ? _self.selectedNetworkImage : selectedNetworkImage // ignore: cast_nullable_to_non_nullable
as String,conversationId: freezed == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String?,audioRecordedFile: freezed == audioRecordedFile ? _self.audioRecordedFile : audioRecordedFile // ignore: cast_nullable_to_non_nullable
as File?,createConversationApiResult: null == createConversationApiResult ? _self.createConversationApiResult : createConversationApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,createResponseApiResult: null == createResponseApiResult ? _self.createResponseApiResult : createResponseApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,getConversationApiResult: null == getConversationApiResult ? _self.getConversationApiResult : getConversationApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,imageUploadApiResult: null == imageUploadApiResult ? _self.imageUploadApiResult : imageUploadApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,audioUploadApiResult: null == audioUploadApiResult ? _self.audioUploadApiResult : audioUploadApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,currentAudioDuration: null == currentAudioDuration ? _self.currentAudioDuration : currentAudioDuration // ignore: cast_nullable_to_non_nullable
as Duration,totalAudioDuration: null == totalAudioDuration ? _self.totalAudioDuration : totalAudioDuration // ignore: cast_nullable_to_non_nullable
as Duration,isRecording: null == isRecording ? _self.isRecording : isRecording // ignore: cast_nullable_to_non_nullable
as bool,chatList: null == chatList ? _self.chatList : chatList // ignore: cast_nullable_to_non_nullable
as List<ChatModel>,selectedFile: freezed == selectedFile ? _self.selectedFile : selectedFile // ignore: cast_nullable_to_non_nullable
as File?,userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,firebaseFileReference: freezed == firebaseFileReference ? _self.firebaseFileReference : firebaseFileReference // ignore: cast_nullable_to_non_nullable
as Reference?,firebaseAudioFileReference: freezed == firebaseAudioFileReference ? _self.firebaseAudioFileReference : firebaseAudioFileReference // ignore: cast_nullable_to_non_nullable
as Reference?,audioPlayerState: freezed == audioPlayerState ? _self.audioPlayerState : audioPlayerState // ignore: cast_nullable_to_non_nullable
as PlayerState?,
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
}/// Create a copy of ChatDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get audioUploadApiResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.audioUploadApiResult, (value) {
    return _then(_self.copyWith(audioUploadApiResult: value));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String chatText,  String selectedAudioUrl,  String selectedNetworkImage,  String? conversationId,  File? audioRecordedFile,  ApiResultStatus createConversationApiResult,  ApiResultStatus createResponseApiResult,  ApiResultStatus getConversationApiResult,  ApiResultStatus imageUploadApiResult,  ApiResultStatus audioUploadApiResult,  Duration currentAudioDuration,  Duration totalAudioDuration,  bool isRecording,  List<ChatModel> chatList,  File? selectedFile,  UserModel? userModel,  Reference? firebaseFileReference,  Reference? firebaseAudioFileReference,  PlayerState? audioPlayerState)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatDetailState() when $default != null:
return $default(_that.chatText,_that.selectedAudioUrl,_that.selectedNetworkImage,_that.conversationId,_that.audioRecordedFile,_that.createConversationApiResult,_that.createResponseApiResult,_that.getConversationApiResult,_that.imageUploadApiResult,_that.audioUploadApiResult,_that.currentAudioDuration,_that.totalAudioDuration,_that.isRecording,_that.chatList,_that.selectedFile,_that.userModel,_that.firebaseFileReference,_that.firebaseAudioFileReference,_that.audioPlayerState);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String chatText,  String selectedAudioUrl,  String selectedNetworkImage,  String? conversationId,  File? audioRecordedFile,  ApiResultStatus createConversationApiResult,  ApiResultStatus createResponseApiResult,  ApiResultStatus getConversationApiResult,  ApiResultStatus imageUploadApiResult,  ApiResultStatus audioUploadApiResult,  Duration currentAudioDuration,  Duration totalAudioDuration,  bool isRecording,  List<ChatModel> chatList,  File? selectedFile,  UserModel? userModel,  Reference? firebaseFileReference,  Reference? firebaseAudioFileReference,  PlayerState? audioPlayerState)  $default,) {final _that = this;
switch (_that) {
case _ChatDetailState():
return $default(_that.chatText,_that.selectedAudioUrl,_that.selectedNetworkImage,_that.conversationId,_that.audioRecordedFile,_that.createConversationApiResult,_that.createResponseApiResult,_that.getConversationApiResult,_that.imageUploadApiResult,_that.audioUploadApiResult,_that.currentAudioDuration,_that.totalAudioDuration,_that.isRecording,_that.chatList,_that.selectedFile,_that.userModel,_that.firebaseFileReference,_that.firebaseAudioFileReference,_that.audioPlayerState);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String chatText,  String selectedAudioUrl,  String selectedNetworkImage,  String? conversationId,  File? audioRecordedFile,  ApiResultStatus createConversationApiResult,  ApiResultStatus createResponseApiResult,  ApiResultStatus getConversationApiResult,  ApiResultStatus imageUploadApiResult,  ApiResultStatus audioUploadApiResult,  Duration currentAudioDuration,  Duration totalAudioDuration,  bool isRecording,  List<ChatModel> chatList,  File? selectedFile,  UserModel? userModel,  Reference? firebaseFileReference,  Reference? firebaseAudioFileReference,  PlayerState? audioPlayerState)?  $default,) {final _that = this;
switch (_that) {
case _ChatDetailState() when $default != null:
return $default(_that.chatText,_that.selectedAudioUrl,_that.selectedNetworkImage,_that.conversationId,_that.audioRecordedFile,_that.createConversationApiResult,_that.createResponseApiResult,_that.getConversationApiResult,_that.imageUploadApiResult,_that.audioUploadApiResult,_that.currentAudioDuration,_that.totalAudioDuration,_that.isRecording,_that.chatList,_that.selectedFile,_that.userModel,_that.firebaseFileReference,_that.firebaseAudioFileReference,_that.audioPlayerState);case _:
  return null;

}
}

}

/// @nodoc


class _ChatDetailState implements ChatDetailState {
  const _ChatDetailState({this.chatText = "", this.selectedAudioUrl = "", this.selectedNetworkImage = "", this.conversationId, this.audioRecordedFile, this.createConversationApiResult = const ApiResultStatus.initial(), this.createResponseApiResult = const ApiResultStatus.initial(), this.getConversationApiResult = const ApiResultStatus.initial(), this.imageUploadApiResult = const ApiResultStatus.initial(), this.audioUploadApiResult = const ApiResultStatus.initial(), this.currentAudioDuration = Duration.zero, this.totalAudioDuration = Duration.zero, this.isRecording = false, final  List<ChatModel> chatList = const [], this.selectedFile, this.userModel, this.firebaseFileReference, this.firebaseAudioFileReference, this.audioPlayerState}): _chatList = chatList;
  

@override@JsonKey() final  String chatText;
@override@JsonKey() final  String selectedAudioUrl;
@override@JsonKey() final  String selectedNetworkImage;
@override final  String? conversationId;
@override final  File? audioRecordedFile;
@override@JsonKey() final  ApiResultStatus createConversationApiResult;
@override@JsonKey() final  ApiResultStatus createResponseApiResult;
@override@JsonKey() final  ApiResultStatus getConversationApiResult;
@override@JsonKey() final  ApiResultStatus imageUploadApiResult;
@override@JsonKey() final  ApiResultStatus audioUploadApiResult;
@override@JsonKey() final  Duration currentAudioDuration;
@override@JsonKey() final  Duration totalAudioDuration;
@override@JsonKey() final  bool isRecording;
 final  List<ChatModel> _chatList;
@override@JsonKey() List<ChatModel> get chatList {
  if (_chatList is EqualUnmodifiableListView) return _chatList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_chatList);
}

@override final  File? selectedFile;
@override final  UserModel? userModel;
@override final  Reference? firebaseFileReference;
@override final  Reference? firebaseAudioFileReference;
@override final  PlayerState? audioPlayerState;

/// Create a copy of ChatDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatDetailStateCopyWith<_ChatDetailState> get copyWith => __$ChatDetailStateCopyWithImpl<_ChatDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatDetailState&&(identical(other.chatText, chatText) || other.chatText == chatText)&&(identical(other.selectedAudioUrl, selectedAudioUrl) || other.selectedAudioUrl == selectedAudioUrl)&&(identical(other.selectedNetworkImage, selectedNetworkImage) || other.selectedNetworkImage == selectedNetworkImage)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.audioRecordedFile, audioRecordedFile) || other.audioRecordedFile == audioRecordedFile)&&(identical(other.createConversationApiResult, createConversationApiResult) || other.createConversationApiResult == createConversationApiResult)&&(identical(other.createResponseApiResult, createResponseApiResult) || other.createResponseApiResult == createResponseApiResult)&&(identical(other.getConversationApiResult, getConversationApiResult) || other.getConversationApiResult == getConversationApiResult)&&(identical(other.imageUploadApiResult, imageUploadApiResult) || other.imageUploadApiResult == imageUploadApiResult)&&(identical(other.audioUploadApiResult, audioUploadApiResult) || other.audioUploadApiResult == audioUploadApiResult)&&(identical(other.currentAudioDuration, currentAudioDuration) || other.currentAudioDuration == currentAudioDuration)&&(identical(other.totalAudioDuration, totalAudioDuration) || other.totalAudioDuration == totalAudioDuration)&&(identical(other.isRecording, isRecording) || other.isRecording == isRecording)&&const DeepCollectionEquality().equals(other._chatList, _chatList)&&(identical(other.selectedFile, selectedFile) || other.selectedFile == selectedFile)&&(identical(other.userModel, userModel) || other.userModel == userModel)&&(identical(other.firebaseFileReference, firebaseFileReference) || other.firebaseFileReference == firebaseFileReference)&&(identical(other.firebaseAudioFileReference, firebaseAudioFileReference) || other.firebaseAudioFileReference == firebaseAudioFileReference)&&(identical(other.audioPlayerState, audioPlayerState) || other.audioPlayerState == audioPlayerState));
}


@override
int get hashCode => Object.hashAll([runtimeType,chatText,selectedAudioUrl,selectedNetworkImage,conversationId,audioRecordedFile,createConversationApiResult,createResponseApiResult,getConversationApiResult,imageUploadApiResult,audioUploadApiResult,currentAudioDuration,totalAudioDuration,isRecording,const DeepCollectionEquality().hash(_chatList),selectedFile,userModel,firebaseFileReference,firebaseAudioFileReference,audioPlayerState]);

@override
String toString() {
  return 'ChatDetailState(chatText: $chatText, selectedAudioUrl: $selectedAudioUrl, selectedNetworkImage: $selectedNetworkImage, conversationId: $conversationId, audioRecordedFile: $audioRecordedFile, createConversationApiResult: $createConversationApiResult, createResponseApiResult: $createResponseApiResult, getConversationApiResult: $getConversationApiResult, imageUploadApiResult: $imageUploadApiResult, audioUploadApiResult: $audioUploadApiResult, currentAudioDuration: $currentAudioDuration, totalAudioDuration: $totalAudioDuration, isRecording: $isRecording, chatList: $chatList, selectedFile: $selectedFile, userModel: $userModel, firebaseFileReference: $firebaseFileReference, firebaseAudioFileReference: $firebaseAudioFileReference, audioPlayerState: $audioPlayerState)';
}


}

/// @nodoc
abstract mixin class _$ChatDetailStateCopyWith<$Res> implements $ChatDetailStateCopyWith<$Res> {
  factory _$ChatDetailStateCopyWith(_ChatDetailState value, $Res Function(_ChatDetailState) _then) = __$ChatDetailStateCopyWithImpl;
@override @useResult
$Res call({
 String chatText, String selectedAudioUrl, String selectedNetworkImage, String? conversationId, File? audioRecordedFile, ApiResultStatus createConversationApiResult, ApiResultStatus createResponseApiResult, ApiResultStatus getConversationApiResult, ApiResultStatus imageUploadApiResult, ApiResultStatus audioUploadApiResult, Duration currentAudioDuration, Duration totalAudioDuration, bool isRecording, List<ChatModel> chatList, File? selectedFile, UserModel? userModel, Reference? firebaseFileReference, Reference? firebaseAudioFileReference, PlayerState? audioPlayerState
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get createConversationApiResult;@override $ApiResultStatusCopyWith<dynamic, $Res> get createResponseApiResult;@override $ApiResultStatusCopyWith<dynamic, $Res> get getConversationApiResult;@override $ApiResultStatusCopyWith<dynamic, $Res> get imageUploadApiResult;@override $ApiResultStatusCopyWith<dynamic, $Res> get audioUploadApiResult;

}
/// @nodoc
class __$ChatDetailStateCopyWithImpl<$Res>
    implements _$ChatDetailStateCopyWith<$Res> {
  __$ChatDetailStateCopyWithImpl(this._self, this._then);

  final _ChatDetailState _self;
  final $Res Function(_ChatDetailState) _then;

/// Create a copy of ChatDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? chatText = null,Object? selectedAudioUrl = null,Object? selectedNetworkImage = null,Object? conversationId = freezed,Object? audioRecordedFile = freezed,Object? createConversationApiResult = null,Object? createResponseApiResult = null,Object? getConversationApiResult = null,Object? imageUploadApiResult = null,Object? audioUploadApiResult = null,Object? currentAudioDuration = null,Object? totalAudioDuration = null,Object? isRecording = null,Object? chatList = null,Object? selectedFile = freezed,Object? userModel = freezed,Object? firebaseFileReference = freezed,Object? firebaseAudioFileReference = freezed,Object? audioPlayerState = freezed,}) {
  return _then(_ChatDetailState(
chatText: null == chatText ? _self.chatText : chatText // ignore: cast_nullable_to_non_nullable
as String,selectedAudioUrl: null == selectedAudioUrl ? _self.selectedAudioUrl : selectedAudioUrl // ignore: cast_nullable_to_non_nullable
as String,selectedNetworkImage: null == selectedNetworkImage ? _self.selectedNetworkImage : selectedNetworkImage // ignore: cast_nullable_to_non_nullable
as String,conversationId: freezed == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String?,audioRecordedFile: freezed == audioRecordedFile ? _self.audioRecordedFile : audioRecordedFile // ignore: cast_nullable_to_non_nullable
as File?,createConversationApiResult: null == createConversationApiResult ? _self.createConversationApiResult : createConversationApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,createResponseApiResult: null == createResponseApiResult ? _self.createResponseApiResult : createResponseApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,getConversationApiResult: null == getConversationApiResult ? _self.getConversationApiResult : getConversationApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,imageUploadApiResult: null == imageUploadApiResult ? _self.imageUploadApiResult : imageUploadApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,audioUploadApiResult: null == audioUploadApiResult ? _self.audioUploadApiResult : audioUploadApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,currentAudioDuration: null == currentAudioDuration ? _self.currentAudioDuration : currentAudioDuration // ignore: cast_nullable_to_non_nullable
as Duration,totalAudioDuration: null == totalAudioDuration ? _self.totalAudioDuration : totalAudioDuration // ignore: cast_nullable_to_non_nullable
as Duration,isRecording: null == isRecording ? _self.isRecording : isRecording // ignore: cast_nullable_to_non_nullable
as bool,chatList: null == chatList ? _self._chatList : chatList // ignore: cast_nullable_to_non_nullable
as List<ChatModel>,selectedFile: freezed == selectedFile ? _self.selectedFile : selectedFile // ignore: cast_nullable_to_non_nullable
as File?,userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,firebaseFileReference: freezed == firebaseFileReference ? _self.firebaseFileReference : firebaseFileReference // ignore: cast_nullable_to_non_nullable
as Reference?,firebaseAudioFileReference: freezed == firebaseAudioFileReference ? _self.firebaseAudioFileReference : firebaseAudioFileReference // ignore: cast_nullable_to_non_nullable
as Reference?,audioPlayerState: freezed == audioPlayerState ? _self.audioPlayerState : audioPlayerState // ignore: cast_nullable_to_non_nullable
as PlayerState?,
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
}/// Create a copy of ChatDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get audioUploadApiResult {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.audioUploadApiResult, (value) {
    return _then(_self.copyWith(audioUploadApiResult: value));
  });
}
}

// dart format on
