import 'package:flame/components.dart';

class MyPlayer extends SpriteComponent {
  MyPlayer() : super(scale: Vector2(.5, .5));

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('player.png');
  }
}
