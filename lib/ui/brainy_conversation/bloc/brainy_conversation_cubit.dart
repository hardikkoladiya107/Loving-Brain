import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/content/brain_ai_system_prompt.dart';
import 'package:loving_brain/core/ai_data_tools.dart';
import 'package:loving_brain/core/emergency_detector.dart';
import 'package:loving_brain/model/ai_response_model.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/conversation_model.dart';
import 'package:loving_brain/model/create_conversation_model.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/ai_repo.dart';
import 'package:loving_brain/repo/auth_repo.dart';

import 'brainy_conversation_state.dart';

class BrainyConversationCubit extends Cubit<BrainyConversationState> {
  BrainyConversationCubit() : super(const BrainyConversationState()) {
    _playerStateSubscription = _audioPlayer.onPlayerStateChanged.listen(
      (PlayerState s) {
        if (isClosed) return;
        final bool playing = s == PlayerState.playing;
        final bool stopOrComplete =
            s == PlayerState.completed || s == PlayerState.stopped;

        if (stopOrComplete) {
          changeProps(
            isAudioPlaying: false,
            clearPlayingMessageId: true,
            isAttachedAudioPlaying: false,
            attachedAudioPosition: Duration.zero,
          );
        } else if (playing) {
          if (state.isAttachedAudioPlaying) {
            changeProps(isAudioPlaying: false, clearPlayingMessageId: true);
          } else {
            changeProps(isAudioPlaying: true, isAttachedAudioPlaying: false);
          }
        } else {
          changeProps(isAudioPlaying: false, isAttachedAudioPlaying: false);
        }
      },
      onError: (_) {
        if (!isClosed) {
          changeProps(isAudioPlaying: false, isAttachedAudioPlaying: false);
        }
      },
    );

    _positionSubscription = _audioPlayer.onPositionChanged.listen((
      Duration position,
    ) {
      if (isClosed) return;
      if (state.isAttachedAudioPlaying) {
        changeProps(attachedAudioPosition: position);
      }
    }, onError: (_) {});

    _durationSubscription = _audioPlayer.onDurationChanged.listen((
      Duration duration,
    ) {
      if (isClosed) return;
      if (state.isAttachedAudioPlaying) {
        changeProps(attachedAudioDuration: duration);
      }
    }, onError: (_) {});
  }

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _chatsSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration>? _durationSubscription;
  final AudioPlayer _audioPlayer = AudioPlayer();

  void changeProps({
    List<BrainyMessage>? messages,
    bool? isTyping,
    String? conversationId,
    String? topic,
    String? selectedImagePath,
    bool clearSelectedImage = false,
    List<String>? selectedImagePaths,
    bool clearSelectedImages = false,
    String? attachedAudioPath,
    bool clearAttachedAudio = false,
    bool? isAttachedAudioPlaying,
    Duration? attachedAudioPosition,
    Duration? attachedAudioDuration,
    String? playingMessageId,
    bool clearPlayingMessageId = false,
    bool? isAudioPlaying,
  }) {
    if (isClosed) return;

    final List<String> updatedImagePaths = clearSelectedImages
        ? <String>[]
        : (selectedImagePaths ?? state.selectedImagePaths);

    emit(
      state.copyWith(
        messages: messages ?? state.messages,
        isTyping: isTyping ?? state.isTyping,
        conversationId: conversationId ?? state.conversationId,
        topic: topic ?? state.topic,
        selectedImagePath: clearSelectedImage
            ? null
            : (selectedImagePath ??
                  (updatedImagePaths.isNotEmpty
                      ? updatedImagePaths.first
                      : null)),
        selectedImagePaths: updatedImagePaths,
        attachedAudioPath: clearAttachedAudio
            ? null
            : (attachedAudioPath ?? state.attachedAudioPath),
        isAttachedAudioPlaying:
            isAttachedAudioPlaying ?? state.isAttachedAudioPlaying,
        attachedAudioPosition:
            attachedAudioPosition ?? state.attachedAudioPosition,
        attachedAudioDuration:
            attachedAudioDuration ?? state.attachedAudioDuration,
        playingMessageId: clearPlayingMessageId
            ? null
            : (playingMessageId ?? state.playingMessageId),
        isAudioPlaying: isAudioPlaying ?? state.isAudioPlaying,
      ),
    );
  }

  void clearDraft() {
    if (isClosed) return;
    _chatsSubscription?.cancel();
    _chatsSubscription = null;
    if (state.isAudioPlaying || state.isAttachedAudioPlaying) {
      try {
        _audioPlayer.stop().catchError((_) {});
      } catch (_) {}
    }
    changeProps(
      isTyping: false,
      clearSelectedImage: true,
      clearSelectedImages: true,
      clearAttachedAudio: true,
      isAttachedAudioPlaying: false,
      attachedAudioPosition: Duration.zero,
      attachedAudioDuration: Duration.zero,
      isAudioPlaying: false,
      clearPlayingMessageId: true,
    );
  }

  Future<void> init({
    String? conversationId,
    String? initialChat,
    File? initialAudioFile,
    String? topic,
  }) async {
    clearDraft();
    final String effectiveTopic = (topic ?? '').trim().isNotEmpty
        ? topic!.trim()
        : 'Sleep';

    if (conversationId != null && conversationId.isNotEmpty) {
      if (conversationId != state.conversationId) {
        changeProps(
          conversationId: conversationId,
          topic: effectiveTopic,
          messages: <BrainyMessage>[],
        );
      } else {
        changeProps(conversationId: conversationId, topic: effectiveTopic);
      }
      _listenToConversation(
        conversationId,
        fallbackInitialQuestion: initialChat,
      );
      return;
    }

    changeProps(conversationId: conversationId, topic: effectiveTopic);

    if ((initialChat != null && initialChat.trim().isNotEmpty) ||
        initialAudioFile != null) {
      await sendMessage(
        initialChat?.trim().isNotEmpty == true
            ? initialChat!.trim()
            : 'Voice note',
        audioFile: initialAudioFile,
      );
      return;
    }

    final ChildModel? child = preferences.getChildModel();
    final String childName = (child?.childName ?? '').trim().isNotEmpty
        ? child!.childName!.trim()
        : 'your child';
    changeProps(
      messages: [
        BrainyMessage(
          id: 'default_user',
          type: MessageType.user,
          chipTitle: 'You asked',
          headline: 'Why is bedtime harder lately?',
        ),
        BrainyMessage(
          id: 'default_info',
          type: MessageType.aiInfo,
          chipTitle: 'What may be happening',
          headline: "$childName's nap or evening rhythm may be shifting",
          subtext:
              'Shortened naps or late afternoon stimulation can raise overtiredness by the evening.',
        ),
        BrainyMessage(
          id: 'default_action',
          type: MessageType.aiAction,
          chipTitle: 'What to try now',
          headline: 'Offer a quieter environment 30m earlier',
          subtext:
              'Dimming the lights and turning off background noise can help signal that it is time to wind down.',
        ),
      ],
    );
  }

  void selectImage(String path) {
    if (path.trim().isEmpty) return;
    addSelectedImages(<String>[path]);
  }

  void addSelectedImages(List<String> paths) {
    if (paths.isEmpty) return;
    final List<String> current = List<String>.from(state.selectedImagePaths);
    for (final String path in paths) {
      if (path.trim().isNotEmpty && !current.contains(path)) {
        current.add(path);
      }
    }
    changeProps(
      selectedImagePaths: current,
      selectedImagePath: current.isNotEmpty ? current.first : null,
    );
  }

  void removeSelectedImageAt(int index) {
    if (index < 0 || index >= state.selectedImagePaths.length) return;
    final List<String> current = List<String>.from(state.selectedImagePaths);
    current.removeAt(index);
    changeProps(
      selectedImagePaths: current,
      selectedImagePath: current.isNotEmpty ? current.first : null,
      clearSelectedImage: current.isEmpty,
    );
  }

  void removeSelectedImage() {
    clearSelectedImages();
  }

  void clearSelectedImages() {
    changeProps(clearSelectedImages: true, clearSelectedImage: true);
  }

  Future<void> attachAudio(String path) async {
    if (path.trim().isEmpty) return;
    if (state.isAttachedAudioPlaying) {
      try {
        await _audioPlayer.stop();
      } catch (_) {}
    }
    changeProps(
      attachedAudioPath: path,
      isAttachedAudioPlaying: false,
      attachedAudioPosition: Duration.zero,
      attachedAudioDuration: Duration.zero,
    );
  }

  Future<void> removeAttachedAudio() async {
    if (state.isAttachedAudioPlaying) {
      try {
        await _audioPlayer.stop().timeout(const Duration(milliseconds: 200));
      } catch (_) {}
    }
    changeProps(
      clearAttachedAudio: true,
      isAttachedAudioPlaying: false,
      attachedAudioPosition: Duration.zero,
      attachedAudioDuration: Duration.zero,
    );
  }

  Future<void> togglePlayAttachedAudio() async {
    final String? path = state.attachedAudioPath;
    if (path == null || path.isEmpty) return;

    if (state.isAttachedAudioPlaying) {
      changeProps(isAttachedAudioPlaying: false);
      try {
        await _audioPlayer.pause().timeout(const Duration(milliseconds: 200));
      } catch (_) {}
      return;
    }

    if (state.isAudioPlaying) {
      try {
        await _audioPlayer.stop().timeout(const Duration(milliseconds: 200));
      } catch (_) {}
    }

    changeProps(
      clearPlayingMessageId: true,
      isAudioPlaying: false,
      isAttachedAudioPlaying: true,
    );
    try {
      if (File(path).existsSync()) {
        await _audioPlayer
            .play(DeviceFileSource(path))
            .timeout(const Duration(milliseconds: 200));
      }
    } catch (_) {
      if (!isClosed) {
        changeProps(isAttachedAudioPlaying: false);
      }
    }
  }

  Future<void> seekAttachedAudio(Duration position) async {
    if (state.attachedAudioPath == null) return;
    changeProps(attachedAudioPosition: position);
    try {
      await _audioPlayer
          .seek(position)
          .timeout(const Duration(milliseconds: 200));
    } catch (_) {}
  }

  void _listenToConversation(
    String conversationId, {
    String? fallbackInitialQuestion,
  }) {
    final String uid = preferences.getUserModel()?.uid ?? '';
    if (uid.isEmpty) return;

    _chatsSubscription?.cancel();
    _chatsSubscription = AuthRepo.instance.userCollection
        .doc(uid)
        .collection('conversations')
        .doc(conversationId)
        .collection('chats')
        .orderBy('time_stamp', descending: false)
        .snapshots()
        .listen(
          (QuerySnapshot<Map<String, dynamic>> snapshot) {
            if (isClosed) return;
            if (snapshot.docs.isEmpty) {
              if (fallbackInitialQuestion != null &&
                  fallbackInitialQuestion.trim().isNotEmpty &&
                  state.messages.isEmpty &&
                  !state.isTyping) {
                changeProps(
                  messages: <BrainyMessage>[
                    BrainyMessage(
                      id: 'initial_q',
                      type: MessageType.user,
                      chipTitle: 'You asked',
                      headline: fallbackInitialQuestion,
                    ),
                  ],
                );
              }
              return;
            }

            final List<BrainyMessage> mapped = <BrainyMessage>[];
            for (final QueryDocumentSnapshot<Map<String, dynamic>> doc
                in snapshot.docs) {
              mapped.addAll(_mapDocToBrainyMessages(doc.id, doc.data()));
            }
            changeProps(messages: mapped);
          },
          onError: (_) {
            _chatsSubscription?.cancel();
            _chatsSubscription = null;
          },
          cancelOnError: true,
        );
  }

  List<BrainyMessage> _mapDocToBrainyMessages(
    String docId,
    Map<String, dynamic> data,
  ) {
    final String? cardType = data['card_type']?.toString();
    final String? imageLocalPath = data['image_local_path']?.toString();
    final String? imageNetworkPath = data['image_network_path']?.toString();
    final List<String> imageLocalPaths =
        (data['image_local_paths'] as List<dynamic>?)
            ?.map((dynamic e) => e.toString())
            .toList() ??
        (imageLocalPath != null && imageLocalPath.isNotEmpty
            ? <String>[imageLocalPath]
            : <String>[]);
    final List<String> imageNetworkPaths =
        (data['image_network_paths'] as List<dynamic>?)
            ?.map((dynamic e) => e.toString())
            .toList() ??
        (imageNetworkPath != null && imageNetworkPath.isNotEmpty
            ? <String>[imageNetworkPath]
            : <String>[]);
    final String? audioLocalPath = data['audio_local_path']?.toString();
    final String? audioNetworkPath = data['audio_network_path']?.toString();
    final bool isSaved = data['is_saved'] == true;

    if (cardType != null && cardType.isNotEmpty) {
      MessageType type = MessageType.user;
      if (cardType == 'aiInfo') {
        type = MessageType.aiInfo;
      } else if (cardType == 'aiAction') {
        type = MessageType.aiAction;
      } else if (cardType == 'safetyAlert') {
        type = MessageType.safetyAlert;
      }
      return [
        BrainyMessage(
          id: docId,
          type: type,
          chipTitle:
              data['chip_title']?.toString() ??
              (type == MessageType.user
                  ? 'You asked'
                  : type == MessageType.aiInfo
                  ? 'What may be happening'
                  : type == MessageType.safetyAlert
                  ? 'Immediate Attention'
                  : 'What to try now'),
          headline:
              data['headline']?.toString() ?? data['text']?.toString() ?? '',
          subtext: data['subtext']?.toString(),
          imageLocalPath: imageLocalPath,
          imageNetworkPath: imageNetworkPath,
          imageLocalPaths: imageLocalPaths,
          imageNetworkPaths: imageNetworkPaths,
          audioLocalPath: audioLocalPath,
          audioNetworkPath: audioNetworkPath,
          isSaved: isSaved,
        ),
      ];
    }

    final String role = data['role']?.toString() ?? 'user';
    final String text = data['text']?.toString() ?? '';
    if (role == 'user') {
      return [
        BrainyMessage(
          id: docId,
          type: MessageType.user,
          chipTitle:
              (audioLocalPath != null && audioLocalPath.isNotEmpty) ||
                  (audioNetworkPath != null && audioNetworkPath.isNotEmpty)
              ? 'Voice note'
              : 'You asked',
          headline: text,
          imageLocalPath: imageLocalPath,
          imageNetworkPath: imageNetworkPath,
          imageLocalPaths: imageLocalPaths,
          imageNetworkPaths: imageNetworkPaths,
          audioLocalPath: audioLocalPath,
          audioNetworkPath: audioNetworkPath,
          isSaved: isSaved,
        ),
      ];
    }

    return _parseAiResponseText(text, baseId: docId, isSaved: isSaved);
  }

  Future<String> _ensureConversationCreated(String firstMessage) async {
    if (state.conversationId != null && state.conversationId!.isNotEmpty) {
      return state.conversationId!;
    }

    String convId = DateTime.now().millisecondsSinceEpoch.toString();
    final ApiResultStatus convResult = await AiRepo.instance
        .createConversation();
    convResult.whenOrNull(
      data: (dynamic data) {
        if (data is Map<String, dynamic>) {
          final CreateConversationModel model =
              CreateConversationModel.fromJson(data);
          if (model.id != null && model.id!.isNotEmpty) {
            convId = model.id!;
          }
        }
      },
    );

    changeProps(conversationId: convId);

    await AuthRepo.instance.addConversationToUser(
      conversationId: convId,
      request: {
        'conversation_id': convId,
        'first_message': firstMessage,
        'topic': state.topic ?? 'General',
        'created_at': Timestamp.now(),
      },
    );

    _listenToConversation(convId);
    return convId;
  }

  Future<void> sendMessage(
    String text, {
    File? audioFile,
    List<File>? imageFiles,
  }) async {
    final String cleanText = text.trim();
    final File? effectiveAudioFile =
        audioFile ??
        (state.attachedAudioPath != null && state.attachedAudioPath!.isNotEmpty
            ? File(state.attachedAudioPath!)
            : null);

    final List<File> effectiveImageFiles = <File>[];
    if (imageFiles != null && imageFiles.isNotEmpty) {
      effectiveImageFiles.addAll(imageFiles);
    } else if (state.selectedImagePaths.isNotEmpty) {
      for (final String path in state.selectedImagePaths) {
        if (path.trim().isNotEmpty) {
          effectiveImageFiles.add(File(path));
        }
      }
    } else if (state.selectedImagePath != null &&
        state.selectedImagePath!.trim().isNotEmpty) {
      effectiveImageFiles.add(File(state.selectedImagePath!));
    }

    if (cleanText.isEmpty &&
        effectiveAudioFile == null &&
        effectiveImageFiles.isEmpty) {
      return;
    }

    final String displayHeadline = cleanText.isNotEmpty
        ? cleanText
        : (effectiveAudioFile != null
              ? 'Voice note'
              : (effectiveImageFiles.length > 1
                    ? 'Shared ${effectiveImageFiles.length} photos'
                    : 'Shared a photo'));

    final BrainyMessage optimisticUserMsg = BrainyMessage(
      id: 'local_${DateTime.now().millisecondsSinceEpoch}',
      type: MessageType.user,
      chipTitle: effectiveAudioFile != null ? 'Voice note' : 'You asked',
      headline: displayHeadline,
      imageLocalPath: effectiveImageFiles.isNotEmpty
          ? effectiveImageFiles.first.path
          : null,
      imageLocalPaths: effectiveImageFiles.map((File f) => f.path).toList(),
      audioLocalPath: effectiveAudioFile?.path,
    );

    if (EmergencyDetector.isEmergency(displayHeadline) ||
        (cleanText.isNotEmpty && EmergencyDetector.isEmergency(cleanText))) {
      final String displayNumber =
          EmergencyDetector.getEmergencyDisplayNumber();
      final BrainyMessage safetyMsg = BrainyMessage(
        id: 'safety_${DateTime.now().millisecondsSinceEpoch}',
        type: MessageType.safetyAlert,
        chipTitle: 'Immediate Attention',
        headline: 'Please contact emergency services ($displayNumber)',
        subtext:
            "Loving Brain cannot assess acute medical symptoms or emergencies. If your child is struggling to breathe, turned blue, unresponsive, or in immediate danger, please call emergency services right away.",
      );

      changeProps(
        messages: <BrainyMessage>[
          ...state.messages,
          optimisticUserMsg,
          safetyMsg,
        ],
        isTyping: false,
        clearSelectedImage: true,
        clearSelectedImages: true,
        clearAttachedAudio: true,
        isAttachedAudioPlaying: false,
      );

      final String convId = await _ensureConversationCreated(displayHeadline);

      await AuthRepo.instance.addChatToConversation(
        conversationId: convId,
        request: {
          'text': displayHeadline,
          'chip_title': optimisticUserMsg.chipTitle,
          'headline': displayHeadline,
          'subtext': null,
          'card_type': 'user',
          'type': 'input_text',
          'role': 'user',
          'image_local_path': effectiveImageFiles.isNotEmpty
              ? effectiveImageFiles.first.path
              : null,
          'image_local_paths': effectiveImageFiles
              .map((File f) => f.path)
              .toList(),
          'audio_local_path': effectiveAudioFile?.path,
          'image_network_path': '',
          'image_network_paths': <String>[],
          'audio_network_path': '',
          'is_saved': false,
          'time_stamp': Timestamp.now(),
        },
      );

      await AuthRepo.instance.addChatToConversation(
        conversationId: convId,
        request: {
          'text': safetyMsg.headline,
          'chip_title': safetyMsg.chipTitle,
          'headline': safetyMsg.headline,
          'subtext': safetyMsg.subtext,
          'card_type': 'safetyAlert',
          'type': 'text',
          'role': 'assistant',
          'image_local_path': null,
          'image_local_paths': <String>[],
          'audio_local_path': null,
          'image_network_path': '',
          'image_network_paths': <String>[],
          'audio_network_path': '',
          'is_saved': false,
          'time_stamp': Timestamp.fromMillisecondsSinceEpoch(
            DateTime.now().millisecondsSinceEpoch + 10,
          ),
        },
      );
      return;
    }

    final List<ConnectivityResult> connectivity = await Connectivity()
        .checkConnectivity();
    final bool isOffline =
        connectivity.isEmpty ||
        connectivity.every(
          (ConnectivityResult c) => c == ConnectivityResult.none,
        );
    if (isOffline) {
      changeProps(
        messages: <BrainyMessage>[
          ...state.messages,
          optimisticUserMsg,
          BrainyMessage(
            id: 'offline_${DateTime.now().millisecondsSinceEpoch}',
            type: MessageType.error,
            chipTitle: "You're offline",
            headline: "You're offline right now",
            subtext:
                'Brainy needs an active internet connection to provide guidance. Please check your network and tap Try again when back online.',
          ),
        ],
        isTyping: false,
        clearSelectedImage: true,
        clearSelectedImages: true,
        clearAttachedAudio: true,
        isAttachedAudioPlaying: false,
      );
      return;
    }

    changeProps(
      messages: [...state.messages, optimisticUserMsg],
      isTyping: true,
      clearSelectedImage: true,
      clearSelectedImages: true,
      clearAttachedAudio: true,
      isAttachedAudioPlaying: false,
    );

    final String convId = await _ensureConversationCreated(displayHeadline);

    // Save user message to Firestore
    final ApiResultStatus addUserMsgResult = await AuthRepo.instance
        .addChatToConversation(
          conversationId: convId,
          request: {
            'text': displayHeadline,
            'chip_title': optimisticUserMsg.chipTitle,
            'headline': displayHeadline,
            'subtext': null,
            'card_type': 'user',
            'type': 'input_text',
            'role': 'user',
            'image_local_path': effectiveImageFiles.isNotEmpty
                ? effectiveImageFiles.first.path
                : null,
            'image_local_paths': effectiveImageFiles
                .map((File f) => f.path)
                .toList(),
            'audio_local_path': effectiveAudioFile?.path,
            'image_network_path': '',
            'image_network_paths': <String>[],
            'audio_network_path': '',
            'is_saved': false,
            'time_stamp': Timestamp.now(),
          },
        );

    addUserMsgResult.whenOrNull(
      data: (data) {
        if (data is DocumentReference) {
          _uploadToFirebaseStorage(
            convId: convId,
            documentReference: data,
            imageLocalPaths: effectiveImageFiles
                .map((File f) => f.path)
                .toList(),
            audioLocalPath: effectiveAudioFile?.path,
          );
        }
      },
    );

    // Fetch child and parent context for BrainAiSystemPrompt
    final UserModel? userModel = preferences.getUserModel();
    ChildModel? childModel = preferences.getChildModel();
    final DocumentReference<Object?>? childRef = userModel?.defaultChild;
    if (childModel == null && childRef != null) {
      try {
        final DocumentSnapshot<Object?> childSnap = await childRef.get();
        final Object? data = childSnap.data();
        if (data is Map<String, dynamic>) {
          childModel = ChildModel.fromJson(data, childSnap.reference);
        }
      } catch (_) {}
    }

    final String liveContext = await AiDataTools.buildLiveContextString(
      childModel: childModel,
    );

    final String systemPrompt = BrainAiSystemPrompt.build(
      childModel: childModel,
      parentName: userModel?.parentName ?? userModel?.displayName ?? 'Parent',
      topic: state.topic,
      liveContextString: liveContext,
    );

    // Build multi-turn conversational history
    final List<Map<String, dynamic>> history = <Map<String, dynamic>>[];
    for (final BrainyMessage msg in state.messages) {
      if (msg.id == optimisticUserMsg.id) continue;
      if (msg.type == MessageType.user) {
        history.add(<String, dynamic>{'role': 'user', 'content': msg.headline});
      } else {
        final String combinedText =
            msg.subtext != null && msg.subtext!.isNotEmpty
            ? '${msg.headline}\n${msg.subtext}'
            : msg.headline;
        history.add(<String, dynamic>{
          'role': 'assistant',
          'content': combinedText,
        });
      }
    }

    List<BrainyMessage> aiCards = <BrainyMessage>[];
    final ApiResultStatus aiResult = await AiRepo.instance.createResponse(
      conversationId: convId,
      messageText: displayHeadline,
      imageFiles: effectiveImageFiles,
      audioFile: effectiveAudioFile,
      history: history,
      systemPrompt: systemPrompt,
    );

    aiResult.whenOrNull(
      data: (dynamic data) {
        if (data is Map<String, dynamic>) {
          final AiResponseModel aiResponseModel = AiResponseModel.fromJson(
            data,
          );
          final List<ConversationItem> outputs = (aiResponseModel.output ?? [])
              .where((ConversationItem e) => e.type == 'message')
              .toList();
          if (outputs.isNotEmpty && (outputs.first.content ?? []).isNotEmpty) {
            final String rawAiText = outputs.first.content!.first.text ?? '';
            if (rawAiText.trim().isNotEmpty) {
              aiCards = _parseAiResponseText(rawAiText);
            }
          }
        }
      },
    );

    if (aiCards.isEmpty) {
      if (isClosed) return;
      final BrainyMessage errorCard = BrainyMessage(
        id: 'retry_${DateTime.now().millisecondsSinceEpoch}',
        type: MessageType.error,
        chipTitle: 'Connection issue',
        headline: "Brainy couldn't connect right now",
        subtext:
            "We couldn't reach the AI service. Please check your connection and tap Try again. Nothing you asked has been lost.",
      );
      changeProps(
        messages: <BrainyMessage>[...state.messages, errorCard],
        isTyping: false,
      );
      return;
    }

    // Persist AI cards to Firestore so history and conversation stream stay in sync
    for (int i = 0; i < aiCards.length; i++) {
      final BrainyMessage card = aiCards[i];
      await AuthRepo.instance.addChatToConversation(
        conversationId: convId,
        request: {
          'text': card.subtext != null
              ? '${card.headline}\n${card.subtext}'
              : card.headline,
          'chip_title': card.chipTitle,
          'headline': card.headline,
          'subtext': card.subtext,
          'card_type': card.type == MessageType.aiAction
              ? 'aiAction'
              : 'aiInfo',
          'type': 'text',
          'role': 'assistant',
          'image_local_path': null,
          'audio_local_path': null,
          'image_network_path': '',
          'audio_network_path': '',
          'is_saved': false,
          'time_stamp': Timestamp.fromMillisecondsSinceEpoch(
            DateTime.now().millisecondsSinceEpoch + (i * 10),
          ),
        },
      );
    }

    if (isClosed) return;
    final String uid = userModel?.uid ?? '';
    if (uid.isEmpty) {
      changeProps(
        messages: <BrainyMessage>[...state.messages, ...aiCards],
        isTyping: false,
      );
    } else {
      changeProps(isTyping: false);
    }
  }

  Future<void> retryLastMessage() async {
    final BrainyMessage? lastUserMsg = state.messages.reversed.firstWhereOrNull(
      (BrainyMessage m) => m.type == MessageType.user,
    );
    if (lastUserMsg == null) return;

    final List<BrainyMessage> cleaned = state.messages
        .where((BrainyMessage m) => m.type != MessageType.error)
        .toList();

    changeProps(messages: cleaned, isTyping: true);

    final String convId =
        state.conversationId ??
        await _ensureConversationCreated(lastUserMsg.headline);

    final UserModel? userModel = preferences.getUserModel();
    ChildModel? childModel = preferences.getChildModel();
    final DocumentReference<Object?>? childRef = userModel?.defaultChild;
    if (childModel == null && childRef != null) {
      try {
        final DocumentSnapshot<Object?> childSnap = await childRef.get();
        final Object? data = childSnap.data();
        if (data is Map<String, dynamic>) {
          childModel = ChildModel.fromJson(data, childSnap.reference);
        }
      } catch (_) {}
    }

    final String liveContext = await AiDataTools.buildLiveContextString(
      childModel: childModel,
    );

    final String systemPrompt = BrainAiSystemPrompt.build(
      childModel: childModel,
      parentName: userModel?.parentName ?? userModel?.displayName ?? 'Parent',
      topic: state.topic,
      liveContextString: liveContext,
    );

    final List<Map<String, dynamic>> history = <Map<String, dynamic>>[];
    for (final BrainyMessage msg in cleaned) {
      if (msg.id == lastUserMsg.id) continue;
      if (msg.type == MessageType.user) {
        history.add(<String, dynamic>{'role': 'user', 'content': msg.headline});
      } else if (msg.type == MessageType.aiInfo ||
          msg.type == MessageType.aiAction) {
        final String combinedText =
            msg.subtext != null && msg.subtext!.isNotEmpty
            ? '${msg.headline}\n${msg.subtext}'
            : msg.headline;
        history.add(<String, dynamic>{
          'role': 'assistant',
          'content': combinedText,
        });
      }
    }

    final File? imgFile =
        (lastUserMsg.imageLocalPath != null &&
            lastUserMsg.imageLocalPath!.isNotEmpty)
        ? File(lastUserMsg.imageLocalPath!)
        : null;
    final File? audFile =
        (lastUserMsg.audioLocalPath != null &&
            lastUserMsg.audioLocalPath!.isNotEmpty)
        ? File(lastUserMsg.audioLocalPath!)
        : null;

    List<BrainyMessage> aiCards = <BrainyMessage>[];
    final ApiResultStatus aiResult = await AiRepo.instance.createResponse(
      conversationId: convId,
      messageText: lastUserMsg.headline,
      imageFile: imgFile,
      audioFile: audFile,
      history: history,
      systemPrompt: systemPrompt,
    );

    aiResult.whenOrNull(
      data: (dynamic data) {
        if (data is Map<String, dynamic>) {
          final AiResponseModel aiResponseModel = AiResponseModel.fromJson(
            data,
          );
          final List<ConversationItem> outputs = (aiResponseModel.output ?? [])
              .where((ConversationItem e) => e.type == 'message')
              .toList();
          if (outputs.isNotEmpty && (outputs.first.content ?? []).isNotEmpty) {
            final String rawAiText = outputs.first.content!.first.text ?? '';
            if (rawAiText.trim().isNotEmpty) {
              aiCards = _parseAiResponseText(rawAiText);
            }
          }
        }
      },
    );

    if (aiCards.isEmpty) {
      if (isClosed) return;
      final BrainyMessage errorCard = BrainyMessage(
        id: 'retry_${DateTime.now().millisecondsSinceEpoch}',
        type: MessageType.error,
        chipTitle: 'Connection issue',
        headline: "Brainy couldn't connect right now",
        subtext:
            "We couldn't reach the AI service. Please check your connection and tap Try again. Nothing you asked has been lost.",
      );
      changeProps(
        messages: <BrainyMessage>[...state.messages, errorCard],
        isTyping: false,
      );
      return;
    }

    for (int i = 0; i < aiCards.length; i++) {
      final BrainyMessage card = aiCards[i];
      await AuthRepo.instance.addChatToConversation(
        conversationId: convId,
        request: {
          'text': card.subtext != null
              ? '${card.headline}\n${card.subtext}'
              : card.headline,
          'chip_title': card.chipTitle,
          'headline': card.headline,
          'subtext': card.subtext,
          'card_type': card.type == MessageType.aiAction
              ? 'aiAction'
              : 'aiInfo',
          'type': 'text',
          'role': 'assistant',
          'image_local_path': null,
          'audio_local_path': null,
          'image_network_path': '',
          'audio_network_path': '',
          'is_saved': false,
          'time_stamp': Timestamp.fromMillisecondsSinceEpoch(
            DateTime.now().millisecondsSinceEpoch + (i * 10),
          ),
        },
      );
    }

    if (isClosed) return;
    final String uid = userModel?.uid ?? '';
    if (uid.isEmpty) {
      changeProps(
        messages: <BrainyMessage>[...state.messages, ...aiCards],
        isTyping: false,
      );
    } else {
      changeProps(isTyping: false);
    }
  }

  List<BrainyMessage> _parseAiResponseText(
    String rawText, {
    String? baseId,
    bool isSaved = false,
  }) {
    final String cleaned = rawText.trim();
    if (cleaned.contains('---')) {
      final List<String> parts = cleaned.split('---');
      final (String, String?) part1 = _extractHeadlineAndSubtext(
        parts[0].trim(),
      );
      final (String, String?) part2 = parts.length > 1
          ? _extractHeadlineAndSubtext(parts[1].trim())
          : (
              'Try one gentle step tonight',
              'Keep your voice low and predictable to help your child settle.',
            );
      final List<BrainyMessage> messages = <BrainyMessage>[
        BrainyMessage(
          id: baseId != null ? '${baseId}_info' : null,
          type: MessageType.aiInfo,
          chipTitle: 'What may be happening',
          headline: part1.$1,
          subtext: part1.$2,
          isSaved: isSaved,
        ),
        BrainyMessage(
          id: baseId != null ? '${baseId}_action' : null,
          type: MessageType.aiAction,
          chipTitle: 'What to try now',
          headline: part2.$1,
          subtext: part2.$2,
          isSaved: isSaved,
        ),
      ];

      if (parts.length > 2) {
        final (String, String?) part3 = _extractHeadlineAndSubtext(
          parts[2].trim(),
        );
        if (part3.$1.trim().isNotEmpty) {
          messages.add(
            BrainyMessage(
              id: baseId != null ? '${baseId}_help' : null,
              type: MessageType.aiInfo,
              chipTitle: 'When to get help',
              headline: part3.$1,
              subtext: part3.$2,
              isSaved: isSaved,
            ),
          );
        }
      }

      if (messages.length == 2) {
        messages.add(
          BrainyMessage(
            id: baseId != null ? '${baseId}_help' : null,
            type: MessageType.aiInfo,
            chipTitle: 'When to get help',
            headline: 'Reach out if challenges persist over 2–3 weeks',
            subtext:
                'If routine adjustments do not help or if distress begins impacting daily wellbeing, discuss these patterns with your pediatrician.',
            isSaved: isSaved,
          ),
        );
      }

      return messages;
    }

    final (String, String?) parsed = _extractHeadlineAndSubtext(cleaned);
    return <BrainyMessage>[
      BrainyMessage(
        id: baseId,
        type: MessageType.aiInfo,
        chipTitle: 'Brainy',
        headline: parsed.$1,
        subtext: parsed.$2,
        isSaved: isSaved,
      ),
    ];
  }

  (String, String?) _extractHeadlineAndSubtext(String section) {
    final List<String> lines = section
        .split('\n')
        .map((l) => l.trim().replaceAll(RegExp(r'^[#*-\s]+'), ''))
        .where(
          (l) =>
              l.isNotEmpty &&
              !l.toLowerCase().startsWith('what may be happening') &&
              !l.toLowerCase().startsWith('what to try now') &&
              !l.toLowerCase().startsWith('when to get help'),
        )
        .toList();

    if (lines.isEmpty) {
      return ('A gentle observation', null);
    }
    if (lines.length == 1) {
      return (lines.first, null);
    }
    return (lines.first, lines.sublist(1).join(' '));
  }

  Future<void> toggleSaveGuidance(BrainyMessage message, int index) async {
    if (index < 0 || index >= state.messages.length) return;
    final bool newSaved = !message.isSaved;
    final List<BrainyMessage> updatedMessages = <BrainyMessage>[
      ...state.messages,
    ];
    updatedMessages[index] = message.copyWith(isSaved: newSaved);
    changeProps(messages: updatedMessages);

    final String uid = preferences.getUserModel()?.uid ?? '';
    if (uid.isEmpty) return;

    if (state.conversationId != null &&
        message.id != null &&
        !message.id!.startsWith('local_') &&
        !message.id!.startsWith('default_')) {
      final String rawDocId = message.id!
          .replaceAll('_info', '')
          .replaceAll('_action', '');
      await AuthRepo.instance.updateChatToConversation(
        conversationId: state.conversationId!,
        chatReferenceId: rawDocId,
        request: <String, dynamic>{'is_saved': newSaved},
      );
    }

    final String savedDocId =
        message.id ?? 'saved_${message.headline.hashCode.abs()}';
    final DocumentReference<Map<String, dynamic>> savedRef = AuthRepo
        .instance
        .userCollection
        .doc(uid)
        .collection('saved_guidance')
        .doc(savedDocId);

    if (newSaved) {
      await savedRef.set(<String, dynamic>{
        'id': savedDocId,
        'conversation_id': state.conversationId,
        'title': message.headline,
        'subtext': message.subtext ?? '',
        'topic': state.topic ?? 'Sleep',
        'saved_at': Timestamp.now(),
      });
    } else {
      try {
        await savedRef.delete();
      } catch (_) {}
    }
  }

  Future<void> togglePlayAudio(BrainyMessage message) async {
    if (state.isAttachedAudioPlaying) {
      try {
        await _audioPlayer.stop();
      } catch (_) {}
      changeProps(isAttachedAudioPlaying: false);
    }

    final String msgKey = message.id ?? message.headline;
    if (state.playingMessageId == msgKey && state.isAudioPlaying) {
      await _audioPlayer.pause();
      changeProps(isAudioPlaying: false);
      return;
    }

    final String? localPath = message.audioLocalPath;
    final String? networkPath = message.audioNetworkPath;

    try {
      await _audioPlayer.stop();
      changeProps(playingMessageId: msgKey, isAudioPlaying: true);
      if (localPath != null &&
          localPath.isNotEmpty &&
          File(localPath).existsSync()) {
        await _audioPlayer.play(DeviceFileSource(localPath));
      } else if (networkPath != null && networkPath.isNotEmpty) {
        await _audioPlayer.play(UrlSource(networkPath));
      } else {
        changeProps(clearPlayingMessageId: true, isAudioPlaying: false);
      }
    } catch (_) {
      if (!isClosed) {
        changeProps(clearPlayingMessageId: true, isAudioPlaying: false);
      }
    }
  }

  Future<void> _uploadToFirebaseStorage({
    required String convId,
    required DocumentReference<Object?> documentReference,
    String? imageLocalPath,
    List<String>? imageLocalPaths,
    String? audioLocalPath,
  }) async {
    final String? uid = preferences.getUserModel()?.uid;
    final List<String> allImagePaths = <String>[];
    if (imageLocalPaths != null && imageLocalPaths.isNotEmpty) {
      allImagePaths.addAll(imageLocalPaths);
    } else if (imageLocalPath != null && imageLocalPath.isNotEmpty) {
      allImagePaths.add(imageLocalPath);
    }

    if (allImagePaths.isNotEmpty) {
      final List<String> uploadedUrls = <String>[];
      for (final String path in allImagePaths) {
        if (path.isNotEmpty && File(path).existsSync()) {
          try {
            final ApiResultStatus uploadedFilePath = await AiRepo.instance
                .uploadFileToFirebaseStorage(
                  file: File(path),
                  referenceId: uid,
                );
            if (uploadedFilePath is Data) {
              final dynamic data = uploadedFilePath.data;
              if (data is String && data.isNotEmpty) {
                uploadedUrls.add(data);
              } else if (data is TaskSnapshot) {
                try {
                  final String imageNetworkUrl = await data.ref
                      .getDownloadURL();
                  uploadedUrls.add(imageNetworkUrl);
                } catch (_) {}
              }
            }
          } catch (_) {}
        }
      }

      if (uploadedUrls.isNotEmpty) {
        try {
          await AuthRepo.instance.updateChatToConversation(
            conversationId: convId,
            chatReferenceId: documentReference.id,
            request: <String, dynamic>{
              'image_network_path': uploadedUrls.first,
              'image_network_paths': uploadedUrls,
            },
          );
        } catch (_) {}
      }
    }

    if (audioLocalPath != null && audioLocalPath.isNotEmpty) {
      try {
        final ApiResultStatus uploadedFilePath = await AiRepo.instance
            .uploadAudioFileToFirebaseStorage(
              file: File(audioLocalPath),
              referenceId: uid,
            );
        if (uploadedFilePath is Data) {
          final dynamic data = uploadedFilePath.data;
          String? audioNetworkUrl;
          if (data is String && data.isNotEmpty) {
            audioNetworkUrl = data;
          } else if (data is TaskSnapshot) {
            try {
              audioNetworkUrl = await data.ref.getDownloadURL();
            } catch (_) {}
          }
          if (audioNetworkUrl != null && audioNetworkUrl.isNotEmpty) {
            await AuthRepo.instance.updateChatToConversation(
              conversationId: convId,
              chatReferenceId: documentReference.id,
              request: <String, dynamic>{'audio_network_path': audioNetworkUrl},
            );
          }
        }
      } catch (_) {}
    }
  }

  @override
  Future<void> close() async {
    await _chatsSubscription?.cancel();
    await _playerStateSubscription?.cancel();
    await _positionSubscription?.cancel();
    await _durationSubscription?.cancel();
    await _audioPlayer.dispose();
    return super.close();
  }
}
