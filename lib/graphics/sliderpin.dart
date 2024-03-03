import 'package:flutter/material.dart';

class CustomSliderThumbCircle extends SliderComponentShape {
  final double thumbRadius;
  final double overlayRadius;

  CustomSliderThumbCircle({
    required this.thumbRadius,
    required this.overlayRadius,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final paint = Paint()
      ..color = Color(0xffe94057)
      ..style = PaintingStyle.fill;

    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final paintStroke = Paint()
      ..color = Color(0xffe94057)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final rRect = RRect.fromRectAndRadius(
        Rect.fromCircle(center: center, radius: thumbRadius),
        Radius.circular(thumbRadius * 0.9));

    canvas.drawRRect(rRect, paint);
    canvas.drawRRect(rRect, paintStroke);

    canvas.drawCircle(center, overlayRadius, whitePaint);
  }
}

class CustomSliderOverlayShape extends SliderComponentShape {
  final double overlayRadius;

  CustomSliderOverlayShape({required this.overlayRadius});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(overlayRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required Size sizeWithOverflow,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double textScaleFactor,
    required double value,
  }) {
    if (activationAnimation.value == 0.0) {
      return;
    }

    final Canvas canvas = context.canvas;

    final paint = Paint()
      ..color = Color(0xffe94057)
      ..style = PaintingStyle.fill;

    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final size = Size.fromRadius(overlayRadius);

    canvas.drawCircle(center, overlayRadius * activationAnimation.value, paint);
    canvas.drawCircle(center, overlayRadius, whitePaint);
  }
}
