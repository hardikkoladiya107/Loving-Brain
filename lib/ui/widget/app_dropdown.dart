import 'package:flutter/material.dart';

class AppDropDownButton extends StatefulWidget {
  const AppDropDownButton({
    super.key,
    required this.child,
    required this.dropDownWidget,
    this.offset = const Offset(0, 65),
  });

  final Widget child;
  final Offset offset;
  final Widget Function(void Function() close) dropDownWidget;

  @override
  State<AppDropDownButton> createState() => _AppDropDownButtonState();
}

class _AppDropDownButtonState extends State<AppDropDownButton> {
  final GlobalKey _dropdownKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  void _showDropdown() {
    final RenderBox renderBox =
        _dropdownKey.currentContext!.findRenderObject() as RenderBox;

    final Size widgetSize = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              GestureDetector(
                child: Container(
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
                onTap: () {
                  _removeDropdown();
                },
              ),
              Positioned(
                width: widgetSize.width,
                child: CompositedTransformFollower(
                  link: _layerLink,
                  showWhenUnlinked: false,
                  offset: widget.offset,
                  child: Material(
                    elevation: 0.0,
                    surfaceTintColor: Colors.transparent,
                    color: Colors.transparent,
                    child: widget.dropDownWidget(() {
                      _removeDropdown();
                    }),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        key: _dropdownKey,
        child: widget.child,
        onTap: () {
          if (_overlayEntry == null) {
            _showDropdown();
          } else {
            _removeDropdown();
          }
        },
      ),
    );
  }
}
