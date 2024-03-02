import 'package:flame/events.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:socket_showdown/static/game_state.dart';

class SkillsAnimationComponent extends RiveComponent with TapCallbacks {
  SkillsAnimationComponent(this._animationName)
      : super(artboard: GameState.artboard!);
// SMIInput<double>? _levelInput;

  final String _animationName;
  @override
  void onLoad() {
    print("Added controller");

    if (GameState.artboard != null) {
      final controller = StateMachineController.fromArtboard(
        artboard,
        _animationName,
      );
      artboard.addController(controller!);
    }
  }
}
