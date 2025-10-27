import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';

class ModuleScreen extends StatefulWidget {
  const ModuleScreen({super.key});

  @override
  State<ModuleScreen> createState() => _ModuleScreenState();
}

class _ModuleScreenState extends State<ModuleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                Assets.images.imgModulesScreenBg.image(
                  height: context.height,
                  width: context.width,
                ),
                SizedBox(height: context.height / 2, width: context.width),
              ],
            ),
            Column(
              children: [
                250.spaceH,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LocaleKeys.modules.tr().appText(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ],
                ),
                LocaleKeys.moduleDescription.tr().appText(
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
                12.spaceH,
                _moduleCard(
                  bgImage: Assets.images.imgModuleCardBg1,
                  title: LocaleKeys.sleep.tr(),
                  description: LocaleKeys.sleepDescription.tr(),
                ),
                8.spaceH,
                _moduleCard(
                  bgImage: Assets.images.imgModuleCardBg2,
                  title: LocaleKeys.postpartumCalmConnection.tr(),
                  description: LocaleKeys.postpartumCalmConnectionDescription
                      .tr(),
                ),
                8.spaceH,
                _moduleCard(
                  bgImage: Assets.images.imgModuleCardBg3,
                  title: LocaleKeys.toddlerEmotionalUnderstanding.tr(),
                  description: LocaleKeys.forParents1To3YearsOld.tr(),
                ),
                8.spaceH,
                _moduleCard(
                  bgImage: Assets.images.imgModuleCardBg4,
                  title: LocaleKeys.buildingFamilyConnection.tr(),
                  description: LocaleKeys.strengthenBondsCommunication.tr(),
                ),
                8.spaceH,
                LocaleKeys.unlockMoreInDepthCourses
                    .tr()
                    .appText(fontSize: 10)
                    .appPadding(left: 20, right: 20),
              ],
            ),
            Positioned(
              top: 60,
              left: 20,
              child: BaseButton(
                child: Assets.icons.icBackIcon.image(height: 36, width: 36),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _moduleCard({
    required AssetGenImage bgImage,
    required String title,
    required String description,
  }) {
    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(bgImage.path),
        ),
      ),
      child: Column(
        children: [
          8.spaceH,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              title.appText(fontWeight: FontWeight.w900, fontSize: 14),
            ],
          ),
          8.spaceH,
          description.appText(fontSize: 10, fontWeight: FontWeight.w600),
        ],
      ),
    ).appPadding(left: 30, right: 30);
  }
}
