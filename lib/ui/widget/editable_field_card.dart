import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';

class EditableFieldCard extends StatefulWidget {
  final String label;
  final String value;
  final String? hintText;
  final VoidCallback? onEdit;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final bool readOnly;

  const EditableFieldCard({
    super.key,
    required this.label,
    required this.value,
    this.hintText,
    this.onEdit,
    this.onTap,
    this.onChanged,
    this.readOnly = false,
  });

  @override
  State<EditableFieldCard> createState() => _EditableFieldCardState();
}

class _EditableFieldCardState extends State<EditableFieldCard> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void didUpdateWidget(EditableFieldCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && _controller.text != widget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isFocused ? const Color(0xFF673AB7) : Colors.transparent,
          width: _isFocused ? 1.5 : 0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.label.appText(
                  fontSize: 14.sp,
                  color: greyColor11,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.start,
                ),
                TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  readOnly: widget.readOnly,
                  onTap: widget.onTap ?? (widget.readOnly ? widget.onEdit : null),
                  onChanged: widget.onChanged,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: greyColor9,
                    fontFamily: "Outfit",
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintText:
                        widget.hintText ??
                        'Enter ${widget.label.toLowerCase()}',
                    hintStyle: TextStyle(
                      fontSize: 16.sp,
                      color: greyColor,
                      fontFamily: "Outfit",
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (widget.onEdit != null) ...[
            16.spaceW,
            InkWell(
              onTap: () {
                if (!widget.readOnly) {
                  _focusNode.requestFocus();
                }
                widget.onEdit?.call();
              },
              child: Image.asset(
                Assets.v2.icons.icEditField.path,
                width: 24.sp,
                height: 24.sp,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
