import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';

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
    this.contentPadding,
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
  final EdgeInsets? contentPadding;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)
          Column(
            children: [
              Row(
                children: [
                  (widget.title ?? "").appText(
                    fontSize: widget.titleFontSize ?? 14,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
              6.spaceH,
            ],
          ),
        Theme(
          data: Theme.of(context).copyWith(
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: primaryColor,
              selectionColor: primaryColor.withValues(alpha: 0.5),
              selectionHandleColor: primaryColor,
            ),
          ),
          child: TextField(
            textAlignVertical: TextAlignVertical.center,
            readOnly: widget.readOnly ?? false,
            enabled: !(widget.readOnly ?? false),
            keyboardType: widget.keyboardType,
            controller: widget.controller,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            obscureText: widget.obscureText,
            onChanged: widget.onChanged,
            onTap: () {
              if (widget.onFieldTap != null) {
                widget.onFieldTap!();
              }
            },
            style: getTextStyle(fontSize: 14),
            inputFormatters: widget.inputFormatters,
            decoration: InputDecoration(
              contentPadding:
                  widget.contentPadding ??
                  EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.suffixIcon,
              hintText: widget.hint,
              hintStyle:
                  widget.hintStyle ??
                  getTextStyle(fontSize: 14, color: Colors.grey.shade400),
              filled: widget.filled,
              fillColor: widget.fillColor,
              border: widget.tfType == TFTYPE.FILLED
                  ? OutlineInputBorder(
                      borderSide: BorderSide.none, // Removes the visible border
                      borderRadius: BorderRadius.circular(10),
                    )
                  : UnderlineInputBorder(),
            ),
          ),
        ),
        if (widget.showError)
          Column(
            children: [
              4.spaceH,
              Row(
                children: [
                  (widget.error ?? "").appText(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }
}

enum TFTYPE { UNDELINED, FILLED }
