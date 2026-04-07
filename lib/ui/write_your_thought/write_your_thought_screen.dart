import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/app_extentions.dart';

import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../model/journal_model.dart';
import '../../other/app_color.dart';
import '../../other/extra_methods.dart';
import '../../other/snack_bar.dart';
import '../../repo/mood_repo.dart';
import '../chat_detail/chat_detail_screen.dart';
import '../widget/app_text_field.dart';
import '../widget/base_button.dart';
import 'bloc/write_your_thought_cubit.dart';
import 'bloc/write_your_thought_state.dart';

class WriteYourThoughtScreen extends StatefulWidget {
  const WriteYourThoughtScreen({super.key});

  @override
  State<WriteYourThoughtScreen> createState() => _WriteYourThoughtScreenState();
}

class _WriteYourThoughtScreenState extends State<WriteYourThoughtScreen> {
  final TransformationController _transformationController = TransformationController();
  final TextEditingController yourThoughtsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<WriteYourThoughtCubit>().init();
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
    yourThoughtsController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  void _showColorPickerSubDialog(BuildContext context, Color startColor, Function(Color) onColorChanged) {
    Color tempColor = startColor;
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
          title: Text(
            'Pick Unlimited Color',
            style: getTextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 18.sp,
              color: primaryColor,
            ),
          ),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: tempColor,
              onColorChanged: (c) => tempColor = c,
              enableAlpha: false, // Opaque cards only
              displayThumbColor: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: getTextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
            TextButton(
              child: Text(
                'Select',
                style: getTextStyle(color: primaryColor, fontWeight: FontWeight.w800),
              ),
              onPressed: () {
                onColorChanged(tempColor);
                Navigator.of(ctx).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddJournalDialog(BuildContext context, WriteYourThoughtState state) {
    // Reset state before opening
    yourThoughtsController.clear();
    context.read<WriteYourThoughtCubit>().changeProps(thoughtsText: '', thoughtsErrorText: '');

    int selectedColorValue = Colors.white.value;

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (ctx) {
        return BlocProvider.value(
          value: context.read<WriteYourThoughtCubit>(),
          child: StatefulBuilder(
            builder: (context, setDialogState) {
              return BlocConsumer<WriteYourThoughtCubit, WriteYourThoughtState>(
                listener: (context, modalState) {
                   modalState.apiResultStatus.whenOrNull(
                    data: (data) {
                      Navigator.of(context).pop(); // close modal on success
                      // Focus back to the newly added cluster center
                      final initialScale = 0.8;
                      final screenSize = MediaQuery.of(context).size;
                      final xOffset = 2000.0 * initialScale - screenSize.width / 2;
                      final yOffset = 2000.0 * initialScale - screenSize.height / 2;
                      _transformationController.value = Matrix4.identity()
                        ..translate(-xOffset, -yOffset)
                        ..scale(initialScale);
                    },
                  );
                },
                builder: (context, modalState) {
                  return Dialog(
                    backgroundColor: Colors.transparent,
                    insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                    child: SingleChildScrollView(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28.r),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                          child: Container(
                            padding: EdgeInsets.all(24.w),
                            decoration: BoxDecoration(
                              color: Color(selectedColorValue).withValues(alpha: 0.95), // Adapt popup to chosen color
                              borderRadius: BorderRadius.circular(28.r),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.8)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 30,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    LocaleKeys.writeYourThoughts.tr().appText(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20.sp,
                                    ),
                                    BaseButton(
                                      onTap: () => Navigator.pop(context),
                                      child: Container(
                                        padding: EdgeInsets.all(8.w),
                                        decoration: BoxDecoration(
                                          color: primaryColor.withValues(alpha: 0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(Icons.close, color: primaryColor, size: 20.sp),
                                      ),
                                    ),
                                  ],
                                ),
                                16.h.spaceH,
                                "${LocaleKeys.hi.tr()}, ${LocaleKeys.howYourHeartTodayTakeMomentReflect.tr()}".appText(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: blackTextColor,
                                  height: 1.4,
                                  textAlign: TextAlign.start,
                                ),
                                20.h.spaceH,
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.7),
                                    borderRadius: BorderRadius.circular(20.r),
                                    border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
                                  ),
                                  child: AppTextField(
                                    controller: yourThoughtsController,
                                    fillColor: Colors.transparent,
                                    filled: true,
                                    minLines: 5,
                                    maxLines: 7,
                                    contentPadding: EdgeInsets.all(16.w),
                                    hintStyle: getTextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.sp,
                                      color: greyColor1,
                                    ),
                                    hint: LocaleKeys.typeYourThoughtsHere.tr(),
                                    error: modalState.thoughtsErrorText,
                                    onChanged: (value) {
                                      context.read<WriteYourThoughtCubit>().changeProps(thoughtsText: value);
                                    },
                                  ),
                                ),
                                20.h.spaceH,
                                
                                // Unlimited Color Selector Button
                                "Card Background Style".appText(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey.shade700,
                                  textAlign: TextAlign.start,
                                ),
                                12.h.spaceH,
                                BaseButton(
                                  onTap: () {
                                    _showColorPickerSubDialog(
                                      context, 
                                      Color(selectedColorValue), 
                                      (newColor) {
                                        setDialogState(() {
                                          selectedColorValue = newColor.value;
                                        });
                                      }
                                    );
                                  },
                                  child: Container(
                                    height: 52.h,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFFFFB3BA), // Pastel Red
                                          Color(0xFFFFDFBA), // Pastel Orange
                                          Color(0xFFFFFFBA), // Pastel Yellow
                                          Color(0xFFBAFFC9), // Pastel Green
                                          Color(0xFFBAE1FF), // Pastel Blue
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(16.r),
                                      border: Border.all(color: Colors.white, width: 2),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.05),
                                          blurRadius: 8,
                                          offset: Offset(0, 4.h),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.8),
                                          borderRadius: BorderRadius.circular(20.r),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.palette, color: primaryColor, size: 18.sp),
                                            8.w.spaceW,
                                            "Pick Unlimited Color".appText(
                                              color: primaryColor,
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                
                                28.h.spaceH,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    BaseButton(
                                      onTap: () {
                                        context.read<WriteYourThoughtCubit>().logThought(colorValue: selectedColorValue);
                                      },
                                      child: Container(
                                        height: 52.h,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [yellowColor3, yellowColor2],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(26.r),
                                          boxShadow: [
                                            BoxShadow(
                                              color: yellowColor3.withValues(alpha: 0.4),
                                              blurRadius: 10.r,
                                              offset: Offset(0, 4.h),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: LocaleKeys.saveEntry.tr().appText(
                                            color: Colors.white,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                    12.h.spaceH,
                                    BaseButton(
                                      onTap: () {
                                        if (context.read<WriteYourThoughtCubit>().isValidate()) {
                                          Navigator.pop(context);
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) => ChatDetailScreen(
                                                initialChat: modalState.thoughtsText,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: Container(
                                        height: 52.h,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(26.r),
                                          border: Border.all(
                                            color: primaryColor.withValues(alpha: 0.3),
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Center(
                                          child: LocaleKeys.getAIReflection.tr().appText(
                                            color: primaryColor,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WriteYourThoughtCubit, WriteYourThoughtState>(
      listener: (context, state) {
        state.apiResultStatus.whenOrNull(
          initial: () {},
          loading: () {
            EasyLoading.show();
          },
          data: (data) {
            EasyLoading.dismiss();
          },
          error: (error) {
            showSnackBar(
              message: error.toString().replaceAll('Exception: ', ''),
              type: SnackBarType.ERROR,
            );
            EasyLoading.dismiss();
          },
        );
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xffF0F3F7), // Light clean background
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
                    color: Color(0xffF6F8FA),
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

              // Title Header
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.8)),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Journal Canvas",
                              style: getTextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 18.sp,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              // Floating Action Button to Add Journal
              Positioned(
                bottom: 30.h,
                right: 20.w,
                child: BaseButton(
                  onTap: () => _showAddJournalDialog(context, state),
                  child: Container(
                    height: 60.h,
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [yellowColor3, yellowColor2],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30.r),
                      boxShadow: [
                        BoxShadow(
                          color: yellowColor3.withValues(alpha: 0.4),
                          blurRadius: 15.r,
                          offset: Offset(0, 6.h),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, color: Colors.white, size: 24.sp),
                        8.w.spaceW,
                        Text(
                          "Add Journal",
                          style: getTextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16.sp,
                            color: Colors.white,
                          ),
                        ),
                      ],
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
        child: Container(
          width: 300.w,
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Color(widget.journal.colorValue ?? 0xFFFFFFFF),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: primaryColor.withValues(alpha: 0.05), 
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 30,
                spreadRadius: 2,
                offset: const Offset(0, 10),
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
                    width: 14.w,
                    height: 14.w,
                    decoration: BoxDecoration(
                      color: const Color(0xffFF7EB3),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xffFF7EB3).withValues(alpha: 0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                  ),
                  12.w.spaceW,
                  Expanded(
                    child: convertToMMMMDYYYY(widget.journal.logTime)
                        .appText(
                          fontWeight: FontWeight.w700, 
                          fontSize: 14.sp,
                          color: Colors.grey.shade600,
                          textAlign: TextAlign.start,
                        ),
                  ),
                ],
              ),
              16.h.spaceH,
              if ((widget.journal.thoughtText ?? "").isNotEmpty)
                (widget.journal.thoughtText ?? "").appText(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                  color: blackTextColor,
                  textAlign: TextAlign.start,
                  height: 1.4,
                ),
            ],
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
      ..color = Colors.black.withValues(alpha: 0.06)
      ..style = PaintingStyle.fill;
      
    const double spacing = 40.0;
    const double radius = 2.0;
    
    for (double i = 0; i < size.width; i += spacing) {
      for (double j = 0; j < size.height; j += spacing) {
        canvas.drawCircle(Offset(i, j), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
