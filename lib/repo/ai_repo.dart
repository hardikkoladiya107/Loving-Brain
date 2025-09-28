import 'dart:io';

import 'package:dio/dio.dart';
import 'package:loving_brain/model/api_result_status.dart';

class AiRepo {
  AiRepo._();

  static final AiRepo _instance = AiRepo._();

  static final String secretKey =
      " ";
  static final String promptKey =
      " ";

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
      var response = await dio.post("files", data: formData);
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
  }) async {
    try {
      var response = await dio.post(
        "https://api.openai.com/v1/responses",
        data: {
          "model": "gpt-5",
          "prompt": {"id": promptKey, "version": "6"},
          "conversation": {"id": conversationId},
          "input": [
            {"role": "user", "content": messageText},
          ],
        },
        options: Options(headers: headers),
      );
      return ApiResultStatus.data(data: response.data);
    } on DioException catch (e) {
      return ApiResultStatus.error(error: e);
    }
  }
}
