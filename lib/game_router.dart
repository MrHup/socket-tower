import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:socket_showdown/screens/main_menu.dart';
import 'package:socket_showdown/screens/pause_screen.dart';
import 'package:socket_showdown/socket_tower.dart';

class GameRouter extends FlameGame with TapCallbacks {
  late final RouterComponent router;

  @override
  Future<void> onLoad() async {
    if (kDebugMode) await add(FpsTextComponent());
    await add(
      router = RouterComponent(
        routes: {
          'game': Route(SocketTower.new),
          'main-menu': MainMenuRoute(),
          'pause': PauseRoute(),
        },
        initialRoute: 'game',
      ),
    );
  }
}
