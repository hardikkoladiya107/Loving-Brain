import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';

import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';

class PostpartumCalmScreen extends StatefulWidget {
  const PostpartumCalmScreen({super.key});

  @override
  State<PostpartumCalmScreen> createState() => _PostpartumCalmScreenState();
}

class _PostpartumCalmScreenState extends State<PostpartumCalmScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(Assets.images.imgPostPartumCalmMeditation.path),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            250.spaceH,
            _controllersItems(),
            30.spaceH,
            _description(),
            30.spaceH,
            _recommendedForYou(),
          ],
        ),
      ),
    );
  }

  Widget _controllersItems() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    "35 MIN".appText(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                    LocaleKeys.calmMeditation.tr().appText(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ],
                ),
                8.spaceH,
                LocaleKeys.nowPlaying.tr().appText(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 24,
                ),
                8.spaceH,
                "Meditator Name".appText(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ],
            ),
            Assets.icons.icMusicIcon.image(height: 65, width: 65),
          ],
        ),
        15.spaceH,
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 2,
            thumbColor: Colors.pink,
            thumbShape: RoundSliderThumbShape(
              enabledThumbRadius: 8.0,
              pressedElevation: 8,
            ),
            overlayShape: SliderComponentShape.noOverlay,
            trackShape: const RoundedRectSliderTrackShape(),
            activeTrackColor: Colors.pink,
          ),
          child: Slider(value: 1, max: 3, onChanged: (value) {}),
        ),
        8.spaceH,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            "01:03".appText(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            "03:03".appText(
              color: Colors.white,

              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ],
        ),
        20.spaceH,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Assets.icons.icRepeatIcon.image(height: 28, width: 28),
            Assets.icons.icLastPlayedIcon.image(height: 28, width: 28),
            Assets.icons.icPauseIcon.image(height: 28, width: 28),
            Assets.icons.icNextPlayIcon.image(height: 28, width: 28),
            Assets.icons.icShuffleIcon.image(height: 28, width: 28),
          ],
        ),
      ],
    ).appPadding(left: 30, right: 30);
  }

  Widget _description() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: LocaleKeys.paspartum_description
          .tr()
          .appText(color: yellowTextColor2, fontWeight: FontWeight.w600)
          .appPadding(all: 8),
    ).appPadding(left: 30, right: 30);
  }

  Widget _recommendedForYou() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            30.spaceW,
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.30),
                borderRadius: BorderRadius.circular(12),
              ),
              child: LocaleKeys.recommendedForYou
                  .tr()
                  .appText(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: Colors.white,
                  )
                  .appPadding(left: 4, right: 6, top: 4, bottom: 4),
            ),
          ],
        ),
        Row(children: []),
      ],
    );
  }
}
