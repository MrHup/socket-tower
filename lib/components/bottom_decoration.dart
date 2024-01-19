import 'package:flame/components.dart';
import 'package:socket_showdown/components/falling_box.dart';

class BottomDecoration extends FallingBox {
  BottomDecoration({required Vector2 startingPosition})
      : super(
          imgPath: 'ground.png',
          startingPosition: startingPosition,
          collisionBox: Vector2(423, 50),
          positionCollisionBox: Vector2(0, 125),
          isFalling: false,
          customAnchor: Anchor.bottomCenter,
        );
}
