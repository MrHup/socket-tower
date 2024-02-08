import 'package:flame/components.dart';
import 'package:socket_showdown/components/player.dart';
import 'package:socket_showdown/components/players/lamp.dart';

import 'dart:math';

import 'package:socket_showdown/components/players/toaster.dart';

class PlayerFactory {
  static MyPlayer createPlayer(Vector2 startingPosition) {
    const List<String> playerTypes = ['toaster', 'lamp'];
    // generate a random number between 0 and len(playerTypes)
    final random = Random();
    final randomIndex = random.nextInt(playerTypes.length);
    final randomPlayerType = playerTypes[randomIndex];

    switch (randomPlayerType) {
      case 'toaster':
        return Toaster(startingPosition: startingPosition);
      case 'lamp':
        return Lamp(startingPosition: startingPosition);
      default:
        throw Exception('Invalid player type');
    }
  }
}
