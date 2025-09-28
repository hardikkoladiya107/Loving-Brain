import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/ai_response_model.dart';
import 'package:loving_brain/model/conversation_model.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../model/api_result_status.dart';
import '../../../model/chat_model.dart';
import '../../../model/create_conversation_model.dart';
import '../../../model/user_model.dart';
import '../../../other/preferances.dart';
import '../../../repo/ai_repo.dart';
import '../../../repo/auth_repo.dart';
import 'chat_detail_state.dart';

class ChatDetailCubit extends Cubit<ChatDetailState> {
  ChatDetailCubit() : super(ChatDetailState());

  void init({String? conversationId, String? initialChat}) {
    emit(
      ChatDetailState(
        userModel: preferences.getUserModel(),
        conversationId: conversationId,
        chatText: initialChat ?? "",
      ),
    );
    if (conversationId != null) {
      _listenToConversation(conversationId);
    } else {
      _createConversation();
    }
  }

  void changeProps({
    ApiResultStatus? createConversationApiResult,
    ApiResultStatus? createResponseApiResult,
    String? chatText,
    String? conversationId,
    UserModel? userModel,
    List<ChatModel>? chatList,
  }) {
    emit(
      state.copyWith(
        createConversationApiResult:
            createConversationApiResult ?? ApiResultStatus.initial(),
        createResponseApiResult:
            createResponseApiResult ?? ApiResultStatus.initial(),
        chatList: chatList ?? state.chatList,
        chatText: chatText ?? state.chatText,
        conversationId: conversationId ?? state.conversationId,
        userModel: userModel ?? state.userModel,
      ),
    );
  }

  bool isValid() {
    if (state.chatText.isEmpty) {
      return false;
    }
    if (state.conversationId == null) {
      return false;
    }
    return true;
  }

  Future<void> createResponse() async {
    if (isValid()) {
      await _addChatToConversation(
        ConversationItem(
          type: "message",
          content: [AIContent(text: state.chatText, type: "input_text")],
          role: "user",
          status: "completed",
        ),
      );
      var textMessage = state.chatText;
      changeProps(
        createResponseApiResult: ApiResultStatus.loading(),
        chatText: "",
      );
      var allConversationResponse = await AiRepo.instance.createResponse(
        conversationId: state.conversationId!,
        messageText: textMessage,
      );
      allConversationResponse.whenOrNull(
        data: (data) async {
          var aiResponseModel = AiResponseModel.fromJson(data);
          List<ConversationItem> tempConversationList = [];
          tempConversationList.addAll(aiResponseModel.output ?? []);
          tempConversationList.removeWhere(
            (element) => element.type != "message",
          );
          changeProps(
            createResponseApiResult: allConversationResponse,
          );
          await _addChatToConversation(tempConversationList.first);
        },
        error: (error) {
          changeProps(createResponseApiResult: allConversationResponse);
        },
      );
    }
  }

  Future<void> _saveConversationId(String id) async {
    changeProps(createConversationApiResult: ApiResultStatus.initial());
    var apiResultStatus = await AuthRepo.instance.addConversationToUser(
      conversationId: id,
      request: {"conversation_id": id, "first_message": state.chatText},
    );
    changeProps(createConversationApiResult: apiResultStatus);
  }

  StreamSubscription? profileSubscription;

  void _listenToConversation(String conversationId) {
    if ((state.userModel?.uid ?? "").isNotEmpty) {
      profileSubscription?.cancel();
      profileSubscription = AuthRepo.instance.userCollection
          .doc(state.userModel!.uid)
          .collection("conversations")
          .doc(conversationId)
          .collection("chats")
          .orderBy("time_stamp", descending: false)
          .snapshots()
          .listen((event) {
            changeProps(
              chatList: event.docs.map((e) {
                return ChatModel.fromJson(e.data());
              }).toList(),
            );
          });
    }
  }

  void dispose() {
    profileSubscription?.cancel();
  }

  Future<void> _createConversation() async {
    changeProps(createConversationApiResult: ApiResultStatus.loading());
    var response = await AiRepo.instance.createConversation();
    response.whenOrNull(
      data: (data) async {
        changeProps(createConversationApiResult: response);
        var conversationModel = CreateConversationModel.fromJson(data);
        if (conversationModel.id != null) {
          changeProps(conversationId: conversationModel.id);
          await _saveConversationId(conversationModel.id!);
          _listenToConversation(conversationModel.id!);
          createResponse();
        } else {
          changeProps(
            createConversationApiResult: ApiResultStatus.error(
              error: Exception(LocaleKeys.failToCreateConversation.tr()),
            ),
          );
        }
      },
      error: (error) {
        changeProps(createConversationApiResult: response);
      },
    );
  }

  Future<void> _addChatToConversation(ConversationItem chat) async {
    if ((chat.content ?? []).isEmpty) {
      return;
    }
    changeProps(createResponseApiResult: ApiResultStatus.loading());
    var response = await AuthRepo.instance.addChatToConversation(
      conversationId: state.conversationId!,
      request: {
        "text": (chat.content ?? []).first.text,
        "role": chat.role,
        "time_stamp": Timestamp.now(),
      },
    );
    changeProps(createResponseApiResult: response);
  }

  // Future _getAllConversation() async {
  //   changeProps(getAllConversationApiResult: ApiResultStatus.loading());
  //   var allConversationResponse = await AiRepo.instance.getAllConversation(
  //     conversationId: state.conversationId!,
  //   );
  //   allConversationResponse.whenOrNull(
  //     data: (data) {
  //       var conversationModel = ConversationModel.fromJson(data);
  //       List<ConversationItem> tempConversationList = [];
  //       tempConversationList.addAll(conversationModel.data ?? []);
  //       tempConversationList.removeWhere(
  //         (element) => element.type != "message",
  //       );
  //       changeProps(
  //         conversationList: tempConversationList.reversed.toList(),
  //         getAllConversationApiResult: allConversationResponse,
  //       );
  //     },
  //     error: (error) {
  //       changeProps(getAllConversationApiResult: allConversationResponse);
  //     },
  //   );
  // }
}
