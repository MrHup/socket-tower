import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_rive/flame_rive.dart';

class SkillsAnimationComponent extends RiveComponent with TapCallbacks {
  SkillsAnimationComponent(Artboard artboard) : super(artboard: artboard);
  // SMIInput<double>? _levelInput;

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    anchor = Anchor.center;
    // scale = Vector2(0.5, 0.5);
  }

  @override
  void onLoad() {
    print("Loaded");
    final controller = StateMachineController.fromArtboard(
      artboard,
      "State Machine 2",
    );
    if (controller != null) {
      artboard.addController(controller);
      // _levelInput = controller.findInput<double>('Level');
      // _levelInput?.value = 0;
    }
  }
}
