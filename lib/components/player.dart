import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/image_composition.dart';
import 'package:socket_showdown/components/block_deleter.dart';
import 'package:socket_showdown/components/falling_box.dart';
import 'package:socket_showdown/components/player_stack.dart';
import 'package:socket_showdown/socket_showdown.dart';
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
  void render(Canvas c) {
    if (Constants.SHOW_COLLISION_BOX) {
      super.renderDebugMode(c);
    }
    super.render(c);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    acceleration = 0;
    isFalling = false;

    // print("onCollision with $other");
    if (hitbox.collisionType == CollisionType.active && other is BlockDeleter) {
      (parent!.parent as SocketShowdown).resetGame();
      removeFromParent();
    }

    if (hitbox.collisionType == CollisionType.active &&
        other.parent is PlayerStack) {
      setToPassive();
      position = absolutePosition;
      (parent!.parent as SocketShowdown).givePoint();
    }
  }

  @override
  void resetPosition() {
    position = startingPosition;
    acceleration = Constants.CUBE_WEIGHT * 0.01;
    isFalling = true;
    add(hitbox);

    super.resetPosition();
  }
}
