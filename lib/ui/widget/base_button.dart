import 'package:flutter/material.dart';

class BaseButton extends StatefulWidget {
  const BaseButton({super.key, required this.child, required this.onTap});

  final Widget child;
  final GestureTapCallback? onTap;

  @override
  State<BaseButton> createState() => _BaseButtonState();
}

class _BaseButtonState extends State<BaseButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  static const clickAnimationDurationMillis = 200;
  double _scaleTransformValue = 1;
  double _scaleTransparentValue = 1;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: clickAnimationDurationMillis),
      lowerBound: 0.0,
      upperBound: 0.05,
    )..addListener(() {
      setState(() => _scaleTransformValue = 1 - animationController.value);
      setState(
        () => _scaleTransparentValue = (1 - (animationController.value * 12)),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      overlayColor: WidgetStateProperty.resolveWith<Color?>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.pressed)) {
          return Colors.transparent; // Color when pressed
        }
        return null;
      }),
      splashColor: Colors.transparent,
      onTapDown: (details) {
        if (widget.onTap != null) {
          _shrinkButtonSize();
        }
      },
      onTapUp: (details) {
        if (widget.onTap != null) {
          FocusManager.instance.primaryFocus?.unfocus();
          _restoreButtonSize();
          widget.onTap?.call();
        }
      },
      onTapCancel: () {
        if (widget.onTap != null) {
          _restoreButtonSize();
        }
      },
      child: Transform.scale(
        scale: _scaleTransformValue,
        child: Opacity(
          opacity: _scaleTransparentValue < 0 ? 0 : _scaleTransparentValue,
          child: widget.child,
        ),
      ),
    );
  }

  void _shrinkButtonSize() {
    animationController.forward();
  }

  void _restoreButtonSize() {
    Future.delayed(
      const Duration(milliseconds: clickAnimationDurationMillis),
      () {
        try {
          animationController.reverse();
        } catch (e) {
          e;
        }
      },
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
