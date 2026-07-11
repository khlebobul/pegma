import 'package:flutter/material.dart';

class Edgy extends StatefulWidget {
  final Widget child;
  final Axis axis;
  final bool fadeStart;
  final bool fadeEnd;

  const Edgy({
    super.key,
    required this.child,
    this.axis = Axis.vertical,
    this.fadeStart = true,
    this.fadeEnd = true,
  });

  @override
  State<Edgy> createState() => _EdgyState();
}

class _EdgyState extends State<Edgy> {
  bool _canScrollStart = false;
  bool _canScrollEnd = true;

  bool _handleScroll(ScrollNotification notification) {
    if (notification.metrics.axis != widget.axis) return false;

    final canScrollStart = notification.metrics.pixels > 0;
    final canScrollEnd =
        notification.metrics.pixels < notification.metrics.maxScrollExtent;

    if (canScrollStart != _canScrollStart || canScrollEnd != _canScrollEnd) {
      setState(() {
        _canScrollStart = canScrollStart;
        _canScrollEnd = canScrollEnd;
      });
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final isVertical = widget.axis == Axis.vertical;
    final fadeStart = widget.fadeStart && _canScrollStart;
    final fadeEnd = widget.fadeEnd && _canScrollEnd;

    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          begin: isVertical ? Alignment.topCenter : Alignment.centerLeft,
          end: isVertical ? Alignment.bottomCenter : Alignment.centerRight,
          colors: [
            fadeStart ? const Color(0x00FFFFFF) : const Color(0xFFFFFFFF),
            const Color(0xFFFFFFFF),
            const Color(0xFFFFFFFF),
            fadeEnd ? const Color(0x00FFFFFF) : const Color(0xFFFFFFFF),
          ],
          stops: const [0.0, 0.12, 0.88, 1.0],
        ).createShader(bounds);
      },
      blendMode: BlendMode.dstIn,
      child: NotificationListener<ScrollNotification>(
        onNotification: _handleScroll,
        child: widget.child,
      ),
    );
  }
}
