import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.title,
    this.hint,
    this.controller,
    this.onChanged,
    this.onAddButtonTap,
    this.inputFormatters,
    this.keyboardType,
    this.prefixIcon,
    this.fillColor = Colors.white,
    this.tfType = TFTYPE.FILLED,
    this.showAddButton = false,
    this.showInfoButton = false,
    this.filled = true,
    this.readOnly,
  });

  final String? title;
  final String? hint;
  final bool showAddButton;
  final bool showInfoButton;
  final bool? readOnly;
  final bool filled;
  final Color fillColor;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onAddButtonTap;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final TFTYPE? tfType;

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
              Row(children: [(widget.title ?? "").appText(fontSize: 14)]),
              8.spaceH,
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
            readOnly: widget.readOnly ?? false,
            keyboardType: widget.keyboardType,
            controller: widget.controller,
            onChanged: widget.onChanged,
            style: getTextStyle(),
            inputFormatters: widget.inputFormatters,
            decoration: InputDecoration(
              prefixIcon: widget.prefixIcon,
              hintText: widget.hint,
              hintStyle: getTextStyle(
                fontSize: 14,
                color: Colors.grey.shade400,
              ),
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
      ],
    );
  }
}

enum TFTYPE { UNDELINED, FILLED }
