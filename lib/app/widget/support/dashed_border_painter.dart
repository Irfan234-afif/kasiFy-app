import 'package:flutter/material.dart';

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final BorderRadius borderRadius;

  DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashSpace,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double x = 0;

    // Top border
    while (x < size.width) {
      double length = x + dashWidth;
      if (length > size.width) {
        length = size.width;
      }
      Path path = Path();
      path.moveTo(x, 0);
      path.lineTo(length, 0);
      canvas.drawPath(path, paint);
      x += dashWidth + dashSpace;
    }

    // Right border
    double y = 0;
    while (y < size.height) {
      double length = y + dashWidth;
      if (length > size.height) {
        length = size.height;
      }
      Path path = Path();
      path.moveTo(size.width, y);
      path.lineTo(size.width, length);
      canvas.drawPath(path, paint);
      y += dashWidth + dashSpace;
    }

    // Bottom border
    x = size.width;
    while (x > 0) {
      double length = x - dashWidth;
      if (length < 0) {
        length = 0;
      }
      Path path = Path();
      path.moveTo(x, size.height);
      path.lineTo(length, size.height);
      canvas.drawPath(path, paint);
      x -= dashWidth + dashSpace;
    }

    // Left border
    y = size.height;
    while (y > 0) {
      double length = y - dashWidth;
      if (length < 0) {
        length = 0;
      }
      Path path = Path();
      path.moveTo(0, y);
      path.lineTo(0, length);
      canvas.drawPath(path, paint);
      y -= dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
