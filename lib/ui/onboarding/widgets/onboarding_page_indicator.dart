import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingPageIndicator extends StatelessWidget {
  const OnboardingPageIndicator({
    super.key,
    this.totalPages = 6,
    required this.currentPage,
    this.controller,
    this.onSegmentTap,
    this.activeColor = const Color(0xFF6560CA),
    this.inactiveColor = const Color(0xFFE0D9EB),
    this.height,
    this.spacing,
    this.borderRadius,
  }) : assert(totalPages > 0, 'totalPages must be greater than 0');

  final int totalPages;
  final int currentPage;
  final PageController? controller;
  final ValueChanged<int>? onSegmentTap;
  final Color activeColor;
  final Color inactiveColor;
  final double? height;
  final double? spacing;
  final BorderRadius? borderRadius;

  Widget _buildRow({
    required int activeIndex,
    required double segmentHeight,
    required double segmentSpacing,
    required BorderRadius radius,
  }) {
    return Row(
      children: <Widget>[
        for (int i = 0; i < totalPages; i++) ...<Widget>[
          if (i > 0) SizedBox(width: segmentSpacing),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onSegmentTap != null ? () => onSegmentTap!(i) : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                height: segmentHeight,
                decoration: BoxDecoration(
                  // Incrementally filled: all segments up to activeIndex are filled,
                  // not just darkening the active page.
                  color: i <= activeIndex ? activeColor : inactiveColor,
                  borderRadius: radius,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double segmentHeight = height ?? 5.h;
    final double segmentSpacing = spacing ?? 5.w;
    final BorderRadius radius = borderRadius ?? BorderRadius.circular(100.r);

    if (controller != null) {
      return AnimatedBuilder(
        animation: controller!,
        builder: (BuildContext context, Widget? child) {
          final int activeIndex =
              controller!.hasClients && controller!.page != null
              ? controller!.page!.round()
              : currentPage;
          return _buildRow(
            activeIndex: activeIndex,
            segmentHeight: segmentHeight,
            segmentSpacing: segmentSpacing,
            radius: radius,
          );
        },
      );
    }

    return _buildRow(
      activeIndex: currentPage,
      segmentHeight: segmentHeight,
      segmentSpacing: segmentSpacing,
      radius: radius,
    );
  }
}
