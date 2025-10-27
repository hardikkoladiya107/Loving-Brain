import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/play_and_connect/bloc/play_and_connect_cubit.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../other/app_color.dart';
import '../../other/dashed_divider.dart';
import '../activity/activity_screen.dart';
import 'bloc/play_and_connect_state.dart';

class PlayAndConnectScreen extends StatefulWidget {
  const PlayAndConnectScreen({super.key});

  @override
  State<PlayAndConnectScreen> createState() => _PlayAndConnectScreenState();
}

class _PlayAndConnectScreenState extends State<PlayAndConnectScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<PlayAndConnectCubit>().init();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlayAndConnectCubit, PlayAndConnectState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  children: [
                    Assets.images.imgPlayAndConnectBg.image(
                      height: context.height,
                      width: context.height,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _header(),
                    20.spaceH,
                    _playIdeaCard(),
                    10.spaceH,
                    _allPlayActivities(),
                    10.spaceH,
                    _yourPlanHistory(),
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
      },
      listener: (context, state) {},
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        80.spaceH,
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: "Play & Connect with Rohan"
              .appText(fontWeight: FontWeight.w800, fontSize: 20)
              .appPadding(left: 10, top: 5, bottom: 5, right: 10),
        ).appPadding(left: 20),
        4.spaceH,
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child:
              "Discover fun, personalized activities to\nfoster connection and development."
                  .appText(
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                    textAlign: TextAlign.left,
                  )
                  .appPadding(left: 10, top: 5, bottom: 5, right: 10),
        ).appPadding(left: 20),
      ],
    );
  }

  Widget _playIdeaCard() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(Assets.images.imgPlayIdeaCard.path),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          10.spaceH,
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LocaleKeys.todayPlayIdea.tr().appText(
                      fontWeight: FontWeight.w700,
                    ),
                    "The 20-Second Hug".appText(
                      fontWeight: FontWeight.w700,
                      color: blueColor,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Icon(Icons.access_time_rounded, size: 22),
                  2.spaceW,
                  "20 sec".appText(
                    color: Colors.red.shade600,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                  8.spaceW,
                ],
              ),
            ],
          ),
          10.spaceH,
          LocaleKeys.aSimplePowerfulHugDeepenConnectionAndCalm.tr().appText(
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
          10.spaceH,
          _startActivity(),
          10.spaceH,
          _getCustomPlayIdea(),
        ],
      ).appPadding(left: 20, right: 20),
    ).appPadding(left: 20, right: 20);
  }

  Widget _startActivity() {
    return BaseButton(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.icons.icHeartIcon.image(height: 24, width: 24),
            20.spaceW,
            LocaleKeys.startActivity.tr().appText(fontWeight: FontWeight.w700),
          ],
        ).appPadding(top: 4, bottom: 4),
      ),
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const ActivityScreen()));
      },
    );
  }

  Widget _getCustomPlayIdea() {
    return BaseButton(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [yellowButtonStartColor, yellowButtonEndColor],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            "Get a Custom Play Idea".appText(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            20.spaceW,
            Icon(Icons.arrow_forward_ios, size: 18, color: Colors.white),
          ],
        ).appPadding(top: 4, bottom: 4),
      ),
      onTap: () {},
    );
  }

  Widget _allPlayActivities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        "All Play Activities".appText(
          color: redColor,
          fontWeight: FontWeight.w700,
        ),
        10.spaceH,
        _activityItem(
          color: Colors.pink.withValues(alpha: 0.2),
          title: LocaleKeys.musicalMovementDance.tr(),
          description: LocaleKeys.yourParagraphText.tr(),
          titleColor: cardColor2,
          icon: Assets.icons.icMusicalMovementAndDanceIcon,
        ),
        10.spaceH,
        _activityItem(
          color: Colors.pink.withValues(alpha: 0.2),
          title: LocaleKeys.animalWalkChallenge.tr(),
          description: LocaleKeys
              .crawlHopAndStompLikeAnimalsMoveLaughAndPlayTogether
              .tr(),
          titleColor: blueColor,
          icon: Assets.icons.icAnimalWalkChallengeIcon,
        ),
        10.spaceH,
        _activityItem(
          color: Colors.pink.withValues(alpha: 0.2),
          title: LocaleKeys.storyBuilderDiceCards.tr(),
          description: LocaleKeys
              .pickPromptBuildFunStoryTogetherImagineCreateConnect
              .tr(),
          titleColor: orangeColor,
          icon: Assets.icons.icStoryBuilderDice,
        ),
      ],
    ).appPadding(left: 20, right: 20);
  }

  Widget _activityItem({
    required AssetGenImage icon,
    required Color color,
    required Color titleColor,
    required String title,
    required String description,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          10.spaceW,
          icon.image(width: 35, height: 35),
          12.spaceW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title.appText(
                  fontWeight: FontWeight.w700,
                  color: titleColor,
                  fontSize: 14,
                ),
                description.appText(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ],
      ).appPadding(all: 8),
    );
  }

  Widget _yourPlanHistory() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          10.spaceH,
          Row(
            children: [
              20.spaceW,
              Assets.icons.icPlayHistoryIcon.image(),
              10.spaceW,
              "Your Play History".appText(fontWeight: FontWeight.w700),
            ],
          ),
          10.spaceH,
          _historyItem(),
          _historyItem(),
          _historyItem(showBorder: false),
        ],
      ),
    ).appPadding(left: 20, right: 20);
  }

  Widget _historyItem({bool showBorder = true}) {
    return Column(
      children: [
        10.spaceH,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            "Musical Movement & Dance".appText(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            "30/01/2025".appText(fontSize: 12),
          ],
        ),
        12.spaceH,
        if (showBorder)
          DashedDivider(color: Colors.black, dashWidth: 8, dashSpace: 4),
      ],
    ).appPadding(left: 20, right: 20);
  }
}
