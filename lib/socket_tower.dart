import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:socket_showdown/screens/game_loop.dart';

class SocketTower extends FlameGame with ScrollDetector, ScaleDetector {
  SocketTower()
      : super(
          camera: CameraComponent.withFixedResolution(width: 400, height: 700),
          world: FixedResolutionWorld(),
        );
}

class FixedResolutionWorld extends World
    with HasGameReference, TapCallbacks, DoubleTapCallbacks {
  @override
  Future<void> onLoad() async {
    add(
      GameLoop()..anchor = Anchor.center,
    );
    super.onLoad();
  }
}
