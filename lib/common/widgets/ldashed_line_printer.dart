import 'dart:ui';

import 'package:demandium/feature/language/controller/localization_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LDashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blueGrey[200]!
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke;

    Path path = Path();

    if (Get.find<LocalizationController>().isLtr) {
      // For LTR (Left-to-Right)
      path.moveTo(size.width * 0.1, 0); // Start at the middle top
      path.lineTo(size.width * 0.1, size.height * 0.7); // Vertical line down
      path.arcToPoint(
        Offset(size.width * 0.2, size.height * 1), // Curve to the right
        radius: const Radius.circular(20), // Adjust radius for smoother curve
        clockwise: false,
      );
      path.lineTo(size.width, size.height * 1); // Horizontal line to the right
    } else {
      // For RTL (Right-to-Left)
      path.moveTo(size.width * 0.9, 0); // Start at the middle top on the right side
      path.lineTo(size.width * 0.9, size.height * 0.7); // Vertical line down
      path.arcToPoint(
        Offset(size.width * 0.8, size.height * 1), // Curve to the left
        radius: const Radius.circular(20), // Adjust radius for smoother curve
        clockwise: true,
      );
      path.lineTo(0, size.height * 1); // Horizontal line to the left
    }

    _drawDashedLine(canvas, path, paint);
  }

  void _drawDashedLine(Canvas canvas, Path path, Paint paint) {
    double dashWidth = 3.0, dashSpace = 3.0; // Adjusted dash spacing
    double distance = 0.0;

    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        canvas.drawPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}


