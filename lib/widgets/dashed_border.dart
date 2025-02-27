// lib/widgets/dashed_border.dart

import 'dart:ui';
import 'package:flutter/material.dart';

class DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double dashSpacing;
  final double borderRadius; // Added borderRadius parameter

  DashedRectPainter({
    required this.color,
    this.strokeWidth = 2.0,
    this.dashLength = 5.0,
    this.dashSpacing = 3.0,
    this.borderRadius = 12.0, // Default border radius to match note cards
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // Create a rounded rectangle path
    final Path path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(borderRadius),
      ));

    double distance = 0.0;
    for (final PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        final double currentDashLength = (distance + dashLength > pathMetric.length)
            ? pathMetric.length - distance
            : dashLength;
        final Path extractPath =
            pathMetric.extractPath(distance, distance + currentDashLength);
        canvas.drawPath(extractPath, paint);
        distance += dashLength + dashSpacing;
      }
    }
  }

  @override
  bool shouldRepaint(DashedRectPainter oldDelegate) => false;
}

class DashedBorder extends StatelessWidget {
  final Widget child;
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double dashSpacing;
  final double borderRadius; // Added borderRadius parameter

  const DashedBorder({
    Key? key,
    required this.child,
    this.color = Colors.grey,
    this.strokeWidth = 2.0,
    this.dashLength = 5.0,
    this.dashSpacing = 3.0,
    this.borderRadius = 12.0, // Default border radius to match note cards
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashedRectPainter(
        color: color,
        strokeWidth: strokeWidth,
        dashLength: dashLength,
        dashSpacing: dashSpacing,
        borderRadius: borderRadius, // Pass the borderRadius
      ),
      child: child,
    );
  }
}
