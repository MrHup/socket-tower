import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:socket_showdown/static/game_state.dart';

class FadingText extends ShapeComponent {
  FadingText({required this.wattage, required this.newPosition})
      : super(scale: Vector2(1, 1));

  double? textSize;
  final int wattage;
  final Vector2 newPosition;

  @override
  Future<void> onLoad() async {
    if (wattage < 500) {
      textSize = 30;
    } else if (wattage < 1000) {
      textSize = 35;
    } else {
      textSize = 40;
    }
    GameState.totalWattage += wattage;
    position = newPosition;
    final regular = TextPaint(
      style: TextStyle(
        fontSize: textSize,
        color: Color.fromARGB(190, 255, 213, 76),
        fontFamily: 'TitleFont',
      ),
    );
    anchor = Anchor.center;
    size = Vector2(300, 100);

    print("Loaded faded text");
    final textComponent = TextComponent(
      text: '+${wattage}W',
      anchor: Anchor.center,
      textRenderer: regular,
      position: Vector2(size.x / 2, size.y / 2),
    );

    final effect = MoveByEffect(
      Vector2(0, -50),
      EffectController(duration: 0.5),
    );

    final removeEffect = RemoveEffect(delay: 0.5);

    add(textComponent);
    add(effect);
    add(removeEffect);

    super.onLoad();
  }
}
