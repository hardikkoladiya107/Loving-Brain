import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.title,
    this.error,
    this.hint,
    this.controller,
    this.onChanged,
    this.height,
    this.onAddButtonTap,
    this.inputFormatters,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.titleFontSize,
    this.titleColor,
    this.titleStyle,
    this.titleUppercase = true,
    this.style,
    this.contentPadding,
    this.borderRadius,
    this.focusNode,
    this.fillColor = Colors.white,
    this.tfType = TFTYPE.FILLED,
    this.showAddButton = false,
    this.showInfoButton = false,
    this.filled = true,
    this.readOnly,
    this.maxLines,
    this.minLines,
    this.hintStyle,
    this.obscureText = false,
    this.showError = true,
    this.onFieldTap,
  });

  final String? title;
  final String? error;
  final double? titleFontSize;
  final Color? titleColor;
  final TextStyle? titleStyle;
  final bool titleUppercase;
  final TextStyle? style;
  final double? height;
  final int? maxLines;
  final int? minLines;
  final String? hint;
  final TextStyle? hintStyle;
  final bool showAddButton;
  final bool showError;
  final bool obscureText;
  final bool showInfoButton;
  final bool? readOnly;
  final bool filled;
  final Color fillColor;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final Function? onFieldTap;
  final GestureTapCallback? onAddButtonTap;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TFTYPE? tfType;
  final EdgeInsetsGeometry? contentPadding;
  final BorderRadius? borderRadius;
  final FocusNode? focusNode;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  FocusNode? _focusNode;

  FocusNode get _effectiveFocusNode =>
      widget.focusNode ?? (_focusNode ??= FocusNode());

  @override
  void didUpdateWidget(covariant AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      if (oldWidget.focusNode == null && widget.focusNode != null) {
        _focusNode?.dispose();
        _focusNode = null;
      }
    }
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool hasTitle =
        widget.title != null && widget.title!.trim().isNotEmpty;
    final bool isMultiline =
        (widget.minLines != null && widget.minLines! > 1) ||
        (widget.maxLines != null && widget.maxLines! > 1);

    Widget? trailingIcon = widget.suffixIcon;
    if (trailingIcon == null) {
      if (widget.showAddButton) {
        trailingIcon = BaseButton(
          onTap: widget.onAddButtonTap,
          child: Icon(Icons.add, color: primaryColor, size: 22.r),
        );
      } else if (widget.showInfoButton) {
        trailingIcon = Icon(
          Icons.info_outline,
          color: const Color(0xFFADB5BD),
          size: 20.r,
        );
      }
    }

    final BorderRadius containerRadius =
        widget.borderRadius ??
        (widget.tfType == TFTYPE.FILLED
            ? BorderRadius.circular(24.r)
            : BorderRadius.zero);

    final BoxDecoration containerDecoration = BoxDecoration(
      color: widget.filled ? widget.fillColor : Colors.transparent,
      borderRadius: containerRadius,
      border: widget.tfType == TFTYPE.FILLED
          ? null
          : Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1.5)),
    );

    final EdgeInsetsGeometry effectivePadding =
        widget.contentPadding ??
        EdgeInsets.only(
          left: 22.w,
          right: trailingIcon != null ? 12.w : 22.w,
          top: hasTitle ? 14.h : 16.h,
          bottom: hasTitle ? 14.h : 16.h,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (widget.onFieldTap != null) {
              widget.onFieldTap!();
            }
            if (!(widget.readOnly ?? false)) {
              _effectiveFocusNode.requestFocus();
            }
          },
          child: Container(
            height: widget.height,
            constraints: BoxConstraints(
              minHeight: widget.height ?? (hasTitle ? 72.h : 54.h),
            ),
            padding: effectivePadding,
            decoration: containerDecoration,
            child: Row(
              crossAxisAlignment: isMultiline
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: <Widget>[
                if (widget.prefixIcon != null) ...<Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      top: isMultiline && hasTitle ? 4.h : 0,
                    ),
                    child: widget.prefixIcon!,
                  ),
                  12.w.spaceW,
                ],
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      if (hasTitle) ...<Widget>[
                        Text(
                          widget.titleUppercase
                              ? widget.title!.toUpperCase()
                              : widget.title!,
                          style:
                              widget.titleStyle ??
                              getTextStyle(
                                fontSize: (widget.titleFontSize ?? 11).sp,
                                fontWeight: FontWeight.w600,
                                color:
                                    widget.titleColor ??
                                    const Color(0xFFADB5BD),
                                letterSpacing: 0.8,
                              ),
                          textAlign: TextAlign.start,
                        ),
                        4.h.spaceH,
                      ],
                      Theme(
                        data: Theme.of(context).copyWith(
                          textSelectionTheme: TextSelectionThemeData(
                            cursorColor: primaryColor,
                            selectionColor: primaryColor.withValues(alpha: 0.5),
                            selectionHandleColor: primaryColor,
                          ),
                        ),
                        child: TextField(
                          focusNode: _effectiveFocusNode,
                          textAlignVertical: isMultiline
                              ? TextAlignVertical.top
                              : TextAlignVertical.center,
                          readOnly: widget.readOnly ?? false,
                          enabled: !(widget.readOnly ?? false),
                          keyboardType: widget.keyboardType,
                          controller: widget.controller,
                          maxLines: widget.obscureText ? 1 : widget.maxLines,
                          minLines: widget.obscureText ? 1 : widget.minLines,
                          obscureText: widget.obscureText,
                          onChanged: widget.onChanged,
                          onTap: () {
                            if (widget.onFieldTap != null) {
                              widget.onFieldTap!();
                            }
                          },
                          style:
                              widget.style ??
                              getTextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF212529),
                              ),
                          inputFormatters: widget.inputFormatters,
                          cursorColor: primaryColor,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            hintText: widget.hint,
                            hintStyle:
                                widget.hintStyle ??
                                getTextStyle(
                                  fontSize: 16.sp,
                                  color: const Color(0xFFADB5BD),
                                  fontWeight: FontWeight.w400,
                                ),
                            filled: false,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (trailingIcon != null) ...<Widget>[
                  10.w.spaceW,
                  trailingIcon,
                ],
              ],
            ),
          ),
        ),
        if (widget.showError &&
            widget.error != null &&
            widget.error!.trim().isNotEmpty) ...<Widget>[
          6.h.spaceH,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: <Widget>[
                widget.error!.appText(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

enum TFTYPE { UNDELINED, FILLED }
