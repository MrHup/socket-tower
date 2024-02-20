import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:flutter/material.dart';
import 'package:socket_showdown/components/animation_template.dart';
import 'package:socket_showdown/components/block_deleter.dart';
import 'package:socket_showdown/static/constants.dart';

class FallingBox extends PositionComponent with CollisionCallbacks {
  FallingBox(
      {required this.imgPath,
      required this.startingPosition,
      required this.positionCollisionBox,
      this.animationName,
      this.collisionBox,
      this.isFalling = true,
      this.customAnchor = Anchor.bottomCenter})
      : super(scale: Vector2(.5, .5));

  final String imgPath;
  final Vector2? collisionBox;
  final Vector2 startingPosition;
  final Anchor customAnchor;
  final String? animationName;
  Vector2 positionCollisionBox;
  bool isFalling;

  final _defaultColor = Color.fromARGB(135, 255, 86, 86);
  ShapeHitbox? hitbox;

  int id = 0;
  static int BOX_COUNT = 0;

  // gravity and acceleration
  static const double SPEED = Constants.SPEED;
  static const double CUBE_WEIGHT = Constants.CUBE_WEIGHT;
  double acceleration = CUBE_WEIGHT * 0.01;

  @override
  Future<void> onLoad() async {
    id = BOX_COUNT++;

    position = startingPosition;
    anchor = customAnchor;

    if (animationName != null) {
      final boxArtboard = await loadArtboard(
          RiveFile.asset('assets/animations/$animationName.riv'));
      final boxAnimation = SkillsAnimationComponent(boxArtboard, animationName!)
        ..anchor = customAnchor;
      add(boxAnimation);
    } else {
      // spawn sprite instead of animation
      final sprite = SpriteComponent()
        ..sprite = await Sprite.load(imgPath)
        ..anchor = customAnchor;
      add(sprite);
    }

    final defaultPaint = Paint()
      ..color = _defaultColor
      ..style = PaintingStyle.fill;

    // make parallelogram hitbox
    Vector2 startingPos = positionCollisionBox;
    Vector2 startingSize = collisionBox ?? size;

    hitbox = PolygonHitbox([
      startingPos,
      startingPos + Vector2(startingSize.x / 2, startingSize.y / 2),
      startingPos +
          Vector2(startingSize.x / 2, startingSize.y + startingSize.y / 2),
      startingPos + Vector2(0, startingSize.y),
    ])
      ..paint = defaultPaint
      ..anchor = Anchor.bottomRight
      ..renderShape = Constants.SHOW_COLLISION_BOX;

    add(hitbox!);
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
    // spawnTouchDownEffects(other); // might have to await
    super.onCollision(intersectionPoints, other);
  }

  void resetPosition() {
    // if (skillsAnimationComponent!.parent != null) {
    //   remove(skillsAnimationComponent!);
    // }
  }

  void setToPassive() {
    hitbox!.collisionType = CollisionType.passive;
  }

  Future<void> spawnTouchDownEffects(PositionComponent other) async {
    if (hitbox!.collisionType == CollisionType.passive ||
        other is BlockDeleter) {
      return;
    }

    final touchEffectArtboard = await loadArtboard(
        RiveFile.asset('assets/animations/landanimation.riv'));
    final touchAnimation =
        SkillsAnimationComponent(touchEffectArtboard, "touch")
          ..anchor = customAnchor;
    touchAnimation.position = Vector2(0, hitbox!.size.y / 4);
    add(touchAnimation);
  }
}
