import 'package:flutter/material.dart';
import 'package:motor/motor.dart';

class Pressable extends StatefulWidget {
  final VoidCallback? onTap;
  final Widget child;
  final double pressedScale;

  const Pressable({
    super.key,
    this.onTap,
    required this.child,
    this.pressedScale = 0.96,
  });

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  double _scale = 1;

  void _setPressed(bool pressed) {
    if (widget.onTap == null) return;
    setState(() => _scale = pressed ? widget.pressedScale : 1);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      child: SingleMotionBuilder(
        motion: const CupertinoMotion.smooth(),
        value: _scale,
        builder: (context, scale, child) {
          return Transform.scale(scale: scale, child: child);
        },
        child: widget.child,
      ),
    );
  }
}
