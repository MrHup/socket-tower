import 'package:flutter/material.dart';

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
    Paint paint = Paint()
      ..color = Color(0xFF555f75)
      ..style = PaintingStyle.fill;

    Path path = Path();

    // Move to the starting point at the left center
    path.moveTo(0, size.height / 1.65);

    // Draw the curve to the bottom right
    // Draw straight line to the bottom right
    path.lineTo(size.width, size.height - size.height / 20);
    // path.quadraticBezierTo(
    //   size.width / 2,
    //   size.height,
    //   size.width,
    //   size.height / 2,
    // );

    // Draw a straight line to the bottom left
    path.lineTo(size.width, size.height);

    // Draw a straight line to the bottom left
    path.lineTo(0, size.height);

    // Close the path to form a closed shape
    path.close();

    // Draw the path on the canvas
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
