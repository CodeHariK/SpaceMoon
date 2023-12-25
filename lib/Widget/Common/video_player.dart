import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:video_player/video_player.dart';

part 'video_player.g.dart';

@Riverpod(keepAlive: true)
// ignore: unsupported_provider_value
class VideoPlayerCache extends _$VideoPlayerCache {
  @override
  FutureOr<VideoPlayerController> build(String url) async {
    final controller = VideoPlayerController.networkUrl(
      Uri.parse(url),
      videoPlayerOptions: VideoPlayerOptions(
        allowBackgroundPlayback: false,
      ),
    );

    await controller.initialize().whenComplete(() => controller.seekTo(
          Duration(seconds: (controller.value.duration.inSeconds * (Random().nextDouble() * 0.1)).toInt()),
        ));

    return controller;
  }
}

class VideoPlayerBox extends ConsumerWidget {
  const VideoPlayerBox({super.key, required this.title, required this.url});

  final String title;
  final String url;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final con = ref.watch(videoPlayerCacheProvider(url));

    return con.when(
      data: (controller) {
        return InkWell(
          onTap: () {
            context.fPush(
              VideoPlayerScaffold(
                title: title,
                controller: controller,
              ),
            );
          },
          child: AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: IgnorePointer(
              child: VideoPlayer(
                controller,
              ),
            ),
          ),
        );
      },
      error: (error, stackTrace) => const Placeholder(),
      loading: () => const CircularProgressIndicator(),
    );
  }
}

class VideoPlayerScaffold extends StatefulWidget {
  const VideoPlayerScaffold({super.key, required this.title, required this.controller});

  final String title;
  final VideoPlayerController controller;

  @override
  State<VideoPlayerScaffold> createState() => _VideoPlayerScaffoldState();
}

class _VideoPlayerScaffoldState extends State<VideoPlayerScaffold> with SingleTickerProviderStateMixin {
  VideoPlayerController get controller => widget.controller;

  late final AnimationController animCon;

  double sliderValue = 0;
  bool _isFullScreen = false;

  void sliderChange() {
    sliderValue = controller.value.position.inSeconds / controller.value.duration.inSeconds;
    if (context.mounted) {
      setState(() {});
    }
  }

  void _toggleFullScreen() {
    if (context.mounted) {
      setState(() {
        _isFullScreen = !_isFullScreen;
        if (_isFullScreen) {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]);
        } else {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
          ]);
        }
      });
    }
  }

  void playpause() {
    if (context.mounted) {
      setState(() {
        if (controller.value.isPlaying) {
          controller.pause();
          animCon.forward();
        } else {
          controller.play();
        }
      });
    }
  }

  @override
  void initState() {
    controller.addListener(sliderChange);

    animCon = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    controller.play();

    super.initState();
  }

  @override
  void dispose() {
    if (_isFullScreen) {
      _toggleFullScreen();
    }
    controller.pause();
    controller.removeListener(sliderChange);
    animCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (context.mounted) {
          setState(() {
            if (animCon.isAnimating || animCon.status == AnimationStatus.completed) {
              animCon.reverse();
            } else {
              animCon.forward();
            }
          });
        }
      },
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: VideoPlayer(controller),
            ),
            AnimatedBuilder(
              animation: animCon,
              builder: (context, child) => Opacity(
                opacity: animCon.value,
                child: Scaffold(
                  backgroundColor: controller.value.isPlaying ? Colors.transparent : Colors.black12,
                  appBar: AppBar(
                    leading: IconButton(
                      iconSize: 32,
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () {
                        if (_isFullScreen) {
                          // _toggleFullScreen();
                        } else {
                          context.pop();
                        }
                      },
                    ),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black87,
                    title: Text(widget.title),
                  ),
                  body: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [],
                        ),
                        Center(
                          child: GestureDetector(
                            onTap: playpause,
                            onHorizontalDragStart: (details) {},
                            onVerticalDragStart: (details) {},
                            child: Container(
                              padding: const EdgeInsets.all(32),
                              child: IconButton.filledTonal(
                                onPressed: playpause,
                                icon: Icon(
                                  controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                  size: 40,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          onHorizontalDragStart: (details) {},
                          onVerticalDragStart: (details) {},
                          child: Container(
                            color: Colors.black54,
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Slider(
                                    value: sliderValue,
                                    onChanged: (v) {
                                      controller.seekTo(
                                        Duration(seconds: (controller.value.duration.inSeconds * v).toInt()),
                                      );
                                      if (context.mounted) {
                                        setState(() {});
                                      }
                                    },
                                  ),
                                ),
                                if (controller.value.aspectRatio > 1)
                                  IconButton(
                                    onPressed: _toggleFullScreen,
                                    icon: const Icon(
                                      Icons.fullscreen,
                                      color: Colors.white,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
