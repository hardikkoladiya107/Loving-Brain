// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChatDetailState {

 String get chatText; File? get selectedImageFile; File? get selectedAudioRecordedFile; String? get conversationId; ApiResultStatus<dynamic> get createConversationApiResult; ApiResultStatus<dynamic> get createResponseApiResult; ApiResultStatus<dynamic> get getConversationApiResult; Duration get currentAudioDuration; Duration get totalAudioDuration; bool get isRecording; List<ChatModel> get chatList; UserModel? get userModel; PlayerState? get audioPlayerState; String get currentPlayingItem; bool get currentAudioLoading;
/// Create a copy of ChatDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatDetailStateCopyWith<ChatDetailState> get copyWith => _$ChatDetailStateCopyWithImpl<ChatDetailState>(this as ChatDetailState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ChatDetailState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatDetailState&&(identical(other.chatText, _this.chatText) || other.chatText == _this.chatText)&&(identical(other.selectedImageFile, _this.selectedImageFile) || other.selectedImageFile == _this.selectedImageFile)&&(identical(other.selectedAudioRecordedFile, _this.selectedAudioRecordedFile) || other.selectedAudioRecordedFile == _this.selectedAudioRecordedFile)&&(identical(other.conversationId, _this.conversationId) || other.conversationId == _this.conversationId)&&(identical(other.createConversationApiResult, _this.createConversationApiResult) || other.createConversationApiResult == _this.createConversationApiResult)&&(identical(other.createResponseApiResult, _this.createResponseApiResult) || other.createResponseApiResult == _this.createResponseApiResult)&&(identical(other.getConversationApiResult, _this.getConversationApiResult) || other.getConversationApiResult == _this.getConversationApiResult)&&(identical(other.currentAudioDuration, _this.currentAudioDuration) || other.currentAudioDuration == _this.currentAudioDuration)&&(identical(other.totalAudioDuration, _this.totalAudioDuration) || other.totalAudioDuration == _this.totalAudioDuration)&&(identical(other.isRecording, _this.isRecording) || other.isRecording == _this.isRecording)&&const DeepCollectionEquality().equals(other.chatList, _this.chatList)&&(identical(other.userModel, _this.userModel) || other.userModel == _this.userModel)&&(identical(other.audioPlayerState, _this.audioPlayerState) || other.audioPlayerState == _this.audioPlayerState)&&(identical(other.currentPlayingItem, _this.currentPlayingItem) || other.currentPlayingItem == _this.currentPlayingItem)&&(identical(other.currentAudioLoading, _this.currentAudioLoading) || other.currentAudioLoading == _this.currentAudioLoading));
}


@override
int get hashCode {
  final _this = this as ChatDetailState;
  return Object.hash(runtimeType,_this.chatText,_this.selectedImageFile,_this.selectedAudioRecordedFile,_this.conversationId,_this.createConversationApiResult,_this.createResponseApiResult,_this.getConversationApiResult,_this.currentAudioDuration,_this.totalAudioDuration,_this.isRecording,const DeepCollectionEquality().hash(_this.chatList),_this.userModel,_this.audioPlayerState,_this.currentPlayingItem,_this.currentAudioLoading);
}

@override
String toString() {
  final _this = this as ChatDetailState;
  return 'ChatDetailState(chatText: ${_this.chatText}, selectedImageFile: ${_this.selectedImageFile}, selectedAudioRecordedFile: ${_this.selectedAudioRecordedFile}, conversationId: ${_this.conversationId}, createConversationApiResult: ${_this.createConversationApiResult}, createResponseApiResult: ${_this.createResponseApiResult}, getConversationApiResult: ${_this.getConversationApiResult}, currentAudioDuration: ${_this.currentAudioDuration}, totalAudioDuration: ${_this.totalAudioDuration}, isRecording: ${_this.isRecording}, chatList: ${_this.chatList}, userModel: ${_this.userModel}, audioPlayerState: ${_this.audioPlayerState}, currentPlayingItem: ${_this.currentPlayingItem}, currentAudioLoading: ${_this.currentAudioLoading})';
}


}

/// @nodoc
abstract mixin class $ChatDetailStateCopyWith<$Res>  {
  factory $ChatDetailStateCopyWith(ChatDetailState value, $Res Function(ChatDetailState) _then) = _$ChatDetailStateCopyWithImpl;
@useResult
$Res call({
 String chatText, File? selectedImageFile, File? selectedAudioRecordedFile, String? conversationId, ApiResultStatus<dynamic> createConversationApiResult, ApiResultStatus<dynamic> createResponseApiResult, ApiResultStatus<dynamic> getConversationApiResult, Duration currentAudioDuration, Duration totalAudioDuration, bool isRecording, List<ChatModel> chatList, UserModel? userModel, PlayerState? audioPlayerState, String currentPlayingItem, bool currentAudioLoading
});


$ApiResultStatusCopyWith<dynamic, $Res> get createConversationApiResult;$ApiResultStatusCopyWith<dynamic, $Res> get createResponseApiResult;$ApiResultStatusCopyWith<dynamic, $Res> get getConversationApiResult;

}
/// @nodoc
class _$ChatDetailStateCopyWithImpl<$Res>
    implements $ChatDetailStateCopyWith<$Res> {
  _$ChatDetailStateCopyWithImpl(this._self, this._then);

  final ChatDetailState _self;
  final $Res Function(ChatDetailState) _then;

/// Create a copy of ChatDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? chatText = null,Object? selectedImageFile = freezed,Object? selectedAudioRecordedFile = freezed,Object? conversationId = freezed,Object? createConversationApiResult = null,Object? createResponseApiResult = null,Object? getConversationApiResult = null,Object? currentAudioDuration = null,Object? totalAudioDuration = null,Object? isRecording = null,Object? chatList = null,Object? userModel = freezed,Object? audioPlayerState = freezed,Object? currentPlayingItem = null,Object? currentAudioLoading = null,}) {
  return _then(ChatDetailState(
chatText: null == chatText ? _self.chatText : chatText // ignore: cast_nullable_to_non_nullable
as String,selectedImageFile: freezed == selectedImageFile ? _self.selectedImageFile : selectedImageFile // ignore: cast_nullable_to_non_nullable
as File?,selectedAudioRecordedFile: freezed == selectedAudioRecordedFile ? _self.selectedAudioRecordedFile : selectedAudioRecordedFile // ignore: cast_nullable_to_non_nullable
as File?,conversationId: freezed == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String?,createConversationApiResult: null == createConversationApiResult ? _self.createConversationApiResult : createConversationApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,createResponseApiResult: null == createResponseApiResult ? _self.createResponseApiResult : createResponseApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,getConversationApiResult: null == getConversationApiResult ? _self.getConversationApiResult : getConversationApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,currentAudioDuration: null == currentAudioDuration ? _self.currentAudioDuration : currentAudioDuration // ignore: cast_nullable_to_non_nullable
as Duration,totalAudioDuration: null == totalAudioDuration ? _self.totalAudioDuration : totalAudioDuration // ignore: cast_nullable_to_non_nullable
as Duration,isRecording: null == isRecording ? _self.isRecording : isRecording // ignore: cast_nullable_to_non_nullable
as bool,chatList: null == chatList ? _self.chatList : chatList // ignore: cast_nullable_to_non_nullable
as List<ChatModel>,userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,audioPlayerState: freezed == audioPlayerState ? _self.audioPlayerState : audioPlayerState // ignore: cast_nullable_to_non_nullable
as PlayerState?,currentPlayingItem: null == currentPlayingItem ? _self.currentPlayingItem : currentPlayingItem // ignore: cast_nullable_to_non_nullable
as String,currentAudioLoading: null == currentAudioLoading ? _self.currentAudioLoading : currentAudioLoading // ignore: cast_nullable_to_non_nullable
as bool,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String chatText,  File? selectedImageFile,  File? selectedAudioRecordedFile,  String? conversationId,  ApiResultStatus<dynamic> createConversationApiResult,  ApiResultStatus<dynamic> createResponseApiResult,  ApiResultStatus<dynamic> getConversationApiResult,  Duration currentAudioDuration,  Duration totalAudioDuration,  bool isRecording,  List<ChatModel> chatList,  UserModel? userModel,  PlayerState? audioPlayerState,  String currentPlayingItem,  bool currentAudioLoading)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatDetailState() when $default != null:
return $default(_that.chatText,_that.selectedImageFile,_that.selectedAudioRecordedFile,_that.conversationId,_that.createConversationApiResult,_that.createResponseApiResult,_that.getConversationApiResult,_that.currentAudioDuration,_that.totalAudioDuration,_that.isRecording,_that.chatList,_that.userModel,_that.audioPlayerState,_that.currentPlayingItem,_that.currentAudioLoading);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String chatText,  File? selectedImageFile,  File? selectedAudioRecordedFile,  String? conversationId,  ApiResultStatus<dynamic> createConversationApiResult,  ApiResultStatus<dynamic> createResponseApiResult,  ApiResultStatus<dynamic> getConversationApiResult,  Duration currentAudioDuration,  Duration totalAudioDuration,  bool isRecording,  List<ChatModel> chatList,  UserModel? userModel,  PlayerState? audioPlayerState,  String currentPlayingItem,  bool currentAudioLoading)  $default,) {final _that = this;
switch (_that) {
case _ChatDetailState():
return $default(_that.chatText,_that.selectedImageFile,_that.selectedAudioRecordedFile,_that.conversationId,_that.createConversationApiResult,_that.createResponseApiResult,_that.getConversationApiResult,_that.currentAudioDuration,_that.totalAudioDuration,_that.isRecording,_that.chatList,_that.userModel,_that.audioPlayerState,_that.currentPlayingItem,_that.currentAudioLoading);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String chatText,  File? selectedImageFile,  File? selectedAudioRecordedFile,  String? conversationId,  ApiResultStatus<dynamic> createConversationApiResult,  ApiResultStatus<dynamic> createResponseApiResult,  ApiResultStatus<dynamic> getConversationApiResult,  Duration currentAudioDuration,  Duration totalAudioDuration,  bool isRecording,  List<ChatModel> chatList,  UserModel? userModel,  PlayerState? audioPlayerState,  String currentPlayingItem,  bool currentAudioLoading)?  $default,) {final _that = this;
switch (_that) {
case _ChatDetailState() when $default != null:
return $default(_that.chatText,_that.selectedImageFile,_that.selectedAudioRecordedFile,_that.conversationId,_that.createConversationApiResult,_that.createResponseApiResult,_that.getConversationApiResult,_that.currentAudioDuration,_that.totalAudioDuration,_that.isRecording,_that.chatList,_that.userModel,_that.audioPlayerState,_that.currentPlayingItem,_that.currentAudioLoading);case _:
  return null;

}
}

}

/// @nodoc


class _ChatDetailState implements ChatDetailState {
  const _ChatDetailState({this.chatText = "", this.selectedImageFile, this.selectedAudioRecordedFile, this.conversationId, this.createConversationApiResult = const ApiResultStatus.initial(), this.createResponseApiResult = const ApiResultStatus.initial(), this.getConversationApiResult = const ApiResultStatus.initial(), this.currentAudioDuration = Duration.zero, this.totalAudioDuration = Duration.zero, this.isRecording = false,  List<ChatModel> chatList = const [], this.userModel, this.audioPlayerState, this.currentPlayingItem = "", this.currentAudioLoading = false}): _chatList = chatList;
  

@override@JsonKey() final  String chatText;
@override final  File? selectedImageFile;
@override final  File? selectedAudioRecordedFile;
@override final  String? conversationId;
@override@JsonKey() final  ApiResultStatus<dynamic> createConversationApiResult;
@override@JsonKey() final  ApiResultStatus<dynamic> createResponseApiResult;
@override@JsonKey() final  ApiResultStatus<dynamic> getConversationApiResult;
@override@JsonKey() final  Duration currentAudioDuration;
@override@JsonKey() final  Duration totalAudioDuration;
@override@JsonKey() final  bool isRecording;
 final  List<ChatModel> _chatList;
@override@JsonKey() List<ChatModel> get chatList {
  if (_chatList is EqualUnmodifiableListView) return _chatList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_chatList);
}

@override final  UserModel? userModel;
@override final  PlayerState? audioPlayerState;
@override@JsonKey() final  String currentPlayingItem;
@override@JsonKey() final  bool currentAudioLoading;

/// Create a copy of ChatDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatDetailStateCopyWith<_ChatDetailState> get copyWith => __$ChatDetailStateCopyWithImpl<_ChatDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatDetailState&&(identical(other.chatText, chatText) || other.chatText == chatText)&&(identical(other.selectedImageFile, selectedImageFile) || other.selectedImageFile == selectedImageFile)&&(identical(other.selectedAudioRecordedFile, selectedAudioRecordedFile) || other.selectedAudioRecordedFile == selectedAudioRecordedFile)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.createConversationApiResult, createConversationApiResult) || other.createConversationApiResult == createConversationApiResult)&&(identical(other.createResponseApiResult, createResponseApiResult) || other.createResponseApiResult == createResponseApiResult)&&(identical(other.getConversationApiResult, getConversationApiResult) || other.getConversationApiResult == getConversationApiResult)&&(identical(other.currentAudioDuration, currentAudioDuration) || other.currentAudioDuration == currentAudioDuration)&&(identical(other.totalAudioDuration, totalAudioDuration) || other.totalAudioDuration == totalAudioDuration)&&(identical(other.isRecording, isRecording) || other.isRecording == isRecording)&&const DeepCollectionEquality().equals(other.chatList, _chatList)&&(identical(other.userModel, userModel) || other.userModel == userModel)&&(identical(other.audioPlayerState, audioPlayerState) || other.audioPlayerState == audioPlayerState)&&(identical(other.currentPlayingItem, currentPlayingItem) || other.currentPlayingItem == currentPlayingItem)&&(identical(other.currentAudioLoading, currentAudioLoading) || other.currentAudioLoading == currentAudioLoading));
}


@override
int get hashCode {
    return Object.hash(runtimeType,chatText,selectedImageFile,selectedAudioRecordedFile,conversationId,createConversationApiResult,createResponseApiResult,getConversationApiResult,currentAudioDuration,totalAudioDuration,isRecording,const DeepCollectionEquality().hash(_chatList),userModel,audioPlayerState,currentPlayingItem,currentAudioLoading);
}

@override
String toString() {
    return 'ChatDetailState(chatText: $chatText, selectedImageFile: $selectedImageFile, selectedAudioRecordedFile: $selectedAudioRecordedFile, conversationId: $conversationId, createConversationApiResult: $createConversationApiResult, createResponseApiResult: $createResponseApiResult, getConversationApiResult: $getConversationApiResult, currentAudioDuration: $currentAudioDuration, totalAudioDuration: $totalAudioDuration, isRecording: $isRecording, chatList: $chatList, userModel: $userModel, audioPlayerState: $audioPlayerState, currentPlayingItem: $currentPlayingItem, currentAudioLoading: $currentAudioLoading)';
}


}

/// @nodoc
abstract mixin class _$ChatDetailStateCopyWith<$Res> implements $ChatDetailStateCopyWith<$Res> {
  factory _$ChatDetailStateCopyWith(_ChatDetailState value, $Res Function(_ChatDetailState) _then) = __$ChatDetailStateCopyWithImpl;
@override @useResult
$Res call({
 String chatText, File? selectedImageFile, File? selectedAudioRecordedFile, String? conversationId, ApiResultStatus<dynamic> createConversationApiResult, ApiResultStatus<dynamic> createResponseApiResult, ApiResultStatus<dynamic> getConversationApiResult, Duration currentAudioDuration, Duration totalAudioDuration, bool isRecording, List<ChatModel> chatList, UserModel? userModel, PlayerState? audioPlayerState, String currentPlayingItem, bool currentAudioLoading
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get createConversationApiResult;@override $ApiResultStatusCopyWith<dynamic, $Res> get createResponseApiResult;@override $ApiResultStatusCopyWith<dynamic, $Res> get getConversationApiResult;

}
/// @nodoc
class __$ChatDetailStateCopyWithImpl<$Res>
    implements _$ChatDetailStateCopyWith<$Res> {
  __$ChatDetailStateCopyWithImpl(this._self, this._then);

  final _ChatDetailState _self;
  final $Res Function(_ChatDetailState) _then;

/// Create a copy of ChatDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? chatText = null,Object? selectedImageFile = freezed,Object? selectedAudioRecordedFile = freezed,Object? conversationId = freezed,Object? createConversationApiResult = null,Object? createResponseApiResult = null,Object? getConversationApiResult = null,Object? currentAudioDuration = null,Object? totalAudioDuration = null,Object? isRecording = null,Object? chatList = null,Object? userModel = freezed,Object? audioPlayerState = freezed,Object? currentPlayingItem = null,Object? currentAudioLoading = null,}) {
  return _then(_ChatDetailState(
chatText: null == chatText ? _self.chatText : chatText // ignore: cast_nullable_to_non_nullable
as String,selectedImageFile: freezed == selectedImageFile ? _self.selectedImageFile : selectedImageFile // ignore: cast_nullable_to_non_nullable
as File?,selectedAudioRecordedFile: freezed == selectedAudioRecordedFile ? _self.selectedAudioRecordedFile : selectedAudioRecordedFile // ignore: cast_nullable_to_non_nullable
as File?,conversationId: freezed == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String?,createConversationApiResult: null == createConversationApiResult ? _self.createConversationApiResult : createConversationApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,createResponseApiResult: null == createResponseApiResult ? _self.createResponseApiResult : createResponseApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,getConversationApiResult: null == getConversationApiResult ? _self.getConversationApiResult : getConversationApiResult // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,currentAudioDuration: null == currentAudioDuration ? _self.currentAudioDuration : currentAudioDuration // ignore: cast_nullable_to_non_nullable
as Duration,totalAudioDuration: null == totalAudioDuration ? _self.totalAudioDuration : totalAudioDuration // ignore: cast_nullable_to_non_nullable
as Duration,isRecording: null == isRecording ? _self.isRecording : isRecording // ignore: cast_nullable_to_non_nullable
as bool,chatList: null == chatList ? _self._chatList : chatList // ignore: cast_nullable_to_non_nullable
as List<ChatModel>,userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,audioPlayerState: freezed == audioPlayerState ? _self.audioPlayerState : audioPlayerState // ignore: cast_nullable_to_non_nullable
as PlayerState?,currentPlayingItem: null == currentPlayingItem ? _self.currentPlayingItem : currentPlayingItem // ignore: cast_nullable_to_non_nullable
as String,currentAudioLoading: null == currentAudioLoading ? _self.currentAudioLoading : currentAudioLoading // ignore: cast_nullable_to_non_nullable
as bool,
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
}
}

// dart format on
