import 'dart:math' as math;
import 'package:flutter/material.dart';

class SquigglyContainer extends StatelessWidget {
  final Widget child;
  final Color borderColor;
  final Color backgroundColor;
  final double strokeWidth;
  final EdgeInsets? padding;
  final double wavelength;
  final double amplitude;
  final int seed;

  const SquigglyContainer({
    super.key,
    required this.child,
    this.borderColor = const Color(0xFF3B82F6),
    this.backgroundColor = Colors.white,
    this.strokeWidth = 3.0,
    this.padding,
    this.wavelength = 10.0,
    this.amplitude = 2.0,
    this.seed = 100,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SquigglyBorderPainter(
        borderColor: borderColor,
        backgroundColor: backgroundColor,
        strokeWidth: strokeWidth,
        wavelength: wavelength,
        amplitude: amplitude,
        seed: seed,
      ),
      child: Container(width: double.infinity, padding: padding, child: child),
    );
  }
}

class _SquigglyBorderPainter extends CustomPainter {
  final Color borderColor;
  final Color backgroundColor;
  final double strokeWidth;
  final double wavelength;
  final double amplitude;
  final int seed;

  _SquigglyBorderPainter({
    required this.borderColor,
    required this.backgroundColor,
    required this.strokeWidth,
    required this.wavelength,
    required this.amplitude,
    required this.seed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final math.Random random = math.Random(seed);

    final Paint strokePaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final Paint fillPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    final path = Path();

    final double cornerRadius = 15.0;

    path.moveTo(cornerRadius, 0);

    _drawDisturbedLine(
      path: path,
      start: Offset(cornerRadius, 0),
      end: Offset(size.width - cornerRadius, 0),
      axis: Axis.horizontal,
      random: random,
    );

    path.quadraticBezierTo(size.width, 0, size.width, cornerRadius);

    _drawDisturbedLine(
      path: path,
      start: Offset(size.width, cornerRadius),
      end: Offset(size.width, size.height - cornerRadius),
      axis: Axis.vertical,
      random: random,
    );

    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width - cornerRadius,
      size.height,
    );

    _drawDisturbedLine(
      path: path,
      start: Offset(size.width - cornerRadius, size.height),
      end: Offset(cornerRadius, size.height),
      axis: Axis.horizontal,
      random: random,
    );

    path.quadraticBezierTo(0, size.height, 0, size.height - cornerRadius);

    _drawDisturbedLine(
      path: path,
      start: Offset(0, size.height - cornerRadius),
      end: Offset(0, cornerRadius),
      axis: Axis.vertical,
      random: random,
    );

    path.quadraticBezierTo(0, 0, cornerRadius, 0);

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);
  }

  void _drawDisturbedLine({
    required Path path,
    required Offset start,
    required Offset end,
    required Axis axis,
    required math.Random random,
  }) {
    double length = (axis == Axis.horizontal)
        ? (end.dx - start.dx)
        : (end.dy - start.dy);

    int sign = length > 0 ? 1 : -1;
    length = length.abs();

    int count = (length / wavelength).round();
    if (count == 0) count = 1;

    double segmentLength = length / count;

    for (int i = 0; i < count; i++) {
      double startDist = i * segmentLength;
      double endDist = (i + 1) * segmentLength;

      double midDist = startDist + (segmentLength / 2);

      double randomSkew = (random.nextDouble() - 0.5) * (segmentLength * 0.4);

      double randomAmpFactor = 0.5 + (random.nextDouble());
      double currentAmp = amplitude * randomAmpFactor;

      double controlAmp = (i % 2 == 0 ? 1 : -1) * currentAmp;

      if (axis == Axis.horizontal) {
        double targetX = start.dx + (sign * endDist);

        double controlX = start.dx + (sign * (midDist + randomSkew));

        path.quadraticBezierTo(
          controlX,
          start.dy + controlAmp,
          targetX,
          start.dy,
        );
      } else {
        double targetY = start.dy + (sign * endDist);

        double controlY = start.dy + (sign * (midDist + randomSkew));

        path.quadraticBezierTo(
          start.dx + controlAmp,
          controlY,
          start.dx,
          targetY,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SquigglyBorderPainter oldDelegate) {
    return oldDelegate.borderColor != borderColor ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.wavelength != wavelength ||
        oldDelegate.amplitude != amplitude ||
        oldDelegate.seed != seed;
  }
}
