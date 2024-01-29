import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class BlockDeleter extends ShapeComponent with CollisionCallbacks {
  BlockDeleter({
    required this.collisionBoxPosition,
    this.collisionBoxSize,
  }) : super(scale: Vector2(1, 1));

  final Vector2? collisionBoxSize;
  Vector2 collisionBoxPosition;

  final _defaultColor = const Color.fromARGB(255, 255, 37, 37);
  late ShapeHitbox hitbox;
  @override
  Future<void> onLoad() async {
    position = collisionBoxPosition;
    size = collisionBoxSize ?? Vector2(100, 100);

    final defaultPaint = Paint()
      ..color = _defaultColor
      ..style = PaintingStyle.fill;

    hitbox = RectangleHitbox(
      isSolid: true,
      position: collisionBoxPosition,
      size: collisionBoxSize,
    )
      ..paint = defaultPaint
      ..renderShape = true;

    add(hitbox);
  }
}
