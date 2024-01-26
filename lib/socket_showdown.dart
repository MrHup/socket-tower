import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:socket_showdown/components/block_deleter.dart';
import 'package:socket_showdown/components/bottom_decoration.dart';
import 'package:socket_showdown/components/crane/cable.dart';
import 'package:socket_showdown/components/player.dart';
import 'package:socket_showdown/components/player_stack.dart';
import 'package:socket_showdown/static/game_state.dart';
import 'package:socket_showdown/utils/logger.dart';

class SocketShowdown extends FlameGame
    with TapCallbacks, HasCollisionDetection {
  late MyPlayer player;
  late CraneCable crane;
  late BottomDecoration bottomDecoration;
  late PlayerStack playerStackComponent;

  double lowerByValue = 0;

  @override
  Future<void> onLoad() async {
    playerStackComponent = PlayerStack(size);
    bottomDecoration =
        BottomDecoration(startingPosition: Vector2(size.x / 2, size.y));
    playerStackComponent.players.add(bottomDecoration);

    crane = CraneCable(Vector2(size.x / 2, 0), screenWidth: size.x);

    add(BlockDeleter(
        collisionBoxPosition: Vector2(0, size.y - 350),
        collisionBoxSize: Vector2(size.x, 100)));
  }

  @override
  void onTapDown(TapDownEvent event) {
    debugLog("Tap down at ${event.localPosition}");
    // paused = !paused;
    paused = false;

    if (crane.enabled == true) {
      print("drop");
      crane.dropBox();
    } else {
      print("spawn");
      crane.spawnBox();
    }
    // bottomDecoration.position = bottomDecoration.position + Vector2(0, 20);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (lowerByValue > 0) {
      lowerByValue -= 1;
      playerStackComponent.players.forEach((element) {
        element.position = element.position + Vector2(0, 100 * dt);
      });
    }
    if (lowerByValue < 0) {
      lowerByValue += 2;
      playerStackComponent.players.forEach((element) {
        element.position = element.position - Vector2(0, 200 * dt);
      });
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    debugLog('Game resized to $size');
  }

  @override
  void render(Canvas canvas) {
    canvas.save();

    playerStackComponent.parent ??= this;
    crane.parent ??= this;

    canvas.restore();

    super.render(canvas);
  }

  void resetGame() {
    for (final player in playerStackComponent.players) {
      player.removeFromParent();
    }
    playerStackComponent.players.clear();
    lowerByValue = -GameState.score * 50;
    playerStackComponent.players.add(bottomDecoration);
    remove(crane);
    crane = CraneCable(Vector2(size.x / 2, 0), screenWidth: size.x);

    GameState.score = 0;
  }

  void givePoint() {
    GameState.score++;
    print(GameState.score);
    lowerByValue += 50;
  }
}
