import 'package:flutter/material.dart';
import 'package:foharmalai/config/constants/app_colors.dart';

class TornPaperPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = AppColors.white
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height - 20);

    double zigzagWidth = 20.0;
    double zigzagHeight = 10.0;
    bool isUp = true;

    for (double x = 0; x < size.width; x += zigzagWidth) {
      if (isUp) {
        path.lineTo(x, size.height - 20 - zigzagHeight);
      } else {
        path.lineTo(x, size.height - 20 + zigzagHeight);
      }
      isUp = !isUp;
    }

    path.lineTo(size.width, size.height - 20);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
