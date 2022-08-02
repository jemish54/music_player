import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:music_player/audio_repository.dart';
import 'package:music_player/player.dart';
import 'package:on_audio_query/on_audio_query.dart';

class DetailScreen extends StatelessWidget {
  DetailScreen({Key? key}) : super(key: key);

  final CarouselController carouselController = CarouselController();
  final List<SongModel> songList = AudioRepository.instance.songList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "All Songs",
              style: TextStyle(fontSize: 22),
            ),
          ),
          CarouselSlider.builder(
            itemCount: songList.length,
            carouselController: carouselController,
            itemBuilder: ((context, index, realIndex) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Neumorphic(
                  style: NeumorphicStyle(
                      shape: NeumorphicShape.convex,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(24.0)),
                      depth: 8,
                      color: Theme.of(context).cardColor),
                  child: QueryArtworkWidget(
                      id: songList[index].id,
                      type: ArtworkType.AUDIO,
                      artworkWidth: 400,
                      artworkBorder: BorderRadius.zero,
                      nullArtworkWidget: const SizedBox(
                        height: 400,
                        width: 400,
                        child: Icon(Icons.music_note_rounded),
                      )),
                ),
              );
            }),
            options: CarouselOptions(
              aspectRatio: 1.2,
              enlargeCenterPage: true,
              viewportFraction: 0.7,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: PlayingDetail(
              songList: songList,
              carouselController: carouselController,
            ),
          ),
          Column(
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30),
                child: PlayerSeekbar(),
              ),
              PlayerController(),
            ],
          ),
          const SizedBox(
            height: 30,
          )
        ],
      )),
    );
  }
}

class PlayingDetail extends StatelessWidget {
  final CarouselController carouselController;
  const PlayingDetail({
    Key? key,
    required this.carouselController,
    required this.songList,
  }) : super(key: key);

  final List<SongModel> songList;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int?>(
        stream: Player.instance.getStream(),
        builder: (context, songIndex) {
          if (songIndex.hasData) {
            carouselController.animateToPage(songIndex.data!);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      songList[songIndex.data!].title,
                      style: const TextStyle(fontSize: 20),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    child: Text(
                      "${songList[songIndex.data!].artist}",
                      style: const TextStyle(fontSize: 18),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox();
          }
        });
  }
}

class PlayerSeekbar extends StatelessWidget {
  const PlayerSeekbar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
        stream: Player.instance.getSeekStream(),
        builder: (context, seekPosition) {
          return seekPosition.hasData
              ? StreamBuilder<Duration?>(
                  stream: Player.instance.getDuration(),
                  builder: (context, duration) {
                    return Column(
                      children: [
                        NeumorphicSlider(
                          onChanged: (percent) =>
                              Player.instance.seekTo(percent),
                          value: seekPosition.data!.inMilliseconds.toDouble(),
                          height: 8,
                          max: duration.hasData
                              ? duration.data!.inMilliseconds.toDouble()
                              : 0,
                          thumb: const SizedBox(),
                          style: const SliderStyle(depth: 4),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(formatDuration(seekPosition.data!)),
                              Text(formatDuration(duration.hasData
                                  ? duration.data!
                                  : Duration.zero)),
                            ],
                          ),
                        )
                      ],
                    );
                  })
              : const SizedBox();
        });
  }
}

class PlayerController extends StatelessWidget {
  const PlayerController({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => Player.instance.previousSong(),
          child: NeumorphicIcon(
            Icons.skip_previous_rounded,
            size: 48,
            style: const NeumorphicStyle(color: Colors.blue),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        GestureDetector(
          onTap: () => Player.instance.playpausePlayer(),
          child: Neumorphic(
            style: NeumorphicStyle(
                boxShape: const NeumorphicBoxShape.circle(),
                color: Colors.blue,
                depth: 4,
                shadowLightColor: Colors.blue[300],
                shadowDarkColor: Colors.blue,
                shape: NeumorphicShape.convex),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: StreamBuilder<bool?>(
                  stream: Player.instance.isPlayingStream(),
                  builder: (context, isPlaying) {
                    return isPlaying.hasData
                        ? Icon(
                            isPlaying.data!
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            size: 30,
                            color: Colors.white,
                          )
                        : const SizedBox();
                  }),
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        GestureDetector(
          onTap: () => Player.instance.nextSong(),
          child: NeumorphicIcon(
            Icons.skip_next_rounded,
            size: 48,
            style: const NeumorphicStyle(color: Colors.blue),
          ),
        ),
      ],
    );
  }
}

String formatDuration(Duration d) {
  return "${d.inMinutes.remainder(60).toString().padLeft(2, '0')}:${d.inSeconds.remainder(60).toString().padLeft(2, '0')}";
}
