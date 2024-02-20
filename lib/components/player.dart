import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/image_composition.dart';
import 'package:socket_showdown/components/block_deleter.dart';
import 'package:socket_showdown/components/falling_box.dart';
import 'package:socket_showdown/components/player_stack.dart';
import 'package:socket_showdown/screens/game_loop.dart';
import 'package:socket_showdown/static/constants.dart';
import 'package:socket_showdown/static/game_state.dart';

class MyPlayer extends FallingBox {
  MyPlayer({
    required imgPath,
    required startingPosition,
    required collisionBox,
    required positionCollisionBox,
    animationName,
  }) : super(
            imgPath: imgPath,
            startingPosition: startingPosition,
            collisionBox: collisionBox,
            positionCollisionBox: positionCollisionBox,
            animationName: animationName,
            customAnchor: Anchor.topCenter);
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

    if (hitbox!.collisionType == CollisionType.active &&
        other is BlockDeleter) {
      (parent!.parent as GameLoop).resetGame();
      removeFromParent();
    }

    if (hitbox!.collisionType == CollisionType.active &&
        other.parent is PlayerStack) {
      setToPassive();
      (parent!.parent as GameLoop).givePoint();
      if (GameState.score > 1 &&
          position.y < (parent!.parent as GameLoop).size.y - 300) {
        (parent!.parent as GameLoop).lowerByValue += hitbox!.size.y / 3;
      }

      // Offset balance on collision
      // double distanceFromCenter = absolutePosition.x;
      // (other.parent as PlayerStack).balanceShift += distanceFromCenter;
      // print("Balance shift: ${(other.parent as PlayerStack).balanceShift}");

      add(ScaleEffect.to(
        Vector2(scale.x - 0.01, scale.y - 0.1),
        EffectController(
          duration: 0.1,
          alternate: true,
          infinite: false,
        ),
      ));
    }
  }

  @override
  void resetPosition() {
    position = startingPosition;
    acceleration = Constants.CUBE_WEIGHT * 0.01;
    isFalling = true;
    add(hitbox!);

    super.resetPosition();
  }
}
