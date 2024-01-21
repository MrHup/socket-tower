import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:flutter/material.dart';
import 'package:socket_showdown/components/animation_template.dart';
import 'package:socket_showdown/static/constants.dart';

class FallingBox extends SpriteComponent with CollisionCallbacks {
  FallingBox(
      {required this.imgPath,
      required this.startingPosition,
      required this.positionCollisionBox,
      this.collisionBox,
      this.isFalling = true,
      this.customAnchor = Anchor.topCenter})
      : super(scale: Vector2(.5, .5));

  final String imgPath;
  final Vector2? collisionBox;
  final Vector2 startingPosition;
  final Anchor customAnchor;
  Vector2 positionCollisionBox;
  bool isFalling;

  final _defaultColor = Color.fromARGB(135, 255, 86, 86);
  late ShapeHitbox hitbox;

  // gravity and acceleration
  static const double SPEED = Constants.SPEED;
  static const double CUBE_WEIGHT = Constants.CUBE_WEIGHT;
  double acceleration = CUBE_WEIGHT * 0.01;

  // tocuh effects animation
  late SkillsAnimationComponent skillsAnimationComponent;
  late Artboard skillsArtboard;

  @override
  Future<void> onLoad() async {
    // load touch down effects
    skillsArtboard = await loadArtboard(
        RiveFile.asset('assets/animations/landanimation.riv'));
    skillsAnimationComponent = SkillsAnimationComponent(skillsArtboard);

    sprite = await Sprite.load(imgPath);
    position = startingPosition;
    anchor = customAnchor;

    final defaultPaint = Paint()
      ..color = _defaultColor
      ..style = PaintingStyle.fill;

    hitbox = RectangleHitbox(size: collisionBox, position: positionCollisionBox)
      ..paint = defaultPaint
      ..renderShape = Constants.SHOW_COLLISION_BOX;

    if (isFalling == false) {
      hitbox.collisionType = CollisionType.passive;
    }

    add(hitbox);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!isFalling) return;

    position += Vector2(0, 2) * dt * SPEED * acceleration;
    acceleration += 0.02 * dt * SPEED + 0.0002 * dt * SPEED * SPEED;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    final otherFallingBox = other as FallingBox;
    otherFallingBox.spawnTouchDownEffects();
    super.onCollision(intersectionPoints, other);
  }

  void resetPosition() {
    if (skillsAnimationComponent.parent != null) {
      print("remove skillsAnimationComponent for $this");
      remove(skillsAnimationComponent);
    }
  }

  void spawnTouchDownEffects() {
    // if (this is MyPlayer) return;
    if (hitbox.collisionType == CollisionType.active) return;
    print("spawnTouchDownEffects for $this");
    skillsAnimationComponent = SkillsAnimationComponent(skillsArtboard);
    add(skillsAnimationComponent);
    skillsAnimationComponent.position = Vector2(size.x / 2, size.y / 4);
  }
}
