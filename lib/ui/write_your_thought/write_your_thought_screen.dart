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
import '../widget/app_text_field.dart';
import '../widget/base_button.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'bloc/write_your_thought_cubit.dart';
import 'bloc/write_your_thought_state.dart';

class WriteYourThoughtScreen extends StatefulWidget {
  const WriteYourThoughtScreen({super.key});

  @override
  State<WriteYourThoughtScreen> createState() => _WriteYourThoughtScreenState();
}

class _WriteYourThoughtScreenState extends State<WriteYourThoughtScreen> {
  final TransformationController _transformationController =
      TransformationController();
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

  void _showColorPickerSubDialog(
    BuildContext context,
    Color startColor,
    Function(Color) onColorChanged,
  ) {
    Color tempColor = startColor;
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
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
                style: getTextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                ctx.pop();
              },
            ),
            TextButton(
              child: Text(
                'Select',
                style: getTextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
              onPressed: () {
                onColorChanged(tempColor);
                ctx.pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddJournalDialog(
    BuildContext context,
    WriteYourThoughtState state,
  ) {
    // Reset state before opening
    yourThoughtsController.clear();
    context.read<WriteYourThoughtCubit>().changeProps(
      thoughtsText: '',
      thoughtsErrorText: '',
    );

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
                      context.pop(); // close modal on success
                      // Focus back to the newly added cluster center
                      final initialScale = 0.8;
                      final screenSize = MediaQuery.of(context).size;
                      final xOffset =
                          2000.0 * initialScale - screenSize.width / 2;
                      final yOffset =
                          2000.0 * initialScale - screenSize.height / 2;
                      _transformationController.value = Matrix4.identity()
                        ..translate(-xOffset, -yOffset)
                        ..scale(initialScale);
                    },
                  );
                },
                builder: (context, modalState) {
                  return Dialog(
                    backgroundColor: Colors.transparent,
                    insetPadding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 20.h,
                    ),
                    child: SingleChildScrollView(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28.r),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                          child: Container(
                            padding: EdgeInsets.all(24.w),
                            decoration: BoxDecoration(
                              color: Color(selectedColorValue).withValues(
                                alpha: 0.95,
                              ), // Adapt popup to chosen color
                              borderRadius: BorderRadius.circular(28.r),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    LocaleKeys.writeYourThoughts.tr().appText(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20.sp,
                                    ),
                                    BaseButton(
                                      onTap: () => context.pop(),
                                      child: Container(
                                        padding: EdgeInsets.all(8.w),
                                        decoration: BoxDecoration(
                                          color: primaryColor.withValues(
                                            alpha: 0.1,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.close,
                                          color: primaryColor,
                                          size: 20.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                16.h.spaceH,
                                "${LocaleKeys.hi.tr()}, ${LocaleKeys.howYourHeartTodayTakeMomentReflect.tr()}"
                                    .appText(
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
                                    border: Border.all(
                                      color: Colors.black.withValues(
                                        alpha: 0.05,
                                      ),
                                    ),
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
                                      context
                                          .read<WriteYourThoughtCubit>()
                                          .changeProps(thoughtsText: value);
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
                                      },
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
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.05,
                                          ),
                                          blurRadius: 8,
                                          offset: Offset(0, 4.h),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16.w,
                                          vertical: 6.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(
                                            alpha: 0.8,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            20.r,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.palette,
                                              color: primaryColor,
                                              size: 18.sp,
                                            ),
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
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    BaseButton(
                                      onTap: () {
                                        context
                                            .read<WriteYourThoughtCubit>()
                                            .logThought(
                                              colorValue: selectedColorValue,
                                            );
                                      },
                                      child: Container(
                                        height: 52.h,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              yellowColor3,
                                              yellowColor2,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            26.r,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: yellowColor3.withValues(
                                                alpha: 0.4,
                                              ),
                                              blurRadius: 10.r,
                                              offset: Offset(0, 4.h),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: LocaleKeys.saveEntry
                                              .tr()
                                              .appText(
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
                                        if (context
                                            .read<WriteYourThoughtCubit>()
                                            .isValidate()) {
                                          context.pop();
                                          context.push(
                                            RoutePaths.chatDetail,
                                            extra: {
                                              'initialChat':
                                                  modalState.thoughtsText,
                                            },
                                          );
                                        }
                                      },
                                      child: Container(
                                        height: 52.h,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            26.r,
                                          ),
                                          border: Border.all(
                                            color: primaryColor.withValues(
                                              alpha: 0.3,
                                            ),
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Center(
                                          child: LocaleKeys.getAIReflection
                                              .tr()
                                              .appText(
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
            },
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
                  decoration: const BoxDecoration(color: Color(0xffF6F8FA)),
                  child: CustomPaint(
                    painter: GridPainter(),
                    child: Stack(
                      children: state.journalList.map((journal) {
                        return DraggableJournalCard(
                          key: ValueKey(
                            journal.id ??
                                journal.logTime?.toIso8601String() ??
                                journal.hashCode.toString(),
                          ),
                          journal: journal,
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),

              // Title header + primary add journal (full-width below header)
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(top: 12.h, left: 16.w, right: 16.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(22.r),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 14.h,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withValues(alpha: 0.72),
                                  Colors.white.withValues(alpha: 0.52),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(22.r),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.95),
                                width: 1.2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withValues(alpha: 0.08),
                                  blurRadius: 24,
                                  offset: Offset(0, 8.h),
                                ),
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 12,
                                  offset: Offset(0, 2.h),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 44.w,
                                  height: 44.w,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        primaryColor.withValues(alpha: 0.18),
                                        const Color(
                                          0xFFB06FE5,
                                        ).withValues(alpha: 0.14),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(14.r),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.9,
                                      ),
                                    ),
                                  ),
                                  child: Center(
                                    child: Assets.icons.icJournalIcon.image(
                                      width: 22.w,
                                      height: 22.w,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                14.w.spaceW,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      'journalCanvasTitle'.tr().appText(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 17.sp,
                                        color: primaryColor,
                                        letterSpacing: -0.2,
                                        textAlign: TextAlign.start,
                                      ),
                                      4.h.spaceH,
                                      'journalCanvasSubtitle'.tr().appText(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12.sp,
                                        color: greyColor1,
                                        height: 1.35,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                ),
                                10.w.spaceW,
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 8.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: primaryColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(
                                      color: primaryColor.withValues(
                                        alpha: 0.15,
                                      ),
                                    ),
                                  ),
                                  child:
                                      (state.journalList.length == 1
                                              ? 'journalEntryCountOne'.tr()
                                              : 'journalEntryCountMany'.tr(
                                                  namedArgs: {
                                                    'count': state
                                                        .journalList
                                                        .length
                                                        .toString(),
                                                  },
                                                ))
                                          .appText(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12.sp,
                                            color: primaryColor,
                                          ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      14.h.spaceH,
                      BaseButton(
                        onTap: () => _showAddJournalDialog(context, state),
                        child: Container(
                          width: double.infinity,
                          height: 62.h,
                          padding: EdgeInsets.symmetric(horizontal: 22.w),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF894BCD), Color(0xFFB06FE5)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20.r),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF894BCD,
                                ).withValues(alpha: 0.42),
                                blurRadius: 22.r,
                                spreadRadius: 0,
                                offset: Offset(0, 10.h),
                              ),
                              BoxShadow(
                                color: const Color(
                                  0xFF894BCD,
                                ).withValues(alpha: 0.18),
                                blurRadius: 36.r,
                                spreadRadius: 2,
                                offset: Offset(0, 4.h),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 34.w,
                                height: 34.w,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.25),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.add_rounded,
                                  color: Colors.white,
                                  size: 24.sp,
                                ),
                              ),
                              14.w.spaceW,
                              'journalAddEntry'.tr().appText(
                                fontWeight: FontWeight.w800,
                                fontSize: 17.sp,
                                color: Colors.white,
                                letterSpacing: 0.35,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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

class _DraggableJournalCardState extends State<DraggableJournalCard>
    with SingleTickerProviderStateMixin {
  late double x;
  late double y;
  bool _isHovered = false;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    x = widget.journal.x ?? 1000.0;
    y = widget.journal.y ?? 1000.0;
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant DraggableJournalCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.journal.x != widget.journal.x ||
        oldWidget.journal.y != widget.journal.y) {
      if (widget.journal.x != null) x = widget.journal.x!;
      if (widget.journal.y != null) y = widget.journal.y!;
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 40.w),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: EdgeInsets.all(28.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(28.r),
                border: Border.all(color: Colors.white, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 40,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.redAccent,
                      size: 36.sp,
                    ),
                  ),
                  20.h.spaceH,
                  Text(
                    'Delete Journal?',
                    style: getTextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 20.sp,
                      color: Colors.black87,
                    ),
                  ),
                  12.h.spaceH,
                  Text(
                    'This journal entry will be permanently removed from your canvas.',
                    textAlign: TextAlign.center,
                    style: getTextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13.sp,
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
                  ),
                  28.h.spaceH,
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => ctx.pop(),
                          child: Container(
                            height: 50.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: Colors.grey.shade200,
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: getTextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14.sp,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ),
                      12.w.spaceW,
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            ctx.pop();
                            if (widget.journal.id != null) {
                              context
                                  .read<WriteYourThoughtCubit>()
                                  .deleteJournal(widget.journal.id!);
                            }
                          },
                          child: Container(
                            height: 50.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFF5252), Color(0xFFFF1744)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.red.withValues(alpha: 0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Text(
                              'Delete',
                              style: getTextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 14.sp,
                                color: Colors.white,
                              ),
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
  }

  Color _getCardAccentColor() {
    final base = Color(widget.journal.colorValue ?? 0xFFFFFFFF);
    // Derive a readable accent from the card color
    final hsl = HSLColor.fromColor(base);
    if (hsl.lightness > 0.85) {
      // Very light card — use purple accent
      return const Color(0xFF894BCD);
    }
    return hsl.withLightness((hsl.lightness - 0.2).clamp(0.2, 0.8)).toColor();
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = Color(widget.journal.colorValue ?? 0xFFFFFFFF);
    final accentColor = _getCardAccentColor();
    final dateText = convertToMMMMDYYYY(widget.journal.logTime);
    final thoughtText = widget.journal.thoughtText ?? '';

    return Positioned(
      left: x,
      top: y,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: GestureDetector(
          onPanStart: (_) {
            setState(() => _isHovered = true);
            _scaleController.forward();
          },
          onPanUpdate: (details) {
            setState(() {
              x += details.delta.dx;
              y += details.delta.dy;
            });
          },
          onPanEnd: (details) {
            setState(() => _isHovered = false);
            _scaleController.reverse();
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
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(28.r),
              border: Border.all(
                color: _isHovered
                    ? accentColor.withValues(alpha: 0.3)
                    : Colors.white.withValues(alpha: 0.8),
                width: _isHovered ? 2 : 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: _isHovered ? 0.12 : 0.07,
                  ),
                  blurRadius: _isHovered ? 40 : 24,
                  spreadRadius: _isHovered ? 4 : 1,
                  offset: Offset(0, _isHovered ? 14 : 8),
                ),
                if (_isHovered)
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.08),
                    blurRadius: 30,
                    spreadRadius: 2,
                  ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // ─── Card Header ───────────────────────────
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 18.w,
                    vertical: 14.h,
                  ),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(28.r),
                      topRight: Radius.circular(28.r),
                    ),
                    border: Border(
                      bottom: BorderSide(
                        color: accentColor.withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Dot indicator
                      Container(
                        width: 10.w,
                        height: 10.w,
                        decoration: BoxDecoration(
                          color: accentColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: accentColor.withValues(alpha: 0.4),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                      8.w.spaceW,
                      Expanded(
                        child: Text(
                          dateText,
                          style: getTextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12.sp,
                            color: accentColor,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                      // ─── Delete Button ───────────────────
                      GestureDetector(
                        onTap: () => _showDeleteConfirmation(context),
                        child: Container(
                          width: 30.w,
                          height: 30.w,
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.redAccent,
                            size: 16.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ─── Card Body ─────────────────────────────
                Padding(
                  padding: EdgeInsets.all(18.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (thoughtText.isNotEmpty)
                        ...([
                          Text(
                            thoughtText,
                            style: getTextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15.sp,
                              color: Colors.black87,
                              height: 1.55,
                            ),
                            maxLines: 8,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ]),
                    ],
                  ),
                ),

                // ─── Card Footer ───────────────────────────
                Padding(
                  padding: EdgeInsets.only(
                    left: 18.w,
                    right: 18.w,
                    bottom: 14.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.drag_indicator_rounded,
                              size: 12.sp,
                              color: accentColor.withValues(alpha: 0.6),
                            ),
                            4.w.spaceW,
                            Text(
                              'Drag to move',
                              style: getTextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 10.sp,
                                color: accentColor.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
