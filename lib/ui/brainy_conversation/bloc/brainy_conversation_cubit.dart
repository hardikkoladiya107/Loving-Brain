import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/content/brain_ai_system_prompt.dart';
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
    _playerStateSubscription = _audioPlayer.onPlayerStateChanged.listen((s) {
      if (isClosed) return;
      final bool playing = s == PlayerState.playing;
      emit(
        state.copyWith(
          isAudioPlaying: playing,
          playingMessageId:
              (s == PlayerState.completed || s == PlayerState.stopped)
              ? null
              : state.playingMessageId,
        ),
      );
    });
  }

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _chatsSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> init({
    String? conversationId,
    String? initialChat,
    File? initialAudioFile,
    String? topic,
  }) async {
    final String effectiveTopic = (topic ?? '').trim().isNotEmpty
        ? topic!.trim()
        : 'Sleep';

    emit(
      state.copyWith(
        conversationId: conversationId,
        topic: effectiveTopic,
      ),
    );

    if (conversationId != null && conversationId.isNotEmpty) {
      _listenToConversation(
        conversationId,
        fallbackInitialQuestion: initialChat,
      );
      return;
    }

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
    emit(
      state.copyWith(
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
      ),
    );
  }

  void selectImage(String path) {
    if (path.trim().isEmpty) return;
    emit(state.copyWith(selectedImagePath: path));
  }

  void removeSelectedImage() {
    emit(state.copyWith(selectedImagePath: null));
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
        .listen((snapshot) {
          if (isClosed) return;
          if (snapshot.docs.isEmpty) {
            if (fallbackInitialQuestion != null &&
                fallbackInitialQuestion.trim().isNotEmpty &&
                state.messages.isEmpty &&
                !state.isTyping) {
              final pair = _buildFallbackAiCards(
                fallbackInitialQuestion,
                preferences.getChildModel(),
              );
              emit(
                state.copyWith(
                  messages: [
                    BrainyMessage(
                      id: 'fallback_q',
                      type: MessageType.user,
                      chipTitle: 'You asked',
                      headline: fallbackInitialQuestion,
                    ),
                    ...pair,
                  ],
                ),
              );
            }
            return;
          }

          final List<BrainyMessage> mapped = [];
          for (final doc in snapshot.docs) {
            mapped.addAll(_mapDocToBrainyMessages(doc.id, doc.data()));
          }
          emit(state.copyWith(messages: mapped));
        });
  }

  List<BrainyMessage> _mapDocToBrainyMessages(
    String docId,
    Map<String, dynamic> data,
  ) {
    final String? cardType = data['card_type']?.toString();
    final String? imageLocalPath = data['image_local_path']?.toString();
    final String? imageNetworkPath = data['image_network_path']?.toString();
    final String? audioLocalPath = data['audio_local_path']?.toString();
    final String? audioNetworkPath = data['audio_network_path']?.toString();
    final bool isSaved = data['is_saved'] == true;

    if (cardType != null && cardType.isNotEmpty) {
      MessageType type = MessageType.user;
      if (cardType == 'aiInfo') {
        type = MessageType.aiInfo;
      } else if (cardType == 'aiAction') {
        type = MessageType.aiAction;
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
                  : 'What to try now'),
          headline:
              data['headline']?.toString() ?? data['text']?.toString() ?? '',
          subtext: data['subtext']?.toString(),
          imageLocalPath: imageLocalPath,
          imageNetworkPath: imageNetworkPath,
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
      data: (data) {
        if (data is Map<String, dynamic>) {
          final model = CreateConversationModel.fromJson(data);
          if (model.id != null && model.id!.isNotEmpty) {
            convId = model.id!;
          }
        }
      },
    );

    emit(state.copyWith(conversationId: convId));

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

  Future<void> sendMessage(String text, {File? audioFile}) async {
    final String cleanText = text.trim();
    final File? imageFile =
        (state.selectedImagePath != null && state.selectedImagePath!.isNotEmpty)
        ? File(state.selectedImagePath!)
        : null;

    if (cleanText.isEmpty && audioFile == null && imageFile == null) return;

    final String displayHeadline = cleanText.isNotEmpty
        ? cleanText
        : (audioFile != null ? 'Voice note' : 'Shared a photo');

    final BrainyMessage optimisticUserMsg = BrainyMessage(
      id: 'local_${DateTime.now().millisecondsSinceEpoch}',
      type: MessageType.user,
      chipTitle: audioFile != null ? 'Voice note' : 'You asked',
      headline: displayHeadline,
      imageLocalPath: imageFile?.path,
      audioLocalPath: audioFile?.path,
    );

    emit(
      state.copyWith(
        messages: [...state.messages, optimisticUserMsg],
        isTyping: true,
        selectedImagePath: null,
      ),
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
            'image_local_path': imageFile?.path,
            'audio_local_path': audioFile?.path,
            'image_network_path': '',
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
            imageLocalPath: imageFile?.path,
            audioLocalPath: audioFile?.path,
          );
        }
      },
    );

    // Fetch child and parent context for BrainAiSystemPrompt
    final UserModel? userModel = preferences.getUserModel();
    ChildModel? childModel = preferences.getChildModel();
    if (childModel == null && userModel?.defaultChild != null) {
      try {
        final DocumentSnapshot<Object?> childSnap = await userModel!
            .defaultChild!
            .get();
        if (childSnap.data() is Map<String, dynamic>) {
          childModel = ChildModel.fromJson(
            childSnap.data()! as Map<String, dynamic>,
            childSnap.reference,
          );
        }
      } catch (_) {}
    }

    final String systemPrompt = BrainAiSystemPrompt.build(
      childModel: childModel,
      parentName:
          userModel?.parentName ?? userModel?.displayName ?? 'Parent',
      topic: state.topic,
    );

    List<BrainyMessage> aiCards = [];
    final ApiResultStatus aiResult = await AiRepo.instance.createResponse(
      conversationId: convId,
      messageText: displayHeadline,
      imageFile: imageFile,
      audioFile: audioFile,
      systemPrompt: systemPrompt,
    );

    aiResult.whenOrNull(
      data: (data) {
        if (data is Map<String, dynamic>) {
          final aiResponseModel = AiResponseModel.fromJson(data);
          final List<ConversationItem> outputs = (aiResponseModel.output ?? [])
              .where((e) => e.type == 'message')
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
      await Future.delayed(const Duration(milliseconds: 900));
      aiCards = _buildFallbackAiCards(displayHeadline, childModel);
    }

    // Persist AI cards to Firestore so history and conversation stream stay in sync
    for (int i = 0; i < aiCards.length; i++) {
      final card = aiCards[i];
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
      emit(
        state.copyWith(
          messages: [...state.messages, ...aiCards],
          isTyping: false,
        ),
      );
    } else {
      emit(state.copyWith(isTyping: false));
    }
  }

  List<BrainyMessage> _parseAiResponseText(
    String rawText, {
    String? baseId,
    bool isSaved = false,
  }) {
    final String cleaned = rawText.trim();
    if (cleaned.contains('---')) {
      final parts = cleaned.split('---');
      final part1 = _extractHeadlineAndSubtext(parts[0].trim());
      final part2 = parts.length > 1
          ? _extractHeadlineAndSubtext(parts[1].trim())
          : (
              'Try one gentle step tonight',
              'Keep your voice low and predictable to help your child settle.',
            );
      return [
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
    }

    final parsed = _extractHeadlineAndSubtext(cleaned);
    return [
      BrainyMessage(
        id: baseId,
        type: MessageType.aiInfo,
        chipTitle: 'What may be happening',
        headline: parsed.$1,
        subtext: parsed.$2,
        isSaved: isSaved,
      ),
    ];
  }

  (String, String?) _extractHeadlineAndSubtext(String section) {
    final lines = section
        .split('\n')
        .map((l) => l.trim().replaceAll(RegExp(r'^[#*-\s]+'), ''))
        .where(
          (l) =>
              l.isNotEmpty &&
              !l.toLowerCase().startsWith('what may be happening') &&
              !l.toLowerCase().startsWith('what to try now'),
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

  List<BrainyMessage> _buildFallbackAiCards(
    String question,
    ChildModel? child,
  ) {
    final String childName = (child?.childName ?? '').trim().isNotEmpty
        ? child!.childName!.trim()
        : 'your child';
    final String lower = question.toLowerCase();
    final String topic = (state.topic ?? '').toLowerCase();

    if (lower.contains('nap') ||
        lower.contains('bedtime') ||
        lower.contains('sleep') ||
        lower.contains('wake') ||
        topic == 'sleep') {
      final String bedtimeNote = (child?.usualBedtime ?? '').isNotEmpty
          ? ' around ${child!.usualBedtime}'
          : '';
      return [
        BrainyMessage(
          type: MessageType.aiInfo,
          chipTitle: 'What may be happening',
          headline: '$childName may be building overtiredness before bed',
          subtext:
              'Shifts in daytime naps or evening stimulation$bedtimeNote can trigger a second wind of cortisol right when sleep pressure should peak.',
        ),
        BrainyMessage(
          type: MessageType.aiAction,
          chipTitle: 'What to try now',
          headline: 'Start a quiet wind-down 20–30 minutes earlier',
          subtext:
              'Dim the lights, lower voice volume, and repeat the same 2–3 calm bedtime cues so $childName feels safe and ready to rest.',
        ),
      ];
    }

    if (lower.contains('tantrum') ||
        lower.contains('meltdown') ||
        lower.contains('hitting') ||
        lower.contains('transition') ||
        topic == 'behaviour') {
      return [
        BrainyMessage(
          type: MessageType.aiInfo,
          chipTitle: 'What may be happening',
          headline: "$childName's nervous system is overloaded",
          subtext:
              'Big feelings often spill over during transitions or when hunger and fatigue make self-regulation too hard for a developing brain.',
        ),
        BrainyMessage(
          type: MessageType.aiAction,
          chipTitle: 'What to try now',
          headline: 'Connect first, then guide with a 5-minute warning',
          subtext:
              'Get down to eye level, validate the feeling in one short sentence ("It is hard to stop playing"), and offer a simple two-choice transition.',
        ),
      ];
    }

    if (lower.contains('clingy') ||
        lower.contains('mood') ||
        lower.contains('cry') ||
        topic == 'mood') {
      return [
        BrainyMessage(
          type: MessageType.aiInfo,
          chipTitle: 'What may be happening',
          headline: '$childName is seeking extra co-regulation from you',
          subtext:
              'Developmental leaps and new environments often make children check in more closely with their safe base.',
        ),
        BrainyMessage(
          type: MessageType.aiAction,
          chipTitle: 'What to try now',
          headline: 'Offer 5 minutes of undivided "fill-the-cup" connection',
          subtext:
              'Follow $childName\'s lead in quiet play without questions or corrections before stepping away for routine tasks.',
        ),
      ];
    }

    return [
      BrainyMessage(
        type: MessageType.aiInfo,
        chipTitle: 'What may be happening',
        headline: '$childName is adjusting to daily rhythms',
        subtext:
            'Small changes in sleep, energy, or routine can ripple into how $childName responds throughout the day.',
      ),
      BrainyMessage(
        type: MessageType.aiAction,
        chipTitle: 'What to try now',
        headline: 'Focus on one predictable anchor today',
        subtext:
            'Keep the next meal or bedtime transition calm and unhurried, and notice how $childName responds.',
      ),
    ];
  }

  Future<void> toggleSaveGuidance(BrainyMessage message, int index) async {
    if (index < 0 || index >= state.messages.length) return;
    final bool newSaved = !message.isSaved;
    final updatedMessages = [...state.messages];
    updatedMessages[index] = message.copyWith(isSaved: newSaved);
    emit(state.copyWith(messages: updatedMessages));

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
        request: {'is_saved': newSaved},
      );
    }

    final String savedDocId =
        message.id ?? 'saved_${message.headline.hashCode.abs()}';
    final savedRef = AuthRepo.instance.userCollection
        .doc(uid)
        .collection('saved_guidance')
        .doc(savedDocId);

    if (newSaved) {
      await savedRef.set({
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
    final String msgKey = message.id ?? message.headline;
    if (state.playingMessageId == msgKey && state.isAudioPlaying) {
      await _audioPlayer.pause();
      emit(state.copyWith(isAudioPlaying: false));
      return;
    }

    final String? localPath = message.audioLocalPath;
    final String? networkPath = message.audioNetworkPath;

    try {
      await _audioPlayer.stop();
      emit(state.copyWith(playingMessageId: msgKey, isAudioPlaying: true));
      if (localPath != null &&
          localPath.isNotEmpty &&
          File(localPath).existsSync()) {
        await _audioPlayer.play(DeviceFileSource(localPath));
      } else if (networkPath != null && networkPath.isNotEmpty) {
        await _audioPlayer.play(UrlSource(networkPath));
      } else {
        emit(state.copyWith(playingMessageId: null, isAudioPlaying: false));
      }
    } catch (_) {
      if (!isClosed) {
        emit(state.copyWith(playingMessageId: null, isAudioPlaying: false));
      }
    }
  }

  Future<void> _uploadToFirebaseStorage({
    required String convId,
    required DocumentReference<Object?> documentReference,
    String? imageLocalPath,
    String? audioLocalPath,
  }) async {
    final String? uid = preferences.getUserModel()?.uid;
    if (imageLocalPath != null && imageLocalPath.isNotEmpty) {
      final uploadedFilePath = await AiRepo.instance
          .uploadFileToFirebaseStorage(
            file: File(imageLocalPath),
            referenceId: uid,
          );
      uploadedFilePath.whenOrNull(
        data: (data) async {
          if (data is TaskSnapshot) {
            final imageNetworkUrl = await data.ref.getDownloadURL();
            await AuthRepo.instance.updateChatToConversation(
              conversationId: convId,
              chatReferenceId: documentReference.id,
              request: {'image_network_path': imageNetworkUrl},
            );
          }
        },
      );
    }

    if (audioLocalPath != null && audioLocalPath.isNotEmpty) {
      final uploadedFilePath = await AiRepo.instance
          .uploadAudioFileToFirebaseStorage(
            file: File(audioLocalPath),
            referenceId: uid,
          );
      uploadedFilePath.whenOrNull(
        data: (data) async {
          if (data is TaskSnapshot) {
            final audioNetworkUrl = await data.ref.getDownloadURL();
            await AuthRepo.instance.updateChatToConversation(
              conversationId: convId,
              chatReferenceId: documentReference.id,
              request: {'audio_network_path': audioNetworkUrl},
            );
          }
        },
      );
    }
  }

  @override
  Future<void> close() async {
    await _chatsSubscription?.cancel();
    await _playerStateSubscription?.cancel();
    await _audioPlayer.dispose();
    return super.close();
  }
}
