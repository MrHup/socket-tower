import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:socket_showdown/screens/game_loop.dart';
import 'package:socket_showdown/screens/main_menu.dart';
import 'package:socket_showdown/screens/pause_screen.dart';

class GameRouter extends FlameGame with TapCallbacks {
  late final RouterComponent router;

  @override
  Future<void> onLoad() async {
    await add(
      router = RouterComponent(
        routes: {
          'game': Route(GameLoop.new),
          'main-menu': MainMenuRoute(),
          'pause': PauseRoute(),
        },
        initialRoute: 'game',
      ),
    );
  }
}
