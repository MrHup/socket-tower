import 'package:flame_audio/flame_audio.dart';
import 'package:socket_showdown/static/constants.dart';

class SoundPlayer {
  static late AudioPool pool;
  static late AudioPool poolTouch;
  static bool hasMusisStarted = false;

  static void loadPool() async {
    pool = await FlameAudio.createPool(
      'drop.mp3',
      maxPlayers: 4,
    );
    poolTouch = await FlameAudio.createPool(
      'touch.mp3',
      maxPlayers: 4,
    );
  }

  static void playDrop() {
    pool.start();
  }

  static void playTouch() {
    poolTouch.start();
  }

  static void startBgMusic() {
    if (!Constants.PLAY_MUSIC) return;
    if (!hasMusisStarted) {
      hasMusisStarted = true;
      FlameAudio.bgm.initialize();
      FlameAudio.bgm.play('bg_sound.wav', volume: 0.3);
    }
  }

  static void dispose() {
    FlameAudio.bgm.dispose();
  }
}
