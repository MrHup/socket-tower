import 'package:flame/components.dart';
import 'package:socket_showdown/components/player.dart';
// import 'package:socket_showdown/components/crane/top_piece.dart';

class CraneCable extends SpriteComponent {
  CraneCable(this.startingPosition, {required this.screenWidth})
      : super(scale: Vector2(1, 1));

  final Vector2 startingPosition;
  final double screenWidth;
  double speed = 150;
  final Vector2 offset = Vector2(0, -600);
  final double easeDuration = 1.5;

  int direction = 1; // 1 for moving down, -1 for moving up
  double easeTime = 0;

  bool enabled = true;
  late MyPlayer player;

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load("crane_body.png");
    anchor = Anchor.topCenter;
    position = startingPosition + offset;

    player = MyPlayer(startingPosition: Vector2(0, scaledSize.y));
    player.isFalling = false;
    player.parent = this;

    // final craneTop = CraneTop(Vector2(size.x / 2, 0) - offset + Vector2(0, 40));
    // add(craneTop);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (position.x <= 0 || position.x >= screenWidth) {
      direction *= -1; // Change direction
      easeTime = 0; // Reset easeTime for the new direction
      position.x = position.x.clamp(0, screenWidth); // Clamp position
    }
    easeTime = (easeTime + dt) < easeDuration ? (easeTime + dt) : easeDuration;

    // Calculate the eased time using the easing function
    double easedTime = easeInOutQuad(easeTime / easeDuration);

    // Calculate the new x-coordinate with easing
    double newX = position.x + direction * easedTime * speed * dt;

    // Calculate the corresponding y-coordinate based on isometric linear equation
    double newY = 0.575 * newX - 450;
    position = Vector2(newX, newY);
  }

  double easeInOutQuad(double t) {
    return t < 0.5 ? 2 * t * t : -1 + (4 - 2 * t) * t;
  }

  void dropBox() {
    enabled = false;
    player.isFalling = true;
    print("Old parent is ${player.parent}");
    print(player.hitbox.collisionType);
    player.parent = parent;

    print("New parent is ${player.parent}");
    player.position = absolutePosition + Vector2(0, scaledSize.y);
  }

  void spawnBox() {
    enabled = true;
    player = MyPlayer(startingPosition: Vector2(0, scaledSize.y));
    player.isFalling = false;
    player.parent = this;
  }
}
