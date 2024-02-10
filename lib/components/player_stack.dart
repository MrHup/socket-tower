import 'package:flame/components.dart';
import 'package:flutter/rendering.dart';
import 'package:socket_showdown/components/falling_box.dart';
import 'package:socket_showdown/screens/game_loop.dart';

/// This is the component responsible for handling the player stack
/// cusotom behaviour and rendering the players based on their position
/// on imaginary z-axis.
class PlayerStack extends PositionComponent {
  PlayerStack(Vector2 size)
      : super(
          size: size,
          position: Vector2(size.x / 2, size.y),
        );

  List<FallingBox> players = [];
  bool rotateLeft = true;
  double balanceShift = 0;

  @override
  void render(Canvas canvas) {
    maintanance();
    sortPlayers();
    super.render(canvas);
  }

  @override
  void update(double dt) {
    super.update(dt);
    rotateStack();
    anchor = Anchor.bottomCenter;
  }

  void rotateStack() {
    if (rotateLeft) {
      angle -= balanceShift / 5000000;
    } else {
      angle += balanceShift / 5000000;
    }

    if (angle <= -0.1) {
      rotateLeft = false;
    } else if (angle >= 0.1) {
      rotateLeft = true;
    }
  }

  void maintanance() {
    // clean up players that are out of bounds
    for (var i = 0; i < players.length; i++) {
      players[i].parent = this;
      if (players[i].hitbox == null) {
        continue; // TODO: experiment with break for better performance
      }
      if (players[i].position.y >
              (parent as GameLoop).absoluteScaledSize.y +
                  players[i].hitbox!.absoluteScaledSize.y &&
          players[i].isFalling == false) {
        print("Removing player");
        players[i].removeFromParent();
        players.removeAt(i);
        continue;
      }
    }
  }

  bool isOverlap(FallingBox A, FallingBox B) {
    if (A.hitbox == null || B.hitbox == null) return false;
    if (B.hitbox!.absolutePosition.x + B.hitbox!.absoluteScaledSize.x <
            A.hitbox!.absolutePosition.x ||
        A.hitbox!.absolutePosition.x + A.hitbox!.absoluteScaledSize.x <
            B.hitbox!.absolutePosition.x) {
      return false;
    }
    return true;
  }

  int shouldLower(FallingBox A, FallingBox B) {
    final x1 = A.hitbox!.absolutePosition.x;
    final y1 = A.hitbox!.absolutePosition.y;
    final x2 = B.hitbox!.absolutePosition.x;
    final y2 = B.hitbox!.absolutePosition.y;
    if (isOverlap(A, B)) {
      if (y1 < y2 && x1 < x2) {
        return 1;
      } else if (y1 == y2 && x1 < x2) {
        return 1;
      } else if (y1 < y2 && x1 == x2) {
        return 1;
      } else if (y1 == y2 && x1 == x2) {
        return 1;
      } else if (y1 < y2 && x1 > x2) {
        return 1;
      }
      return -1;
    } else {
      if (y1 < y2 && x1 < x2) {
        return -1;
      } else if (y1 == y2 && x1 < x2) {
        return -1;
      } else if (y1 > y2 && x1 < x2) {
        return -1;
      }
      return 1;
    }
  }

  void sortPlayers() {
    players.sort((a, b) => shouldLower(a, b));
  }
}
