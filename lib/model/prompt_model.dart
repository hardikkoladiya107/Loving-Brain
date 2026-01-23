import 'package:cloud_firestore/cloud_firestore.dart';

class PromptModel {
  final String id;
  final String prompt;
  final String hint1;
  final String hint2;

  PromptModel({
    required this.id,
    required this.prompt,
    required this.hint1,
    required this.hint2,
  });

  factory PromptModel.fromMap(Map<String, dynamic> map, String docId) {
    return PromptModel(
      id: docId,
      prompt: map['prompt'] ?? "",
      hint1: map['hint1'] ?? "",
      hint2: map['hint2'] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'prompt': prompt,
      'hint1': hint1,
      'hint2': hint2,
    };
  }
}
