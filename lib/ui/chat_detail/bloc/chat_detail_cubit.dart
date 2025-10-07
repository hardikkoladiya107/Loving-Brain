import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

  Future<void> changeProps({
    ApiResultStatus? createConversationApiResult,
    ApiResultStatus? createResponseApiResult,
    String? chatText,
    String? conversationId,
    UserModel? userModel,
    List<ChatModel>? chatList,
    ApiResultStatus? getConversationApiResult,
    File? selectedFile,
    ApiResultStatus? imageUploadApiResult,
    String? selectedNetworkImage,
    Reference? firebaseFileReference,
    bool? isRecording,
    File? audioRecordedFile,
    Duration? currentAudioDuration,
    Duration? totalAudioDuration,
    PlayerState? audioPlayerState,
  }) async {
    emit(
      state.copyWith(
        createConversationApiResult:
            createConversationApiResult ?? ApiResultStatus.initial(),
        createResponseApiResult:
            createResponseApiResult ?? ApiResultStatus.initial(),
        getConversationApiResult:
            getConversationApiResult ?? ApiResultStatus.initial(),
        imageUploadApiResult: imageUploadApiResult ?? ApiResultStatus.initial(),
        chatList: chatList ?? state.chatList,
        chatText: chatText ?? state.chatText,
        conversationId: conversationId ?? state.conversationId,
        userModel: userModel ?? state.userModel,
        isRecording: isRecording ?? state.isRecording,
        selectedFile: selectedFile ?? state.selectedFile,
        audioRecordedFile: audioRecordedFile ?? state.audioRecordedFile,
        currentAudioDuration:
            currentAudioDuration ?? state.currentAudioDuration,
        totalAudioDuration: totalAudioDuration ?? state.totalAudioDuration,
        audioPlayerState: audioPlayerState ?? state.audioPlayerState,
        selectedNetworkImage:
            selectedNetworkImage ?? state.selectedNetworkImage,
        firebaseFileReference:
            firebaseFileReference ?? state.firebaseFileReference,
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
    changeProps(getConversationApiResult: ApiResultStatus.loading());
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
              getConversationApiResult: ApiResultStatus.data(data: event.docs),
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
        "network_image": state.selectedNetworkImage,
        "role": chat.role,
        "time_stamp": Timestamp.now(),
      },
    );
    changeProps(createResponseApiResult: response);
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
      var networkImage = state.selectedNetworkImage;
      changeProps(
        createResponseApiResult: ApiResultStatus.loading(),
        chatText: "",
      );
      removeSelectedImage();
      var allConversationResponse = await AiRepo.instance.createResponse(
        conversationId: state.conversationId!,
        messageText: textMessage,
        imageUrl: networkImage,
      );
      allConversationResponse.whenOrNull(
        data: (data) async {
          var aiResponseModel = AiResponseModel.fromJson(data);
          List<ConversationItem> tempConversationList = [];
          tempConversationList.addAll(aiResponseModel.output ?? []);
          tempConversationList.removeWhere(
            (element) => element.type != "message",
          );
          changeProps(createResponseApiResult: allConversationResponse);
          await _addChatToConversation(tempConversationList.first);
        },
        error: (error) {
          changeProps(createResponseApiResult: allConversationResponse);
        },
      );
    }
  }

  Future selectImage(String path) async {
    var selectedFile = File(path);
    changeProps(
      selectedNetworkImage: "",
      selectedFile: selectedFile,
      imageUploadApiResult: ApiResultStatus.loading(),
    );
    var allConversationResponse = await AiRepo.instance
        .uploadFileToFirebaseStorage(
          referenceId: state.userModel?.uid,
          file: selectedFile,
        );
    changeProps(imageUploadApiResult: allConversationResponse);
    allConversationResponse.whenOrNull(
      data: (data) async {
        if (data is TaskSnapshot) {
          var downloadUrl = await data.ref.getDownloadURL();
          changeProps(
            selectedNetworkImage: downloadUrl,
            firebaseFileReference: data.ref,
          );
        }
      },
    );
  }

  Future<void> removeSelectedImage() async {
    emit(state.copyWith(selectedFile: null, selectedNetworkImage: ""));
    await state.firebaseFileReference?.delete();
  }

  void removeSelectedAudio() {
    emit(
      state.copyWith(
        audioRecordedFile: null,
        isRecording: false,
        totalAudioDuration: Duration.zero,
        currentAudioDuration: Duration.zero,
      ),
    );
    // await state.firebaseFileReference?.delete();
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
