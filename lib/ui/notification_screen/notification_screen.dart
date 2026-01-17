import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Widget _appBar() {
      return Row(
        children: [
          20.spaceW,
          BaseButton(
            child: Assets.icons.icBackIcon.image(
              height: 36,
              width: 36,
              color: Colors.black.withValues(alpha: 0.8),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          12.w.spaceW,
          "Notifications".appText(fontWeight: FontWeight.w700),
        ],
      );
    }

    return Scaffold(
      // backgroundColor: Colors.white,
      body: Column(
        children: [
          40.spaceH,
          _appBar(),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              shrinkWrap: true,

              itemBuilder: (context, index) => ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications,
                    size: 22,
                    color: Colors.blue,
                  ),
                ),
                title: "test".appText(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: "description".appText(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: Colors.grey.shade400,
                  size: 20,
                ),
                tileColor: Colors.white,
              ).appPadding(left: 16, right: 16, bottom: 8, top: 8),
            ),
          ),
        ],
      ),
    );
  }
}
