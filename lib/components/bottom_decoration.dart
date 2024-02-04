import 'package:flame/components.dart';
import 'package:socket_showdown/components/falling_box.dart';

class BottomDecoration extends FallingBox {
  BottomDecoration({required Vector2 startingPosition})
      : super(
          imgPath: 'ground.png',
          startingPosition: startingPosition,
          collisionBox: Vector2(423, 240),
          positionCollisionBox: Vector2(100, 120),
          isFalling: false,
          customAnchor: Anchor.bottomCenter,
        );

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    if (gameSize.x > gameSize.y) {
      scale = Vector2(.7, .7);
    } else {
      scale = Vector2(.5, 0.5);
    }
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    setToPassive();
  }
}
