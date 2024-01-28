import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
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
    // ..removeRenderEffect();
  }
}

class MainMenuPage extends Component
    with TapCallbacks, HasGameReference<GameRouter> {
  @override
  Future<void> onLoad() async {
    final game = findGame()!;
    final logo = SpriteComponent.fromImage(
      await game.images.load('logo.png'),
    );
    logo.anchor = Anchor.center;
    logo.position = game.size / 2;
    add(logo);

    final tapToPlay = TextComponent(
      text: 'TAP TO START',
      position: game.canvasSize / 2 + Vector2(0, logo.size.y / 2 + 20),
      anchor: Anchor.center,
      children: [
        ScaleEffect.to(
          Vector2.all(1.1),
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
