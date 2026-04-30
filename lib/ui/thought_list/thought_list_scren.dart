import 'package:go_router/go_router.dart';
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/repo/mood_repo.dart';

import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../model/journal_model.dart';
import '../../other/extra_methods.dart';
import '../widget/base_button.dart';
import 'bloc/thought_list_cubit.dart';
import 'bloc/thought_list_state.dart';

class ThoughtListScreen extends StatefulWidget {
  const ThoughtListScreen({super.key});

  @override
  State<ThoughtListScreen> createState() => _ThoughtListScreenState();
}

class _ThoughtListScreenState extends State<ThoughtListScreen> {
  final TransformationController _transformationController = TransformationController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ThoughtListCubit>().init();
      // Center the view on 2000, 2000 initially
      final initialScale = 0.8;
      final screenSize = MediaQuery.of(context).size;
      final xOffset = 2000.0 * initialScale - screenSize.width / 2;
      final yOffset = 2000.0 * initialScale - screenSize.height / 2;
      _transformationController.value = Matrix4.identity()
        ..translate(-xOffset, -yOffset)
        ..scale(initialScale);
    });
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ThoughtListCubit, ThoughtListState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xff12121A), // Dark premium background
          body: Stack(
            children: [
              // The Infinite Canvas
              InteractiveViewer(
                transformationController: _transformationController,
                minScale: 0.1,
                maxScale: 3.0,
                boundaryMargin: const EdgeInsets.all(double.infinity),
                constrained: false,
                child: Container(
                  width: 4000,
                  height: 4000,
                  decoration: const BoxDecoration(
                    color: Color(0xff1A1A24),
                  ),
                  child: CustomPaint(
                    painter: GridPainter(),
                    child: Stack(
                      children: state.journalList.map((journal) {
                        return DraggableJournalCard(
                          key: ValueKey(journal.id ?? journal.logTime?.toIso8601String() ?? journal.hashCode.toString()),
                          journal: journal,
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),

              // Glassmorphic App Bar at the top
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            BaseButton(
                              child: ColorFiltered(
                                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                                child: Assets.icons.icBackIcon.image(height: 36, width: 36),
                              ),
                              onTap: () {
                                context.pop();
                              },
                            ),
                            16.w.spaceW,
                            LocaleKeys.thoughtsList.tr().appText(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class DraggableJournalCard extends StatefulWidget {
  final JournalModel journal;
  const DraggableJournalCard({super.key, required this.journal});

  @override
  State<DraggableJournalCard> createState() => _DraggableJournalCardState();
}

class _DraggableJournalCardState extends State<DraggableJournalCard> {
  late double x;
  late double y;

  @override
  void initState() {
    super.initState();
    x = widget.journal.x ?? 1000.0;
    y = widget.journal.y ?? 1000.0;
  }

  @override
  void didUpdateWidget(covariant DraggableJournalCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.journal.x != widget.journal.x || oldWidget.journal.y != widget.journal.y) {
      if (widget.journal.x != null) x = widget.journal.x!;
      if (widget.journal.y != null) y = widget.journal.y!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x,
      top: y,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            x += details.delta.dx;
            y += details.delta.dy;
          });
        },
        onPanEnd: (details) {
          if (widget.journal.id != null) {
            MoodRepo.instance.updateJournalPosition(
              journalId: widget.journal.id!,
              x: x,
              y: y,
            );
          }
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              width: 280,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2), 
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 30,
                    spreadRadius: 5,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: const Color(0xffFF7EB3),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xffFF7EB3).withValues(alpha: 0.5),
                              blurRadius: 10,
                              spreadRadius: 2,
                            )
                          ],
                        ),
                      ),
                      12.spaceW,
                      Expanded(
                        child: convertToMMMMDYYYY(widget.journal.logTime)
                            .appText(
                              fontWeight: FontWeight.w700, 
                              fontSize: 13,
                              color: Colors.white.withValues(alpha: 0.7),
                              textAlign: TextAlign.start,
                            ),
                      ),
                    ],
                  ),
                  16.spaceH,
                  (widget.journal.thoughtText ?? "").appText(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colors.white,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;
      
    const double spacing = 40.0;
    const double radius = 1.5;
    
    for (double i = 0; i < size.width; i += spacing) {
      for (double j = 0; j < size.height; j += spacing) {
        canvas.drawCircle(Offset(i, j), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
