import 'dart:async';
import 'dart:developer';

import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player/audio_repository.dart';

class Player {
  static final Player instance = Player._internal();

  Player._internal();

  final _audioPlayer = AudioPlayer();
  final songList = AudioRepository.instance.songList;

  factory Player() {
    return instance;
  }

  final StreamController<int> _playingSongIndex = StreamController<int>();

  Stream<int>? getStream() {
    return _playingSongIndex.stream;
  }

  playSong(int index) async {
    final song = songList[index];
    try {
      await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(song.uri!),
          tag: MediaItem(
            id: "${song.id}",
            title: song.title,
            album: song.album,
          )));
      _audioPlayer.play();
      _playingSongIndex.add(index);
    } on Exception {
      log("Error in Playing");
    }
  }

  nextSong(int index) {
    playSong((index + 1) % songList.length);
  }

  previousSong(int index) {
    playSong((index - 1 + songList.length) % songList.length);
  }

  playpausePlayer() =>
      _audioPlayer.playing ? _audioPlayer.pause() : _audioPlayer.play();

  bool isPlaying() => _audioPlayer.playing;
}
