import 'dart:math' as math;
import 'package:flutter/material.dart';

class RotatingCircleText extends StatefulWidget {
  final String text;
  final double radius;
  final TextStyle textStyle;
  final Duration rotationDuration;

  const RotatingCircleText({
    super.key,
    required this.text,
    required this.radius,
    required this.textStyle,
    required this.rotationDuration,
  });

  @override
  RotatingCircleTextState createState() => RotatingCircleTextState();
}

class RotatingCircleTextState extends State<RotatingCircleText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.rotationDuration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.radius * 2, widget.radius * 2),
          painter: _HalfCircleTextPainter(
            text: widget.text,
            radius: widget.radius,
            textStyle: widget.textStyle,
            progress: _controller.value,
          ),
        );
      },
    );
  }
}

class _HalfCircleTextPainter extends CustomPainter {
  final String text;
  final double radius;
  final TextStyle textStyle;
  final double progress;

  _HalfCircleTextPainter({
    required this.text,
    required this.radius,
    required this.textStyle,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double totalAngle = 2 * math.pi;

    double rotation = progress * totalAngle;

    _drawArcText(
      canvas,
      text: text,
      centerX: centerX,
      centerY: centerY,
      radius: radius,
      startAngle: -math.pi,
      sweepAngle: math.pi,
      rotation: rotation,
    );

    _drawArcText(
      canvas,
      text: text,
      centerX: centerX,
      centerY: centerY,
      radius: radius,
      startAngle: 0,
      sweepAngle: math.pi,
      rotation: rotation,
    );
  }

  void _drawArcText(
    Canvas canvas, {
    required String text,
    required double centerX,
    required double centerY,
    required double radius,
    required double startAngle,
    required double sweepAngle,
    required double rotation,
  }) {
    final anglePerChar = sweepAngle / text.length;

    for (int i = 0; i < text.length; i++) {
      final charAngle = startAngle + i * anglePerChar + rotation;
      final char = text[i];

      final tp = TextPainter(
        text: TextSpan(text: char, style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();

      final x = centerX + radius * math.cos(charAngle);
      final y = centerY + radius * math.sin(charAngle);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(charAngle + math.pi / 2);
      tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
