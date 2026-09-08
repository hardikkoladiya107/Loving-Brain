import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingPageIndicator extends StatelessWidget {
  const OnboardingPageIndicator({
    super.key,
    this.totalPages = 6,
    required this.currentPage,
    this.onSegmentTap,
    this.activeColor = const Color(0xFF6560CA),
    this.inactiveColor = const Color(0xFFE0D6E8),
    this.height,
    this.spacing,
    this.borderRadius,
  }) : assert(totalPages > 0, 'totalPages must be greater than 0');

  final int totalPages;
  final int currentPage;
  final ValueChanged<int>? onSegmentTap;
  final Color activeColor;
  final Color inactiveColor;
  final double? height;
  final double? spacing;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final double segmentHeight = height ?? 4.5.h;
    final double segmentSpacing = spacing ?? 8.w;
    final BorderRadius radius = borderRadius ?? BorderRadius.circular(100.r);

    return Row(
      children: <Widget>[
        for (int i = 0; i < totalPages; i++) ...<Widget>[
          if (i > 0) SizedBox(width: segmentSpacing),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onSegmentTap != null ? () => onSegmentTap!(i) : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeInOut,
                height: segmentHeight,
                decoration: BoxDecoration(
                  color: i == currentPage ? activeColor : inactiveColor,
                  borderRadius: radius,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
