import 'dart:async';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:learn_flutter/video_player_example/model/video_model.dart';

class CustomControlsWidget extends StatefulWidget {
  final BetterPlayerController? controller;
  final Function(bool visbility)? onControlsVisibilityChanged;
  final List<VideoModel> videos;
  final int selectedVideo;
  final VoidCallback onPlayPause;
  final VoidCallback onFullscreen;
  final Function(int selectedVideo) onChangeVideo;

  const CustomControlsWidget({
    Key? key,
    this.controller,
    this.onControlsVisibilityChanged,
    required this.videos,
    required this.selectedVideo,
    required this.onPlayPause,
    required this.onFullscreen,
    required this.onChangeVideo,
  }) : super(key: key);

  @override
  State<CustomControlsWidget> createState() => _CustomControlsWidgetState();
}

class _CustomControlsWidgetState extends State<CustomControlsWidget> {
  bool showControls = false;
  bool showPlaylist = false;
  Timer? timer;

  List<VideoModel> videos = [];
  int selectedVideo = 0;

  void showHideControls() {
    timer?.cancel();
    timer = Timer(
      const Duration(seconds: 3),
      () => setState(
        () {
          showControls = false;
        },
      ),
    );
    setState(() {
      showPlaylist = false;
      showControls = !showControls;
    });
  }

  void openPlaylist(List<VideoModel> videos, int selectedVideo) {
    setState(() {
      showControls = false;
      showPlaylist = true;
    });
  }

  void closePlaylist() {
    setState(() {
      showPlaylist = false;
      showControls = false;
    });
  }

  @override
  void initState() {
    videos = widget.videos;
    selectedVideo = widget.selectedVideo;
    super.initState();
  }

  @override
  void dispose() {
    debugPrint('call dispose');
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          AnimatedOpacity(
            opacity: showControls ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                showHideControls();
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey.withOpacity(0.5),
                              ),
                              child: Text(
                                videos[selectedVideo].title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          if (widget.controller!.isFullScreen)
                            GestureDetector(
                              onTap: () {
                                openPlaylist(videos, selectedVideo);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                                child: const Icon(
                                  Icons.menu,
                                  color: Colors.black,
                                  size: 24,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        widget.onPlayPause();
                        setState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        child: Icon(
                          widget.controller!.isPlaying() ?? false ? Icons.pause : Icons.play_arrow,
                          color: Colors.black,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: GestureDetector(
                      onTap: () {
                        widget.onFullscreen();
                        setState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        child: Icon(
                          widget.controller!.isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                          color: Colors.black,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (widget.controller!.isFullScreen && showPlaylist)
            Align(
              alignment: Alignment.topRight,
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height,
                color: Colors.white,
                child: Column(
                  children: [
                    ListTile(
                      title: const Text(
                        'Segments',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: GestureDetector(
                        onTap: () {
                          closePlaylist();
                        },
                        child: const Icon(
                          Icons.menu,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const Divider(
                      color: Colors.blue,
                      height: 2,
                    ),
                    Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () async {
                              setState(() {
                                selectedVideo = index;
                              });
                              widget.onChangeVideo(selectedVideo);
                            },
                            title: Text(
                              videos[index].title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: selectedVideo == index
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
            ),
        ],
      ),
    );
  }
}
