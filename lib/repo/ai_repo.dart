import 'dart:io';
import 'dart:io' as io;
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:loving_brain/model/api_result_status.dart';

import '../model/ai_file_upload_model.dart';
import '../model/transcribe_model.dart';

class AiRepo {
  AiRepo._();

  static final AiRepo _instance = AiRepo._();

  static final String secretKey =
      "";
  static final String promptKey =
      "";
  static final String conversationUrl =
      "https://api.openai.com/v1/conversations";

  Map<String, dynamic> headers = {
    "Content-Type": "application/json",
    "Authorization": secretKey,
  };

  factory AiRepo() {
    return _instance;
  }

  static AiRepo get instance => _instance;

  var dio = Dio();

  Future<ApiResultStatus> uploadFile({required File file}) async {
    try {
      final multipartFile = await MultipartFile.fromFile(
        file.path,
        filename: file.path.split("/").last,
      );
      final formData = FormData.fromMap({
        'file': multipartFile,
        'purpose': 'user_data',
      });
      var response = await dio.post(
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
      final multipartFile = await MultipartFile.fromFile(
        file.path,
        filename: file.path.split("/").last,
      );
      final formData = FormData.fromMap({
        'file': multipartFile,
        'model': 'whisper-1',
      });
      var response = await dio.post(
        "https://api.openai.com/v1/audio/transcriptions",
        data: formData,
        options: Options(headers: headers),
      );
      return ApiResultStatus.data(data: response.data);
    } on DioException catch (e) {
      return ApiResultStatus.error(error: e);
    }
  }

  Future<ApiResultStatus> createConversation({String? conversationName}) async {
    try {
      var request = {
        "metadata": {"topic": conversationName ?? "New Chat"},
      };
      var response = await dio.post(
        conversationUrl,
        data: request,
        options: Options(headers: headers),
      );
      return ApiResultStatus.data(data: response.data);
    } on DioException catch (e) {
      return ApiResultStatus.error(error: e);
    }
  }

  Future<ApiResultStatus> getAllConversation({
    required String conversationId,
  }) async {
    try {
      var response = await dio.get(
        "$conversationUrl/$conversationId/items?limit=10",
        options: Options(headers: headers),
      );
      return ApiResultStatus.data(data: response.data);
    } on DioException catch (e) {
      return ApiResultStatus.error(error: e);
    }
  }

  Future<ApiResultStatus> createResponse({
    required String conversationId,
    required String messageText,
    File? imageFile,
    File? audioFile,
  }) async {
    try {
      AiFileUploadModel? imageFileModel;
      TranscribeModel? transcribeModel;

      if (imageFile != null) {
        var imageFileResponse = await uploadFile(file: imageFile);
        imageFileResponse.whenOrNull(
          data: (data) {
            imageFileModel = AiFileUploadModel.fromJson(data);
          },
          error: (error) {
            return imageFileResponse;
          },
        );
      }

      if (audioFile != null) {
        var audioFileResponse = await transcribeAudio(file: audioFile);
        audioFileResponse.whenOrNull(
          data: (data) {
            transcribeModel = TranscribeModel.fromJson(data);
          },
          error: (error) {
            return audioFileResponse;
          },
        );
      }

      var response = await dio.post(
        "https://api.openai.com/v1/responses",
        data: {
          "model": "gpt-5",
          "prompt": {"id": promptKey, "version": "8"},
          "conversation": {"id": conversationId},
          "input": [
            {
              "role": "user",
              "content": [
                {"type": "input_text", "text": messageText},
                if (imageFileModel != null)
                  {"type": "input_image", "file_id": imageFileModel?.id},
                if (transcribeModel != null)
                  {"type": "input_text", "text": transcribeModel?.text},
              ],
            },
          ],
        },
        options: Options(headers: headers),
      );
      return ApiResultStatus.data(data: response.data);
    } on DioException catch (e) {
      return ApiResultStatus.error(error: e);
    }
  }

  Future<ApiResultStatus> uploadFileToFirebaseStorage({
    required File file,
    required String? referenceId,
  }) async {
    try {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('ai-chat-images')
          .child(referenceId ?? "TEST")
          .child('/${file.path.split("/").last}');
      final metadata = SettableMetadata(
        contentType: 'image/${file.path.split(".").last}',
        customMetadata: {'picked-file-path': file.path},
      );
      var uploadTask = ref.putFile(io.File(file.path), metadata);
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
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('ai-chat-audio')
          .child(referenceId ?? "TEST")
          .child('/${file.path.split("/").last}');
      final metadata = SettableMetadata(
        contentType: 'audio/${file.path.split(".").last}',
        customMetadata: {'picked-file-path': file.path},
      );
      var uploadTask = ref.putFile(io.File(file.path), metadata);
      return ApiResultStatus.data(data: await Future.value(uploadTask));
    } on FirebaseException catch (e) {
      return ApiResultStatus.error(error: e);
    } on Exception catch (e) {
      return ApiResultStatus.error(error: e);
    }
  }
}
