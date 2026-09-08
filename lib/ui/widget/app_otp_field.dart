import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';

class AppOtpField extends StatefulWidget {
  const AppOtpField({
    super.key,
    this.length = 4,
    this.onChanged,
    this.onCompleted,
    this.controller,
    this.value,
    this.hasError = false,
    this.autoFocus = true,
    this.enabled = true,
    this.obscureText = false,
    this.boxWidth,
    this.boxHeight,
    this.spacing,
    this.borderRadius,
    this.fillColor,
    this.activeBorderColor,
    this.errorBorderColor,
    this.defaultBorderColor,
    this.borderWidth,
    this.textStyle,
    this.mainAxisAlignment = MainAxisAlignment.start,
  }) : assert(length > 0, 'length must be greater than 0');

  /// The number of OTP digit boxes to display.
  final int length;

  /// Called whenever the OTP code changes as the user types or deletes.
  final ValueChanged<String>? onChanged;

  /// Called when all OTP boxes are filled.
  final ValueChanged<String>? onCompleted;

  /// Optional external controller for two-way synchronization.
  final TextEditingController? controller;

  /// Optional external string value to control the OTP.
  final String? value;

  /// Whether the field is in an error state.
  final bool hasError;

  /// Whether to auto focus the first box on mount.
  final bool autoFocus;

  /// Whether the input fields are enabled.
  final bool enabled;

  /// Whether to obscure text for PIN entry.
  final bool obscureText;

  /// Width of each OTP box (defaults to `56.w`).
  final double? boxWidth;

  /// Height of each OTP box (defaults to `56.h`).
  final double? boxHeight;

  /// Horizontal spacing between boxes (defaults to `14.w`).
  final double? spacing;

  /// Border radius of each box (defaults to `16.r`).
  final BorderRadius? borderRadius;

  /// Background color of each box (defaults to `Colors.white`).
  final Color? fillColor;

  /// Border color when a box is active/focused (defaults to `primaryColor`).
  final Color? activeBorderColor;

  /// Border color when `hasError` is true (defaults to `Colors.red.shade400`).
  final Color? errorBorderColor;

  /// Border color when a box is inactive and not in error (defaults to `greyColor`).
  final Color? defaultBorderColor;

  /// Border width (defaults to `1.5`).
  final double? borderWidth;

  /// Text style of the OTP digits inside the boxes.
  final TextStyle? textStyle;

  /// Main axis alignment of the row containing the boxes.
  final MainAxisAlignment mainAxisAlignment;

  @override
  State<AppOtpField> createState() => _AppOtpFieldState();
}

class _AppOtpFieldState extends State<AppOtpField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  bool _isInternalSync = false;

  @override
  void initState() {
    super.initState();
    _initControllersAndNodes();
    _syncFromExternalSource();

    widget.controller?.addListener(_onExternalControllerChanged);

    if (widget.autoFocus && widget.enabled) {
      WidgetsBinding.instance.addPostFrameCallback((Duration _) {
        if (!mounted) return;
        if (_focusNodes.isNotEmpty) {
          _focusNodes[0].requestFocus();
        }
      });
    }
  }

  void _initControllersAndNodes() {
    _controllers = List<TextEditingController>.generate(
      widget.length,
      (_) => TextEditingController(),
    );
    _focusNodes = List<FocusNode>.generate(
      widget.length,
      (int index) => FocusNode(
        onKeyEvent: (FocusNode node, KeyEvent event) {
          if (!widget.enabled) return KeyEventResult.ignored;

          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace) {
            if (_controllers[index].text.isEmpty && index > 0) {
              _focusNodes[index - 1].requestFocus();
              _controllers[index - 1].clear();
              _notifyOtpChanged();
              return KeyEventResult.handled;
            }
          }
          return KeyEventResult.ignored;
        },
      )..addListener(_onFocusChange),
    );
  }

  void _disposeControllersAndNodes() {
    for (final FocusNode node in _focusNodes) {
      node.removeListener(_onFocusChange);
      node.dispose();
    }
    for (final TextEditingController controller in _controllers) {
      controller.dispose();
    }
  }

  void _onFocusChange() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onExternalControllerChanged() {
    if (_isInternalSync) return;
    final String text = widget.controller?.text ?? '';
    _applyStringToControllers(text);
  }

  void _syncFromExternalSource() {
    final String initial = widget.controller?.text ?? widget.value ?? '';
    if (initial.isNotEmpty) {
      _applyStringToControllers(initial);
    }
  }

  void _applyStringToControllers(String text) {
    final String clean = text.replaceAll(RegExp(r'\D'), '');
    for (int i = 0; i < widget.length; i++) {
      final String char = i < clean.length ? clean[i] : '';
      if (_controllers[i].text != char) {
        _controllers[i].value = TextEditingValue(
          text: char,
          selection: TextSelection.collapsed(offset: char.length),
        );
      }
    }
  }

  String get _currentOtp {
    return _controllers.map((TextEditingController c) => c.text).join();
  }

  void _notifyOtpChanged() {
    final String otp = _currentOtp;

    if (widget.controller != null && widget.controller!.text != otp) {
      _isInternalSync = true;
      widget.controller!.text = otp;
      _isInternalSync = false;
    }

    widget.onChanged?.call(otp);

    if (otp.length == widget.length) {
      widget.onCompleted?.call(otp);
    }
  }

  void _onDigitChanged(int index, String value) {
    if (!widget.enabled) return;

    final String cleanValue = value.replaceAll(RegExp(r'\D'), '');

    if (cleanValue.isEmpty) {
      _controllers[index].clear();
      _notifyOtpChanged();
      return;
    }

    // Full paste: length or more digits
    if (cleanValue.length >= widget.length) {
      for (int i = 0; i < widget.length; i++) {
        _controllers[i].value = TextEditingValue(
          text: cleanValue[i],
          selection: const TextSelection.collapsed(offset: 1),
        );
      }
      _notifyOtpChanged();
      _focusNodes[widget.length - 1].requestFocus();
      return;
    }

    // Typing into an already filled box: replace with newly entered character
    if (cleanValue.length == 2) {
      final String newChar = cleanValue[cleanValue.length - 1];
      _controllers[index].value = TextEditingValue(
        text: newChar,
        selection: const TextSelection.collapsed(offset: 1),
      );
      _notifyOtpChanged();
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      }
      return;
    }

    // Multi-digit paste into current box position
    if (cleanValue.length > 2) {
      int targetIndex = index;
      for (
        int j = 0;
        j < cleanValue.length && targetIndex < widget.length;
        j++, targetIndex++
      ) {
        _controllers[targetIndex].value = TextEditingValue(
          text: cleanValue[j],
          selection: const TextSelection.collapsed(offset: 1),
        );
      }
      _notifyOtpChanged();
      if (targetIndex < widget.length) {
        _focusNodes[targetIndex].requestFocus();
      } else {
        _focusNodes[widget.length - 1].requestFocus();
      }
      return;
    }

    // Standard single digit input
    _controllers[index].value = TextEditingValue(
      text: cleanValue,
      selection: const TextSelection.collapsed(offset: 1),
    );
    _notifyOtpChanged();
    if (index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    } else {
      _focusNodes[index].unfocus();
    }
  }

  void _selectBoxText(int index) {
    if (!widget.enabled) return;
    _controllers[index].selection = TextSelection(
      baseOffset: 0,
      extentOffset: _controllers[index].text.length,
    );
  }

  @override
  void didUpdateWidget(covariant AppOtpField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.length != widget.length) {
      _disposeControllersAndNodes();
      _initControllersAndNodes();
      _syncFromExternalSource();
    }

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_onExternalControllerChanged);
      widget.controller?.addListener(_onExternalControllerChanged);
      _syncFromExternalSource();
    } else if (widget.value != null && widget.value != oldWidget.value) {
      if (widget.value != _currentOtp) {
        _applyStringToControllers(widget.value!);
      }
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onExternalControllerChanged);
    _disposeControllersAndNodes();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double defaultBoxWidth = 56.r;
    final double defaultBoxHeight = 56.r;
    final double defaultSpacing = 14.w;
    final BorderRadius defaultRadius = BorderRadius.circular(16.r);

    return Row(
      mainAxisAlignment: widget.mainAxisAlignment,
      children: <Widget>[
        for (int i = 0; i < widget.length; i++) ...<Widget>[
          if (i > 0) (widget.spacing ?? defaultSpacing).spaceW,
          _OtpDigitBox(
            controller: _controllers[i],
            focusNode: _focusNodes[i],
            enabled: widget.enabled,
            obscureText: widget.obscureText,
            hasError: widget.hasError,
            boxWidth: widget.boxWidth ?? defaultBoxWidth,
            boxHeight: widget.boxHeight ?? defaultBoxHeight,
            borderRadius: widget.borderRadius ?? defaultRadius,
            fillColor: widget.fillColor ?? Colors.white,
            activeBorderColor: widget.activeBorderColor ?? primaryColor,
            errorBorderColor: widget.errorBorderColor ?? Colors.red.shade400,
            defaultBorderColor: widget.defaultBorderColor ?? greyColor2,
            borderWidth: widget.borderWidth ?? 1,
            textStyle:
                widget.textStyle ??
                getTextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF212529),
                ),
            onChanged: (String value) => _onDigitChanged(i, value),
            onTap: () => _selectBoxText(i),
          ),
        ],
      ],
    );
  }
}

class _OtpDigitBox extends StatelessWidget {
  const _OtpDigitBox({
    required this.controller,
    required this.focusNode,
    required this.enabled,
    required this.obscureText,
    required this.hasError,
    required this.boxWidth,
    required this.boxHeight,
    required this.borderRadius,
    required this.fillColor,
    required this.activeBorderColor,
    required this.errorBorderColor,
    required this.defaultBorderColor,
    required this.borderWidth,
    required this.textStyle,
    required this.onChanged,
    this.onTap,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool enabled;
  final bool obscureText;
  final bool hasError;
  final double boxWidth;
  final double boxHeight;
  final BorderRadius borderRadius;
  final Color fillColor;
  final Color activeBorderColor;
  final Color errorBorderColor;
  final Color defaultBorderColor;
  final double borderWidth;
  final TextStyle textStyle;
  final ValueChanged<String> onChanged;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bool isFocused = focusNode.hasFocus;

    final Color borderColor = hasError
        ? errorBorderColor
        : (isFocused ? activeBorderColor : defaultBorderColor);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (!enabled) return;
        focusNode.requestFocus();
        onTap?.call();
      },
      child: Container(
        width: boxWidth,
        height: boxHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: borderRadius,
          border: Border.all(color: borderColor, width: borderWidth),
        ),
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          enabled: enabled,
          obscureText: obscureText,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          style: textStyle,
          cursorColor: activeBorderColor,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.zero,
            border: InputBorder.none,
            counterText: '',
          ),
          onChanged: onChanged,
          onTap: onTap,
        ),
      ),
    );
  }
}
