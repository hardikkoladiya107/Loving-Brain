import 'package:flutter/material.dart';

enum ChildState { calm, highEnergy, fussy, tired }

extension ChildStateExtension on ChildState {
  String get key {
    switch (this) {
      case ChildState.calm:
        return 'calm';
      case ChildState.highEnergy:
        return 'high_energy';
      case ChildState.fussy:
        return 'fussy';
      case ChildState.tired:
        return 'tired';
    }
  }

  String get label {
    switch (this) {
      case ChildState.calm:
        return 'Calm';
      case ChildState.highEnergy:
        return 'High Energy';
      case ChildState.fussy:
        return 'Fussy';
      case ChildState.tired:
        return 'Tired';
    }
  }

  String get emoji {
    switch (this) {
      case ChildState.calm:
        return '🍃';
      case ChildState.highEnergy:
        return '⚡';
      case ChildState.fussy:
        return '🌧';
      case ChildState.tired:
        return '🌙';
    }
  }

  /// One-line Family Meter insight (Task 1). Use [insightTextFor] for child name.
  String insightTextFor(String childName) {
    final String name = childName.trim().isEmpty
        ? 'your child'
        : childName.trim();
    switch (this) {
      case ChildState.calm:
        return 'Good window for connection';
      case ChildState.highEnergy:
        return 'Energy running high — great for active play';
      case ChildState.fussy:
        return '$name needs some support right now';
      case ChildState.tired:
        return 'Wind-down time — sleep may be coming';
    }
  }

  String get explanationText {
    switch (this) {
      case ChildState.calm:
        return 'Your child has been calm for a while. Energy usually shifts after this period.';
      case ChildState.highEnergy:
        return 'Your child is highly active right now. The Energy Bridge timer has been started to help you transition smoothly.';
      case ChildState.fussy:
        return 'Your child seems unsettled. Try connecting with comfort — a hug or quiet activity often helps.';
      case ChildState.tired:
        return 'Your child is winding down. Sleep may be coming soon — keep things quiet and calm.';
    }
  }

  Color get color {
    switch (this) {
      case ChildState.calm:
        return const Color(0xFF2ECC71);
      case ChildState.highEnergy:
        return const Color(0xFFFF914D);
      case ChildState.fussy:
        return const Color(0xFF5271FF);
      case ChildState.tired:
        return const Color(0xFF894BCD);
    }
  }

  Color get lightColor {
    switch (this) {
      case ChildState.calm:
        return const Color(0xFFE8F8F0);
      case ChildState.highEnergy:
        return const Color(0xFFFFF3EB);
      case ChildState.fussy:
        return const Color(0xFFEEF1FF);
      case ChildState.tired:
        return const Color(0xFFF3ECFA);
    }
  }

  static ChildState? fromKey(String? key) {
    switch (key) {
      case 'calm':
        return ChildState.calm;
      case 'high_energy':
        return ChildState.highEnergy;
      case 'fussy':
        return ChildState.fussy;
      case 'tired':
        return ChildState.tired;
      default:
        return null;
    }
  }
}
