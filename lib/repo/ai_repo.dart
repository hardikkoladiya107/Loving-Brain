import 'dart:convert';
import 'dart:io' as io;
import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:loving_brain/core/ai_data_tools.dart';
import 'package:loving_brain/model/api_result_status.dart';

import '../model/transcribe_model.dart';

class AiRepo {
  AiRepo._();

  static final AiRepo _instance = AiRepo._();

  factory AiRepo() {
    return _instance;
  }

  static AiRepo get instance => _instance;

  static const Duration _callableTimeout = Duration(seconds: 45);

  // OpenAI Chat API is stateless. We don't "create" a conversation on their side.
  // We just return a success with a mock ID or null to proceed.
  Future<ApiResultStatus> createConversation({String? conversationName}) async {
    return ApiResultStatus.data(
      data: <String, dynamic>{
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
      },
    );
  }

  Future<ApiResultStatus> getAllConversation({
    required String conversationId,
  }) async {
    return ApiResultStatus.data(data: <String, dynamic>{'items': <dynamic>[]});
  }

  Future<ApiResultStatus> transcribeAudio({required File file}) async {
    try {
      if (!await file.exists()) {
        return ApiResultStatus.error(error: Exception('Audio file not found'));
      }
      final List<int> bytes = await file.readAsBytes();
      if (bytes.isEmpty) {
        return ApiResultStatus.error(error: Exception('Audio file is empty'));
      }
      final String extension = file.path.split('.').last.toLowerCase();
      final String mimeType = extension == 'wav'
          ? 'audio/wav'
          : extension == 'mp3'
          ? 'audio/mpeg'
          : extension == 'webm'
          ? 'audio/webm'
          : 'audio/m4a';
      final String fileName = file.path.split('/').last;

      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'transcribeAudio',
        options: HttpsCallableOptions(timeout: _callableTimeout),
      );
      final HttpsCallableResult<dynamic> response = await callable
          .call(<String, dynamic>{
            'audioBase64': base64Encode(bytes),
            'mimeType': mimeType,
            'fileName': fileName,
          });
      final dynamic data = response.data;
      if (data is Map) {
        final String text = data['text']?.toString() ?? '';
        return ApiResultStatus.data(data: <String, dynamic>{'text': text});
      }
      return ApiResultStatus.error(
        error: Exception('Empty transcription response'),
      );
    } on FirebaseFunctionsException catch (e) {
      return ApiResultStatus.error(
        error: Exception(e.message ?? 'Transcription failed'),
      );
    } catch (e) {
      return ApiResultStatus.error(error: Exception(e.toString()));
    }
  }

  Future<ApiResultStatus> createResponse({
    required String conversationId,
    required String messageText,
    File? imageFile,
    List<File>? imageFiles,
    File? audioFile,
    List<Map<String, dynamic>>? history,
    String? systemPrompt,
  }) async {
    try {
      String finalText = messageText;

      if (audioFile != null) {
        final ApiResultStatus audioFileResponse = await transcribeAudio(
          file: audioFile,
        );
        audioFileResponse.whenOrNull(
          data: (dynamic data) {
            final TranscribeModel transcribeModel = TranscribeModel.fromJson(
              data as Map<String, dynamic>,
            );
            final String? transcribedText = transcribeModel.text;
            if (transcribedText != null && transcribedText.isNotEmpty) {
              finalText += '\n[Audio Transcription]: $transcribedText';
            }
          },
        );
      }

      final List<File> effectiveImages = <File>[];
      if (imageFiles != null && imageFiles.isNotEmpty) {
        effectiveImages.addAll(imageFiles);
      } else if (imageFile != null) {
        effectiveImages.add(imageFile);
      }

      final List<String> imageUrls = <String>[];
      for (final File img in effectiveImages) {
        if (!await img.exists()) continue;
        try {
          final ApiResultStatus uploaded = await uploadFileToFirebaseStorage(
            file: img,
            referenceId: conversationId,
          );
          if (uploaded is Data) {
            final dynamic data = uploaded.data;
            if (data is String && data.isNotEmpty) {
              imageUrls.add(data);
            }
          }
        } catch (_) {}
      }

      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'brainyChat',
        options: HttpsCallableOptions(timeout: _callableTimeout),
      );
      final List<Map<String, dynamic>> toolTail = <Map<String, dynamic>>[];
      for (int round = 0; round < 3; round++) {
        final bool allowTools = round < 2;
        final HttpsCallableResult<dynamic> response = await callable
            .call(<String, dynamic>{
              'messageText': finalText,
              'systemPrompt': systemPrompt,
              'history': history ?? <Map<String, dynamic>>[],
              'imageUrls': imageUrls,
              'tools': allowTools
                  ? AiDataTools.openAiTools
                  : <Map<String, dynamic>>[],
              'toolTail': toolTail,
            })
            .timeout(_callableTimeout);

        final dynamic data = response.data;
        if (data is! Map) {
          return ApiResultStatus.error(
            error: Exception('Failed to get response'),
          );
        }
        final List<dynamic> toolCalls = data['toolCalls'] is List
            ? data['toolCalls'] as List<dynamic>
            : <dynamic>[];
        if (toolCalls.isEmpty) {
          final String content = data['text']?.toString() ?? '';
          if (content.trim().isNotEmpty) {
            return ApiResultStatus.data(
              data: <String, dynamic>{
                'output': <Map<String, dynamic>>[
                  <String, dynamic>{
                    'type': 'message',
                    'role': 'assistant',
                    'content': <Map<String, dynamic>>[
                      <String, dynamic>{'type': 'text', 'text': content},
                    ],
                  },
                ],
              },
            );
          }
          return ApiResultStatus.error(
            error: Exception('Failed to get response'),
          );
        }

        final dynamic assistantMessage = data['assistantMessage'];
        final int tailBefore = toolTail.length;
        if (assistantMessage is Map) {
          toolTail.add(Map<String, dynamic>.from(assistantMessage));
        }
        int answeredCalls = 0;
        for (final dynamic call in toolCalls) {
          if (call is! Map) continue;
          final String callId = call['id']?.toString() ?? '';
          final dynamic function = call['function'];
          if (callId.isEmpty || function is! Map) continue;
          final String name = function['name']?.toString() ?? '';
          if (name.isEmpty) continue;
          Map<String, dynamic> arguments = <String, dynamic>{};
          final dynamic rawArguments = function['arguments'];
          if (rawArguments is String && rawArguments.trim().isNotEmpty) {
            try {
              final dynamic decoded = jsonDecode(rawArguments);
              if (decoded is Map) {
                arguments = Map<String, dynamic>.from(decoded);
              }
            } catch (_) {}
          } else if (rawArguments is Map) {
            arguments = Map<String, dynamic>.from(rawArguments);
          }
          String output;
          try {
            output = await AiDataTools.executeTool(name, arguments);
          } catch (_) {
            output = jsonEncode(<String, dynamic>{
              'error': 'Could not read that record just now.',
            });
          }
          toolTail.add(<String, dynamic>{
            'role': 'tool',
            'tool_call_id': callId,
            'content': output,
          });
          answeredCalls += 1;
        }
        if (answeredCalls == 0) {
          toolTail.removeRange(tailBefore, toolTail.length);
        }
      }
      return ApiResultStatus.error(error: Exception('Failed to get response'));
    } on FirebaseFunctionsException catch (e) {
      return ApiResultStatus.error(
        error: Exception(e.message ?? 'Failed to get response'),
      );
    } on Exception catch (e) {
      return ApiResultStatus.error(error: e);
    } catch (e) {
      return ApiResultStatus.error(error: Exception(e.toString()));
    }
  }

  Future<ApiResultStatus> uploadFileToFirebaseStorage({
    required File file,
    required String? referenceId,
  }) async {
    try {
      final Reference ref = FirebaseStorage.instance
          .ref()
          .child('ai-chat-images')
          .child(referenceId ?? 'TEST')
          .child('/${file.path.split('/').last}');
      final SettableMetadata metadata = SettableMetadata(
        contentType: 'image/${file.path.split('.').last}',
        customMetadata: <String, String>{'picked-file-path': file.path},
      );
      final UploadTask uploadTask = ref.putFile(io.File(file.path), metadata);
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      return ApiResultStatus.data(data: downloadUrl);
    } on FirebaseException catch (e) {
      return ApiResultStatus.error(error: e);
    } on Exception catch (e) {
      return ApiResultStatus.error(error: e);
    } catch (e) {
      return ApiResultStatus.error(error: Exception(e.toString()));
    }
  }

  Future<ApiResultStatus> uploadAudioFileToFirebaseStorage({
    required File file,
    required String? referenceId,
  }) async {
    try {
      final Reference ref = FirebaseStorage.instance
          .ref()
          .child('ai-chat-audio')
          .child(referenceId ?? 'TEST')
          .child('/${file.path.split('/').last}');
      final SettableMetadata metadata = SettableMetadata(
        contentType: 'audio/${file.path.split('.').last}',
        customMetadata: <String, String>{'picked-file-path': file.path},
      );
      final UploadTask uploadTask = ref.putFile(io.File(file.path), metadata);
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      return ApiResultStatus.data(data: downloadUrl);
    } on FirebaseException catch (e) {
      return ApiResultStatus.error(error: e);
    } on Exception catch (e) {
      return ApiResultStatus.error(error: e);
    } catch (e) {
      return ApiResultStatus.error(error: Exception(e.toString()));
    }
  }
}
