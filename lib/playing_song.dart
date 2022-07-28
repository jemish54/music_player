import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';

abstract class PlayingSongState {
  const PlayingSongState();
}

class PlayingSongEmpty extends PlayingSongState {
  const PlayingSongEmpty();
}

class PlayingSongLoaded extends PlayingSongState {
  final SongModel song;

  const PlayingSongLoaded(this.song);
}

class PlayingSongNotifier extends StateNotifier<PlayingSongState> {
  PlayingSongNotifier() : super(const PlayingSongEmpty());

  playSong(SongModel song) {
    print("Clicked ${song.title}");
    state = PlayingSongLoaded(song);
  }
}
