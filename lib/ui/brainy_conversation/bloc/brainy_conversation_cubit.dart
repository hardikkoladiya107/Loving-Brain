import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
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
    _prepareAttachedPlayer();
    _playerStateSubscription = _audioPlayer.onPlayerStateChanged.listen(
      (PlayerState s) {
        if (isClosed) return;
        final bool playing = s == PlayerState.playing;

        if (s == PlayerState.completed) {
          changeProps(
            isAudioPlaying: false,
            clearPlayingMessageId: true,
            isAttachedAudioPlaying: false,
            attachedAudioPosition: Duration.zero,
          );
        } else if (playing) {
          if (_attachedNoteIsSource) {
            changeProps(
              isAudioPlaying: false,
              isAttachedAudioPlaying: true,
              clearPlayingMessageId: true,
            );
          } else {
            changeProps(isAudioPlaying: true, isAttachedAudioPlaying: false);
          }
        } else if (s == PlayerState.paused) {
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
      if (isClosed || !_attachedNoteIsSource) return;
      if (state.attachedAudioPath == null) return;
      final Duration total = state.attachedAudioDuration;
      final Duration clamped = total > Duration.zero && position > total
          ? total
          : position;
      changeProps(attachedAudioPosition: clamped);
    }, onError: (_) {});

    _durationSubscription = _audioPlayer.onDurationChanged.listen((
      Duration duration,
    ) {
      if (isClosed || !_attachedNoteIsSource) return;
      if (state.attachedAudioPath == null || duration <= Duration.zero) {
        return;
      }
      changeProps(attachedAudioDuration: duration);
    }, onError: (_) {});
  }

  /// True while the shared player is pointed at the composer voice note.
  /// Duration events must still land before playback starts, and must not
  /// overwrite the note when a sent message is playing.
  bool _attachedNoteIsSource = false;

  Future<void> _prepareAttachedPlayer() async {
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.stop);
      await _audioPlayer.setPlayerMode(PlayerMode.mediaPlayer);
    } catch (_) {}
  }

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _chatsSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration>? _durationSubscription;
  final AudioPlayer _audioPlayer = AudioPlayer();
  static const int _chatPageSize = 30;
  int _chatLoadGeneration = 0;
  DocumentSnapshot<Map<String, dynamic>>? _oldestChatDoc;
  final Set<String> _knownChatDocIds = <String>{};

  void changeProps({
    List<BrainyMessage>? messages,
    bool? isTyping,
    String? conversationId,
    String? topic,
    String? attachedContext,
    bool clearAttachedContext = false,
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
    String? pendingSafetyMode,
    bool clearPendingSafetyMode = false,
    String? pendingSafetySourceMessage,
    bool clearPendingSafetySourceMessage = false,
    bool? isLoadingOlder,
    bool? hasMoreMessages,
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
        attachedContext: clearAttachedContext
            ? null
            : (attachedContext ?? state.attachedContext),
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
        pendingSafetyMode: clearPendingSafetyMode
            ? null
            : (pendingSafetyMode ?? state.pendingSafetyMode),
        pendingSafetySourceMessage: clearPendingSafetySourceMessage
            ? null
            : (pendingSafetySourceMessage ?? state.pendingSafetySourceMessage),
        isLoadingOlder: isLoadingOlder ?? state.isLoadingOlder,
        hasMoreMessages: hasMoreMessages ?? state.hasMoreMessages,
      ),
    );
  }

  void clearPendingSafetyNavigation() {
    changeProps(
      clearPendingSafetyMode: true,
      clearPendingSafetySourceMessage: true,
    );
  }

  void reset() {
    _attachedNoteIsSource = false;
    _chatLoadGeneration += 1;
    _oldestChatDoc = null;
    _knownChatDocIds.clear();
    _chatsSubscription?.cancel();
    _chatsSubscription = null;
    try {
      _audioPlayer.stop().catchError((_) {});
    } catch (_) {}
    emit(const BrainyConversationState());
  }

  void clearDraft() {
    if (isClosed) return;
    _attachedNoteIsSource = false;
    _chatLoadGeneration += 1;
    _oldestChatDoc = null;
    _knownChatDocIds.clear();
    _chatsSubscription?.cancel();
    _chatsSubscription = null;
    if (state.isAudioPlaying || state.isAttachedAudioPlaying) {
      try {
        _audioPlayer.stop().catchError((_) {});
      } catch (_) {}
    }
    changeProps(
      clearSelectedImage: true,
      clearSelectedImages: true,
      clearAttachedAudio: true,
      isAttachedAudioPlaying: false,
      attachedAudioPosition: Duration.zero,
      attachedAudioDuration: Duration.zero,
      isAudioPlaying: false,
      clearPlayingMessageId: true,
      isLoadingOlder: false,
      hasMoreMessages: false,
    );
  }

  Future<void> init({
    String? conversationId,
    String? initialChat,
    File? initialAudioFile,
    String? topic,
    String? attachedContext,
  }) async {
    clearDraft();
    final String effectiveTopic = (topic ?? '').trim().isNotEmpty
        ? topic!.trim()
        : 'Sleep';

    changeProps(
      topic: effectiveTopic,
      attachedContext: (attachedContext ?? '').trim().isNotEmpty
          ? attachedContext!.trim()
          : null,
      clearAttachedContext: (attachedContext ?? '').trim().isEmpty,
    );

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

    if (state.messages.isEmpty) {
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
          BrainyMessage(
            id: 'default_help',
            type: MessageType.aiInfo,
            chipTitle: 'When to get help',
            headline: 'Ask a health professional if evenings stay hard',
            subtext:
                'If this keeps going, or $childName seems unwell, speak with an appropriate health professional.',
          ),
        ],
      );
    }
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

  Future<void> attachAudio(String path, {Duration? knownDuration}) async {
    if (path.trim().isEmpty) return;
    if (state.isAttachedAudioPlaying || state.isAudioPlaying) {
      _attachedNoteIsSource = false;
      try {
        await _audioPlayer.stop();
      } catch (_) {}
    }
    _attachedNoteIsSource = true;
    final Duration initialDuration =
        knownDuration != null && knownDuration > Duration.zero
        ? knownDuration
        : Duration.zero;
    changeProps(
      attachedAudioPath: path,
      isAttachedAudioPlaying: false,
      isAudioPlaying: false,
      clearPlayingMessageId: true,
      attachedAudioPosition: Duration.zero,
      attachedAudioDuration: initialDuration,
    );
    await _primeAttachedDuration(path);
  }

  Future<void> _primeAttachedDuration(String path) async {
    if (!File(path).existsSync()) return;
    try {
      await _audioPlayer.setSource(DeviceFileSource(path));
      final Duration? duration = await _audioPlayer.getDuration();
      if (isClosed || state.attachedAudioPath != path) return;
      if (duration != null && duration > Duration.zero) {
        changeProps(attachedAudioDuration: duration);
      }
    } catch (_) {}
  }

  Future<void> removeAttachedAudio() async {
    _attachedNoteIsSource = false;
    if (state.isAttachedAudioPlaying) {
      try {
        await _audioPlayer.stop();
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
        await _audioPlayer.pause();
      } catch (_) {}
      return;
    }

    _attachedNoteIsSource = true;
    if (state.isAudioPlaying) {
      try {
        await _audioPlayer.stop();
      } catch (_) {}
    }

    changeProps(
      clearPlayingMessageId: true,
      isAudioPlaying: false,
      isAttachedAudioPlaying: true,
    );
    try {
      if (File(path).existsSync()) {
        final bool resume =
            _audioPlayer.state == PlayerState.paused &&
            state.attachedAudioPosition > Duration.zero;
        if (resume) {
          await _audioPlayer.resume();
        } else {
          await _audioPlayer.play(DeviceFileSource(path));
        }
      }
    } catch (_) {
      if (!isClosed) {
        changeProps(isAttachedAudioPlaying: false);
      }
    }
  }

  Future<void> seekAttachedAudio(Duration position) async {
    final String? path = state.attachedAudioPath;
    if (path == null || path.isEmpty) return;
    final Duration total = state.attachedAudioDuration;
    final Duration clamped = total > Duration.zero && position > total
        ? total
        : (position < Duration.zero ? Duration.zero : position);
    changeProps(attachedAudioPosition: clamped);
    if (!File(path).existsSync()) return;
    _attachedNoteIsSource = true;
    try {
      if (_audioPlayer.state == PlayerState.stopped) {
        await _audioPlayer.setSource(DeviceFileSource(path));
      }
      await _audioPlayer.seek(clamped);
    } catch (_) {}
  }

  void _listenToConversation(
    String conversationId, {
    String? fallbackInitialQuestion,
  }) {
    final String uid = preferences.getUserModel()?.uid ?? '';
    if (uid.isEmpty) return;
    _chatLoadGeneration += 1;
    final int generation = _chatLoadGeneration;
    _oldestChatDoc = null;
    _knownChatDocIds.clear();
    _chatsSubscription?.cancel();
    _chatsSubscription = null;
    _openLatestChatPage(
      uid: uid,
      conversationId: conversationId,
      generation: generation,
      fallbackInitialQuestion: fallbackInitialQuestion,
    );
  }

  CollectionReference<Map<String, dynamic>> _chatsCollection(
    String uid,
    String conversationId,
  ) {
    return AuthRepo.instance.userCollection
        .doc(uid)
        .collection('conversations')
        .doc(conversationId)
        .collection('chats');
  }

  Future<void> _openLatestChatPage({
    required String uid,
    required String conversationId,
    required int generation,
    String? fallbackInitialQuestion,
  }) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await _chatsCollection(
            uid,
            conversationId,
          ).orderBy('time_stamp', descending: true).limit(_chatPageSize).get();
      if (isClosed || generation != _chatLoadGeneration) return;

      final List<QueryDocumentSnapshot<Map<String, dynamic>>> newestFirst =
          snapshot.docs;
      final bool hasMore = newestFirst.length >= _chatPageSize;
      _oldestChatDoc = newestFirst.isEmpty ? null : newestFirst.last;
      for (final QueryDocumentSnapshot<Map<String, dynamic>> doc
          in newestFirst) {
        _knownChatDocIds.add(doc.id);
      }
      final List<BrainyMessage> recent = _mapDocsChronological(
        newestFirst.reversed,
      );

      if (recent.isEmpty) {
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
            hasMoreMessages: false,
            isLoadingOlder: false,
          );
        } else {
          changeProps(hasMoreMessages: false, isLoadingOlder: false);
        }
      } else if (state.isTyping || _hasPendingMessages(state.messages)) {
        _mergeServerMessages(recent);
        changeProps(hasMoreMessages: hasMore, isLoadingOlder: false);
      } else {
        changeProps(
          messages: recent,
          hasMoreMessages: hasMore,
          isLoadingOlder: false,
        );
      }

      _watchNewerChats(
        uid: uid,
        conversationId: conversationId,
        generation: generation,
        newestDoc: newestFirst.isEmpty ? null : newestFirst.first,
      );
    } catch (_) {
      if (!isClosed && generation == _chatLoadGeneration) {
        changeProps(isLoadingOlder: false);
      }
    }
  }

  void _watchNewerChats({
    required String uid,
    required String conversationId,
    required int generation,
    required DocumentSnapshot<Map<String, dynamic>>? newestDoc,
  }) {
    if (generation != _chatLoadGeneration) return;
    Query<Map<String, dynamic>> query = _chatsCollection(
      uid,
      conversationId,
    ).orderBy('time_stamp');
    if (newestDoc != null) {
      query = query.startAfterDocument(newestDoc);
    }
    _chatsSubscription?.cancel();
    _chatsSubscription = query.snapshots().listen(
      (QuerySnapshot<Map<String, dynamic>> snapshot) {
        if (isClosed || generation != _chatLoadGeneration) return;
        final List<QueryDocumentSnapshot<Map<String, dynamic>>> fresh = snapshot
            .docs
            .where(
              (QueryDocumentSnapshot<Map<String, dynamic>> doc) =>
                  !_knownChatDocIds.contains(doc.id),
            )
            .toList();
        if (fresh.isEmpty) return;
        for (final QueryDocumentSnapshot<Map<String, dynamic>> doc in fresh) {
          _knownChatDocIds.add(doc.id);
        }
        _mergeServerMessages(_mapDocsChronological(fresh));
      },
      onError: (_) {
        _chatsSubscription?.cancel();
        _chatsSubscription = null;
      },
      cancelOnError: true,
    );
  }

  Future<void> loadOlderMessages() async {
    final String uid = preferences.getUserModel()?.uid ?? '';
    final String? conversationId = state.conversationId;
    final DocumentSnapshot<Map<String, dynamic>>? oldest = _oldestChatDoc;
    if (uid.isEmpty ||
        conversationId == null ||
        conversationId.isEmpty ||
        oldest == null ||
        !state.hasMoreMessages ||
        state.isLoadingOlder) {
      return;
    }
    final int generation = _chatLoadGeneration;
    changeProps(isLoadingOlder: true);
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await _chatsCollection(uid, conversationId)
              .orderBy('time_stamp', descending: true)
              .startAfterDocument(oldest)
              .limit(_chatPageSize)
              .get();
      if (isClosed || generation != _chatLoadGeneration) return;
      if (snapshot.docs.isNotEmpty) {
        _oldestChatDoc = snapshot.docs.last;
      }
      final List<BrainyMessage> older = _mapDocsChronological(
        snapshot.docs.reversed,
      );
      for (final QueryDocumentSnapshot<Map<String, dynamic>> doc
          in snapshot.docs) {
        _knownChatDocIds.add(doc.id);
      }
      final Set<String> existingIds = state.messages
          .map((BrainyMessage m) => m.id)
          .whereType<String>()
          .toSet();
      final List<BrainyMessage> freshOlder = older
          .where(
            (BrainyMessage m) => m.id == null || !existingIds.contains(m.id),
          )
          .toList();
      changeProps(
        messages: <BrainyMessage>[...freshOlder, ...state.messages],
        hasMoreMessages: snapshot.docs.length >= _chatPageSize,
        isLoadingOlder: false,
      );
    } catch (_) {
      if (!isClosed && generation == _chatLoadGeneration) {
        changeProps(isLoadingOlder: false);
      }
    }
  }

  List<BrainyMessage> _mapDocsChronological(
    Iterable<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    final List<BrainyMessage> mapped = <BrainyMessage>[];
    for (final QueryDocumentSnapshot<Map<String, dynamic>> doc in docs) {
      mapped.addAll(_mapDocToBrainyMessages(doc.id, doc.data()));
    }
    return mapped;
  }

  void _mergeServerMessages(List<BrainyMessage> incoming) {
    if (incoming.isEmpty) return;
    final List<BrainyMessage> next = List<BrainyMessage>.from(state.messages);
    for (final BrainyMessage serverMsg in incoming) {
      if (serverMsg.id != null &&
          next.any((BrainyMessage m) => m.id == serverMsg.id)) {
        continue;
      }
      final int replaceAt = next.indexWhere((BrainyMessage m) {
        final String id = m.id ?? '';
        final bool pending =
            id.isEmpty ||
            id.startsWith('local_') ||
            id.startsWith('retry_') ||
            id.startsWith('safety_') ||
            id.startsWith('clinical_') ||
            id.startsWith('offline_');
        return pending &&
            m.type == serverMsg.type &&
            m.chipTitle == serverMsg.chipTitle &&
            m.headline == serverMsg.headline;
      });
      if (replaceAt >= 0) {
        next[replaceAt] = serverMsg;
      } else {
        next.add(serverMsg);
      }
    }
    changeProps(messages: next);
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
      } else if (cardType == 'clinicalConcern') {
        type = MessageType.clinicalConcern;
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
                  : type == MessageType.clinicalConcern
                  ? 'Health check'
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

    final bool isAcuteEmergency =
        EmergencyDetector.isEmergency(displayHeadline) ||
        (cleanText.isNotEmpty && EmergencyDetector.isEmergency(cleanText));
    final bool isClinicalConcern =
        !isAcuteEmergency &&
        (EmergencyDetector.isConcerningHealth(displayHeadline) ||
            (cleanText.isNotEmpty &&
                EmergencyDetector.isConcerningHealth(cleanText)));

    if (isAcuteEmergency || isClinicalConcern) {
      final BrainyMessage safetyMsg = isAcuteEmergency
          ? BrainyMessage(
              id: 'safety_${DateTime.now().millisecondsSinceEpoch}',
              type: MessageType.safetyAlert,
              chipTitle: 'Immediate Attention',
              headline:
                  'Please contact emergency services (${EmergencyDetector.getEmergencyDisplayNumber()})',
              subtext:
                  'Loving Brain cannot assess acute medical symptoms or emergencies. If your child is struggling to breathe, turned blue, unresponsive, or in immediate danger, please call emergency services right away.',
            )
          : BrainyMessage(
              id: 'clinical_${DateTime.now().millisecondsSinceEpoch}',
              type: MessageType.clinicalConcern,
              chipTitle: 'Health check',
              headline: 'Please speak with a health professional',
              subtext:
                  'Loving Brain cannot assess symptoms. This sounds like something a doctor or health visitor should review. We will not generate parenting advice for this message.',
            );

      changeProps(
        messages: <BrainyMessage>[
          ..._withoutPlaceholders(state.messages),
          optimisticUserMsg,
          safetyMsg,
        ],
        isTyping: false,
        clearSelectedImage: true,
        clearSelectedImages: true,
        clearAttachedAudio: true,
        isAttachedAudioPlaying: false,
        pendingSafetyMode: isAcuteEmergency ? 'acute' : 'clinical',
        pendingSafetySourceMessage: displayHeadline,
      );

      final String convId = await _ensureConversationCreated(displayHeadline);

      await AuthRepo.instance.addChatToConversation(
        conversationId: convId,
        request: <String, dynamic>{
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
        request: <String, dynamic>{
          'text': safetyMsg.headline,
          'chip_title': safetyMsg.chipTitle,
          'headline': safetyMsg.headline,
          'subtext': safetyMsg.subtext,
          'card_type': isAcuteEmergency ? 'safetyAlert' : 'clinicalConcern',
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
          ..._withoutPlaceholders(state.messages),
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
      messages: <BrainyMessage>[
        ..._withoutPlaceholders(state.messages),
        optimisticUserMsg,
      ],
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

    final BrainyContextSummary contextSummary =
        await AiDataTools.buildFourteenDayContext(childModel: childModel);
    final String liveWithAttached = _mergeAttachedContext(
      contextSummary.contextString,
    );

    final String systemPrompt = BrainAiSystemPrompt.build(
      childModel: childModel,
      parentName: userModel?.parentName ?? userModel?.displayName ?? 'Parent',
      topic: state.topic,
      liveContextString: liveWithAttached,
      hasPersonalData: contextSummary.hasPersonalData,
    );

    final List<Map<String, dynamic>> history = _modelHistory(
      state.messages,
      skipId: optimisticUserMsg.id,
    );

    List<BrainyMessage> aiCards = <BrainyMessage>[];
    try {
      final ApiResultStatus aiResult = await AiRepo.instance
          .createResponse(
            conversationId: convId,
            messageText: displayHeadline,
            imageFiles: effectiveImageFiles,
            audioFile: effectiveAudioFile,
            history: history,
            systemPrompt: systemPrompt,
          )
          .timeout(const Duration(seconds: 80));

      aiResult.whenOrNull(
        data: (dynamic data) {
          if (data is Map<String, dynamic>) {
            final AiResponseModel aiResponseModel = AiResponseModel.fromJson(
              data,
            );
            final List<ConversationItem> outputs =
                (aiResponseModel.output ?? [])
                    .where((ConversationItem e) => e.type == 'message')
                    .toList();
            if (outputs.isNotEmpty &&
                (outputs.first.content ?? []).isNotEmpty) {
              final String rawAiText = outputs.first.content!.first.text ?? '';
              if (rawAiText.trim().isNotEmpty) {
                aiCards = _parseAiResponseText(rawAiText);
              }
            }
          }
        },
      );
    } catch (_) {
      aiCards = <BrainyMessage>[];
    }

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

    aiCards = _applyGeneralGuidanceLabel(
      aiCards,
      hasPersonalData: contextSummary.hasPersonalData,
    );

    // 1. Immediately display the AI cards in the UI and stop the thinking indicator
    changeProps(
      messages: <BrainyMessage>[...state.messages, ...aiCards],
      isTyping: false,
    );

    // 2. Persist AI cards to Firestore in background for permanent history
    try {
      for (int i = 0; i < aiCards.length; i++) {
        final BrainyMessage card = aiCards[i];
        await AuthRepo.instance.addChatToConversation(
          conversationId: convId,
          request: {
            'text': card.subtext != null && card.subtext!.isNotEmpty
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
    } catch (_) {
      // Persistence error should not affect the already displayed response
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

    final BrainyContextSummary contextSummary =
        await AiDataTools.buildFourteenDayContext(childModel: childModel);
    final String liveWithAttached = _mergeAttachedContext(
      contextSummary.contextString,
    );

    final String systemPrompt = BrainAiSystemPrompt.build(
      childModel: childModel,
      parentName: userModel?.parentName ?? userModel?.displayName ?? 'Parent',
      topic: state.topic,
      liveContextString: liveWithAttached,
      hasPersonalData: contextSummary.hasPersonalData,
    );

    final List<Map<String, dynamic>> history = _modelHistory(
      cleaned,
      skipId: lastUserMsg.id,
    );

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
    try {
      final ApiResultStatus aiResult = await AiRepo.instance
          .createResponse(
            conversationId: convId,
            messageText: lastUserMsg.headline,
            imageFile: imgFile,
            audioFile: audFile,
            history: history,
            systemPrompt: systemPrompt,
          )
          .timeout(const Duration(seconds: 80));

      aiResult.whenOrNull(
        data: (dynamic data) {
          if (data is Map<String, dynamic>) {
            final AiResponseModel aiResponseModel = AiResponseModel.fromJson(
              data,
            );
            final List<ConversationItem> outputs =
                (aiResponseModel.output ?? [])
                    .where((ConversationItem e) => e.type == 'message')
                    .toList();
            if (outputs.isNotEmpty &&
                (outputs.first.content ?? []).isNotEmpty) {
              final String rawAiText = outputs.first.content!.first.text ?? '';
              if (rawAiText.trim().isNotEmpty) {
                aiCards = _parseAiResponseText(rawAiText);
              }
            }
          }
        },
      );
    } catch (_) {
      aiCards = <BrainyMessage>[];
    }

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

    aiCards = _applyGeneralGuidanceLabel(
      aiCards,
      hasPersonalData: contextSummary.hasPersonalData,
    );

    // 1. Immediately display the AI cards in the UI and stop the thinking indicator
    changeProps(
      messages: <BrainyMessage>[...state.messages, ...aiCards],
      isTyping: false,
    );

    // 2. Persist AI cards to Firestore in background
    try {
      for (int i = 0; i < aiCards.length; i++) {
        final BrainyMessage card = aiCards[i];
        await AuthRepo.instance.addChatToConversation(
          conversationId: convId,
          request: {
            'text': card.subtext != null && card.subtext!.isNotEmpty
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
    } catch (_) {
      // Background persistence error should not affect the already displayed response
    }
  }

  @visibleForTesting
  List<BrainyMessage> parseAiResponseForTesting(
    String rawText, {
    String? baseId,
    bool isSaved = false,
  }) => _parseAiResponseText(rawText, baseId: baseId, isSaved: isSaved);

  List<BrainyMessage> applyGeneralGuidanceLabelForTesting(
    List<BrainyMessage> cards, {
    required bool hasPersonalData,
  }) => _applyGeneralGuidanceLabel(cards, hasPersonalData: hasPersonalData);

  String mergeAttachedContextForTesting(String liveContext) =>
      _mergeAttachedContext(liveContext);

  @visibleForTesting
  List<Map<String, dynamic>> modelHistoryForTesting(
    List<BrainyMessage> messages, {
    String? skipId,
  }) => _modelHistory(messages, skipId: skipId);

  bool _hasPendingMessages(List<BrainyMessage> messages) {
    return messages.any((BrainyMessage message) {
      final String id = message.id ?? '';
      return id.isEmpty ||
          id.startsWith('local_') ||
          id.startsWith('retry_') ||
          id.startsWith('safety_') ||
          id.startsWith('clinical_') ||
          id.startsWith('offline_');
    });
  }

  List<BrainyMessage> _withoutPlaceholders(List<BrainyMessage> messages) {
    return messages.where((BrainyMessage message) {
      final String id = message.id ?? '';
      return !id.startsWith('default_');
    }).toList();
  }

  List<Map<String, dynamic>> _modelHistory(
    List<BrainyMessage> messages, {
    String? skipId,
  }) {
    final List<Map<String, dynamic>> history = <Map<String, dynamic>>[];
    final StringBuffer assistant = StringBuffer();

    void flushAssistant() {
      final String text = assistant.toString().trim();
      assistant.clear();
      if (text.isEmpty) return;
      history.add(<String, dynamic>{'role': 'assistant', 'content': text});
    }

    for (final BrainyMessage message in messages) {
      if (skipId != null && message.id == skipId) continue;
      final String id = message.id ?? '';
      if (id.startsWith('default_')) continue;
      if (message.type == MessageType.user) {
        flushAssistant();
        if (message.headline.trim().isNotEmpty) {
          history.add(<String, dynamic>{
            'role': 'user',
            'content': message.headline.trim(),
          });
        }
      } else if (message.type == MessageType.aiInfo ||
          message.type == MessageType.aiAction) {
        if (assistant.isNotEmpty) {
          assistant.writeln();
        }
        assistant.writeln(message.chipTitle);
        assistant.writeln(message.headline.trim());
        final String detail = message.subtext?.trim() ?? '';
        if (detail.isNotEmpty) {
          assistant.writeln(detail);
        }
      }
    }
    flushAssistant();
    return history;
  }

  String _mergeAttachedContext(String liveContext) {
    final String attached = state.attachedContext?.trim() ?? '';
    if (attached.isEmpty) return liveContext;
    final StringBuffer buffer = StringBuffer(liveContext.trim());
    if (buffer.isNotEmpty) {
      buffer.writeln();
    }
    buffer.writeln('Attached screen context:');
    buffer.writeln(attached);
    return buffer.toString();
  }

  List<BrainyMessage> _applyGeneralGuidanceLabel(
    List<BrainyMessage> cards, {
    required bool hasPersonalData,
  }) {
    if (hasPersonalData || cards.isEmpty) return cards;
    if (cards.first.chipTitle == 'Brainy') return cards;
    final BrainyMessage first = cards.first;
    final String existing = first.subtext?.trim() ?? '';
    final String label = AiDataTools.generalGuidanceLabel;
    if (existing.contains(label)) return cards;
    final String combined = existing.isEmpty ? label : '$label $existing';
    return <BrainyMessage>[first.copyWith(subtext: combined), ...cards.skip(1)];
  }

  List<BrainyMessage> _parseAiResponseText(
    String rawText, {
    String? baseId,
    bool isSaved = false,
  }) {
    final String cleaned = rawText.trim();
    if (cleaned.isEmpty) return <BrainyMessage>[];

    // Case 1: Standard '---' delimiter (per V2 App Content Copy Master §7)
    if (cleaned.contains('---')) {
      final List<String> rawParts = cleaned
          .split('---')
          .map((String s) => s.trim())
          .where((String s) => s.isNotEmpty)
          .toList();

      if (rawParts.length >= 3) {
        final (String, String?) part1 = _extractHeadlineAndSubtext(rawParts[0]);
        final (String, String?) part2 = _extractHeadlineAndSubtext(rawParts[1]);
        final (String, String?) part3 = _extractHeadlineAndSubtext(rawParts[2]);
        if (part1.$1.trim().isEmpty ||
            part2.$1.trim().isEmpty ||
            part3.$1.trim().isEmpty) {
          return <BrainyMessage>[];
        }
        return <BrainyMessage>[
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
          BrainyMessage(
            id: baseId != null ? '${baseId}_help' : null,
            type: MessageType.aiInfo,
            chipTitle: 'When to get help',
            headline: part3.$1,
            subtext: part3.$2,
            isSaved: isSaved,
          ),
        ];
      }
      // Incomplete parenting answer — do not invent missing parts.
      return <BrainyMessage>[];
    }

    // Case 2: Section headers (e.g., "Part 1:", "What may be happening:", "### 1.")
    final RegExp sectionHeaderRegex = RegExp(
      r'(?:^|\n+)(?:#{1,4}\s*)?(?:(?:Part\s*[123]|Step\s*[123])[:.]?\s*)?(?:(?:What\s+may\s+be\s+happening|What\s+to\s+try\s+now|When\s+to\s+get\s+help)[:.]?)\s*',
      caseSensitive: false,
    );

    if (sectionHeaderRegex.hasMatch(cleaned)) {
      final List<String> sections = cleaned
          .split(sectionHeaderRegex)
          .map((String s) => s.trim())
          .where((String s) => s.isNotEmpty)
          .toList();

      if (sections.length >= 3) {
        final (String, String?) part1 = _extractHeadlineAndSubtext(sections[0]);
        final (String, String?) part2 = _extractHeadlineAndSubtext(sections[1]);
        final (String, String?) part3 = _extractHeadlineAndSubtext(sections[2]);
        if (part1.$1.trim().isEmpty ||
            part2.$1.trim().isEmpty ||
            part3.$1.trim().isEmpty) {
          return <BrainyMessage>[];
        }
        return <BrainyMessage>[
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
          BrainyMessage(
            id: baseId != null ? '${baseId}_help' : null,
            type: MessageType.aiInfo,
            chipTitle: 'When to get help',
            headline: part3.$1,
            subtext: part3.$2,
            isSaved: isSaved,
          ),
        ];
      }
      return <BrainyMessage>[];
    }

    // Case 3: Casual greetings (Rule 75-76)
    final bool isCasualGreeting =
        cleaned.length < 250 &&
        (cleaned.toLowerCase().startsWith('hi') ||
            cleaned.toLowerCase().startsWith('hello') ||
            cleaned.toLowerCase().startsWith('hey') ||
            cleaned.toLowerCase().startsWith('good morning') ||
            cleaned.toLowerCase().startsWith('good afternoon') ||
            cleaned.toLowerCase().startsWith('good evening') ||
            cleaned.toLowerCase().startsWith('welcome'));

    if (isCasualGreeting) {
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

    // Case 4: Multi-paragraph response — require three real parts, never invent.
    final List<String> paragraphs = cleaned
        .split(RegExp(r'\n\s*\n'))
        .map((String s) => s.trim())
        .where((String s) => s.isNotEmpty)
        .toList();

    if (paragraphs.length >= 3) {
      final (String, String?) part1 = _extractHeadlineAndSubtext(paragraphs[0]);
      final (String, String?) part2 = _extractHeadlineAndSubtext(paragraphs[1]);
      final (String, String?) part3 = _extractHeadlineAndSubtext(
        paragraphs.sublist(2).join('\n\n'),
      );
      if (part1.$1.trim().isEmpty ||
          part2.$1.trim().isEmpty ||
          part3.$1.trim().isEmpty) {
        return <BrainyMessage>[];
      }
      return <BrainyMessage>[
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
        BrainyMessage(
          id: baseId != null ? '${baseId}_help' : null,
          type: MessageType.aiInfo,
          chipTitle: 'When to get help',
          headline: part3.$1,
          subtext: part3.$2,
          isSaved: isSaved,
        ),
      ];
    }

    // Incomplete or unstructured parenting answer — surface retry, do not fabricate.
    return <BrainyMessage>[];
  }

  (String, String?) _extractHeadlineAndSubtext(String section) {
    final List<String> rawLines = section
        .split('\n')
        .map((String l) => l.trim())
        .where((String l) => l.isNotEmpty)
        .toList();

    final List<String> filteredLines = rawLines
        .map((String l) => l.replaceAll(RegExp(r'^[#*-\s]+'), '').trim())
        .where(
          (String l) =>
              l.isNotEmpty &&
              !l.toLowerCase().startsWith('what may be happening') &&
              !l.toLowerCase().startsWith('what to try now') &&
              !l.toLowerCase().startsWith('when to get help') &&
              !l.toLowerCase().startsWith('part 1') &&
              !l.toLowerCase().startsWith('part 2') &&
              !l.toLowerCase().startsWith('part 3') &&
              !l.toLowerCase().startsWith('step 1') &&
              !l.toLowerCase().startsWith('step 2') &&
              !l.toLowerCase().startsWith('step 3'),
        )
        .toList();

    if (filteredLines.isEmpty) {
      return ('A gentle observation', null);
    }
    if (filteredLines.length == 1) {
      return (filteredLines.first, null);
    }
    return (filteredLines.first, filteredLines.sublist(1).join(' '));
  }

  Future<void> toggleSaveGuidance(BrainyMessage message, int index) async {
    if (index < 0 || index >= state.messages.length) return;
    if (message.type != MessageType.aiInfo &&
        message.type != MessageType.aiAction) {
      return;
    }

    final bool newSaved = !message.isSaved;
    final List<int> groupIndexes = _findAnswerGroupIndexes(index);
    final List<BrainyMessage> updatedMessages = <BrainyMessage>[
      ...state.messages,
    ];
    for (final int i in groupIndexes) {
      updatedMessages[i] = updatedMessages[i].copyWith(isSaved: newSaved);
    }
    changeProps(messages: updatedMessages);

    final String uid = preferences.getUserModel()?.uid ?? '';
    if (uid.isEmpty) return;

    BrainyMessage? happening;
    BrainyMessage? tryNow;
    BrainyMessage? getHelp;
    for (final int i in groupIndexes) {
      final BrainyMessage m = updatedMessages[i];
      if (m.chipTitle == 'What may be happening') happening = m;
      if (m.chipTitle == 'What to try now') tryNow = m;
      if (m.chipTitle == 'When to get help') getHelp = m;
    }
    happening ??= message;

    for (final int i in groupIndexes) {
      final BrainyMessage m = updatedMessages[i];
      if (state.conversationId != null &&
          m.id != null &&
          !m.id!.startsWith('local_') &&
          !m.id!.startsWith('default_') &&
          !m.id!.startsWith('retry_')) {
        final String rawDocId = m.id!
            .replaceAll('_info', '')
            .replaceAll('_action', '')
            .replaceAll('_help', '');
        try {
          await AuthRepo.instance.updateChatToConversation(
            conversationId: state.conversationId!,
            chatReferenceId: rawDocId,
            request: <String, dynamic>{'is_saved': newSaved},
          );
        } catch (_) {}
      }
    }

    final String savedDocId =
        state.conversationId != null && state.conversationId!.isNotEmpty
        ? 'answer_${state.conversationId}_${happening.headline.hashCode.abs()}'
        : 'saved_${happening.headline.hashCode.abs()}';
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
        'title': happening.headline,
        'subtext': happening.subtext ?? '',
        'what_may_be_happening_headline': happening.headline,
        'what_may_be_happening_subtext': happening.subtext ?? '',
        'what_to_try_now_headline': tryNow?.headline ?? '',
        'what_to_try_now_subtext': tryNow?.subtext ?? '',
        'when_to_get_help_headline': getHelp?.headline ?? '',
        'when_to_get_help_subtext': getHelp?.subtext ?? '',
        'topic': state.topic ?? 'Sleep',
        'saved_at': Timestamp.now(),
      });
    } else {
      try {
        await savedRef.delete();
      } catch (_) {}
    }
  }

  List<int> _findAnswerGroupIndexes(int index) {
    final List<BrainyMessage> messages = state.messages;
    if (index < 0 || index >= messages.length) return <int>[index];

    int start = index;
    while (start > 0) {
      final BrainyMessage prev = messages[start - 1];
      if (prev.type != MessageType.aiInfo &&
          prev.type != MessageType.aiAction) {
        break;
      }
      if (messages[start].chipTitle == 'What may be happening') break;
      start -= 1;
    }

    final List<int> group = <int>[];
    for (int i = start; i < messages.length && group.length < 3; i++) {
      final BrainyMessage m = messages[i];
      if (m.type != MessageType.aiInfo && m.type != MessageType.aiAction) {
        break;
      }
      group.add(i);
      if (m.chipTitle == 'When to get help') break;
    }
    return group.isEmpty ? <int>[index] : group;
  }

  Future<void> togglePlayAudio(BrainyMessage message) async {
    _attachedNoteIsSource = false;
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
