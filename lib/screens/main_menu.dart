import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:socket_showdown/screens/game_loop.dart';
import 'package:socket_showdown/socket_showdown.dart';

class MainMenuRoute extends Route {
  MainMenuRoute() : super(MainMenuPage.new, transparent: true);

  @override
  void onPush(Route? previousRoute) {
    previousRoute!.stopTime();
  }

  @override
  void onPop(Route nextRoute) {
    nextRoute.resumeTime();
    (nextRoute.firstChild() as GameLoop).startGame();
  }
}

class MainMenuPage extends PositionComponent
    with TapCallbacks, HasGameReference<GameRouter> {
  TextComponent? tapToPlay;
  SpriteComponent? logo;

  @override
  Future<void> onLoad() async {
    final game = findGame()!;
    logo = SpriteComponent(
        sprite: await game.loadSprite('logo.png'),
        anchor: Anchor.center,
        position: game.size / 2,
        children: [
          ScaleEffect.to(
            Vector2.all(1.1),
            EffectController(
              duration: 0.3,
              alternate: true,
              infinite: true,
            ),
          ),
        ]);
    add(logo as Component);

    tapToPlay = TextComponent(
      text: 'TAP TO START',
      position: game.canvasSize / 2 + Vector2(0, logo!.size.y / 2 + 40),
      anchor: Anchor.center,
      children: [
        RotateEffect.to(
          0.1,
          EffectController(
            duration: 0.3,
            alternate: true,
            infinite: true,
          ),
        ),
      ],
    );
    add(tapToPlay as Component);
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    if (logo != null && tapToPlay != null) {
      logo!.position = gameSize / 2;
      tapToPlay!.position = gameSize / 2 + Vector2(0, logo!.size.y / 2 + 40);
    }
  }

  @override
  bool containsLocalPoint(Vector2 point) => true;

  @override
  void onTapUp(TapUpEvent event) => game.router.pop();
}
