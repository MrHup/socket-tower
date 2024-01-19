import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:socket_showdown/components/bottom_decoration.dart';
import 'package:socket_showdown/components/player.dart';
import 'package:socket_showdown/utils.dart/logger.dart';

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

class SocketShowdown extends FlameGame with TapCallbacks {
  var player = MyPlayer();
  static const double SPEED = 100;

  @override
  Future<void> onLoad() async {
    var bottomDecoration = BottomDecoration();
    await add(bottomDecoration);
    bottomDecoration.position = Vector2(
        size.x / 2 - bottomDecoration.scaledSize.x / 2,
        size.y - bottomDecoration.scaledSize.y);

    await add(player);
    player.position = Vector2(size.x / 2 - player.scaledSize.x / 2, 20);
  }

  @override
  void onTapDown(TapDownEvent event) {
    // Do something in response to a tap eventR
    debugLog("Tap down at ${event.localPosition}");
  }

  @override
  void update(double dt) {
    super.update(dt);
    // print(dt);

    // add gravity to player
    // player will fall down until it hits stack top or is out of bounds
    player.position += Vector2(0, 2) * dt * SPEED;

    if (player.position.y > size.y) {
      player.position = Vector2(size.x / 2 - player.scaledSize.x / 2, 20);
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    // change layout based on gameSize
    debugLog('Game resized to $size');
  }
}
