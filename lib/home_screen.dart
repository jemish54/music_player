import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marquee_text/marquee_text.dart';
import 'package:music_player/audio_repository.dart';
import 'package:music_player/player.dart';
import 'package:music_player/providers.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    requestPermission();
    ref.read(audioRepositoryProvider).getAllSongs();
    setState(() {});
    super.initState();
  }

  requestPermission() async {
    if (await Permission.storage.request().isGranted) {
      setState(() {});
    } else {
      requestPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Music Player")),
        body: Stack(children: [
          ListView.builder(
            itemCount: AudioRepository.instance.songList.length,
            itemBuilder: ((context, index) {
              final song = AudioRepository.instance.songList[index];
              return SongTile(
                  song: song, onTap: () => Player.instance.playSong(index));
            }),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: StreamBuilder<int?>(
                stream: Player.instance.getStream(),
                builder: (context, index) {
                  return index.data == null
                      ? const SizedBox()
                      : NowPlayingCard(
                          index: index.data!,
                        );
                }),
          )
        ]));
  }
}

class SongTile extends StatelessWidget {
  final SongModel song;
  final Function() onTap;

  const SongTile({Key? key, required this.song, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onTap();
      },
      leading: Neumorphic(
        style: NeumorphicStyle(
            shape: NeumorphicShape.convex,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(8.0)),
            depth: 4,
            color: Theme.of(context).cardColor),
        child: QueryArtworkWidget(
          id: song.id,
          type: ArtworkType.AUDIO,
          nullArtworkWidget: Container(
              padding: const EdgeInsets.all(12),
              child: const Icon(Icons.music_note)),
          artworkBorder: BorderRadius.zero,
        ),
      ),
      title: Text(
        song.displayName,
        maxLines: 1,
      ),
      subtitle: Text(
        "${song.artist}",
        maxLines: 1,
      ),
    );
  }
}

class NowPlayingCard extends StatelessWidget {
  final int index;
  const NowPlayingCard({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final song = AudioRepository.instance.songList[index];
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Neumorphic(
        style: NeumorphicStyle(
            shape: NeumorphicShape.concave,
            depth: 8,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
            color: Colors.blue),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Neumorphic(
                style: NeumorphicStyle(
                    shape: NeumorphicShape.convex,
                    boxShape: NeumorphicBoxShape.roundRect(
                        BorderRadius.circular(8.0)),
                    depth: -4,
                    color: Theme.of(context).cardColor),
                child: QueryArtworkWidget(
                  id: song.id,
                  type: ArtworkType.AUDIO,
                  artworkHeight: 64,
                  artworkWidth: 64,
                  artworkBorder: BorderRadius.zero,
                  nullArtworkWidget: Container(
                    padding: const EdgeInsets.all(20.0),
                    child: const Icon(
                      Icons.music_note,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onPanUpdate: (details) {
                  if (details.delta.dx > 0) {
                    Player.instance.previousSong();
                  } else {
                    Player.instance.nextSong();
                  }
                },
                child: Column(
                  children: [
                    marqueeText(song.title),
                    marqueeText("${song.artist}"),
                  ],
                ),
              ),
              const PlayButton()
            ],
          ),
        ),
      ),
    );
  }
}

class PlayButton extends StatelessWidget {
  const PlayButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
        onPressed: () {
          Player.instance.playpausePlayer();
        },
        style: const NeumorphicStyle(
            boxShape: NeumorphicBoxShape.circle(),
            shadowLightColor: Colors.black54,
            depth: 4,
            shape: NeumorphicShape.convex),
        child: StreamBuilder<bool?>(
          stream: Player.instance.isPlayingStream(),
          builder: ((context, isPlaying) {
            if (isPlaying.hasData) {
              return Icon(isPlaying.data!
                  ? Icons.pause_rounded
                  : Icons.play_arrow_rounded);
            } else {
              return const Icon(Icons.pause_rounded);
            }
          }),
        ));
  }
}

Widget marqueeText(String text) {
  return SizedBox(
    width: 200,
    child: MarqueeText(
      text: TextSpan(text: text),
      speed: 18,
    ),
  );
}
