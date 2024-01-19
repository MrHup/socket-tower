import 'package:flame/components.dart';
import 'package:socket_showdown/components/falling_box.dart';
import 'package:socket_showdown/static/constants.dart';

class MyPlayer extends FallingBox {
  MyPlayer({required Vector2 startingPosition})
      : super(
          imgPath: 'player.png',
          startingPosition: startingPosition,
          collisionBox: Vector2(201, 125),
          positionCollisionBox: Vector2(0, 67),
        );

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    acceleration = 0;
    // remove collider
    remove(hitbox);
    isFalling = false;
  }

  void resetPosition() {
    position = startingPosition;
    acceleration = Constants.CUBE_WEIGHT * 0.01;
    isFalling = true;
    add(hitbox);
  }
}
