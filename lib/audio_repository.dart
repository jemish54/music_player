import 'package:on_audio_query/on_audio_query.dart';

class AudioRepository {
  final _onAudioQuery = OnAudioQuery();

  final sortType = null;
  final orderType = OrderType.ASC_OR_SMALLER;
  final uriType = UriType.EXTERNAL;
  final ignoreCase = true;

  Future<List<SongModel>> getAllSongs() {
    return _onAudioQuery.querySongs(
      sortType: sortType,
      orderType: orderType,
      uriType: uriType,
      ignoreCase: ignoreCase,
    );
  }
}
