import 'dart:async';
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:socket_showdown/components/crane/top_piece.dart';
import 'package:socket_showdown/components/player.dart';
import 'package:socket_showdown/components/players/player_factory.dart';
import 'package:socket_showdown/screens/game_loop.dart';
import 'package:socket_showdown/static/game_state.dart';

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

  int currentWattage = 0;

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

    final Vector2 limit = Vector2(50, screenSize.x - 50);

    if (position.x <= limit.x || position.x >= limit.y) {
      direction *= -1; // Change direction
      easeTime = 0; // Reset easeTime for the new direction
      position.x = position.x.clamp(limit.x, limit.y); // Clamp position
    }
    easeTime = (easeTime + dt) < easeDuration ? (easeTime + dt) : easeDuration;

    // Calculate the eased time using the easing function
    double easedTime = easeInOutQuad(easeTime / easeDuration);

    // Compute incremental speed based on score
    double increment = 2.973 +
        (0.085 - 1.973) / (1 + math.pow((GameState.score / 5.14), 2.39));

    // Calculate the new x-coordinate with easing
    double newX = position.x + direction * easedTime * speed * increment * dt;

    // Calculate the corresponding y-coordinate based on isometric linear equation
    double newY = 0.575 * newX - 300;
    position = Vector2(newX, newY);
  }

  double easeInOutQuad(double t) {
    return t < 0.5 ? 2 * t * t : -1 + (4 - 2 * t) * t;
  }

  void dropBox() {
    enabled = false;
    player.isFalling = true;
    double offsetX = (parent as GameLoop).playerStackComponent.balanceShiftX;
    double offsetY = (parent as GameLoop).playerStackComponent.balanceShiftY;
    player.position = Vector2(
        position.x + offsetX, position.y + absoluteScaledSize.y + offsetY);
    player.parent = (parent as GameLoop).playerStackComponent;
    (parent as GameLoop).playerStackComponent.players.add(player);
  }

  void spawnBox() {
    print("Spawning box");
    enabled = true;
    player = PlayerFactory.createPlayer(
        Vector2(absoluteScaledSize.x / 2, absoluteScaledSize.y));
    player.isFalling = false;
    player.parent = this;
    player.anchor = Anchor.topLeft;

    currentWattage = player.wattage;
  }

  void resetPosition() {
    position = Vector2(screenSize.x / 2, -absoluteScaledSize.y / 2);
    direction = 1;
  }
}
