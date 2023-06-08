import 'package:flutter/material.dart';

mixin OverlayStateMixin<T extends StatefulWidget> on State<T> {
  OverlayEntry? _overlayEntry;
  bool get isOverlayShown => _overlayEntry != null;

  void removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Widget _dismissibleOverlay(Widget child) => Stack(
        alignment: Alignment.topRight,
        children: [
          const Positioned(
            child: ColoredBox(
              color: Colors.white24,
            ),
          ),
          child,
        ],
      );

  void _insertOverlay(Widget child) {
    _overlayEntry = OverlayEntry(
      builder: (_) => _dismissibleOverlay(child),
    );

    Overlay.of(context)?.insert(_overlayEntry!);
  }

  void toggleOverlay(Widget child) =>
      isOverlayShown ? removeOverlay() : _insertOverlay(child);

  @override
  void dispose() {
    removeOverlay();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    removeOverlay();
    super.didChangeDependencies();
  }
}
