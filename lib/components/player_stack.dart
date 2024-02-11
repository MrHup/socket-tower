import 'package:flame/components.dart';
import 'package:flutter/rendering.dart';
import 'package:socket_showdown/components/falling_box.dart';
import 'package:socket_showdown/screens/game_loop.dart';
import 'package:socket_showdown/static/game_state.dart';

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

  int direction = 1;
  double balanceShift = 0;
  final double easeDuration = 1.5;
  double easeTime = 0;

  @override
  void render(Canvas canvas) {
    maintanance();
    sortPlayers();
    super.render(canvas);
  }

  @override
  void update(double dt) {
    super.update(dt);
    shiftStack(dt);
    anchor = Anchor.bottomCenter;
  }

  void shiftStack(double dt) {
    if (GameState.score < 2) return;
    double? maxOffset = balanceShift / 10 > 100 ? 100 : balanceShift / 10;
    maxOffset = num.parse(maxOffset.toStringAsFixed(2)) as double?;
    final Vector2 limit =
        Vector2(size.x / 2 - maxOffset!, size.x / 2 + maxOffset);

    if (position.x <= limit.x || position.x >= limit.y) {
      direction *= -1;
      position.x = position.x.clamp(limit.x, limit.y);
    }

    double newX = position.x + direction * dt * 2 * GameState.score;
    double newY = 0.575 * newX + 600;
    position = Vector2(newX, newY);
  }

  void maintanance() {
    // clean up players that are out of bounds
    for (var i = 0; i < players.length; i++) {
      players[i].parent = this;
      if (players[i].hitbox == null) {
        break;
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
