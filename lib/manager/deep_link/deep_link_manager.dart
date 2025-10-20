import 'dart:async';

import 'package:app_links/app_links.dart';

class DeepLinkManager {
  DeepLinkManager._internal();

  static final DeepLinkManager _instance = DeepLinkManager._internal();

  static DeepLinkManager get instance => _instance;

  final appLinks = AppLinks();

  StreamSubscription? appLinkStreamSubscription;

  void listenToLinks() {
    appLinkStreamSubscription?.cancel();
    appLinkStreamSubscription = appLinks.uriLinkStream.listen((uri) {
      print(uri.path);
    });
  }

  void disposeListenToLinks() {
    appLinkStreamSubscription?.cancel();
  }
}
