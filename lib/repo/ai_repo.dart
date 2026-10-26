import 'dart:convert';
import 'dart:io' as io;
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:loving_brain/core/ai_data_tools.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/secrets.dart';

import '../model/transcribe_model.dart';

class AiRepo {
  AiRepo._();

  static final AiRepo _instance = AiRepo._();

  static String get secretKey => "Bearer ${Secrets.openAiApiKey}";

  // Standard OpenAI Chat Completion Endpoint
  static const String chatUrl = "https://api.openai.com/v1/chat/completions";

  Map<String, dynamic> get headers => <String, dynamic>{
    "Content-Type": "application/json",
    "Authorization": secretKey,
  };

  factory AiRepo() {
    return _instance;
  }

  static AiRepo get instance => _instance;

  final Dio dio = Dio();

  Future<ApiResultStatus> uploadFile({required File file}) async {
    try {
      final MultipartFile multipartFile = await MultipartFile.fromFile(
        file.path,
        filename: file.path.split("/").last,
      );
      final FormData formData = FormData.fromMap({
        'file': multipartFile,
        'purpose': 'vision', // Correct purpose for vision/chat
      });
      final Response<dynamic> response = await dio.post(
        "https://api.openai.com/v1/files",
        data: formData,
        options: Options(headers: headers),
      );
      return ApiResultStatus.data(data: response.data);
    } on DioException catch (e) {
      return ApiResultStatus.error(error: e);
    }
  }

  Future<ApiResultStatus> transcribeAudio({required File file}) async {
    try {
      final MultipartFile multipartFile = await MultipartFile.fromFile(
        file.path,
        filename: file.path.split("/").last,
      );
      final FormData formData = FormData.fromMap({
        'file': multipartFile,
        'model': 'whisper-1',
      });
      final Response<dynamic> response = await dio.post(
        "https://api.openai.com/v1/audio/transcriptions",
        data: formData,
        options: Options(headers: headers),
      );
      return ApiResultStatus.data(data: response.data);
    } on DioException catch (e) {
      return ApiResultStatus.error(error: e);
    }
  }

  // OpenAI Chat API is stateless. We don't "create" a conversation on their side.
  // We just return a success with a mock ID or null to proceed.
  Future<ApiResultStatus> createConversation({String? conversationName}) async {
    // Just mock a success response as we manage conversation ID locally/firebase
    return ApiResultStatus.data(
      data: {"id": DateTime.now().millisecondsSinceEpoch.toString()},
    );
  }

  Future<ApiResultStatus> getAllConversation({
    required String conversationId,
  }) async {
    // This was likely fetching from a non-existent endpoint.
    // Since we store chats in Firebase (via AuthRepo), this might not be needed from OpenAI.
    // Returning empty list or error to avoid breaking if called.
    return ApiResultStatus.data(data: {"items": []});
  }

  Future<ApiResultStatus> createResponse({
    required String conversationId,
    required String messageText,
    File? imageFile,
    File? audioFile,
    List<Map<String, dynamic>>? history,
    String? systemPrompt,
  }) async {
    try {
      TranscribeModel? transcribeModel;
      String finalText = messageText;

      if (audioFile != null) {
        final ApiResultStatus audioFileResponse = await transcribeAudio(
          file: audioFile,
        );
        audioFileResponse.whenOrNull(
          data: (dynamic data) {
            transcribeModel = TranscribeModel.fromJson(
              data as Map<String, dynamic>,
            );
            final String? transcribedText = transcribeModel?.text;
            if (transcribedText != null && transcribedText.isNotEmpty) {
              finalText += "\n[Audio Transcription]: $transcribedText";
            }
          },
        );
      }

      final List<Map<String, dynamic>> messages = <Map<String, dynamic>>[
        <String, dynamic>{
          "role": "system",
          "content":
              systemPrompt ??
              "You are a helpful parenting assistant for LovingBrain.",
        },
      ];

      // Add conversation history if available
      if (history != null && history.isNotEmpty) {
        messages.addAll(history);
      }

      // Format current user message (with image if present)
      if (imageFile != null && await imageFile.exists()) {
        try {
          final List<int> imageBytes = await imageFile.readAsBytes();
          final String base64Image = base64Encode(imageBytes);
          final String extension = imageFile.path.split('.').last.toLowerCase();
          final String mimeType = extension == 'png'
              ? 'image/png'
              : 'image/jpeg';
          messages.add(<String, dynamic>{
            "role": "user",
            "content": <dynamic>[
              <String, dynamic>{"type": "text", "text": finalText},
              <String, dynamic>{
                "type": "image_url",
                "image_url": <String, dynamic>{
                  "url": "data:$mimeType;base64,$base64Image",
                },
              },
            ],
          });
        } catch (_) {
          messages.add(<String, dynamic>{"role": "user", "content": finalText});
        }
      } else {
        messages.add(<String, dynamic>{"role": "user", "content": finalText});
      }

      // First completion call with tools
      final Response<dynamic> response = await dio.post(
        chatUrl,
        data: <String, dynamic>{
          "model": "gpt-4o",
          "messages": messages,
          "tools": AiDataTools.openAiTools,
          "tool_choice": "auto",
        },
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData =
            response.data as Map<String, dynamic>;
        final List<dynamic> choices = responseData['choices'] as List<dynamic>;
        if (choices.isEmpty) {
          return ApiResultStatus.error(
            error: Exception("Empty OpenAI response"),
          );
        }

        final Map<String, dynamic> choice = choices[0] as Map<String, dynamic>;
        final Map<String, dynamic> message =
            choice['message'] as Map<String, dynamic>;
        final List<dynamic>? toolCalls =
            message['tool_calls'] as List<dynamic>?;

        // If the model requested function calling / tools
        if (toolCalls != null && toolCalls.isNotEmpty) {
          final List<Map<String, dynamic>> conversationWithTools =
              List<Map<String, dynamic>>.from(messages);
          conversationWithTools.add(message);

          for (final dynamic call in toolCalls) {
            final Map<String, dynamic> callMap = call as Map<String, dynamic>;
            final String functionName =
                callMap['function']['name']?.toString() ?? '';
            final String argsStr =
                callMap['function']['arguments']?.toString() ?? '{}';
            Map<String, dynamic> args = <String, dynamic>{};
            try {
              args = jsonDecode(argsStr) as Map<String, dynamic>;
            } catch (_) {}

            final String toolResult = await AiDataTools.executeTool(
              functionName,
              args,
            );

            conversationWithTools.add(<String, dynamic>{
              'role': 'tool',
              'tool_call_id': callMap['id'],
              'content': toolResult,
            });
          }

          // Follow-up completion after tool execution
          final Response<dynamic> followUp = await dio.post(
            chatUrl,
            data: <String, dynamic>{
              "model": "gpt-4o",
              "messages": conversationWithTools,
            },
            options: Options(headers: headers),
          );

          if (followUp.statusCode == 200) {
            final Map<String, dynamic> followUpData =
                followUp.data as Map<String, dynamic>;
            final String finalContent =
                (followUpData['choices']
                        as List<dynamic>)[0]['message']['content']
                    as String;
            return ApiResultStatus.data(
              data: <String, dynamic>{
                "output": <Map<String, dynamic>>[
                  <String, dynamic>{
                    "type": "message",
                    "role": "assistant",
                    "content": <Map<String, dynamic>>[
                      <String, dynamic>{"type": "text", "text": finalContent},
                    ],
                  },
                ],
              },
            );
          }
        }

        final String content = message['content']?.toString() ?? '';
        return ApiResultStatus.data(
          data: <String, dynamic>{
            "output": <Map<String, dynamic>>[
              <String, dynamic>{
                "type": "message",
                "role": "assistant",
                "content": <Map<String, dynamic>>[
                  <String, dynamic>{"type": "text", "text": content},
                ],
              },
            ],
          },
        );
      }
      return ApiResultStatus.error(error: Exception("Failed to get response"));
    } on DioException catch (e) {
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
          .child(referenceId ?? "TEST")
          .child('/${file.path.split("/").last}');
      final SettableMetadata metadata = SettableMetadata(
        contentType: 'image/${file.path.split(".").last}',
        customMetadata: {'picked-file-path': file.path},
      );
      final UploadTask uploadTask = ref.putFile(io.File(file.path), metadata);
      return ApiResultStatus.data(data: await Future.value(uploadTask));
    } on FirebaseException catch (e) {
      return ApiResultStatus.error(error: e);
    } on Exception catch (e) {
      return ApiResultStatus.error(error: e);
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
          .child(referenceId ?? "TEST")
          .child('/${file.path.split("/").last}');
      final SettableMetadata metadata = SettableMetadata(
        contentType: 'audio/${file.path.split(".").last}',
        customMetadata: {'picked-file-path': file.path},
      );
      final UploadTask uploadTask = ref.putFile(io.File(file.path), metadata);
      return ApiResultStatus.data(data: await Future.value(uploadTask));
    } on FirebaseException catch (e) {
      return ApiResultStatus.error(error: e);
    } on Exception catch (e) {
      return ApiResultStatus.error(error: e);
    }
  }
}
