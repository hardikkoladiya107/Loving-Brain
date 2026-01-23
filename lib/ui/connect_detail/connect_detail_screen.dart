
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
        if (state.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          body: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Stack(
              children: [
                // Background Image
                Container(
                  height: context.height,
                  width: context.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(Assets.images.imgSleepBackground.path),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                
                // Content
                Column(
                  children: [
                    // Top Section with Prompt
                    SafeArea(
                      bottom: false,
                      child: Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        child: Column(
                          children: [
                             // Header Title
                             Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                                    ),
                                    child: "Learn & Play".appText(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                               ],
                             ),
                             24.spaceH,

                             // Prompt Card
                             Container(
                               width: double.infinity,
                               padding: const EdgeInsets.all(24),
                               decoration: BoxDecoration(
                                 color: Colors.white.withOpacity(0.15),
                                 borderRadius: BorderRadius.circular(24),
                                 border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.5),
                                 boxShadow: [
                                   BoxShadow(
                                     color: Colors.black.withOpacity(0.1),
                                     blurRadius: 20,
                                     offset: const Offset(0, 10),
                                   ),
                                 ],
                               ),
                               child: Column(
                                 children: [
                                    // Main Prompt
                                    state.currentPrompt.appText(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white,
                                      textAlign: TextAlign.center,
                                      height: 1.3,
                                    ),
                                    
                                    if (state.promptModel != null) ...[
                                      16.spaceH,
                                      Divider(color: Colors.white.withOpacity(0.3), thickness: 1),
                                      16.spaceH,
                                      // Hints
                                      if (state.promptModel!.hint1.isNotEmpty)
                                        _buildHintParams("Hint 1", state.promptModel!.hint1),
                                      if (state.promptModel!.hint2.isNotEmpty) ...[
                                         12.spaceH,
                                        _buildHintParams("Hint 2", state.promptModel!.hint2),
                                      ],
                                    ],
                                 ],
                               ),
                             ),
                          ],
                        ),
                      ),
                    ),
                    
                    20.spaceH,
                    
                    // Drawing Area Container - White Sheet Effect
                    Container(
                      width: context.width,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 30,
                            offset: Offset(0, -10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          24.spaceH,
                          // Tools Row
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                "Your Canvas".appText(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                ),
                                Row(
                                  children: [
                                     _eraserButton(context, state),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          16.spaceH,
                          
                          // Color Palette
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                              children: [
                                _colorButton(context, state, Colors.red),
                                12.spaceW,
                                _colorButton(context, state, Colors.blue),
                                12.spaceW,
                                _colorButton(context, state, Colors.green),
                                12.spaceW,
                                _colorButton(context, state, const Color(0xFFFFEB3B)), // Yellow
                                12.spaceW,
                                _colorButton(context, state, Colors.purple),
                                12.spaceW,
                                _colorButton(context, state, Colors.orange),
                                12.spaceW,
                                _colorButton(context, state, Colors.teal),
                                12.spaceW,
                                _colorButton(context, state, Colors.black),
                              ],
                            ),
                          ),
                          24.spaceH,

                          // Canvas
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            height: context.height * 0.45,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: Colors.grey.shade200, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.08),
                                  blurRadius: 15,
                                  spreadRadius: 5,
                                  offset: const Offset(0, 5),
                                )
                              ]
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: GestureDetector(
                                onPanStart: (details) {
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
                          
                          32.spaceH,
                          
                          // Finish Button
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: BaseButton(
                              child: Container(
                                height: 56,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFFAB47BC), Color(0xFF8E24AA)],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF8E24AA).withOpacity(0.4),
                                      blurRadius: 15,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.check_circle_outline, color: Colors.white),
                                    10.spaceW,
                                    "I'm Finished!".appText(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      letterSpacing: 0.5,
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                _showCompletionDialog(context);
                              },
                            ),
                          ),
                          40.spaceH,
                        ],
                      ),
                    ),
                  ],
                ),

                // Back Button (Floating)
                Positioned(
                  top: 50,
                  left: 20,
                  child: BaseButton(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.5)),
                      ),
                      child: Assets.icons.icBackIcon.image(height: 24, width: 24, color: Colors.white),
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
  
  Widget _buildHintParams(String label, String text) {
     return Row(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         Container(
           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
           decoration: BoxDecoration(
             color: Colors.white.withOpacity(0.3),
             borderRadius: BorderRadius.circular(8),
           ),
           child: label.appText(
             fontSize: 12,
             fontWeight: FontWeight.w700,
             color: Colors.white,
           ),
         ),
         10.spaceW,
         Expanded(
           child: text.appText(
             fontSize: 14, 
             fontWeight: FontWeight.w500,
             color: Colors.white.withOpacity(0.9),
             height: 1.4,
           ),
         )
       ],
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
