import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerBox extends StatefulWidget {
  const VideoPlayerBox({
    super.key,
    this.videoOnlyOri = true,
    required this.localUrl,
    required this.url,
    required this.title,
  });

  final bool videoOnlyOri;
  final String title;
  final String localUrl;
  final String url;

  @override
  State<VideoPlayerBox> createState() => _VideoPlayerBoxState();
}

class _VideoPlayerBoxState extends State<VideoPlayerBox> with SingleTickerProviderStateMixin {
  late VideoPlayerController _videoPlayerController;
  late AnimationController _animationController;

  double _sliderValue = 0.0;

  bool _showControls = false;
  bool _showReplayButton = false;
  bool _isFullScreen = false;

  bool videoOnly = true;

  Timer? _hideControlsTimer;
  static const Duration _controlsVisibleDuration = Duration(seconds: 3);

  static const List<Duration> _exampleCaptionOffsets = <Duration>[
    Duration(seconds: -10),
    Duration(seconds: -3),
    Duration(seconds: -1, milliseconds: -500),
    Duration(milliseconds: -250),
    Duration.zero,
    Duration(milliseconds: 250),
    Duration(seconds: 1, milliseconds: 500),
    Duration(seconds: 3),
    Duration(seconds: 10),
  ];
  static const List<double> _examplePlaybackRates = <double>[
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
  ];

  @override
  void initState() {
    super.initState();
    videoOnly = widget.videoOnlyOri;

    _videoPlayerController = (widget.url.isNotEmpty)
        ? VideoPlayerController.networkUrl(
            Uri.parse(widget.url),
            videoPlayerOptions: VideoPlayerOptions(
              allowBackgroundPlayback: false,
            ),
          )
        : VideoPlayerController.file(File(widget.localUrl));

    _videoPlayerController
      ..addListener(() {
        // Inside the `addListener` callback of the `VideoPlayerController`
        if (_videoPlayerController.value.isInitialized && !_videoPlayerController.value.isBuffering) {
          setState(() {
            _sliderValue = _videoPlayerController.value.position.inSeconds.toDouble() /
                _videoPlayerController.value.duration.inSeconds.toDouble();
          });
        }

        if (_videoPlayerController.value.isCompleted) {
          setState(() {
            _showControls = false;
            _showReplayButton = true;
          });
        }
      })
      ..initialize().then((_) {
        setState(() {});
        if (!videoOnly) {
          // _startHideControlsTimer();
          _videoPlayerController.play();
        } else {
          _videoPlayerController.seekTo(
              Duration(seconds: _videoPlayerController.value.duration.inSeconds ~/ (Random().nextInt(100) + 1)));
        }
      });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _animationController.dispose();
    _hideControlsTimer?.cancel();
    super.dispose();
  }

  void _onSliderChanged(double value) {
    setState(() {
      _sliderValue = value;
      final Duration duration = _videoPlayerController.value.duration;
      final double newPosition = value * duration.inMilliseconds.toDouble();
      _videoPlayerController.seekTo(Duration(milliseconds: newPosition.toInt()));
    });
  }

  void _tapSeek(bool forward) {
    // final Duration duration = _videoPlayerController.value.duration;
    final double currentPosition = _videoPlayerController.value.position.inMilliseconds.toDouble();
    final double targetPosition = currentPosition + (forward ? 10000 : -10000)
        //* (math.min(duration.inMilliseconds * 0.1, 10000))
        ;
    _videoPlayerController.seekTo(Duration(milliseconds: targetPosition.toInt()));
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(_controlsVisibleDuration, () {
      if (_videoPlayerController.value.isPlaying && _showControls) {
        setState(() {
          _showControls = false;
        });
      }
    });
    setState(() {
      _showControls = true;
    });
  }

  void _toggleFullScreen() {
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

  @override
  Widget build(BuildContext context) {
    final videoBox = GestureDetector(
      onTap: videoOnly ? null : _startHideControlsTimer,
      onDoubleTapDown: videoOnly
          ? null
          : (details) {
              final double screenWidth = MediaQuery.of(context).size.width;
              if (details.globalPosition.dx / screenWidth < .3) {
                _tapSeek(false);
              }
              if (details.globalPosition.dx / screenWidth > .7) {
                _tapSeek(true);
              }
              _startHideControlsTimer();
            },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.antiAlias,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) =>
              ScaleTransition(scale: Tween<double>(begin: .9, end: 1).animate(animation), child: child),
          child: videoOnly
              ? (!_videoPlayerController.value.isInitialized
                  ? const SizedBox(
                      height: 120,
                    )
                  : video())
              : (!_videoPlayerController.value.isInitialized
                  ? Animate(
                      effects: const [
                        ShimmerEffect(size: 2, delay: Duration(seconds: 2), duration: Duration(seconds: 2))
                      ],
                      onComplete: (controller) => controller.repeat(),
                      child: Scaffold(appBar: appbar(context)),
                    )
                  : Stack(
                      alignment: Alignment.center,
                      children: [
                        if ((!_videoPlayerController.value.isPlaying || _showControls) && !_isFullScreen && !videoOnly)
                          appbar(context),

                        video(),

                        if ((!_videoPlayerController.value.isPlaying || _showControls) && !_isFullScreen && !videoOnly)
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: SizedBox(
                              height: 120,
                              child: appbar(context),
                            ),
                          ),
                        //
                        if ((!_videoPlayerController.value.isPlaying || _showControls) &&
                            !_showReplayButton &&
                            !videoOnly)
                          playPauseButton(),
                        if (_showReplayButton && !videoOnly) replayButton(),
                      ],
                    )),
        ),
      ),
    );

    if (videoOnly) {
      // return videoBox;
      return GestureDetector(
        onTap: () {
          // context.bSlidePush(
          // VideoPlayerBox(
          //   title: widget.title,
          //   videoUrl: widget.videoUrl,
          //   videoOnly: false,
          // ),
          // );
          Navigator.of(context).push(
            PageRouteBuilder(
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  // child: Hero(
                  //   tag: widget.link,
                  child: VideoPlayerBox(
                    url: widget.url,
                    localUrl: widget.localUrl,
                    title: widget.title,
                    videoOnlyOri: false,
                  ),
                  // ),
                );
              },
              pageBuilder: (context, animation, secondaryAnimation) {
                return const FlutterLogo();
                // return Scaffold(
                //   appBar: AppBar(),
                //   body: Center(
                //     child: Hero(tag: widget.tweet.link, child: videoBox),
                //   ),
                // );
              },
            ),
          );
          // MaterialPageRoute(
          //   builder: (context) {
          //     return Scaffold(
          //       body: Center(
          //         child: Hero(tag: widget.videoUrl, child: videoBox),
          //       ),
          //     );
          //   },
          // ),
        },
        child: videoBox,
        // child: Hero(tag: widget.link, child: videoBox),
      );
    } else {
      return Scaffold(
        body: SafeArea(
          top: false,
          bottom: false,
          right: false,
          left: false,
          child: Center(child: videoBox),
        ),
      );
    }
  }

  AppBar appbar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(153, 12, 12, 12),
      title: Text(widget.title, style: const TextStyle(color: Colors.white)),
      leading: BackButton(
        color: Colors.white,
        onPressed: () {
          if (!_isFullScreen) context.pop();
          if (_isFullScreen) _toggleFullScreen();
        },
      ),
    );
  }

  Stack video() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          foregroundDecoration: (videoOnly || _videoPlayerController.value.isPlaying)
              ? null
              : const BoxDecoration(color: Color.fromARGB(100, 67, 67, 67)),
          child: _isFullScreen
              ? VideoPlayer(_videoPlayerController)
              : AspectRatio(
                  aspectRatio: _videoPlayerController.value.aspectRatio,
                  child: VideoPlayer(_videoPlayerController),
                ),
        ),
        if (!videoOnly && _showControls) ...controls(),
        // if (_videoPlayerController.value.isBuffering)
        //   const CircularProgressIndicator(
        //     strokeWidth: 10,
        //   ),
      ],
    );
  }

  AnimatedOpacity playPauseButton() {
    return AnimatedOpacity(
      opacity: _showControls ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: IconButton.filledTonal(
        onPressed: () {
          _hideControlsTimer?.cancel();
          setState(() {
            if (_videoPlayerController.value.isPlaying) {
              _videoPlayerController.pause();
              _animationController.forward();
            } else {
              _videoPlayerController.play();
              _animationController.reverse();
            }
            _startHideControlsTimer();
          });
        },
        icon: AnimatedIcon(
          icon: AnimatedIcons.pause_play,
          progress: _animationController,
          size: 40,
        ),
      ),
    );
  }

  List<Positioned> controls() {
    return [
      Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Padding(
          padding: const EdgeInsets.all(8),
          // color: const Color.fromARGB(86, 0, 0, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              if (_isFullScreen)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BackButton(
                    color: Colors.white,
                    onPressed: () {
                      if (!_isFullScreen) context.pop();
                      if (_isFullScreen) _toggleFullScreen();
                    },
                  ),
                ),
              const Spacer(),
              PopupMenuButton<Duration>(
                initialValue: _videoPlayerController.value.captionOffset,
                tooltip: 'Caption Offset',
                onSelected: (Duration delay) {
                  _videoPlayerController.setCaptionOffset(delay);
                },
                itemBuilder: (BuildContext context) {
                  return <PopupMenuItem<Duration>>[
                    for (final Duration offsetDuration in _exampleCaptionOffsets)
                      PopupMenuItem<Duration>(
                        value: offsetDuration,
                        child: Text('${offsetDuration.inMilliseconds}ms'),
                      )
                  ];
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Text(
                    '${_videoPlayerController.value.captionOffset.inMilliseconds}ms',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              PopupMenuButton<double>(
                initialValue: _videoPlayerController.value.playbackSpeed,
                tooltip: 'Playback speed',
                onSelected: (double speed) {
                  _videoPlayerController.setPlaybackSpeed(speed);
                },
                itemBuilder: (BuildContext context) {
                  return <PopupMenuItem<double>>[
                    for (final double speed in _examplePlaybackRates)
                      PopupMenuItem<double>(
                        value: speed,
                        child: Text(
                          '${speed}x',
                        ),
                      )
                  ];
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Text(
                    '${_videoPlayerController.value.playbackSpeed}x',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          color: const Color.fromARGB(120, 67, 67, 67),
          padding: EdgeInsets.all(_isFullScreen ? 32.0 : 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Text(
              //   '${durationMMSS(_videoPlayerController.value.position)} / ${durationMMSS(_videoPlayerController.value.duration)}',
              // ),
              Expanded(
                child: Slider(
                  value: _sliderValue,
                  onChanged: _onSliderChanged,
                  activeColor: Colors.white,
                  inactiveColor: const Color.fromARGB(134, 255, 255, 255),
                ),
              ),
              if (_videoPlayerController.value.aspectRatio > 1)
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
    ];
  }

  IconButton replayButton() {
    return IconButton(
      onPressed: () {
        setState(() {
          _videoPlayerController.seekTo(Duration.zero);
          _videoPlayerController.play();
          _animationController.reverse();
          _showReplayButton = false;
        });
      },
      icon: const Icon(
        Icons.replay,
        size: 60,
        color: Colors.white,
      ),
    );
  }
}
