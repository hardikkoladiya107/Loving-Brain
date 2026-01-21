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
                      width: context.width,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
                SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _header(),
                      16.spaceH,
                      _playIdeaCard(),
                      16.spaceH,
                      _allPlayActivities(),
                      16.spaceH,
                      _yourPlanHistory(),
                      20.spaceH, // Bottom padding
                    ],
                  ),
                ),
                Positioned(
                  top: 50,
                  left: 20,
                  child: BaseButton(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Assets.icons.icBackIcon.image(height: 24, width: 24),
                    ),
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
        60.spaceH,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.6),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: "Play & Connect with Rohan".appText(
            fontWeight: FontWeight.w800,
            fontSize: 18,
            color: Colors.black87,
          ),
        ).appPadding(left: 20, right: 20),
        8.spaceH,
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.6),
            borderRadius: BorderRadius.circular(20),
          ),
          child:
              "Discover fun, personalized activities to\nfoster connection and development."
                  .appText(
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                    textAlign: TextAlign.left,
                    color: Colors.black54,
                  ),
        ),
      ],
    );
  }

  Widget _playIdeaCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(Assets.images.imgPlayIdeaCard.path),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Container(
          // Add a gradient overlay to ensure text readability if needed,
          // or just padding.
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LocaleKeys.todayPlayIdea.tr().appText(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          color: Colors.black54,
                        ),
                        2.spaceH,
                        "The 20-Second Hug".appText(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          color: blueColor,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 14,
                          color: Colors.red.shade400,
                        ),
                        4.spaceW,
                        "20 sec".appText(
                          color: Colors.red.shade600,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              12.spaceH,
              LocaleKeys.aSimplePowerfulHugDeepenConnectionAndCalm.tr().appText(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              16.spaceH,
              _startActivity(),
              12.spaceH,
              _getCustomPlayIdea(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _startActivity() {
    return BaseButton(
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.icons.icHeartIcon.image(height: 20, width: 20),
            8.spaceW,
            LocaleKeys.startActivity.tr().appText(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: Colors.black87,
            ),
          ],
        ),
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
        height: 44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [yellowButtonStartColor, yellowButtonEndColor],
          ),
          boxShadow: [
            BoxShadow(
              color: yellowButtonStartColor.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            "Get a Custom Play Idea".appText(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: Colors.white,
            ),
            8.spaceW,
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Colors.white,
            ),
          ],
        ),
      ),
      onTap: () {},
    );
  }

  Widget _allPlayActivities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: "All Play Activities".appText(
            color: redColor,
            fontWeight: FontWeight.w800,
            fontSize: 15,
          ),
        ),
        10.spaceH,
        ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _activityItem(
              color: Colors.pink.withOpacity(0.08),
              title: LocaleKeys.musicalMovementDance.tr(),
              description: LocaleKeys.yourParagraphText.tr(),
              titleColor: cardColor2,
              icon: Assets.icons.icMusicalMovementAndDanceIcon,
            ),
            10.spaceH,
            _activityItem(
              color: Colors.blue.withOpacity(0.08),
              title: LocaleKeys.animalWalkChallenge.tr(),
              description: LocaleKeys
                  .crawlHopAndStompLikeAnimalsMoveLaughAndPlayTogether
                  .tr(),
              titleColor: blueColor,
              icon: Assets.icons.icAnimalWalkChallengeIcon,
            ),
            10.spaceH,
            _activityItem(
              color: Colors.orange.withOpacity(0.08),
              title: LocaleKeys.storyBuilderDiceCards.tr(),
              description: LocaleKeys
                  .pickPromptBuildFunStoryTogetherImagineCreateConnect
                  .tr(),
              titleColor: orangeColor,
              icon: Assets.icons.icStoryBuilderDice,
            ),
          ],
        ),
      ],
    );
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {}, // Add onTap if needed
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 70,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(18),
                      bottomLeft: Radius.circular(18),
                    ),
                  ),
                  child: icon.image(width: 30, height: 30),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        title.appText(
                          fontWeight: FontWeight.w700,
                          color: titleColor,
                          fontSize: 13,
                        ),
                        2.spaceH,
                        description.appText(
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                          textAlign: TextAlign.start, 
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _yourPlanHistory() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          10.spaceH,
          Row(
            children: [
              20.spaceW,
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Assets.icons.icPlayHistoryIcon.image(
                  width: 18,
                  height: 18,
                ),
              ),
              10.spaceW,
              "Your Play History".appText(
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ],
          ),
          6.spaceH,
          _historyItem(),
          _historyItem(),
          _historyItem(showBorder: false),
          6.spaceH,
        ],
      ),
    );
  }

  Widget _historyItem({bool showBorder = true}) {
    return Column(
      children: [
        8.spaceH,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            "Musical Movement & Dance".appText(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: "30/01/2025".appText(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ).appPadding(left: 20, right: 20),
        8.spaceH,
        if (showBorder)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: DashedDivider(
              color: Colors.grey.withOpacity(0.3),
              dashWidth: 4,
              dashSpace: 3,
            ),
          ),
      ],
    );
  }
}
