import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/core/emergency_detector.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/ui/base_screen/bloc/base_cubit.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:url_launcher/url_launcher.dart';

enum SafetyConcernMode { acute, clinical }

/// Screen 70 — Safety Concern.
class SafetyConcernScreen extends StatefulWidget {
  const SafetyConcernScreen({
    super.key,
    this.mode = SafetyConcernMode.acute,
    this.sourceMessage,
  });

  final SafetyConcernMode mode;
  final String? sourceMessage;

  @override
  State<SafetyConcernScreen> createState() => _SafetyConcernScreenState();
}

class _SafetyConcernScreenState extends State<SafetyConcernScreen> {
  bool get _isAcute => widget.mode == SafetyConcernMode.acute;

  Future<void> _callEmergency() async {
    final Uri uri = Uri.parse(EmergencyDetector.getEmergencyPhone());
    try {
      await launchUrl(uri);
    } catch (_) {}
  }

  void _goToHelpSafety() {
    context.push(RoutePaths.helpSafety);
  }

  void _goBackToBrainyHome() {
    try {
      context.read<BaseCubit>().changeProps(bottomNavigationIndex: 1);
    } catch (_) {}
    context.go(RoutePaths.baseScreen);
  }

  @override
  Widget build(BuildContext context) {
    final String displayNumber = EmergencyDetector.getEmergencyDisplayNumber();
    final String title = _isAcute
        ? 'Please contact emergency services'
        : 'Please speak with a health professional';
    final String message = _isAcute
        ? 'Loving Brain cannot assess acute medical symptoms or emergencies. If your child is struggling to breathe, turned blue, unresponsive, or in immediate danger, call emergency services right away.'
        : 'Loving Brain cannot assess symptoms. This sounds like something a doctor or health visitor should review. We will not generate parenting advice for this message.';

    return Scaffold(
      backgroundColor: const Color(0xFFFEF8F4),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      onTap: _goBackToBrainyHome,
                      child: Padding(
                        padding: EdgeInsets.all(8.r),
                        child: Icon(
                          Icons.arrow_back,
                          color: darkBlue,
                          size: 24.w,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      28.spaceH,
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: _isAcute
                              ? const Color(0xFFFFEBEE)
                              : const Color(0xFFFFF7ED),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child:
                            (_isAcute
                                    ? 'This may need emergency attention'
                                    : 'This may need professional attention')
                                .appText(
                                  fontSize: 12,
                                  color: _isAcute
                                      ? const Color(0xFFD32F2F)
                                      : const Color(0xFFB45309),
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                      20.spaceH,
                      title.appText(
                        fontSize: 28,
                        fraunces: true,
                        color: darkBlue,
                        textAlign: TextAlign.start,
                      ),
                      16.spaceH,
                      message.appText(
                        fontSize: 15,
                        color: greyColor,
                        height: 1.45,
                        textAlign: TextAlign.start,
                      ),
                      if (widget.sourceMessage != null &&
                          widget.sourceMessage!.trim().isNotEmpty) ...[
                        20.spaceH,
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(color: const Color(0xFFF3ECE7)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              'You mentioned'.appText(
                                fontSize: 12,
                                color: greyColor4,
                                fontWeight: FontWeight.w600,
                              ),
                              8.spaceH,
                              widget.sourceMessage!.trim().appText(
                                fontSize: 14,
                                color: greyColor9,
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                      ],
                      24.spaceH,
                    ],
                  ),
                ),
              ),
              if (_isAcute) ...[
                AppButton(
                  title: 'Call emergency services ($displayNumber)',
                  backgroundColor: const Color(0xFFD32F2F),
                  textColor: Colors.white,
                  height: 52,
                  onTap: _callEmergency,
                ),
                12.spaceH,
                AppButton(
                  title: 'Read safety information',
                  backgroundColor: Colors.white,
                  textColor: const Color(0xFFD32F2F),
                  borderColor: const Color(0xFFD32F2F),
                  height: 48,
                  onTap: _goToHelpSafety,
                ),
              ] else ...[
                AppButton(
                  title: 'Read safety information',
                  backgroundColor: const Color(0xFFB45309),
                  textColor: Colors.white,
                  height: 52,
                  onTap: _goToHelpSafety,
                ),
              ],
              12.spaceH,
              Center(
                child: TextButton(
                  onPressed: _goBackToBrainyHome,
                  child: 'Not now — go back to Brainy'.appText(
                    fontSize: 14,
                    color: greyColor9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              24.spaceH,
            ],
          ),
        ),
      ),
    );
  }
}
