import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:moonspace/Helper/extensions.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerBox extends StatefulWidget {
  const VideoPlayerBox({
    super.key,
    required this.title,
    required this.videoUrl,
    this.videoOnly = true,
  });

  final String videoUrl;
  final String title;
  final bool videoOnly;

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
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    )
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
        if (!widget.videoOnly) {
          // _startHideControlsTimer();
          _videoPlayerController.play();
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

  void _playPauseVideo() {
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
  }

  void _onSliderChanged(double value) {
    setState(() {
      _sliderValue = value;
      final Duration duration = _videoPlayerController.value.duration;
      final double newPosition = value * duration.inMilliseconds.toDouble();
      _videoPlayerController.seekTo(Duration(milliseconds: newPosition.toInt()));
    });
  }

  void _replayVideo() {
    setState(() {
      _videoPlayerController.seekTo(Duration.zero);
      _videoPlayerController.play();
      _animationController.reverse();
      _showReplayButton = false;
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
      onTap: widget.videoOnly ? null : _startHideControlsTimer,
      onDoubleTapDown: widget.videoOnly
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
          child: !_videoPlayerController.value.isInitialized
              ? Animate(
                  effects: const [ShimmerEffect(size: 2, delay: Duration(seconds: 2), duration: Duration(seconds: 2))],
                  onComplete: (controller) => controller.repeat(),
                  child: Scaffold(appBar: appbar(context)),
                )
              : Stack(
                  alignment: Alignment.center,
                  children: [
                    if (!widget.videoOnly) appbar(context),

                    video(),

                    //
                    if ((!_videoPlayerController.value.isPlaying || _showControls) && !widget.videoOnly) ...[
                      playPauseButton(),
                      // controls(),
                    ],
                    if (_showReplayButton && !widget.videoOnly) replayButton(),
                  ],
                ),
        ),
      ),
    );

    if (widget.videoOnly) {
      return GestureDetector(
        onTap: () {
          context.bSlidePush(
            VideoPlayerBox(
              title: widget.title,
              videoUrl: widget.videoUrl,
              videoOnly: false,
            ),
          );
        },
        child: videoBox,
      );
    } else {
      return Scaffold(
        body: SafeArea(
          right: false,
          left: false,
          child: Center(child: videoBox),
        ),
      );
    }
  }

  AppBar appbar(BuildContext context) {
    return AppBar(
      title: Text(widget.title),
      leading: BackButton(
        onPressed: () {
          if (_isFullScreen) {
            _toggleFullScreen();
          }
          context.pop();
        },
      ),
    );
  }

  Stack video() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          foregroundDecoration: (widget.videoOnly || _videoPlayerController.value.isPlaying)
              ? null
              : const BoxDecoration(color: Color.fromARGB(63, 111, 111, 111)),
          child: AspectRatio(
            aspectRatio: _videoPlayerController.value.aspectRatio,
            child: VideoPlayer(_videoPlayerController),
          ),
        ),
        if (!widget.videoOnly && _showControls) ...controls(),
        if (_videoPlayerController.value.isBuffering)
          const CircularProgressIndicator(
            strokeWidth: 10,
          ),
      ],
    );
  }

  AnimatedOpacity playPauseButton() {
    return AnimatedOpacity(
      opacity: _showControls ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: IconButton(
        onPressed: _playPauseVideo,
        icon: AnimatedIcon(
          icon: AnimatedIcons.pause_play,
          progress: _animationController,
          size: 60,
          color: Colors.white,
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
        child: Container(
          color: const Color.fromARGB(86, 0, 0, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              if (_isFullScreen)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BackButton(
                    onPressed: () {
                      if (_isFullScreen) {
                        _toggleFullScreen();
                      }
                      context.pop();
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
                  child: Text('${_videoPlayerController.value.captionOffset.inMilliseconds}ms'),
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
                        child: Text('${speed}x'),
                      )
                  ];
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Text('${_videoPlayerController.value.playbackSpeed}x'),
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
          color: const Color.fromARGB(86, 0, 0, 0),
          padding: const EdgeInsets.all(4.0),
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
                ),
              ),
              IconButton(
                onPressed: _toggleFullScreen,
                icon: const Icon(
                  Icons.fullscreen,
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
      onPressed: _replayVideo,
      icon: const Icon(
        Icons.replay,
        size: 60,
        color: Colors.white,
      ),
    );
  }
}
