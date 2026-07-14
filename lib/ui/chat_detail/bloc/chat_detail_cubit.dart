import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/content/brain_ai_system_prompt.dart';
import 'package:loving_brain/model/ai_response_model.dart';
import 'package:loving_brain/model/child_model.dart';
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
    File? selectedImageFile,
    File? selectedAudioRecordedFile,
    bool? isRecording,
    Duration? currentAudioDuration,
    Duration? totalAudioDuration,
    PlayerState? audioPlayerState,
    String? currentPlayingItem,
    bool? currentAudioLoading,
  }) async {
    emit(
      state.copyWith(
        createConversationApiResult:
            createConversationApiResult ?? ApiResultStatus.initial(),
        createResponseApiResult:
            createResponseApiResult ?? ApiResultStatus.initial(),
        getConversationApiResult:
            getConversationApiResult ?? ApiResultStatus.initial(),
        chatList: chatList ?? state.chatList,
        chatText: chatText ?? state.chatText,
        currentAudioLoading: currentAudioLoading ?? state.currentAudioLoading,
        conversationId: conversationId ?? state.conversationId,
        userModel: userModel ?? state.userModel,
        currentPlayingItem: currentPlayingItem ?? state.currentPlayingItem,
        isRecording: isRecording ?? state.isRecording,
        selectedImageFile: selectedImageFile ?? state.selectedImageFile,
        selectedAudioRecordedFile:
            selectedAudioRecordedFile ?? state.selectedAudioRecordedFile,
        currentAudioDuration:
            currentAudioDuration ?? state.currentAudioDuration,
        totalAudioDuration: totalAudioDuration ?? state.totalAudioDuration,
        audioPlayerState: audioPlayerState ?? state.audioPlayerState,
      ),
    );
  }

  bool isValid() {
    if (state.selectedAudioRecordedFile == null && state.chatText.isEmpty) {
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
                return ChatModel.fromJson(e.data(), e.reference);
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
        "type": (chat.content ?? []).first.type,
        "image_local_path": state.selectedImageFile?.path,
        "audio_local_path": state.selectedAudioRecordedFile?.path,
        "image_network_path": "",
        "audio_network_path": "",
        "role": chat.role,
        "time_stamp": Timestamp.now(),
      },
    );
    changeProps(createResponseApiResult: response);
    response.whenOrNull(
      data: (data) {
        uploadToFirebaseStorage(
          data as DocumentReference,
          state.selectedImageFile?.path,
          state.selectedAudioRecordedFile?.path,
        );
      },
      error: (error) {
        changeProps(createResponseApiResult: response);
      },
    );
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
      var selectedImageFile = state.selectedImageFile;
      var selectedAudioRecordedFile = state.selectedAudioRecordedFile;
      changeProps(
        createResponseApiResult: ApiResultStatus.loading(),
        chatText: "",
      );
      removeSelectedImage();
      removeSelectedAudio();
      ChildModel? childModel;
      final DocumentReference<Object?>? defaultChildRef =
          state.userModel?.defaultChild;
      if (defaultChildRef != null) {
        final DocumentSnapshot<Object?> childSnap = await defaultChildRef.get();
        if (childSnap.data() != null) {
          childModel = ChildModel.fromJson(
            childSnap.data() as Map<String, dynamic>,
            childSnap.reference,
          );
        }
      }
      final String systemPrompt = BrainAiSystemPrompt.build(
        childModel: childModel,
        parentName: state.userModel?.parentName ?? 'Parent',
      );
      var allConversationResponse = await AiRepo.instance.createResponse(
        conversationId: state.conversationId!,
        messageText: textMessage,
        audioFile: selectedAudioRecordedFile,
        imageFile: selectedImageFile,
        systemPrompt: systemPrompt,
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
    changeProps(selectedImageFile: selectedFile);
  }

  Future<void> selectAudio({
    required bool isRecording,
    required File audioRecordedFile,
  }) async {
    changeProps(
      isRecording: false,
      selectedAudioRecordedFile: audioRecordedFile,
    );
  }

  Future<void> removeSelectedImage() async {
    emit(state.copyWith(selectedImageFile: null));
  }

  Future<void> removeSelectedAudio() async {
    emit(
      state.copyWith(
        selectedAudioRecordedFile: null,
        currentAudioDuration: Duration.zero,
        totalAudioDuration: Duration.zero,
      ),
    );
  }

  Future<void> uploadToFirebaseStorage(
    DocumentReference<Object?> documentReference,
    String? imageLocalPath,
    String? audioLocalPath,
  ) async {
    if (imageLocalPath != null) {
      var uploadedFilePath = await AiRepo.instance.uploadFileToFirebaseStorage(
        file: File(imageLocalPath),
        referenceId: state.userModel?.uid,
      );
      uploadedFilePath.whenOrNull(
        data: (data) async {
          if (data is TaskSnapshot) {
            data.ref.fullPath;
            var imageNetworkUrl = await data.ref.getDownloadURL();
            AuthRepo.instance.updateChatToConversation(
              conversationId: state.conversationId!,
              chatReferenceId: documentReference.id,
              request: {"image_network_path": imageNetworkUrl},
            );
          }
        },
        error: (error) {},
      );
    }

    if (audioLocalPath != null) {
      var uploadedFilePath = await AiRepo.instance.uploadFileToFirebaseStorage(
        file: File(audioLocalPath),
        referenceId: state.userModel?.uid,
      );
      uploadedFilePath.whenOrNull(
        data: (data) async {
          if (data is TaskSnapshot) {
            data.ref.fullPath;
            var audioNetworkUrl = await data.ref.getDownloadURL();
            AuthRepo.instance.updateChatToConversation(
              conversationId: state.conversationId!,
              chatReferenceId: documentReference.id,
              request: {"audio_network_path": audioNetworkUrl},
            );
          }
        },
        error: (error) {
          error;
        },
      );
    }
  }
}
