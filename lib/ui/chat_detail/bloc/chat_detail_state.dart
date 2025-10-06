import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../model/api_result_status.dart';
import '../../../model/chat_model.dart';
import '../../../model/user_model.dart';

part 'chat_detail_state.freezed.dart';

@freezed
abstract class ChatDetailState with _$ChatDetailState {
  const factory ChatDetailState({
    @Default("") String chatText,
    @Default("") String selectedNetworkImage,
    String? conversationId,
    @Default(ApiResultStatus.initial()) ApiResultStatus createConversationApiResult,
    @Default(ApiResultStatus.initial()) ApiResultStatus createResponseApiResult,
    @Default(ApiResultStatus.initial()) ApiResultStatus getConversationApiResult,
    @Default(ApiResultStatus.initial()) ApiResultStatus imageUploadApiResult,
    @Default([]) List<ChatModel> chatList,
    File? selectedFile,
    UserModel? userModel,
    Reference? firebaseFileReference
  }) = _ChatDetailState;
}
