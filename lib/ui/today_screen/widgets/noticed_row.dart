import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/onboarding/widgets/info_chip.dart';
import 'package:loving_brain/ui/behaviour_pattern/behaviour_pattern_screen.dart';
import 'package:loving_brain/ui/calm_heads_up/calm_heads_up_screen.dart';

class NoticedRow extends StatelessWidget {
  const NoticedRow({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 330.h,
      child: Row(
        spacing: 12,
        children: [
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: Ink(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20.r),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CalmHeadsUpScreen(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 160.h,
                          width: 160.w,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                Assets.v2.images.imgHeadsUp.path,
                              ),
                            ),
                          ),
                        ),
                        20.spaceH,
                        const InfoChip(chipTitle: "Heads-up"),
                        20.spaceH,
                        "A harder window may be more likely tonight".appText(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: Ink(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20.r),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BehaviourPatternScreen(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const InfoChip(chipTitle: "Noticed"),
                        10.h.spaceH,
                        SizedBox(width: 12.h),
                        "Naps have been 20 minutes shorter this week".appText(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.start,
                        ),
                        6.h.spaceH,
                        Container(
                          height: 150.w,
                          width: 150.w,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                Assets.v2.images.imgNoticed.path,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
