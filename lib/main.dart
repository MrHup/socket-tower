import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:socket_showdown/socket_showdown.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setPortraitUpOnly();

  SocketShowdown game = SocketShowdown();
  runApp(GameWidget(
    game: kDebugMode ? SocketShowdown() : game,
    backgroundBuilder: (context) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Color(0xFF267892), Color(0xFFFFFFFF)],
          ),
        ),
      );
    },
  ));
}
