import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/app_text_field.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../other/app_color.dart';
import 'bloc/write_your_thought_cubit.dart';
import 'bloc/write_your_thought_state.dart';

class WriteYourThoughtScreen extends StatefulWidget {
  const WriteYourThoughtScreen({super.key});

  @override
  State<WriteYourThoughtScreen> createState() => _WriteYourThoughtScreenState();
}

class _WriteYourThoughtScreenState extends State<WriteYourThoughtScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WriteYourThoughtCubit, WriteYourThoughtState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(Assets.images.imgWriteYourThoughtBg.path),
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  130.spaceH,
                  _header(),
                  20.spaceH,
                  _description(),
                  40.spaceH,
                  _typeYourThoughtsHere(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BaseButton(
                        onTap: () {},
                        child: Container(
                          width: 150.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: yellowColor3,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: LocaleKeys.saveEntry.tr().appText(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),

                      BaseButton(
                        onTap: () {},
                        child: Container(
                          width: 150.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: yellowColor3,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: LocaleKeys.getAIReflection.tr().appText(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ).appPadding(left: 20, right: 20),
                  16.spaceH,
                  LocaleKeys.yourPastEntries
                      .tr()
                      .appText(fontWeight: FontWeight.w800)
                      .appPadding(left: 20),
                  16.spaceH,
                  _pastEntry(color: Colors.pink),
                  10.spaceH,
                  _pastEntry(color: Colors.green),
                ],
              ),
            ),
          ),
        );
      },
      listener: (context, state) {},
    );
    return Scaffold();
  }

  Widget _header() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: LocaleKeys.writeYourThoughts
          .tr()
          .appText(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          )
          .appPadding(left: 10, right: 10, top: 6, bottom: 6),
    );
  }

  Widget _description() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20),
      ),
      child:
          "${LocaleKeys.hi.tr()}, ${LocaleKeys.howYourHeartTodayTakeMomentReflect.tr()}"
              .appText(fontSize: 9, fontWeight: FontWeight.w800)
              .appPadding(left: 10, right: 10, top: 6, bottom: 6),
    ).appPadding(left: 16, right: 16);
  }

  Widget _typeYourThoughtsHere() {
    return AppTextField(
      fillColor: Colors.grey.withValues(alpha: 0.4),
      filled: true,
      minLines: 5,
      contentPadding: EdgeInsets.only(top: 16, left: 16),
      hintStyle: getTextStyle(fontWeight: FontWeight.w600, fontSize: 12),
      hint: LocaleKeys.typeYourThoughtsHere.tr(),
    ).appPadding(left: 20, right: 20);
  }

  Widget _pastEntry({required Color color}) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          8.spaceH,
          "July 27, 2025".appText(fontWeight: FontWeight.w700, fontSize: 11),
          6.spaceH,
          "Rohan had a tough day with transitions, but we managed with some deep breaths. Feeling a bit drained but proud."
              .appText(
                fontWeight: FontWeight.w600,
                fontSize: 11,
                textAlign: TextAlign.start,
              ),
          8.spaceH,
          "\"Parenting is not about perfection, but connection.\"".appText(
            fontWeight: FontWeight.w800,
            fontSize: 11,
            textAlign: TextAlign.center,
          ),
          8.spaceH,
        ],
      ).appPadding(left: 10.w, right: 10.w),
    ).appPadding(left: 20.w, right: 20.w);
  }
}
