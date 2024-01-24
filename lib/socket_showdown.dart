import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:socket_showdown/components/bottom_decoration.dart';
import 'package:socket_showdown/components/crane/cable.dart';
import 'package:socket_showdown/components/player.dart';
import 'package:socket_showdown/components/player_stack.dart';
import 'package:socket_showdown/utils/logger.dart';

class SocketShowdown extends FlameGame
    with TapCallbacks, HasCollisionDetection {
  late MyPlayer player;
  late CraneCable crane;
  late BottomDecoration bottomDecoration;
  late PlayerStack playerStackComponent;

  @override
  Future<void> onLoad() async {
    playerStackComponent = PlayerStack(size);
    bottomDecoration =
        BottomDecoration(startingPosition: Vector2(size.x / 2, size.y));
    playerStackComponent.players.add(bottomDecoration);

    crane = CraneCable(Vector2(size.x / 2, 0), screenWidth: size.x);
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
}
