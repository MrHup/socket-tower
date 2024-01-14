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
  runApp(GameWidget(game: kDebugMode ? SocketShowdown() : game));
}
