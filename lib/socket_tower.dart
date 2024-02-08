import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:socket_showdown/screens/game_loop.dart';

class SocketTower extends FlameGame {
  SocketTower()
      : super(
          camera: CameraComponent.withFixedResolution(width: 400, height: 700),
          world: FixedResolutionWorld(),
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // camera.viewport = FixedResolutionViewport(
    //   resolution: Vector2(400, 700),
    // );
    // camera.viewport.add(SpriteComponent(
    //   sprite: await loadSprite('logo.png'),
    //   scale: Vector2.all(0.5),
    // ));
  }
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
