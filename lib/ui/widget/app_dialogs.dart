import 'package:flutter/material.dart';

import '../../main.dart';

enum DialogAnimation { UpDown, Bounce }

void showAppDialog({
  DialogAnimation animation = DialogAnimation.UpDown,
  required Widget Function(BuildContext context) child,
}) {
  if (navigatorKey.currentContext != null) {
    showGeneralDialog(
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionBuilder: (context, a1, a2, widget) {
        if (animation == DialogAnimation.Bounce) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(opacity: a1.value, child: widget),
          );
        }

        final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
          child: Opacity(opacity: a1.value, child: widget),
        );
      },
      transitionDuration: Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      context: navigatorKey.currentContext!,
      pageBuilder: (context, animation1, animation2) {
        return child(context);
      },
    );
  }
}
