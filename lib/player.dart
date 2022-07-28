import 'dart:async';

import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Player {
  static final Player instance = Player._internal();

  Player._internal();

  final _audioPlayer = AudioPlayer();

  factory Player() {
    return instance;
  }

  final StreamController<SongModel> _playingSong =
      StreamController<SongModel>();

  playSong(SongModel song) {
    _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(song.uri!)));
    _audioPlayer.play();
    _playingSong.add(song);
  }

  getStream() {
    return _playingSong.stream;
  }

  playpausePlayer() {
    _audioPlayer.playing ? _audioPlayer.pause() : _audioPlayer.play();
  }

  bool isPlaying() => _audioPlayer.playing;
}
