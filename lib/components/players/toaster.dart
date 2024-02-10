import 'package:flame/components.dart';
import 'package:flame/image_composition.dart';
import 'package:socket_showdown/components/player.dart';

class Toaster extends MyPlayer {
  Toaster({
    required startingPosition,
    animationName,
  }) : super(
          imgPath: 'characters/toaster.png',
          startingPosition: startingPosition,
          collisionBox: Vector2(201, 125),
          positionCollisionBox: Vector2(50, -20),
          animationName: animationName,
        );
}
