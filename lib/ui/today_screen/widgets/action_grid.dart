import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/today_screen/sheets/add_sleep_update_sheet.dart';
import 'package:loving_brain/ui/today_screen/sheets/add_tantrums_update_sheet.dart';
import 'package:loving_brain/ui/today_screen/sheets/add_mood_update_sheet.dart';
import 'package:loving_brain/ui/today_screen/sheets/add_health_update_sheet.dart';
import 'package:loving_brain/ui/today_screen/sheets/add_notes_update_sheet.dart';

class ActionGrid extends StatelessWidget {
  const ActionGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 16.h,
      crossAxisSpacing: 16.w,
      children: [
        _ActionGridItem(
          iconPath: Assets.v2.images.imgSleep.path,
          title: "Sleep",
          onTap: () {
            showAddSleepUpdateSheet(context);
          },
        ),
        _ActionGridItem(
          iconPath: Assets.v2.images.imgTantrums.path,
          title: "Tantrums",
          onTap: () {
            showAddTantrumsUpdateSheet(context);
          },
        ),
        _ActionGridItem(
          iconPath: Assets.v2.images.imgMood.path,
          title: "Mood",
          onTap: () {
            showAddMoodUpdateSheet(context);
          },
        ),
        _ActionGridItem(
          iconPath: Assets.v2.images.imgHealth.path,
          title: "Health",
          onTap: () {
            showAddHealthUpdateSheet(context);
          },
        ),
        _ActionGridItem(
          iconPath: Assets.v2.images.imgNotes.path,
          title: "Notes",
          onTap: () {
            showAddNotesUpdateSheet(context);
          },
        ),
        _ActionGridItem(
          iconPath: Assets.v2.images.imgAskBrainy.path,
          title: "Ask Brainy",
          onTap: () {
            // showAskBrainySheet(context);
          },
        ),
      ],
    );
  }
}

class _ActionGridItem extends StatefulWidget {
  final String iconPath;
  final String title;
  final VoidCallback onTap;

  const _ActionGridItem({
    required this.iconPath,
    required this.title,
    required this.onTap,
  });

  @override
  State<_ActionGridItem> createState() => _ActionGridItemState();
}

class _ActionGridItemState extends State<_ActionGridItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        decoration: BoxDecoration(
          color: _isPressed ? indigoLight : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: _isPressed
                ? secondaryColor
                : Colors.grey.withValues(alpha: 0.1),
            width: _isPressed ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 36.h,
              width: 40.w,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(widget.iconPath),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            widget.title.appText(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: _isPressed ? Colors.blue : blackTextColor,
            ),
          ],
        ),
      ),
    );
  }
}
