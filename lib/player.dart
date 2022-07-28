import 'dart:async';

import 'package:on_audio_query/on_audio_query.dart';

class Player {
  final StreamController<SongModel> _playingSong =
      StreamController<SongModel>();

  playSong(SongModel song) {
    _playingSong.add(song);
  }

  getStream() {
    return _playingSong.stream;
  }
}
