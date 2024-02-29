import 'package:flutter/material.dart';

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
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(begin: 0.0, end: 300.0).animate(_controller);
    _controller.repeat(reverse: false);
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
    final Color color2 = Color.fromARGB(183, 19, 165, 255);
    final Color color1 = Color.fromARGB(166, 42, 173, 255);

    for (var i = -10; i < 14; i++) {
      double yOffset = 150.0 * i + animation.value;
      // create increasingly darker blue shapes from top to bottom
      Paint bluePaint = Paint()
        ..style = PaintingStyle.fill
        ..color = i.isEven ? color1 : color2;

      Path blue = Path();
      blue.moveTo(0, yOffset);
      blue.lineTo(size.width, yOffset + size.width / 1.732);
      blue.lineTo(size.width, yOffset + size.width / 1.732 + 150);
      blue.lineTo(0, yOffset + 150);
      blue.close();
      canvas.drawPath(blue, bluePaint);
    }

    if (size.width < size.height) {
      Paint grayPaint = Paint()
        ..color = Color(0xFF555f75)
        ..style = PaintingStyle.fill;

      Path path = Path();
      path.moveTo(0, size.height - size.width / 1.732);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();
      canvas.drawPath(path, grayPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
