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

  GameRouter game = GameRouter();
  runApp(GameWidget(
    game: kDebugMode ? GameRouter() : game,
    // overlayBuilderMap: kDebugMode ? game.overlayBuilderMap : null,
    overlayBuilderMap: {
      "fog": (BuildContext context, GameRouter game) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0, 1),
              end: Alignment(0, 0.7),
              colors: [Color(0xFF555f75), Color(0x00555f75)],
            ),
          ),
        );
      },
    },
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
