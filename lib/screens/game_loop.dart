import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_showdown/components/block_deleter.dart';
import 'package:socket_showdown/components/bottom_decoration.dart';
import 'package:socket_showdown/components/crane/cable.dart';
import 'package:socket_showdown/components/player.dart';
import 'package:socket_showdown/components/player_stack.dart';
import 'package:socket_showdown/components/score_board.dart';
import 'package:socket_showdown/socket_tower.dart';
import 'package:socket_showdown/static/constants.dart';
import 'package:socket_showdown/static/game_state.dart';
import 'package:socket_showdown/static/sound_player.dart';

class GameLoop extends PositionComponent
    with TapCallbacks, HasCollisionDetection, HasGameReference<SocketTower> {
  late MyPlayer player;
  late CraneCable crane;
  late BottomDecoration bottomDecoration;
  late PlayerStack playerStackComponent;
  late ScoreBoard scoreBoard;
  late SharedPreferences preferences;

  double lowerByValue = 0;

  @override
  Future<void> onLoad() async {
    print("GAME LOOP LOADED");
    preferences = await SharedPreferences.getInstance();
    size = Vector2(game.size.x, game.size.y);
    playerStackComponent = PlayerStack(size);
    bottomDecoration =
        BottomDecoration(startingPosition: Vector2(size.x / 2, size.y));
    playerStackComponent.players.add(bottomDecoration);

    crane = CraneCable(screenSize: size);
    scoreBoard = ScoreBoard(
        givenSize: Vector2(size.x / 2, size.x / 2),
        givenPosition: Vector2(size.x / 2, size.y / 2));
    add(scoreBoard);

    add(BlockDeleter(
        collisionBoxPosition: Vector2(-2000, size.y - 350),
        collisionBoxSize: Vector2(6000, 200)));
    add(BlockDeleter(
        collisionBoxPosition: Vector2(0, 3 * size.y),
        collisionBoxSize: Vector2(size.x * 3, 200)));

    SoundPlayer.loadPool();
  }

  @override
  void onRemove() {
    SoundPlayer.dispose();
  }

  void tapDown() {
    if (crane.enabled) {
      crane.dropBox();
      SoundPlayer.playDrop();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (lowerByValue > 0) {
      double offset = Constants.SPEED * dt * 1.5;
      lowerByValue -= offset;
      playerStackComponent.players.forEach((element) {
        element.position = element.position + Vector2(0, offset);
      });
    }
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
    // shake the screen
    add(MoveByEffect(
      Vector2.all(2.4),
      EffectController(
        duration: 0.1,
        alternate: true,
        infinite: false,
      ),
    ));

    for (final player in playerStackComponent.players) {
      player.removeFromParent();
    }
    playerStackComponent.players.clear();
    if (bottomDecoration.parent != null) bottomDecoration.removeFromParent();
    bottomDecoration =
        BottomDecoration(startingPosition: Vector2(size.x / 2, size.y));
    bottomDecoration.parent ??= this;
    playerStackComponent.players.add(bottomDecoration);

    // set best score
    if (GameState.score > GameState.bestScore) {
      GameState.bestScore = GameState.score;
      preferences.setInt('best', GameState.bestScore);
    }

    playerStackComponent.balanceShift = 0;
    playerStackComponent.position = Vector2(size.x / 2, size.y);

    // startGame();
    game.overlays.add('replay-menu');
    SoundPlayer.playSmash();
  }

  void givePoint() {
    add(MoveByEffect(
      Vector2.all(5),
      EffectController(
        duration: 0.2,
        alternate: true,
        infinite: false,
      ),
    ));
    GameState.score++;
    scoreBoard.updateScore(GameState.score);
    crane.spawnBox();
    SoundPlayer.playKey();
  }

  void startGame() {
    GameState.score = 0;
    scoreBoard.updateScore(GameState.score);
    crane.resetPosition();
    crane.spawnBox();
    SoundPlayer.startBgMusic();
  }
}
