import 'package:flame/components.dart';
import 'package:flame/image_composition.dart';
import 'package:socket_showdown/components/player.dart';

class Printer extends MyPlayer {
  Printer({
    required startingPosition,
    animationName,
  }) : super(
          wattage: 800,
          imgPath: 'characters/printer.png',
          startingPosition: startingPosition,
          collisionBox: Vector2(266, 116),
          positionCollisionBox: Vector2(50, -10),
          animationName: animationName,
        );
}
