import 'package:firebase_core/firebase_core.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_showdown/firebase_options.dart';
import 'package:socket_showdown/overlays/collection_menu.dart';
import 'package:socket_showdown/overlays/leaderboard_menu.dart';
import 'package:socket_showdown/overlays/main_menu.dart';
import 'package:socket_showdown/overlays/replay_menu.dart';
import 'package:socket_showdown/overlays/summary_menu.dart';
import 'package:socket_showdown/overlays/utils/hover_image.dart';
import 'package:socket_showdown/screens/game_loop.dart';
import 'package:socket_showdown/socket_tower.dart';
import 'package:socket_showdown/static/game_state.dart';
import 'package:socket_showdown/static/sound_player.dart';
import 'package:socket_showdown/utils/background_decoration.dart';
import 'package:socket_showdown/utils/random_string_generator.dart';

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

  final String? userIdentifier = preferences.getString('userIdentifier');
  if (userIdentifier != null) {
    GameState.userIdentifier = userIdentifier;
  } else {
    GameState.userIdentifier = getRandomString(12);
    preferences.setString('userIdentifier', GameState.userIdentifier);
  }

  final String? userName = preferences.getString('userName');
  if (userName != null) {
    GameState.userName = userName;
  } else {
    GameState.userName = 'Anon-' + getRandomString(6);
    preferences.setString('userName', GameState.userName);
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
      'summary': (context, game) {
        return SummaryMenu(game);
      },
      'leaderboard': (context, game) {
        return LeaderboardMenu(game);
      },
      'collections': (context, game) {
        return CollectionMenu(game);
      },
      'pause-overlay': (context, game) {
        return Align(
          alignment: Alignment.topRight,
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: HoverImage(
                normalImage: 'assets/images/buttons/pause_up.png',
                hoverImage: 'assets/images/buttons/pause_down.png',
                onPressed: () {
                  (game as FlameGame).overlays.add('pause');
                  (game).paused = true;
                  SoundPlayer.playDrop();
                },
              ),
            ),
          ),
        );
      },
      'utilities-overlay': (context, game) {
        return Align(
          alignment: Alignment.topRight,
          child: Material(
            color: Colors.transparent,
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    HoverImage(
                      normalImage: 'assets/images/buttons/collection_up.png',
                      hoverImage: 'assets/images/buttons/collection_down.png',
                      onPressed: () {
                        (game as FlameGame).overlays.add('collections');
                        (game).overlays.remove('menu');
                        (game).overlays.remove('utilities-overlay');

                        SoundPlayer.playDrop();
                      },
                    ),
                    HoverImage(
                      normalImage: 'assets/images/buttons/leaderboard_up.png',
                      hoverImage: 'assets/images/buttons/leaderboard_down.png',
                      onPressed: () {
                        (game as FlameGame).overlays.add('leaderboard');
                        (game).overlays.remove('menu');
                        (game).overlays.remove('utilities-overlay');

                        SoundPlayer.playDrop();
                      },
                    ),
                  ],
                )),
          ),
        );
      },
      'pause': (context, game) {
        return GestureDetector(
          onTap: () {
            (game as FlameGame).paused = false;
            (game).overlays.remove('pause');
          },
          child: Container(
            color: const Color.fromARGB(134, 0, 0, 0),
            child: const Center(
              child: Text(
                'PAUSED',
                style: TextStyle(
                  fontFamily: "TitleFont",
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 48,
                ),
              ),
            ),
          ),
        );
      },
      'tap-overlay': (context, game) {
        return GestureDetector(
          onTapDown: (details) =>
              ((game as SocketTower).world.children.first as GameLoop)
                  .tapDown(),
          child: Container(
            color: const Color.fromARGB(0, 0, 0, 0),
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
    initialActiveOverlays: const ['tap-overlay', 'menu', 'utilities-overlay'],
    backgroundBuilder: (context) {
      return Stack(
        children: [
          Container(color: const Color.fromARGB(255, 133, 172, 255)),
          const BackgroundDecoration(),
        ],
      );
    },
  ));
}
