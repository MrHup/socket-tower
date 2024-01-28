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
    // ..addRenderEffect(
    //   PaintDecorator.grayscale(opacity: 0.5)..addBlur(3.0),
    // );
  }

  @override
  void onPop(Route nextRoute) {
    nextRoute.resumeTime();
    (nextRoute.firstChild() as GameLoop).startGame();
    // nextRoute.crane.spawnBox();
    // nextRoute.gameRef.add(
    //   ShakeEffect(
    //     duration: 0.5,
    //     offset: 10,
    //     maxAngle: 0.1,
    //   ),
    // );
    // ..removeRenderEffect();
  }
}

class MainMenuPage extends Component
    with TapCallbacks, HasGameReference<GameRouter> {
  @override
  Future<void> onLoad() async {
    final game = findGame()!;
    final SpriteComponent logo = SpriteComponent(
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
    add(logo);

    final tapToPlay = TextComponent(
      text: 'TAP TO START',
      position: game.canvasSize / 2 + Vector2(0, logo.size.y / 2 + 40),
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
    add(tapToPlay);
  }

  @override
  bool containsLocalPoint(Vector2 point) => true;

  @override
  void onTapUp(TapUpEvent event) => game.router.pop();
}
