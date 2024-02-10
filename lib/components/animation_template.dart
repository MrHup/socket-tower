import 'package:flame/events.dart';
import 'package:flame_rive/flame_rive.dart';

class SkillsAnimationComponent extends RiveComponent with TapCallbacks {
  SkillsAnimationComponent(Artboard artboard, this._animationName)
      : super(artboard: artboard);
// SMIInput<double>? _levelInput;

  final String _animationName;

  @override
  void onLoad() {
    final controller = StateMachineController.fromArtboard(
      artboard,
      _animationName,
    );
    if (controller != null) {
      artboard.addController(controller);
      // _levelInput = controller.findInput<double>('Level');
      // _levelInput?.value = 0;
    }
  }
}
