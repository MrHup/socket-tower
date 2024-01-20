import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:socket_showdown/components/animation_template.dart';
import 'package:socket_showdown/components/bottom_decoration.dart';
import 'package:socket_showdown/components/player.dart';
import 'package:socket_showdown/utils.dart/logger.dart';

import 'package:rive/rive.dart';

// main game loop will be designed here
// Structure ----
// Tap to Play Menu
// Game loop
// --------------

// Game loop
// player class will be swinged from top LEFT to top RIGHT side of the screen
// on tap, the player will drop until it hits stack top or is out of bounds
// if the player hits stack top, then
// an object will be created at top of stack visually identical to player
// player will be resetted to the top middle of the screen
// stack will go down by stack last height using a tween animation

class SocketShowdown extends FlameGame
    with TapCallbacks, HasCollisionDetection {
  late MyPlayer player;

  @override
  Future<void> onLoad() async {
    var bottomDecoration =
        BottomDecoration(startingPosition: Vector2(size.x / 2, size.y));
    await add(bottomDecoration);

    player = MyPlayer(startingPosition: Vector2(size.x / 2, 20));
    await add(player);

    final skillsArtboard = await loadArtboard(
        RiveFile.asset('assets/animations/landanimation.riv'));
    add(SkillsAnimationComponent(skillsArtboard));
  }

  @override
  void onTapDown(TapDownEvent event) {
    debugLog("Tap down at ${event.localPosition}");
    paused = !paused;
    player.resetPosition();
  }

  @override
  void update(double dt) {
    super.update(dt);
    // print(dt);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    // change layout based on gameSize
    debugLog('Game resized to $size');
  }
}
