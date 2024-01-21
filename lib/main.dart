import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:socket_showdown/socket_showdown.dart';
import 'package:socket_showdown/utils/background_decoration.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setPortraitUpOnly();

  SocketShowdown game = SocketShowdown();
  runApp(GameWidget(
    game: kDebugMode ? SocketShowdown() : game,
    backgroundBuilder: (context) {
      return Stack(
        children: [
          // draw a  gray shape that fills half of the screen and curves down
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Color(0xFF058bde), Color(0xFFe0f0fa)],
              ),
            ),
          ),
          BackgroundDecoration(),
        ],
      );
    },
  ));
}
