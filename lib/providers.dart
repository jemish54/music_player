import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/audio_repository.dart';

final audioRepositoryProvider = Provider((ref) => AudioRepository());
