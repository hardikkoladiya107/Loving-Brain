import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';

import 'base_button.dart';

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
    this.fillColor = Colors.white,
    this.showAddButton = false,
    this.showInfoButton = false,
  });

  final String? title;
  final String? hint;
  final bool showAddButton;
  final bool showInfoButton;
  final Color fillColor;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onAddButtonTap;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;

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
                  (widget.title ?? "").appText(fontSize: 14),
                  if (widget.showInfoButton) ...[
                    6.spaceW,
                    BaseButton(
                      child: Icon(
                        CupertinoIcons.info,
                        size: 14,
                        color: Colors.grey,
                      ),
                      onTap: () {},
                    ),
                  ],
                  if (widget.showAddButton) ...[10.spaceW, _addButton()],
                ],
              ),
              8.spaceH,
            ],
          ),
        Theme(
          data: Theme.of(context).copyWith(
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: primaryColor, // Cursor color
              selectionColor: primaryColor.withValues(
                alpha: 0.5,
              ), // Highlighted text background color
              selectionHandleColor: primaryColor, // Thumb (handle) color
            ),
          ),
          child: TextField(
            keyboardType: widget.keyboardType,
            controller: widget.controller,
            onChanged: widget.onChanged,
            style: getTextStyle(),
            inputFormatters: widget.inputFormatters,
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: getTextStyle(
                fontSize: 14,
                color: Colors.grey.shade400,
              ),
              filled: true,
              fillColor: widget.fillColor,
              border: OutlineInputBorder(
                borderSide: BorderSide.none, // Removes the visible border
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    ).appPadding(left: 20, right: 20, top: 20);
  }

  Widget _addButton() {
    return BaseButton(
      onTap: widget.onAddButtonTap,
      child: Container(
        height: 20,
        width: 20,
        decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle),
        child: Center(child: Icon(Icons.add, color: Colors.white, size: 15)),
      ),
    );
  }
}
