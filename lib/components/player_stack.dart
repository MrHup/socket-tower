import 'package:flame/components.dart';
import 'package:flutter/rendering.dart';
import 'package:socket_showdown/components/falling_box.dart';

/// This is the component responsible for handling the player stack
/// cusotom behaviour and rendering the players based on their position
/// on imaginary z-axis.
class PlayerStack extends PositionComponent {
  PlayerStack(Vector2 size)
      : super(
          size: size,
          position: Vector2(0, 0),
        );

  List<FallingBox> players = [];

  @override
  void render(Canvas canvas) {
    for (var element in players) {
      element.parent ??= this;
    }
    super.render(canvas);
  }
}
