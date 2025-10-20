import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loving_brain/model/api_result_status.dart';

import '../../model/invitation_model.dart';
import '../../repo/co_parent_repo.dart';

class DeepLinkManager {
  DeepLinkManager._internal();

  static final DeepLinkManager _instance = DeepLinkManager._internal();

  static DeepLinkManager get instance => _instance;

  final appLinks = AppLinks();

  StreamSubscription? appLinkStreamSubscription;

  void listenToLinks() {
    appLinkStreamSubscription?.cancel();
    appLinkStreamSubscription = appLinks.uriLinkStream.listen((uri) async {
      if (uri.path.isNotEmpty) {
        var invitationReferenceId = uri.toString().split("/").last;
        await CoParentRepo.instance.addUserAsCoParent(
          invitationReferenceId,
        );
      }
    });
  }

  void disposeListenToLinks() {
    appLinkStreamSubscription?.cancel();
  }
}
