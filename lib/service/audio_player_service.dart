import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

class AudioPlayerService {
  final _player = AudioPlayer();
  double _volume = 1.0;

  static const String moveStartSound = 'whistle.mp3';
  static const String restStartSound = 'fighting.mp3';

  void setVolume(double value) {
    _volume = value.clamp(0.0, 1.0);
    _player.setVolume(_volume);
  }

  double get volume => _volume;

  Future<void> _vibrate() async {
    if (await Vibration.hasVibrator() ) {
      Vibration.vibrate(duration: 500);
    }
  }

  Future<void> playMoveStart() async {
    _vibrate();
    await _player.setVolume(_volume);
    await _player.play(AssetSource(moveStartSound));
  }

  Future<void> playRestStart() async {
    _vibrate();
    await _player.setVolume(_volume);
    await _player.play(AssetSource(restStartSound));
  }
}