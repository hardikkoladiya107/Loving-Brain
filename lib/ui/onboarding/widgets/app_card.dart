import 'package:flutter/material.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/onboarding/widgets/info_chip.dart';

class AppCard extends StatelessWidget {
  const AppCard({super.key, required this.chipTitle, required this.title});
  final String chipTitle;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white,
      ),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoChip(chipTitle: chipTitle),
          12.spaceH,
          title.appText(
            fontSize: 22,
            color: greyColor9,
            textAlign: TextAlign.start,
            fraunces: true,
          ),
          8.spaceH,
          title.appText(
            fontSize: 16,
            color: greyColor6,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}
