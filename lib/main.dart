import 'package:firebase_core/firebase_core.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_showdown/firebase_options.dart';
import 'package:socket_showdown/overlays/leaderboard_menu.dart';
import 'package:socket_showdown/overlays/main_menu.dart';
import 'package:socket_showdown/overlays/replay_menu.dart';
import 'package:socket_showdown/screens/game_loop.dart';
import 'package:socket_showdown/socket_tower.dart';
import 'package:socket_showdown/static/game_state.dart';
import 'package:socket_showdown/utils/background_decoration.dart';

void main() async {
  // initiate flame configuration
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setPortraitUpOnly();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.web,
  );

  // initiate state
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  final int? bestScore = preferences.getInt('best');
  if (bestScore != null) {
    GameState.bestScore = bestScore;
  }

  // initiate game
  final game = SocketTower();
  runApp(GameWidget(
    game: kDebugMode ? SocketTower() : game,
    overlayBuilderMap: {
      'menu': (context, game) {
        return MainMenu(game);
      },
      'test': (context, game) {
        return Container(
            color: Colors.red,
            child: GestureDetector(
                onTap: () => (game! as FlameGame).overlays.remove('test'),
                child: const Text('Test')));
      },
      'replay-menu': (context, game) {
        return ReplayMenu(game);
      },
      'leaderboard': (context, game) {
        return LeaderboardMenu(game);
      },
      'tap-overlay': (context, game) {
        return GestureDetector(
          onTapDown: (details) =>
              ((game as SocketTower).world.children.first as GameLoop)
                  .tapDown(),
          child: Container(
            color: Color.fromARGB(0, 0, 0, 0),
            child: Image.asset(
              'assets/images/fog.png',
              fit: BoxFit.fill,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        );
      },
    },
    initialActiveOverlays: const ['tap-overlay', 'leaderboard'],
    backgroundBuilder: (context) {
      return Stack(
        children: [
          Container(color: Color.fromARGB(255, 133, 172, 255)),
          const BackgroundDecoration(),
        ],
      );
    },
  ));
}
