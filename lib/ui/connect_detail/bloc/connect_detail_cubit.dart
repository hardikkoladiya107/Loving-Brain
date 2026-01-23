import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'connect_detail_state.dart';

class ConnectDetailCubit extends Cubit<ConnectDetailState> {
  ConnectDetailCubit() : super(const ConnectDetailState());

  final List<String> _prompts = [
    "Draw something that made you smile today.",
    "Draw your favorite place to play.",
    "Draw someone you love spending time with.",
    "Draw something that makes you feel happy.",
    "Draw something that helps you feel calm.",
    "Draw your favorite toy or game.",
    "Draw what you like to do when it rains.",
    "Draw something that makes you laugh.",
    "Draw your favorite color as a feeling.",
    "Draw your favorite food.",
    "Draw something you are thankful for.",
    "Draw a place where you feel safe.",
    "Draw something that made you proud today.",
    "Draw your favorite family moment.",
    "Draw something that helps you relax.",
  ];

  void init() {
    final random = Random();
    final prompt = _prompts[random.nextInt(_prompts.length)];
    emit(state.copyWith(currentPrompt: prompt));
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
