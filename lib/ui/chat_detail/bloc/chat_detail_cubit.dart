import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/ai_response_model.dart';
import 'package:loving_brain/model/conversation_model.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../model/api_result_status.dart';
import '../../../model/create_conversation_model.dart';
import '../../../repo/ai_repo.dart';
import '../../../repo/auth_repo.dart';
import 'chat_detail_state.dart';

class ChatDetailCubit extends Cubit<ChatDetailState> {
  ChatDetailCubit() : super(ChatDetailState());

  void init({String? conversationId, String? initialChat}) {
    emit(
      ChatDetailState(
        conversationId: conversationId,
        chatText: initialChat ?? "",
      ),
    );
    if (conversationId != null) {
      _getAllConversation();
    }else{
      _createConversation();
    }
  }

  void changeProps({
    ApiResultStatus? createConversationApiResult,
    ApiResultStatus? getAllConversationApiResult,
    List<ConversationItem>? conversationList,
    ApiResultStatus? createResponseApiResult,
    String? chatText,
    String? conversationId,
    ApiResultStatus? saveConversationResponseApiResult
  }) {
    emit(
      state.copyWith(
        createConversationApiResult:
            createConversationApiResult ?? ApiResultStatus.initial(),
        getAllConversationApiResult:
            getAllConversationApiResult ?? ApiResultStatus.initial(),
        createResponseApiResult:
            createResponseApiResult ?? ApiResultStatus.initial(),
        conversationList: conversationList ?? state.conversationList,
        chatText: chatText ?? state.chatText,
        conversationId: conversationId ?? state.conversationId,
        saveConversationResponseApiResult: saveConversationResponseApiResult ?? state.saveConversationResponseApiResult,
      ),
    );
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
          createResponse();
          _saveConversationId(conversationModel.id!);
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
      List<ConversationItem> tempConversationList = [];
      tempConversationList.addAll(state.conversationList ?? []);
      tempConversationList.add(
        ConversationItem(
          type: "message",
          content: [AIContent(text: state.chatText, type: "input_text")],
          role: "user",
          status: "completed",
        ),
      );
      changeProps(
        createResponseApiResult: ApiResultStatus.loading(),
        conversationList: tempConversationList,
      );
      var allConversationResponse = await AiRepo.instance.createResponse(
        conversationId: state.conversationId!,
        messageText: state.chatText,
      );
      allConversationResponse.whenOrNull(
        data: (data) {
          var aiResponseModel = AiResponseModel.fromJson(data);
          List<ConversationItem> tempConversationList = [];
          tempConversationList.addAll(state.conversationList ?? []);
          tempConversationList.addAll(aiResponseModel.output ?? []);
          changeProps(
            createResponseApiResult: allConversationResponse,
            conversationList: tempConversationList,
          );
          _getAllConversation();
        },
        error: (error) {
          changeProps(createResponseApiResult: allConversationResponse);
        },
      );
    }
  }

  Future _getAllConversation() async {
    changeProps(getAllConversationApiResult: ApiResultStatus.loading());
    var allConversationResponse = await AiRepo.instance.getAllConversation(
      conversationId: state.conversationId!,
    );
    allConversationResponse.whenOrNull(
      data: (data) {
        var conversationModel = ConversationModel.fromJson(data);
        List<ConversationItem> tempConversationList = [];
        tempConversationList.addAll(conversationModel.data ?? []);
        tempConversationList.removeWhere(
          (element) => element.type != "message",
        );
        changeProps(
          conversationList: tempConversationList,
          getAllConversationApiResult: allConversationResponse,
        );
      },
      error: (error) {
        changeProps(getAllConversationApiResult: allConversationResponse);
      },
    );
  }

  Future<void> _saveConversationId(String id) async {
    changeProps(saveConversationResponseApiResult : ApiResultStatus.initial());
    var apiResultStatus = await AuthRepo.instance.addConversationToUser(
      conversationId: id,
      request: {"conversation_id": id},
    );
    changeProps(saveConversationResponseApiResult : apiResultStatus);
  }
}
