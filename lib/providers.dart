import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/audio_repository.dart';
import 'package:music_player/player.dart';

final audioRepositoryProvider = Provider((ref) => AudioRepository());

final playerProvider = Provider((ref) => Player());
