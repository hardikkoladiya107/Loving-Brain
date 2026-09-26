import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/app_button.dart';

void showViewSupportSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xFFF7F7F7),
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height * 0.7,
    ),
    builder: (context) => const ViewSupportSheet(),
  );
}

class ViewSupportSheet extends StatelessWidget {
  const ViewSupportSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 2,
                width: 80.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: greyColor7,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              Container(
                height: 180.h,
                width: 190.w,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(Assets.v2.images.imgLuma.path),
                  ),
                ),
              ).appPadding(top: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Column(
                  children: [
                    "A guided sleep journey may help".appText(
                      fontSize: 28.sp,
                      fraunces: true,
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 8.h),
                    "Sleep has been inconsistent for 9 days · a guided sleep journey may help you build a more consistent routine."
                        .appText(
                          fontSize: 12.sp,
                          color: greyColor6,
                          height: 1.4,
                          textAlign: TextAlign.start,
                        ),
                  ],
                ).appPadding(all: 16),
              ).appPadding(all: 16),
              12.spaceH,
              AppButton(title: "View support", onTap: () {}),
              12.spaceH,
              AppButton(
                title: "Join waitlist",
                onTap: () {},
                backgroundColor: Colors.white,
                textColor: greyColor9,
              ),
              AppButton(
                title: "Not now",
                onTap: () {},
                backgroundColor: Colors.transparent,
                textColor: greyColor8,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
