import 'dart:async';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learn_flutter/video_player_example/model/video_model.dart';
import 'package:learn_flutter/video_player_example/page/custom_controls_widget.dart';

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({Key? key}) : super(key: key);

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  List<VideoModel> videos = const [
    VideoModel(
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      title: 'Big Buck Bunny',
    ),
    VideoModel(
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      title: 'For Bigger Blazes',
    ),
  ];

  int selectedIndex = 0;

  late BetterPlayerController betterPlayerController;
  late BetterPlayerDataSource betterPlayerDataSource;
  BetterPlayerTheme playerTheme = BetterPlayerTheme.custom;

  StreamController<bool> placeholderStreamController = StreamController.broadcast();
  bool showPlaceholder = true;

  void setUp({required String videoUrl}) {
    betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      videoUrl,
    );

    final betterPlayerConfiguration = BetterPlayerConfiguration(
      autoDispose: true,
      autoPlay: true,
      fit: BoxFit.contain,
      autoDetectFullscreenDeviceOrientation: true,
      fullScreenByDefault: false,
      showPlaceholderUntilPlay: true,
      placeholder: _buildVideoPlaceholder(),
      errorBuilder: (context, _) => _buildVideoError(),
      autoDetectFullscreenAspectRatio: true,
      expandToFill: true,
      controlsConfiguration: BetterPlayerControlsConfiguration(
        playerTheme: playerTheme,
        customControlsBuilder: (controller, onControlsVisibilityChanged) => CustomControlsWidget(
          controller: controller,
          onControlsVisibilityChanged: onControlsVisibilityChanged,
          videos: videos,
          selectedVideo: selectedIndex,
          onPlayPause: () {
            onPlayPause();
          },
          onFullscreen: () {
            onFullscreen();
          },
          onChangeVideo: (selectedVideo) async {
            await changeVideo(selectedVideo);
          },
        ),
      ),
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitUp,
      ],
      deviceOrientationsOnFullScreen: [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],
    );

    betterPlayerController = BetterPlayerController(
      betterPlayerConfiguration,
      betterPlayerDataSource: betterPlayerDataSource,
    );

    betterPlayerController.addEventsListener((event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
        placeholderStreamController.add(false);
        showPlaceholder = false;
      }
    });
  }

  Future<void> changeVideo(int index) async {
    if (mounted) {
      setState(() {
        selectedIndex = index;
      });
    }
    await betterPlayerController.pause().then((_) async {
      setState(() {
        betterPlayerController.dispose();
        placeholderStreamController.add(true);
        showPlaceholder = true;
      });
      setUp(videoUrl: videos[index].videoUrl);
    });
  }

  Future<void> onPlayPause() async {
    if (betterPlayerController.isPlaying() ?? false) {
      await betterPlayerController.pause();
    }
    else {
      await betterPlayerController.play();
    }
    setState(() {});
  }

  void onFullscreen() {
    if (betterPlayerController.isFullScreen) {
      betterPlayerController.exitFullScreen();
    }
    else {
      betterPlayerController.enterFullScreen();
    }
    setState(() {});
  }

  @override
  void initState() {
    setUp(videoUrl: videos[0].videoUrl);
    super.initState();
  }

  @override
  void dispose() {
    debugPrint('dispose');
    betterPlayerController.dispose();
    placeholderStreamController.close();
    super.dispose();
  }

  Widget _buildVideoPlaceholder() {
    return StreamBuilder<bool>(
      stream: placeholderStreamController.stream,
      builder: (context, snapshot) {
        return showPlaceholder
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : const SizedBox();
      },
    );
  }

  Widget _buildVideoError() {
    return const Center(
      child: Text(
        'Something error',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: BetterPlayer(
                controller: betterPlayerController,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      changeVideo(index);
                    },
                    title: Text(
                      videos[index].title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: selectedIndex == index
                        ? const Icon(
                            Icons.play_arrow,
                            color: Colors.blue,
                          )
                        : null,
                  );
                },
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.blue,
                  height: 2,
                ),
                itemCount: videos.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
