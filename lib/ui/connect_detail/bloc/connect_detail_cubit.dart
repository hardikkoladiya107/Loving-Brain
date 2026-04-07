import 'dart:math';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/journal_model.dart';
import 'package:loving_brain/model/prompt_model.dart';
import 'package:loving_brain/repo/mood_repo.dart';
import 'package:loving_brain/repo/prompts_repo.dart';
import 'package:loving_brain/repo/user_repo.dart';
import 'connect_detail_state.dart';

class ConnectDetailCubit extends Cubit<ConnectDetailState> {
  ConnectDetailCubit() : super(const ConnectDetailState());

  final List<String> _fallbackPrompts = [
    "Draw something that made you smile today.",
    "Draw your favorite place to play.",
    "Draw someone you love spending time with.",
  ];

  void changeProps({
    String? currentPrompt,
    PromptModel? promptModel,
    Color? selectedColor,
    List<DrawingStroke>? allStrokes,
    DrawingStroke? currentStroke,
    ApiResultStatus? getPromptApiResultStatus,
    ApiResultStatus? saveDrawingApiResultStatus,
  }) {
    emit(
      state.copyWith(
        currentPrompt: currentPrompt ?? state.currentPrompt,
        promptModel: promptModel ?? state.promptModel,
        selectedColor: selectedColor ?? state.selectedColor,
        allStrokes: allStrokes ?? state.allStrokes,
        currentStroke: currentStroke ?? state.currentStroke,
        getPromptApiResultStatus:
            getPromptApiResultStatus ?? state.getPromptApiResultStatus,
        saveDrawingApiResultStatus:
            saveDrawingApiResultStatus ?? state.saveDrawingApiResultStatus,
      ),
    );
  }

  Future<void> init() async {
    emit(ConnectDetailState());
    _fetchAllPrompts();
  }

  Future<void> _fetchAllPrompts() async {
    try {
      changeProps(getPromptApiResultStatus: ApiResultStatus.loading());
      final getAllPromptsApiResultStatus = await PromptsRepo.instance
          .getAllPrompts();
      changeProps(getPromptApiResultStatus: getAllPromptsApiResultStatus);
      getAllPromptsApiResultStatus.whenOrNull(
        data: (data) {
          _handleSuccess(data);
        },
        error: (error) {
          _useFallback();
        },
      );
    } catch (e) {
      debugPrint("Error fetching prompts: $e");
      _useFallback();
    }
  }

  Future<void> _handleSuccess(List<PromptModel> allPrompts) async {
    try {
      PromptModel? selected;

      // 2a. Check if we already have a prompt for today
      final todayPromptId = await PromptsRepo.instance
          .getLastSeenPromptIdSinceToday();
      if (todayPromptId != null) {
        // Find it in the list
        try {
          selected = allPrompts.firstWhere((p) => p.id == todayPromptId);
        } catch (_) {
          // If for some reason the ID from history isn't in allPrompts (deleted?), fallback
          selected = null;
        }
      }

      if (selected == null) {
        // 2b. If no prompt for today, pick a new one
        // Fetch IDs of prompts seen in last 15 days
        final recentIds = await PromptsRepo.instance.getRecentPromptIds(15);

        final availablePrompts = allPrompts
            .where((p) => !recentIds.contains(p.id))
            .toList();

        if (availablePrompts.isNotEmpty) {
          selected =
              availablePrompts[Random().nextInt(availablePrompts.length)];
        } else {
          selected = allPrompts[Random().nextInt(allPrompts.length)];
        }

        // Mark as seen for today
        await PromptsRepo.instance.markPromptAsSeen(selected.id);
      }

      changeProps(promptModel: selected, currentPrompt: selected.prompt);
    } catch (e) {
      debugPrint("Error in prompt selection logic: $e");
      _useFallback();
    }
  }

  void _useFallback() {
    final random = Random();
    final promptText =
        _fallbackPrompts[random.nextInt(_fallbackPrompts.length)];
    final fallbackModel = PromptModel(
      id: 'fallback_${DateTime.now().millisecondsSinceEpoch}',
      prompt: promptText,
      hint1: "Think about happy moments",
      hint2: "Use bright colors!",
    );
    changeProps(currentPrompt: promptText, promptModel: fallbackModel);
  }

  void startStroke(Offset point) {
    final newStroke = DrawingStroke(
      points: [point],
      color: state.selectedColor,
      width: 5.0,
    );
    emit(state.copyWith(currentStroke: newStroke));
  }

  void updateStroke(Offset point) {
    if (state.currentStroke != null) {
      final updatedPoints = List<Offset>.from(state.currentStroke!.points)
        ..add(point);
      final updatedStroke = DrawingStroke(
        points: updatedPoints,
        color: state.currentStroke!.color,
        width: state.currentStroke!.width,
      );
      emit(state.copyWith(currentStroke: updatedStroke));
    }
  }

  void endStroke() {
    if (state.currentStroke != null) {
      final updatedAllStrokes = List<DrawingStroke>.from(state.allStrokes)
        ..add(state.currentStroke!);
      emit(state.copyWith(allStrokes: updatedAllStrokes, currentStroke: null));
    }
  }

  void clearCanvas() {
    emit(state.copyWith(allStrokes: [], currentStroke: null));
  }

  void undoLastStroke() {
    if (state.allStrokes.isNotEmpty) {
      final updatedStrokes = List<DrawingStroke>.from(state.allStrokes);
      updatedStrokes.removeLast();
      emit(state.copyWith(allStrokes: updatedStrokes));
    }
  }

  Future<void> saveDrawing(Uint8List bytes) async {
    try {
      changeProps(saveDrawingApiResultStatus: ApiResultStatus.loading());
      final refId = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = FirebaseStorage.instance
          .ref()
          .child('journal_images')
          .child('$refId.png');
      final metadata = SettableMetadata(
        contentType: 'image/png',
        customMetadata: {'picked-file-path': 'canvas_drawing'},
      );
      await ref.putData(bytes, metadata);
      final downloadUrl = await ref.getDownloadURL();
      final journal = JournalModel(
        thoughtText: "Drawing Entry",
        logTime: DateTime.now(),
        imageUrl: downloadUrl,
        prompt: state.currentPrompt,
        hint1: state.promptModel?.hint1 ?? "",
        hint2: state.promptModel?.hint2 ?? "",
      );
      final result = await MoodRepo.instance.addJournal(
        request: journal.toJson(),
      );
      
      // Update streak on successful save
      result.whenOrNull(
        data: (data) async {
           await UserRepo.instance.updateUserStreak();
        },
      );

      changeProps(saveDrawingApiResultStatus: result);
      result.whenOrNull(
        data: (data) {
          clearCanvas();
        },
      );
    } on Exception catch (e) {
      debugPrint("Error saving drawing: $e");
      changeProps(saveDrawingApiResultStatus: ApiResultStatus.error(error: e));
    }
  }
}

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
