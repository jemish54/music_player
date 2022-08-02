import 'dart:async';

import 'package:on_audio_query/on_audio_query.dart';

class AudioRepository {
  static final AudioRepository instance = AudioRepository._internal();
  AudioRepository._internal();
  factory AudioRepository() {
    return instance;
  }

  final _onAudioQuery = OnAudioQuery();

  final _sortType = null;
  final _orderType = OrderType.DESC_OR_GREATER;
  final _uriType = UriType.EXTERNAL;
  final _ignoreCase = true;

  final List<SongModel> songList = [];

  void getAllSongs() {
    _onAudioQuery
        .querySongs(
          sortType: _sortType,
          orderType: _orderType,
          uriType: _uriType,
          ignoreCase: _ignoreCase,
        )
        .then((value) => songList.addAll(value));
  }
}
