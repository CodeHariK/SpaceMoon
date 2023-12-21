import 'package:flutter/material.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerBox extends StatefulWidget {
  const VideoPlayerBox({super.key, required this.title, required this.url});

  final String title;
  final String url;

  @override
  State<VideoPlayerBox> createState() => _VideoPlayerBoxState();
}

class _VideoPlayerBoxState extends State<VideoPlayerBox> {
  late final VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.url),
      videoPlayerOptions: VideoPlayerOptions(
        allowBackgroundPlayback: false,
      ),
    );

    controller.initialize().then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.fPush(
        VideoPlayerScaffold(
          title: widget.title,
          controller: controller,
        ),
      ),
      child: Container(
        width: 300,
        height: 300,
        color: Colors.green,
      ),
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

class _VideoPlayerScaffoldState extends State<VideoPlayerScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: VideoPlayer(widget.controller),
    );
  }
}
