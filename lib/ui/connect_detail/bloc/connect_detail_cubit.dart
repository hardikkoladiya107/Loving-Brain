
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/repo/prompts_repo.dart';
import 'connect_detail_state.dart';

class ConnectDetailCubit extends Cubit<ConnectDetailState> {
  ConnectDetailCubit() : super(const ConnectDetailState());

  final PromptsRepo _promptsRepo = PromptsRepo.instance;
  
  // Fallback prompts if online fails
  final List<String> _fallbackPrompts = [
    "Draw something that made you smile today.",
    "Draw your favorite place to play.",
    "Draw someone you love spending time with.",
  ];

  Future<void> init() async {
    emit(state.copyWith(isLoading: true));

    try {
      // 1. Fetch available prompts from Firestore
      final result = await _promptsRepo.getAllPrompts();
      
      if (result.status == Status.success && result.data != null && result.data!.isNotEmpty) {
        final allPrompts = result.data!;

        // 2. Fetch IDs of prompts seen in last 15 days
        final recentIds = await _promptsRepo.getRecentPromptIds(15);

        // 3. Filter available prompts
        final availablePrompts = allPrompts.where((p) => !recentIds.contains(p.id)).toList();

        // 4. Select a prompt
        if (availablePrompts.isNotEmpty) {
           // Pick random from available
           final random = Random();
           final selected = availablePrompts[random.nextInt(availablePrompts.length)];
           
           // Mark as seen
           await _promptsRepo.markPromptAsSeen(selected.id);
           
           emit(state.copyWith(
             isLoading: false,
             promptModel: selected,
             currentPrompt: selected.prompt, // Update legacy/display string
           ));
        } else {
          // If all prompts seen recently, resetting cycle or just pick random from all
          // "each prompt should be show once for 15 days" -> if user exhausts all, maybe pick oldest valid or just random.
          // Let's pick random from ALL to avoid empty state, even if 'rule' says don't show.
          // Better UX: Show random one rather than error.
           final random = Random();
           final selected = allPrompts[random.nextInt(allPrompts.length)];
           
            // Mark as seen (restart cycle for this one)
           await _promptsRepo.markPromptAsSeen(selected.id);

           emit(state.copyWith(
             isLoading: false,
             promptModel: selected,
             currentPrompt: selected.prompt,
           ));
        }

      } else {
        // Fallback to local
        _useFallback();
      }
    } catch (e) {
      _useFallback();
    }
  }

  void _useFallback() {
    final random = Random();
    final prompt = _fallbackPrompts[random.nextInt(_fallbackPrompts.length)];
    emit(state.copyWith(isLoading: false, currentPrompt: prompt));
  }

  void changeColor(Color color) {
    emit(state.copyWith(selectedColor: color));
  }

  void startStroke(Offset point) {
    final newStroke = DrawingStroke(
      points: [point],
      color: state.selectedColor,
      width: 5.0, // Default stroke width
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
}
