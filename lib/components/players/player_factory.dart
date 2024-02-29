import 'dart:math';
import 'package:flame/components.dart';
import 'package:socket_showdown/components/player.dart';
import 'package:socket_showdown/components/players/lamp.dart';
import 'package:socket_showdown/components/players/printer.dart';
import 'package:socket_showdown/components/players/tibi.dart';
import 'package:socket_showdown/components/players/toaster.dart';
import 'package:socket_showdown/components/players/washer.dart';

class PlayerFactory {
  static MyPlayer createPlayer(Vector2 startingPosition) {
    const List<String> playerTypes = [
      'toaster',
      'lamp',
      'tibi',
      'printer',
      'washer'
    ];
    // generate a random number between 0 and len(playerTypes)
    final random = Random();
    final randomIndex = random.nextInt(playerTypes.length);
    final randomPlayerType = playerTypes[randomIndex];

    switch (randomPlayerType) {
      case 'toaster':
        return Toaster(
            startingPosition: startingPosition, animationName: "toaster");
      case 'lamp':
        return Lamp(startingPosition: startingPosition);
      case 'tibi':
        return Tibi(startingPosition: startingPosition);
      case 'washer':
        return Washer(startingPosition: startingPosition);
      case 'printer':
        return Printer(startingPosition: startingPosition);
      default:
        throw Exception('Invalid player type');
    }
  }
}
