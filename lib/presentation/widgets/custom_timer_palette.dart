import 'dart:ui' as ui;
import 'package:flutter/material.dart';


class CustomTimePainter extends CustomPainter {
  CustomTimePainter({
    required this.animation,
    required this.backgroundColor,
    required this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = backgroundColor;
    canvas.clipRect(Offset.zero & size);
    canvas.drawPaint(paint);

    final top = ui.lerpDouble(0, size.height, animation.value)!;

    Rect rect = Rect.fromLTRB(0, 0, size.width, top);
    Path path = Path()..addRect(rect);

    canvas.drawPath(path, paint..color = color);
  }

  @override
  bool shouldRepaint(CustomTimePainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}