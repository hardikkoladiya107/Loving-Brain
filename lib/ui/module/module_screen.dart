import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_extentions.dart';

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
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(Assets.images.imgModulesScreenBg.path),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
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
