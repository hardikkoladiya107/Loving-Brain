import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import 'connectivity_screen.dart';

final connectivityManager = ConnectivityManager();

class ConnectivityManager {
  static final ConnectivityManager _instance = ConnectivityManager._internal();

  factory ConnectivityManager() => _instance;

  ConnectivityManager._internal();

  StreamSubscription<List<ConnectivityResult>>? connectivitySubscription;

  bool connectivityDialogVisible = false;

  void initConnectivity() {
    (Connectivity().checkConnectivity()).then((value) {
      if (value.any((element) => element == ConnectivityResult.none)) {
        if (connectivityDialogVisible && navigatorKey.currentContext != null) {
          showPersistentDialog();
        }
      }
    });
    connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> result,
    ) {
      if (result.any((element) => element == ConnectivityResult.none)) {
        showPersistentDialog();
      } else {
        if (connectivityDialogVisible && navigatorKey.currentContext != null) {
          hidePersistentDialog();
        }
      }
    });
  }

  OverlayEntry? _overlayEntry;

  void showPersistentDialog() {
    if (navigatorKey.currentContext != null) {
      if (_overlayEntry != null) return;
      _overlayEntry = OverlayEntry(
        builder:
            (context) => Stack(
              children: [
                Positioned.fill(
                  child: Material(
                    color: Colors.black54, // Background effect
                    child: Center(
                      child: Dialog.fullscreen(
                        backgroundColor: Colors.transparent,
                        child: ConnectivityScreen(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
      );
      connectivityDialogVisible = true;
      Overlay.of(navigatorKey.currentContext!).insert(_overlayEntry!);
    }
  }

  void hidePersistentDialog() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    connectivityDialogVisible = false;
  }
}
