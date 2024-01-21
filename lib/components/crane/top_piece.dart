import 'package:flame/components.dart';

class CraneTop extends SpriteComponent {
  CraneTop(this.startingPosition) : super(scale: Vector2(.75, .75));

  final Vector2 startingPosition;
  double speed = 100;

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load("crane_base.png");
    anchor = Anchor.topCenter;
    position = startingPosition;
  }

  @override
  void update(double dt) {
    super.update(dt);

    // position += Vector2(0, 2) * dt * speed;
    // acceleration += 0.02 * dt * SPEED + 0.0002 * dt * SPEED * SPEED;
  }
}
