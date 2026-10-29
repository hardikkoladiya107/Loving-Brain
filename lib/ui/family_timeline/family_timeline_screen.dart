import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:loving_brain/model/timeline_event_model.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';

import 'bloc/family_timeline_cubit.dart';
import 'bloc/family_timeline_state.dart';

class FamilyTimelineScreen extends StatefulWidget {
  const FamilyTimelineScreen({super.key});

  @override
  State<FamilyTimelineScreen> createState() => _FamilyTimelineScreenState();
}

class _FamilyTimelineScreenState extends State<FamilyTimelineScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FamilyTimelineCubit>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FamilyTimelineCubit, FamilyTimelineState>(
      listener: (BuildContext context, FamilyTimelineState state) {},
      builder: (BuildContext context, FamilyTimelineState state) {
        return Scaffold(
          backgroundColor: const Color(0xFFFEF8F4),
          body: Stack(
            children: [
              // Top Left Glow
              Positioned(
                left: -150,
                top: -150,
                child: Container(
                  width: 400.w,
                  height: 400.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFFFD4C8).withValues(alpha: 0.8),
                        const Color(0xFFFFD4C8).withValues(alpha: 0.0),
                      ],
                      stops: const [0.0, 1.0],
                    ),
                  ),
                ),
              ),
              SafeArea(
                bottom: false,
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  children: [
                    16.spaceH,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Material(
                        color: Colors.transparent,
                        child: Ink(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(24.r),
                            onTap: () {
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Icon(
                                Icons.arrow_back,
                                color: darkBlue,
                                size: 24.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    24.spaceH,
                    'Family timeline'.appText(
                      fontSize: 28.sp,
                      color: greyColor9,
                      fraunces: true,
                      textAlign: TextAlign.start,
                    ),
                    24.spaceH,
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip('All', state),
                          8.spaceW,
                          _buildFilterChip('Sleep', state),
                          8.spaceW,
                          _buildFilterChip('Behaviour', state),
                          8.spaceW,
                          _buildFilterChip('Notes', state),
                          8.spaceW,
                          _buildFilterChip('Mentorship', state),
                        ],
                      ),
                    ),
                    24.spaceH,
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 28.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: state.filteredEvents.isEmpty
                          ? Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 32.h),
                                child: 'No events found for this filter.'
                                    .appText(fontSize: 14.sp, color: greyColor),
                              ),
                            )
                          : Column(
                              children: [
                                ...state.filteredEvents.asMap().entries.map((
                                  MapEntry<int, TimelineEventModel> entry,
                                ) {
                                  final int idx = entry.key;
                                  final TimelineEventModel event = entry.value;
                                  return _buildTimelineItem(
                                    event: event,
                                    isFirst: idx == 0,
                                    isLast:
                                        idx == state.filteredEvents.length - 1,
                                  );
                                }),
                              ],
                            ),
                    ),
                    24.spaceH,
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 20.h,
                      ),
                      decoration: BoxDecoration(
                        color: orangeLightColor,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child:
                          (state.weeksWithLovingBrain >= 2 &&
                              state.averageBedtimeShiftMinutes > 0)
                          ? '${state.weeksWithLovingBrain} weeks with Loving Brain. Bedtime has moved ${state.averageBedtimeShiftMinutes} minutes earlier on average since you started.'
                                .appText(
                                  fontSize: 14.sp,
                                  color: greyColor9,
                                  textAlign: TextAlign.start,
                                  height: 1.4,
                                )
                          : 'Keep logging check-ins to see long-term bedtime and rhythm patterns emerge.'
                                .appText(
                                  fontSize: 14.sp,
                                  color: greyColor9,
                                  textAlign: TextAlign.start,
                                  height: 1.4,
                                ),
                    ),
                    120.spaceH,
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String title, FamilyTimelineState state) {
    final bool isSelected = title == state.selectedFilter;
    return GestureDetector(
      onTap: () => context.read<FamilyTimelineCubit>().setFilter(title),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF1EEFF) : Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: isSelected ? secondaryColor : Colors.transparent,
            width: 1,
          ),
        ),
        child: title.appText(
          fontSize: 16.sp,
          color: isSelected ? secondaryColor : greyColor9,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildTimelineItem({
    required TimelineEventModel event,
    required bool isFirst,
    required bool isLast,
  }) {
    final bool isQuickNote = event.type == 'quick_note';
    final bool hasAudio =
        event.audioLocalPath != null && event.audioLocalPath!.isNotEmpty;
    final bool hasCustomText =
        event.subtitle.isNotEmpty && event.subtitle != 'Voice note';

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline line & dot
          SizedBox(
            width: 24.w,
            child: Column(
              children: [
                Container(
                  width: 2,
                  height: 16.h,
                  color: isFirst ? Colors.transparent : const Color(0xFFE5E7EB),
                ),
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: const BoxDecoration(
                    color: secondaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    color: isLast
                        ? Colors.transparent
                        : const Color(0xFFE5E7EB),
                  ),
                ),
              ],
            ),
          ),
          16.spaceW,
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                12.spaceH,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Expanded(
                      child: event.title.appText(
                        fontSize: 16.sp,
                        color: greyColor9,
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    8.spaceW,
                    DateFormat('MMM d · h:mm a')
                        .format(event.timestamp.toLocal())
                        .appText(
                          fontSize: 11.sp,
                          color: greyColor6,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.end,
                        ),
                  ],
                ),
                if (isQuickNote) ...[
                  if (hasCustomText) ...[
                    6.spaceH,
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9F7FC),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: secondaryColor.withValues(alpha: 0.15),
                          width: 1.w,
                        ),
                      ),
                      child: event.subtitle.appText(
                        fontSize: 14.sp,
                        color: darkBlue,
                        height: 1.45,
                        textAlign: TextAlign.start,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                  if (hasAudio)
                    TimelineAudioPlayer(
                      audioPath: event.audioLocalPath!,
                      durationSeconds: event.audioDurationSeconds,
                    )
                  else if (!hasCustomText) ...[
                    4.spaceH,
                    event.subtitle.appText(
                      fontSize: 12.sp,
                      color: greyColor,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ] else ...[
                  4.spaceH,
                  event.subtitle.appText(
                    fontSize: 12.sp,
                    color: greyColor,
                    textAlign: TextAlign.start,
                  ),
                ],
                28.spaceH,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TimelineAudioPlayer extends StatefulWidget {
  final String audioPath;
  final int? durationSeconds;

  const TimelineAudioPlayer({
    super.key,
    required this.audioPath,
    this.durationSeconds,
  });

  @override
  State<TimelineAudioPlayer> createState() => _TimelineAudioPlayerState();
}

class _TimelineAudioPlayerState extends State<TimelineAudioPlayer> {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  StreamSubscription<Duration>? _posSub;
  StreamSubscription<Duration>? _durSub;
  StreamSubscription<void>? _compSub;
  StreamSubscription<PlayerState>? _stateSub;

  @override
  void initState() {
    super.initState();
    if (widget.durationSeconds != null && widget.durationSeconds! > 0) {
      _duration = Duration(seconds: widget.durationSeconds!);
    }
    _posSub = _player.onPositionChanged.listen((Duration p) {
      if (mounted) {
        setState(() => _position = p);
      }
    }, onError: (_) {});
    _durSub = _player.onDurationChanged.listen((Duration d) {
      if (mounted) {
        setState(() => _duration = d);
      }
    }, onError: (_) {});
    _compSub = _player.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
        });
      }
    }, onError: (_) {});
    _stateSub = _player.onPlayerStateChanged.listen((PlayerState state) {
      if (mounted) {
        setState(() => _isPlaying = state == PlayerState.playing);
      }
    }, onError: (_) {});
  }

  @override
  void dispose() {
    _posSub?.cancel();
    _durSub?.cancel();
    _compSub?.cancel();
    _stateSub?.cancel();
    _player.dispose();
    super.dispose();
  }

  String _format(Duration d) {
    final int minutes = d.inMinutes;
    final int seconds = d.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> _toggle() async {
    try {
      if (_isPlaying) {
        await _player.pause();
      } else {
        if (widget.audioPath.startsWith('http://') ||
            widget.audioPath.startsWith('https://')) {
          await _player.play(UrlSource(widget.audioPath));
        } else {
          await _player.play(DeviceFileSource(widget.audioPath));
        }
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final double maxMs = _duration.inMilliseconds > 0
        ? _duration.inMilliseconds.toDouble()
        : 1.0;
    final double currentMs = _position.inMilliseconds.toDouble().clamp(
      0.0,
      maxMs,
    );

    return Container(
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF1EEFF),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: secondaryColor.withValues(alpha: 0.25),
          width: 1.w,
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _toggle,
            child: Container(
              width: 36.w,
              height: 36.w,
              decoration: const BoxDecoration(
                color: secondaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: Colors.white,
                size: 22.sp,
              ),
            ),
          ),
          10.spaceW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    "Voice note".appText(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: darkBlue,
                    ),
                    "${_format(_position)} / ${_format(_duration)}".appText(
                      fontSize: 10.sp,
                      color: greyColor4,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 2.5.h,
                    activeTrackColor: secondaryColor,
                    inactiveTrackColor: greyColor7,
                    thumbColor: secondaryColor,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5.r),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 10.r),
                  ),
                  child: Slider(
                    value: currentMs,
                    min: 0.0,
                    max: maxMs,
                    onChanged: (double val) async {
                      await _player.seek(Duration(milliseconds: val.toInt()));
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
