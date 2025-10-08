import 'package:flutter/material.dart';

class RecordingAnimation extends StatefulWidget {
  final bool isRecording;

  const RecordingAnimation({super.key, required this.isRecording});

  @override
  State<RecordingAnimation> createState() => _RecordingAnimationState();
}

class _RecordingAnimationState extends State<RecordingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _scaleAnim = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).chain(CurveTween(curve: Curves.easeInOut)).animate(_controller);

    if (widget.isRecording) _controller.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(RecordingAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.isRecording && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnim,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnim.value,
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.7),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.redAccent.withOpacity(0.5),
                  blurRadius: 20 * _scaleAnim.value,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const Icon(Icons.mic, color: Colors.white, size: 30),
          ),
        );
      },
    );
  }
}
