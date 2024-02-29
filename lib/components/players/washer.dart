import 'package:flame/components.dart';
import 'package:flame/image_composition.dart';
import 'package:socket_showdown/components/player.dart';

class Washer extends MyPlayer {
  Washer({
    required startingPosition,
    animationName,
  }) : super(
          wattage: 500,
          imgPath: 'characters/washer.png',
          startingPosition: startingPosition,
          collisionBox: Vector2(201, 136),
          positionCollisionBox: Vector2(50, -10),
          animationName: animationName,
        );
}
