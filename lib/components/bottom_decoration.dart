import 'package:flame/components.dart';

class BottomDecoration extends SpriteComponent {
  BottomDecoration() : super(scale: Vector2(.5, .5));

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('ground.png');
  }
}
