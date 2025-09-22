import 'dart:io';

import 'package:dio/dio.dart';
import 'package:loving_brain/model/api_result_status.dart';

class AiRepo {
  AiRepo._();

  static final AiRepo _instance = AiRepo._();

  static final String baseUrl = "https://api.openai.com/v1/";

  factory AiRepo() {
    return _instance;
  }

  static AiRepo get instance => _instance;

  var dio = Dio(BaseOptions(baseUrl: baseUrl));

  Future<ApiResultStatus> getResponse({
    required String inputText,
    File? inputFile,
  }) async {
    try {
      if (inputFile != null) {
        var response = await uploadFile(file: inputFile);
        response.whenOrNull(data: (data) {}, error: (error) {});
      }
      var request = {"model": "gpt-5", "input": inputText};
      /*var request2 = {
        "model": "gpt-5",
        "input": [
          {
            "role": "user",
            "content": [
              {"type": "input_file", "file_id": "file-6F2ksmvXxt4VdoqmHRw6kL"},
              {
                "type": "input_text",
                "text": "What is the first dragon in the book?",
              },
            ],
          },
        ],
      };*/
      var response = await dio.post(
        "responses",
        data: request,
        options: Options(headers: {}),
      );
      return ApiResultStatus.data(data: response.data);
    } on DioException catch (e) {
      return ApiResultStatus.error(error: e);
    }
  }

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
}
