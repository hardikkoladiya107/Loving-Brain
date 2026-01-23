import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../model/prompt_model.dart';

part 'connect_detail_state.freezed.dart';

class DrawingStroke {
  final List<Offset> points;
  final Color color;
  final double width;

  DrawingStroke({
    required this.points,
    required this.color,
    required this.width,
  });
}

@freezed
abstract class ConnectDetailState with _$ConnectDetailState {
  const factory ConnectDetailState({
    @Default("Draw what makes you feel calm") String currentPrompt, // Keeping as fallback or while loading/error
    PromptModel? promptModel,
    @Default(true) bool isLoading,
    @Default(Colors.blue) Color selectedColor,
    @Default([]) List<DrawingStroke> allStrokes,
    DrawingStroke? currentStroke,
  }) = _ConnectDetailState;
}
