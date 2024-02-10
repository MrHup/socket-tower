import 'package:flame/components.dart';
import 'package:flame/image_composition.dart';
import 'package:socket_showdown/components/player.dart';

class Lamp extends MyPlayer {
  Lamp({
    required startingPosition,
    animationName,
  }) : super(
          imgPath: 'characters/lamp.png',
          startingPosition: startingPosition,
          collisionBox: Vector2(201, 136),
          positionCollisionBox: Vector2(50, -10),
          animationName: animationName,
        );
}
