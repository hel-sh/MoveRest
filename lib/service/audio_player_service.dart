import 'package:audioplayers/audioplayers.dart';

class AudioPlayerService {
  final _player = AudioPlayer();

  static const String moveStartSound = 'whistle.mp3';
  static const String restStartSound = 'fighting.mp3';

  Future<void> playMoveStart() async {
    await _player.play(AssetSource(moveStartSound));
  }

  Future<void> playRestStart() async {
    await _player.play(AssetSource(restStartSound));
  }
}
