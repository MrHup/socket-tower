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

    final Color color2 = Color(0xFF058bde);
    final Color color1 = Color.fromARGB(36, 22, 157, 241);

    for (var i = -1; i < 5; i++) {
      double yOffset = 150.0 * i + animation.value;
      // create increasingly darker blue shapes from top to bottom
      Paint bluePaint = Paint()
        ..style = PaintingStyle.fill
        ..color = Color.lerp(color1, color2, i / 5)!;

      Path blue = Path();
      blue.moveTo(0, yOffset);
      blue.lineTo(size.width, yOffset + size.width / 1.732);
      blue.lineTo(size.width, yOffset + size.width / 1.732 + 150);
      blue.lineTo(0, yOffset + 150);
      blue.close();
      canvas.drawPath(blue, bluePaint);
    }

    Path path = Path();
    path.moveTo(0, size.height - size.width / 1.732);
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
