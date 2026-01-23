import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/api_result_status.dart';
import '../../../../model/prompt_model.dart';
import 'connect_detail_cubit.dart';
part 'connect_detail_state.freezed.dart';

@freezed
abstract class ConnectDetailState with _$ConnectDetailState {
  const factory ConnectDetailState({
    @Default("Draw what makes you feel calm") String currentPrompt, // Keeping as fallback or while loading/error
    PromptModel? promptModel,
    @Default(Colors.blue) Color selectedColor,
    @Default([]) List<DrawingStroke> allStrokes,
    @Default(ApiResultStatus.initial()) ApiResultStatus getPromptApiResultStatus,
    @Default(ApiResultStatus.initial()) ApiResultStatus saveDrawingApiResultStatus,
    DrawingStroke? currentStroke,
  }) = _ConnectDetailState;
}
