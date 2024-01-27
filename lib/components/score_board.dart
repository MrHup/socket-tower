import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ScoreBoard extends CircleComponent {
  ScoreBoard({required this.givenSize, required this.givenPosition})
      : super(scale: Vector2(1, 1));

  final Vector2 givenSize;
  final Vector2 givenPosition;
  final regular = TextPaint(
    style: const TextStyle(
      fontSize: 84.0,
      color: Color(0x79ffffff),
      fontFamily: 'TitleFont',
    ),
  );

  late TextComponent textComponent;

  final _defaultColor = const Color(0x07000000);
  late ShapeHitbox hitbox;
  @override
  Future<void> onLoad() async {
    anchor = Anchor.center;
    position = givenPosition;
    size = givenSize;
    paint = Paint()..color = _defaultColor;

    textComponent = TextComponent(
      text: '0',
      anchor: Anchor.center,
      textRenderer: regular,
      position: Vector2(size.x / 2, size.y / 2),
    );

    add(textComponent);
    super.onLoad();
  }

  void updateScore(int score) {
    textComponent.text = score.toString();
  }
}
