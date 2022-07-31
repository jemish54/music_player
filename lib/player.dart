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

  Stream<int?> getStream() {
    return _audioPlayer.currentIndexStream;
  }

  playSong(int index) {
    if (_audioPlayer.audioSource != null) {
      try {
        _audioPlayer.seek(Duration.zero, index: index);
        _audioPlayer.play();
      } on Exception {
        log("Error in Playing");
      }
    } else {
      loadInPlayer();
      playSong(index);
    }
  }

  loadInPlayer() {
    try {
      _audioPlayer.setAudioSource(ConcatenatingAudioSource(
          children: songList
              .map((e) => AudioSource.uri(Uri.parse(e.uri!),
                  tag: MediaItem(id: "${e.id}", title: e.title)))
              .toList()));
    } on Exception {
      log("Error in loading list");
    }
  }

  nextSong() {
    _audioPlayer.seekToNext();
  }

  previousSong() {
    _audioPlayer.seekToPrevious();
  }

  Stream<bool> isPlayingStream() {
    return _audioPlayer.playingStream;
  }

  playpausePlayer() =>
      _audioPlayer.playing ? _audioPlayer.pause() : _audioPlayer.play();
}
