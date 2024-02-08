import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:socket_showdown/socket_tower.dart';
import 'package:socket_showdown/utils/background_decoration.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setPortraitUpOnly();

  final game = SocketTower();
  runApp(GameWidget(
    game: kDebugMode ? game : game,
    backgroundBuilder: (context) {
      return Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment(0, -0.8),
                colors: [Color(0xFF058bde), Color(0xFFe0f0fa)],
              ),
            ),
          ),
          const BackgroundDecoration(),
        ],
      );
    },
  ));
}
