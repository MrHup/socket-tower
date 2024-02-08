import 'dart:async';

import 'package:flame/components.dart';
import 'package:socket_showdown/components/crane/top_piece.dart';
import 'package:socket_showdown/components/player.dart';
import 'package:socket_showdown/screens/game_loop.dart';

class CraneCable extends SpriteComponent {
  CraneCable({required this.screenSize}) : super(scale: Vector2(1, 1));

  Vector2 screenSize;
  double speed = 150;
  final Vector2 offset = Vector2(0, -600);
  final double easeDuration = 1.5;

  int direction = 1; // 1 for moving down, -1 for moving up
  double easeTime = 0;

  bool enabled = false;
  late MyPlayer player;

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load("crane_body.png");
    anchor = Anchor.topCenter;
    position = Vector2(screenSize.x / 2, -absoluteScaledSize.y / 2);

    final craneTop = CraneTop(Vector2(size.x / 2, 0));
    add(craneTop);
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    resetPosition();
  }

  @override
  void update(double dt) {
    super.update(dt);

    final Vector2 limit = screenSize.x > screenSize.y
        ? screenSize.x > 1000
            ? Vector2(screenSize.x / 2 - 200, screenSize.x / 2 + 200)
            : Vector2(screenSize.x / 4, screenSize.x / 4 * 3)
        : Vector2(0, screenSize.x);

    if (position.x <= limit.x || position.x >= limit.y) {
      direction *= -1; // Change direction
      easeTime = 0; // Reset easeTime for the new direction
      position.x = position.x.clamp(limit.x, limit.y); // Clamp position
    }
    easeTime = (easeTime + dt) < easeDuration ? (easeTime + dt) : easeDuration;

    // Calculate the eased time using the easing function
    double easedTime = easeInOutQuad(easeTime / easeDuration);

    // Calculate the new x-coordinate with easing
    double newX = position.x + direction * easedTime * speed * dt;

    // Calculate the corresponding y-coordinate based on isometric linear equation
    double newY = screenSize.x > screenSize.y
        ? 0.575 * newX - size.y - screenSize.y / 2 + 200
        : 0.575 * newX - 300;
    position = Vector2(newX, newY);
  }

  double easeInOutQuad(double t) {
    return t < 0.5 ? 2 * t * t : -1 + (4 - 2 * t) * t;
  }

  void dropBox() {
    enabled = false;
    player.isFalling = true;
    print(position);
    player.position = Vector2(position.x, position.y + absoluteScaledSize.y);
    player.parent = (parent as GameLoop).playerStackComponent;
    (parent as GameLoop).playerStackComponent.players.add(player);
  }

  void spawnBox() {
    print("Spawning box");
    enabled = true;
    player = MyPlayer(
        startingPosition:
            Vector2(absoluteScaledSize.x / 2, absoluteScaledSize.y));
    player.isFalling = false;
    player.parent = this;
    player.anchor = Anchor.topLeft;
  }

  void resetPosition() {
    position = Vector2(screenSize.x / 2, -absoluteScaledSize.y / 2);
    direction = 1;
  }
}
