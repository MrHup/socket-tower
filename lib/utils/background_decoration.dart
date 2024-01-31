import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class BackgroundDecoration extends StatefulWidget {
  const BackgroundDecoration({super.key});

  @override
  State<BackgroundDecoration> createState() => _BackgroundDecorationState();
}

class _BackgroundDecorationState extends State<BackgroundDecoration>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 0.0, end: 100.0).animate(_controller);
    _controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CurvePainter(_animation),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Container(),
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  final Animation<double> animation;

  CurvePainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    Paint grayPaint = Paint()
      ..color = Color(0xFF555f75)
      ..style = PaintingStyle.fill;

    for (var i = -1; i < 5; i++) {
      double yOffset = 150.0 * i + animation.value;
      // create increasingly darker blue shapes from top to bottom
      Paint bluePaint = Paint()
        ..style = PaintingStyle.fill
        ..shader = ui.Gradient.linear(
          Offset(0, size.height / 2),
          Offset(size.width, size.height - size.height / 2),
          [
            Color.fromARGB(110 + i * 5 * 10, 104, 201, 253),
            Color.fromARGB(60 + i * 5 * 10, 17, 169, 253)
          ],
        );

      Path blue = Path();
      blue.moveTo(0, yOffset);
      blue.lineTo(size.width, yOffset + size.width / 1.732);
      blue.lineTo(size.width, yOffset + size.width / 1.732 + 150);
      blue.lineTo(0, yOffset + 150);
      blue.close();
      canvas.drawPath(blue, bluePaint);
    }

    double startingHeight =
        size.width > size.height ? size.height / 10 : size.height / 1.75;
    Path path = Path();
    path.moveTo(0, startingHeight);
    path.lineTo(size.width, startingHeight + size.width / 1.732);
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
