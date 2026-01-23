import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/ui/connect_detail/bloc/connect_detail_cubit.dart';
import 'package:loving_brain/ui/connect_detail/bloc/connect_detail_state.dart';
import 'package:loving_brain/ui/widget/base_button.dart';
import '../../gen/assets.gen.dart';
import '../../main.dart';
import '../../other/app_color.dart';

class ConnectDetailScreen extends StatefulWidget {
  const ConnectDetailScreen({super.key});

  @override
  State<ConnectDetailScreen> createState() => _ConnectDetailScreenState();
}

class _ConnectDetailScreenState extends State<ConnectDetailScreen> {
  final GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ConnectDetailCubit>().init();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConnectDetailCubit, ConnectDetailState>(
      builder: (context, state) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          body: Stack(
            children: [
              // Background
              Container(
                height: context.height,
                width: context.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(Assets.images.imgSleepBackground.path),
                    fit: BoxFit.cover,
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Container(color: Colors.black.withOpacity(0.2)),
                ),
              ),

              SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 6,
                      ),
                      child: Column(
                        children: [
                          60.spaceH,
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.25),
                                  Colors.white.withOpacity(0.08),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.25),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 15,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                state.currentPrompt.appText(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.white,
                                  textAlign: TextAlign.center,
                                  height: 1.25,
                                ),
                                if (state.promptModel != null) ...[
                                  Divider(
                                    color: Colors.white.withOpacity(0.15),
                                    thickness: 1,
                                  ),
                                  if (state.promptModel!.hint1.isNotEmpty)
                                    _buildHintParams(
                                      "Hint 1",
                                      state.promptModel!.hint1,
                                    ),
                                  if (state.promptModel!.hint2.isNotEmpty) ...[
                                    6.spaceH,
                                    _buildHintParams(
                                      "Hint 2",
                                      state.promptModel!.hint2,
                                    ),
                                  ],
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    4.spaceH,
                    Expanded(
                      child: Container(
                        width: context.width,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(32),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 30,
                              offset: Offset(0, -5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            16.spaceH,
                            // Tools Row
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.palette_outlined,
                                        size: 18,
                                        color: Colors.grey,
                                      ),
                                      8.spaceW,
                                      "Your Canvas".appText(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      _colorPickerTrigger(context, state),
                                      12.spaceW,
                                      _undoButton(context, state),
                                      12.spaceW,
                                      _eraserButton(context, state),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            16.spaceH,

                            // Canvas - Expanded
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.grey.shade100,
                                    width: 4,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      blurRadius: 15,
                                      spreadRadius: 2,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: RepaintBoundary(
                                  key: _globalKey,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Container(
                                      color: Colors.white,
                                      child: GestureDetector(
                                        onPanStart: (details) {
                                          context
                                              .read<ConnectDetailCubit>()
                                              .startStroke(
                                                details.localPosition,
                                              );
                                        },
                                        onPanUpdate: (details) {
                                          context
                                              .read<ConnectDetailCubit>()
                                              .updateStroke(
                                                details.localPosition,
                                              );
                                        },
                                        onPanEnd: (details) {
                                          context
                                              .read<ConnectDetailCubit>()
                                              .endStroke();
                                        },
                                        child: CustomPaint(
                                          painter: ConnectDetailPainter(
                                            state.allStrokes,
                                            state.currentStroke,
                                          ),
                                          size: Size.infinite,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            20.spaceH,

                            // Finish Button
                            BaseButton(
                              child: Container(
                                height: 48,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      rateThisAppIconColor,
                                      rateThisAppIconColor,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF8E24AA,
                                      ).withOpacity(0.4),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.check_circle_outline,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    8.spaceW,
                                    "I'm Finished!".appText(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      letterSpacing: 0.5,
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                _showCompletionDialog(context);
                              },
                            ).appPadding(left: 24.w, right: 24.w),
                            10.spaceH,
                            "We will cherish this drawing as a serene moment."
                                .appText(fontSize: 12),
                            // Safe area bottom padding if needed, or just space
                            (MediaQuery.of(context).padding.bottom + 10).spaceH,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                top: 50,
                left: 16,
                child: BaseButton(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.4),
                      ),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
      listener: (context, state) {
        state.getPromptApiResultStatus.whenOrNull(
          error: (error) {
            EasyLoading.dismiss();
          },
          loading: () {
            EasyLoading.show();
          },
          data: (data) {
            EasyLoading.dismiss();
          },
        );
        state.saveDrawingApiResultStatus.whenOrNull(
          error: (error) {
            EasyLoading.dismiss();
            showSnackBar(message: error.toString(), type: SnackBarType.ERROR);
          },
          loading: () {
            EasyLoading.show();
          },
          data: (data) {
            EasyLoading.dismiss();
            showSnackBar(
              message: "Saved Successfully",
              type: SnackBarType.SUCCESS,
            );
            Navigator.pop(context);

          },
        );
      },
    );
  }

  Widget _buildHintParams(String label, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: label.appText(
            fontSize: 9,
            fontWeight: FontWeight.w800,
            color: Colors.white.withValues(alpha: 0.9),
            textAlign: TextAlign.start,
          ),
        ),
        8.spaceW,
        Expanded(
          child: text.appText(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.white.withValues(alpha: 0.95),
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }

  // New circular button triggering the color picker
  Widget _colorPickerTrigger(BuildContext context, ConnectDetailState state) {
    return GestureDetector(
      onTap: () => _showColorPickerBottomSheet(context, state),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: state.selectedColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: state.selectedColor.withOpacity(0.3),
              blurRadius: 4,
            ),
          ],
        ),
        // Small indicator icon if white (eraser or white) is selected to make it visible
        child: state.selectedColor == Colors.white
            ? const Icon(Icons.format_paint, size: 14, color: Colors.grey)
            : null,
      ),
    );
  }

  Widget _eraserButton(BuildContext context, ConnectDetailState state) {
    final isSelected = state.selectedColor == Colors.white;
    return GestureDetector(
      onTap: () => context.read<ConnectDetailCubit>().changeProps(
        selectedColor: Colors.white,
      ),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey.shade100 : Colors.white,
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(color: Colors.black54, width: 1.5)
              : Border.all(color: Colors.grey.shade300),
        ),
        child: Icon(
          Icons.cleaning_services_rounded,
          color: isSelected ? Colors.black87 : Colors.grey,
          size: 18,
        ),
      ),
    );
  }

  Widget _undoButton(BuildContext context, ConnectDetailState state) {
    return GestureDetector(
      onTap: () => context.read<ConnectDetailCubit>().undoLastStroke(),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: const Icon(Icons.undo_rounded, color: Colors.grey, size: 18),
      ),
    );
  }

  void _showColorPickerBottomSheet(
    BuildContext context,
    ConnectDetailState state,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              "Pick a Color".appText(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              20.spaceH,
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children:
                    [
                      Colors.red,
                      Colors.blue,
                      Colors.green,
                      const Color(0xFFFFEB3B), // Yellow
                      Colors.purple,
                      Colors.orange,
                      Colors.teal,
                      Colors.pink,
                      Colors.brown,
                      Colors.black,
                      Colors.grey,
                      const Color(0xFFE91E63),
                    ].map((color) {
                      final isSelected = state.selectedColor == color;
                      return GestureDetector(
                        onTap: () {
                          this.context.read<ConnectDetailCubit>().changeProps(
                            selectedColor: color,
                          );
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: isSelected
                                ? Border.all(color: Colors.black, width: 2.5)
                                : Border.all(color: Colors.grey.shade200),
                            boxShadow: [
                              BoxShadow(
                                color: color.withOpacity(0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 20,
                                )
                              : null,
                        ),
                      );
                    }).toList(),
              ),
              20.spaceH,
            ],
          ),
        );
      },
    );
  }

  void _showCompletionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Assets.icons.icHappyIcon.image(height: 70),
              16.spaceH,
              "That was beautiful!".appText(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
                color: Colors.black87,
              ),
              8.spaceH,
              "You drew your happy feeling!".appText(
                fontSize: 15,
                color: Colors.grey.shade600,
                textAlign: TextAlign.center,
              ),
              24.spaceH,
              BaseButton(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFAB47BC), Color(0xFF8E24AA)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF8E24AA).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: "Save to Journal".appText(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final bytes = await _capturePng();
                  if (bytes != null && navigatorKey.currentContext != null) {
                    navigatorKey.currentContext!
                        .read<ConnectDetailCubit>()
                        .saveDrawing(bytes);
                  }
                },
              ),

              8.spaceH,
              BaseButton(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: "Done for Today".appText(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    fontSize: 15,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Uint8List?> _capturePng() async {
    try {
      if (_globalKey.currentContext == null) return null;
      EasyLoading.show(status: "Capturing...");
      RenderRepaintBoundary? boundary =
          _globalKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) return null;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint("Error capturing png: $e");
      return null;
    } finally {
      EasyLoading.dismiss();
    }
  }
}

class ConnectDetailPainter extends CustomPainter {
  final List<DrawingStroke> strokes;
  final DrawingStroke? currentStroke;

  ConnectDetailPainter(this.strokes, this.currentStroke);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());

    for (final stroke in strokes) {
      _paintStroke(canvas, stroke);
    }
    if (currentStroke != null) {
      _paintStroke(canvas, currentStroke!);
    }

    canvas.restore();
  }

  void _paintStroke(Canvas canvas, DrawingStroke stroke) {
    if (stroke.points.isEmpty) return;
    final paint = Paint()
      ..color = stroke.color
      ..strokeWidth = stroke.width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(stroke.points.first.dx, stroke.points.first.dy);
    for (int i = 1; i < stroke.points.length; i++) {
      path.lineTo(stroke.points[i].dx, stroke.points[i].dy);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant ConnectDetailPainter oldDelegate) {
    return true;
  }
}
