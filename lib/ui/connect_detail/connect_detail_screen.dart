
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/connect_detail/bloc/connect_detail_cubit.dart';
import 'package:loving_brain/ui/connect_detail/bloc/connect_detail_state.dart';
import 'package:loving_brain/ui/widget/base_button.dart';
import '../../gen/assets.gen.dart';

class ConnectDetailScreen extends StatefulWidget {
  const ConnectDetailScreen({super.key});

  @override
  State<ConnectDetailScreen> createState() => _ConnectDetailScreenState();
}

class _ConnectDetailScreenState extends State<ConnectDetailScreen> {
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
          body: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(), // Prevent scrolling while drawing
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: context.height * 0.35, // Slightly reduced
                      width: context.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(Assets.images.imgSleepBackground.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    const Color(0xFFE0F7FA).withValues(alpha: 0.3),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              20.spaceH,
                              "Learn & Play".appText(
                                fontWeight: FontWeight.w800,
                                fontSize: 24, // Smaller
                                color: const Color(0xFFFFD54F),
                              ),
                              10.spaceH,
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: state.currentPrompt.appText(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16, // Smaller
                                  color: Colors.white,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                              ),
                              20.spaceH,
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.4),
                                    width: 1.5,
                                  ),
                                ),
                                child: "Use your finger to draw!".appText(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              20.spaceH,
                               Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Assets.icons.icBrainAi.image(height: 40),
                                  10.spaceW,
                                  Assets.icons.icHeartIcon.image(height: 40),
                                ],
                              ),
                            ],
                          ).appPadding(top: 40),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      width: context.width,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Color Palette
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _colorButton(context, state, Colors.red),
                              _colorButton(context, state, Colors.blue),
                              _colorButton(context, state, Colors.green),
                              _colorButton(context, state, const Color(0xFFFFEB3B)), // Yellow
                              _colorButton(context, state, Colors.purple),
                              _eraserButton(context, state),
                            ],
                          ),
                          20.spaceH,
                          
                          // Drawing Canvas
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              height: context.height * 0.40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.grey.shade300, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withValues(alpha: 0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  )
                                ]
                              ),
                              child: GestureDetector(
                                onPanStart: (details) {
                                  final box = context.findRenderObject() as RenderBox;
                                  final point = box.globalToLocal(details.globalPosition);
                                  // Adjust for headers etc. simplified: pass local position
                                  // Since this is inside lists/stacks, simpler to use RepaintBoundary or similar,
                                  // but localPosition from details works relative to the widget receiving the gesture.
                                  context.read<ConnectDetailCubit>().startStroke(details.localPosition);
                                },
                                onPanUpdate: (details) {
                                  context.read<ConnectDetailCubit>().updateStroke(details.localPosition);
                                },
                                onPanEnd: (details) {
                                  context.read<ConnectDetailCubit>().endStroke();
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
                          20.spaceH,
                          
                          BaseButton(
                            child: Container(
                              height: 48,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xFF9C27B0), // Purple color
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.purple.withValues(alpha: 0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: "I'm Finished!".appText(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            onTap: () {
                              _showCompletionDialog(context);
                            },
                          ),
                          20.spaceH,
                        ],
                      ),
                    ),
                  ],
                ),
                 Positioned(
                  top: 50,
                  left: 20,
                  child: BaseButton(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Assets.icons.icBackIcon.image(height: 24, width: 24),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {},
    );
  }

  Widget _colorButton(BuildContext context, ConnectDetailState state, Color color) {
    final isSelected = state.selectedColor == color;
    return GestureDetector(
      onTap: () => context.read<ConnectDetailCubit>().changeColor(color),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.black, width: 2) : Border.all(color: Colors.grey.shade300),
          boxShadow: isSelected ? [BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 4)] : [],
        ),
        child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
      ),
    );
  }

  Widget _eraserButton(BuildContext context, ConnectDetailState state) {
    final isSelected = state.selectedColor == Colors.white;
    return GestureDetector(
      onTap: () => context.read<ConnectDetailCubit>().changeColor(Colors.white),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.black, width: 2) : Border.all(color: Colors.grey.shade300),
        ),
        child: const Icon(Icons.cleaning_services_rounded, color: Colors.black54, size: 16),
      ),
    );
  }

  void _showCompletionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Assets.icons.icHappyIcon.image(height: 80),
              20.spaceH,
              "That was beautiful!".appText(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
              ),
              10.spaceH,
              "You drew your happy feeling!".appText(
                fontSize: 16,
                color: Colors.grey,
                textAlign: TextAlign.center,
              ),
              30.spaceH,
              Row(
                children: [
                  Expanded(
                    child: BaseButton(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: "Done for Today".appText(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      onTap: () {
                        // Pop dialog then pop screen
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  10.spaceW,
                  Expanded(
                     // "Save to Journal" could be added here
                     child: BaseButton(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF9C27B0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: "Save".appText(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                         // Save placeholder logic
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ConnectDetailPainter extends CustomPainter {
  final List<DrawingStroke> strokes;
  final DrawingStroke? currentStroke;

  ConnectDetailPainter(this.strokes, this.currentStroke);

  @override
  void paint(Canvas canvas, Size size) {
    // Draw all saved strokes
    for (final stroke in strokes) {
      _paintStroke(canvas, stroke);
    }
    // Draw current stroke
    if (currentStroke != null) {
      _paintStroke(canvas, currentStroke!);
    }
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
    return true; // Simple approach, always repaint on updates
  }
}
