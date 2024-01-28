import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:socket_showdown/components/block_deleter.dart';
import 'package:socket_showdown/components/bottom_decoration.dart';
import 'package:socket_showdown/components/crane/cable.dart';
import 'package:socket_showdown/components/player.dart';
import 'package:socket_showdown/components/player_stack.dart';
import 'package:socket_showdown/components/score_board.dart';
import 'package:socket_showdown/socket_showdown.dart';
import 'package:socket_showdown/static/game_state.dart';
import 'package:socket_showdown/utils/logger.dart';

class GameLoop extends PositionComponent
    with TapCallbacks, HasCollisionDetection, HasGameReference<GameRouter> {
  late MyPlayer player;
  late CraneCable crane;
  late BottomDecoration bottomDecoration;
  late PlayerStack playerStackComponent;
  late ScoreBoard scoreBoard;

  double lowerByValue = 0;

  @override
  Future<void> onLoad() async {
    size = Vector2(game.size.x, game.size.y);
    playerStackComponent = PlayerStack(size);
    bottomDecoration =
        BottomDecoration(startingPosition: Vector2(size.x / 2, size.y));
    playerStackComponent.players.add(bottomDecoration);

    crane = CraneCable(Vector2(size.x / 2, 0), screenWidth: size.x);
    scoreBoard = ScoreBoard(
        givenSize: Vector2(size.x / 2, size.x / 2),
        givenPosition: Vector2(size.x / 2, size.y / 2));
    add(scoreBoard);

    add(BlockDeleter(
        collisionBoxPosition: Vector2(0, size.y - 350),
        collisionBoxSize: Vector2(size.x, 100)));

    // load main-menu overlay route
    game.router.pushNamed('main-menu');
  }

  @override
  void onTapDown(TapDownEvent event) {
    debugLog("Main game tap at ${event.localPosition}");
    if (crane.enabled) {
      crane.dropBox();
    }
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
      bottomDecoration.position =
          bottomDecoration.position - Vector2(0, 200 * dt);
      if (bottomDecoration.position.y <= size.y) {
        lowerByValue = 0;
      }
    }
  }

  @override
  void onGameResize(Vector2 newSize) {
    size = newSize;
    super.onGameResize(newSize);

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
    add(MoveByEffect(
      Vector2.all(2.4),
      EffectController(
        duration: 0.1,
        alternate: true,
        infinite: false,
      ),
    ));
    print("Resetting game");
    for (final player in playerStackComponent.players) {
      player.removeFromParent();
    }
    playerStackComponent.players.clear();
    lowerByValue = -GameState.score * 50;
    playerStackComponent.players.add(bottomDecoration);
    startGame();
    GameState.score = 0;
    scoreBoard.updateScore(GameState.score);
  }

  void givePoint() {
    GameState.score++;
    scoreBoard.updateScore(GameState.score);
    lowerByValue += 50;
    crane.spawnBox();
  }

  void startGame() {
    crane.resetPosition();
    crane.spawnBox();
  }
}
