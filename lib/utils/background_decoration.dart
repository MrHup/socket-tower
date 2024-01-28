import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class BackgroundDecoration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CurvePainter(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Container(),
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint grayPaint = Paint()
      ..color = Color(0xFF555f75)
      ..style = PaintingStyle.fill;
    Paint bluePaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = ui.Gradient.linear(
        Offset(0, size.height / 2),
        Offset(size.width, size.height - size.height / 2),
        [Color.fromARGB(255, 63, 177, 238), Color.fromARGB(64, 27, 157, 228)],
      );
    Paint bluePaint2 = Paint()
      ..style = PaintingStyle.fill
      ..shader = ui.Gradient.linear(
        Offset(0, size.height / 3),
        Offset(size.width, size.height - size.height / 6),
        [Color.fromARGB(255, 73, 191, 255), Color.fromARGB(64, 53, 182, 252)],
      );
    Paint bluePaint3 = Paint()
      ..style = PaintingStyle.fill
      ..shader = ui.Gradient.linear(
        Offset(0, size.height / 5),
        Offset(size.width, size.height - size.height / 2),
        [Color.fromARGB(255, 145, 217, 255), Color.fromARGB(64, 78, 191, 252)],
      );

    Paint bluePaint4 = Paint()
      ..style = PaintingStyle.fill
      ..shader = ui.Gradient.linear(
        Offset(0, size.height / 5),
        Offset(size.width, size.height - size.height / 2),
        [Color.fromARGB(255, 179, 228, 255), Color.fromARGB(64, 122, 208, 255)],
      );

    Path blue4 = Path();
    blue4.moveTo(0, size.height / 15);
    blue4.lineTo(size.width, size.height - size.height / 1.5);
    blue4.lineTo(size.width, size.height);
    blue4.lineTo(0, size.height);
    blue4.close();
    canvas.drawPath(blue4, bluePaint4);

    Path blue3 = Path();
    blue3.moveTo(0, size.height / 5);
    blue3.lineTo(size.width, size.height - size.height / 2);
    blue3.lineTo(size.width, size.height);
    blue3.lineTo(0, size.height);
    blue3.close();
    canvas.drawPath(blue3, bluePaint3);

    Path blue2 = Path();
    blue2.moveTo(0, size.height / 3);
    blue2.lineTo(size.width, size.height - size.height / 3);
    blue2.lineTo(size.width, size.height);
    blue2.lineTo(0, size.height);
    blue2.close();
    canvas.drawPath(blue2, bluePaint2);

    Path blue1 = Path();
    blue1.moveTo(0, size.height / 2);
    blue1.lineTo(size.width, size.height - size.height / 6);
    blue1.lineTo(size.width, size.height);
    blue1.lineTo(0, size.height);
    blue1.close();
    canvas.drawPath(blue1, bluePaint);

    // lower gray shape
    Path path = Path();
    path.moveTo(0, size.height / 1.65);
    path.lineTo(size.width, size.height - size.height / 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, grayPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
