import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:loving_brain/main.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/repo/child_repo.dart';
import 'package:loving_brain/repo/user_repo.dart';
import 'package:loving_brain/ui/success_screen/success_screen.dart';

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
        ApiResultStatus addUserAsCoParentApiResultStatus = await CoParentRepo
            .instance
            .addUserAsCoParent(invitationReferenceId);
        showSuccessMessage(addUserAsCoParentApiResultStatus);
      }
    });
  }

  void disposeListenToLinks() {
    appLinkStreamSubscription?.cancel();
  }

  void showSuccessMessage(ApiResultStatus addUserAsCoParentApiResultStatus) {
    addUserAsCoParentApiResultStatus.whenOrNull(
      data: (data) async {
        if (data is InvitationModel) {
          UserModel? fromParent = await UserRepo.instance.getUserFromEmail(
            email: data.fromParent ?? "",
          );
          final String rawChildren = (data.children ?? "").trim();
          final List<String> childIds = rawChildren.isEmpty
              ? <String>[]
              : rawChildren
                    .split(',')
                    .map((String e) => e.trim())
                    .where((String e) => e.isNotEmpty)
                    .toSet()
                    .toList();
          final ApiResultStatus childApiResult = await ChildRepo.instance
              .getChildren(childrenIds: childIds);
          childApiResult.whenOrNull(
            data: (data) {
              if (data is List<ChildModel>) {
                if (data.isNotEmpty) {
                  ChildModel child = data[0];
                  if (fromParent != null &&
                      navigatorKey.currentContext != null) {
                    Navigator.of(navigatorKey.currentContext!).push(
                      MaterialPageRoute(
                        builder: (context) => SucessScreen(
                          successText:
                              "You’ve successfully accepted ${fromParent.parentName ?? fromParent.displayName}’s invitation to be a co-parent of ${child.childName}.",
                        ),
                      ),
                    );
                  }
                }
              }
            },
          );
        }
      },
    );
  }
}
