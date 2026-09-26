import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/brainy_conversation/brainy_conversation_screen.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'dart:math';

class BrainyVoiceSheet extends StatefulWidget {
  const BrainyVoiceSheet({super.key});

  @override
  State<BrainyVoiceSheet> createState() => _BrainyVoiceSheetState();
}

class _BrainyVoiceSheetState extends State<BrainyVoiceSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          16.spaceH,
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: greyColor4,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          40.spaceH,
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFFAF9FF),
            ),
            padding: const EdgeInsets.all(12),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF4F3FF),
              ),
              padding: const EdgeInsets.all(12),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFECEAFF),
                ),
                padding: const EdgeInsets.all(16),
                child: Icon(Icons.mic, color: secondaryColor, size: 50),
              ),
            ),
          ),
          32.spaceH,
          // Animated equalizer mock
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildEqBar(16.0 + _random.nextDouble() * 10),
                  _buildEqBar(24.0 + _random.nextDouble() * 20),
                  _buildEqBar(32.0 + _random.nextDouble() * 30),
                  _buildEqBar(48.0 + _random.nextDouble() * 40),
                  _buildEqBar(32.0 + _random.nextDouble() * 30),
                  _buildEqBar(24.0 + _random.nextDouble() * 20),
                  _buildEqBar(16.0 + _random.nextDouble() * 10),
                ],
              );
            },
          ),
          40.spaceH,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: '"She keeps waking around\nfour in the morning..."'.appText(
              fontSize: 24.sp,
              fraunces: true,
              textAlign: TextAlign.center,
            ),
          ),
          12.spaceH,
          "Listening take your time.".appText(
            fontSize: 14.sp,
            color: greyColor6,
            textAlign: TextAlign.center,
          ),
          40.spaceH,
          Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 40.h),
            child: Row(
              children: [
                Expanded(
                  child: AppButton(
                    title: "Cancel",
                    onTap: () => Navigator.pop(context),
                    backgroundColor: Colors.white,
                    textColor: greyColor9,
                    padding: EdgeInsetsGeometry.zero,
                    height: 48,
                    borderColor: const Color(0xFFE8E8E8),
                  ),
                ),
                16.spaceW,
                Expanded(
                  child: AppButton(
                    height: 48,
                    title: "Send",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BrainyConversationScreen(),
                        ),
                      );
                    },
                    backgroundColor: secondaryColor,
                    textColor: Colors.white,
                    padding: EdgeInsetsGeometry.zero,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEqBar(double height) {
    return Container(
      width: 6.w,
      height: height,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
