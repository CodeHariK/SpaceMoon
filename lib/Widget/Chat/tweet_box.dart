import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moonspace/Form/mario.dart';
import 'package:moonspace/Helper/extensions.dart';
import 'package:moonspace/darkknight/extensions/regex.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Providers/router.dart';
import 'package:spacemoon/Providers/tweets.dart';
import 'package:spacemoon/Routes/Home/home.dart';
import 'package:spacemoon/Static/theme.dart';
import 'package:spacemoon/Widget/Chat/qr_box.dart';
import 'package:spacemoon/Widget/Common/video_player.dart';

// part 'tweet_box.g.dart';

class TweetBox extends HookConsumerWidget {
  const TweetBox({
    super.key,
    required this.tweet,
    required this.roomuser,
  });

  final Tweet tweet;
  final RoomUser roomuser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final ValueNotifier<PreviewData?> linkPreviewData = useState(null);

    final child = Hero(
      tag: tweet.path,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Row(
            children: [
              const Expanded(
                flex: 2,
                child: SizedBox(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.palette_outlined),
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SelectableText(tweet.text),

                              // SuperLink(tweet.text),

                              //
                              // if (tweet.mediaType == MediaType.VIDEO)
                              //   const VideoPlayerBox(
                              //     title: 'Sintel',
                              //     videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
                              //     // 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
                              //   ),

                              // if (tweet.mediaType == MediaType.IMAGE)
                              //   ClipRRect(
                              //     borderRadius: 25.br,
                              //     child: SizedBox(
                              //       height: 300,
                              //       width: 300,
                              //       child: Image.network(
                              //         tweet.link,
                              //         fit: BoxFit.cover,
                              //       ),
                              //     ),
                              //   ),

                              // if (tweet.mediaType == MediaType.QR)
                              //   QrBox(
                              //     qrtext: tweet.text,
                              //   ),

                              // if (isWebsite(tweet.text))
                              //   link.LinkPreview(
                              //     enableAnimation: true,
                              //     onPreviewDataFetched: (p0) {
                              //       linkPreviewData.value = p0;
                              //     },
                              //     previewData: linkPreviewData.value,
                              //     text: tweet.text,
                              //     width: 300,
                              //   ),

                              Text('Time : ${tweet.created.toDateTime()}'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]..sort(
                (_, __) => roomuser.user == tweet.user ? -1 : 1,
              ),
          ),
        ),
      ),
    );

    return GestureDetector(
      onTap: () {
        TweetRoute(
          chatId: tweet.room,
          tweetPath: tweet.path,
          $extra: child,
        ).navPush(context);
      },
      child: child,
    );
  }
}

class DialogPage extends Page<String> {
  /// A page to display a dialog.
  const DialogPage({required this.child, super.key});

  /// The widget to be displayed which is usually a [Dialog] widget.
  final Widget child;

  @override
  Route<String> createRoute(BuildContext context) {
    return DialogRoute<String>(
      context: context,
      settings: this,
      useSafeArea: false,
      builder: (BuildContext context) => child,
    );
  }
}

class TweetRoute extends GoRouteData {
  final String chatId;
  final String tweetPath;
  final Widget $extra;

  const TweetRoute({
    required this.chatId,
    required this.tweetPath,
    required this.$extra,
  });

  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  @override
  Page<String> buildPage(BuildContext context, GoRouterState state) {
    return DialogPage(
      key: state.pageKey,
      child: TweetDialog(
        chatId: chatId,
        dialog: true,
        child: $extra,
      ),
    );
  }

  void navPush(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: AppTheme.darkness ? const Color.fromARGB(50, 255, 255, 255) : const Color.fromARGB(50, 0, 0, 0),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        pageBuilder: (BuildContext context, _, __) {
          return TweetDialog(
            chatId: chatId,
            dialog: true,
            child: $extra,
          );
        },
      ),
    );
  }
}

class TweetDialog extends StatelessWidget {
  const TweetDialog({
    super.key,
    this.dialog = true,
    required this.chatId,
    required this.child,
  });

  final String chatId;
  final bool dialog;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => GoRouter.maybeOf(context)?.pop('Hello'),
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(4),
        content: child,
        actions: [
          OutlinedButton(
            onPressed: () {},
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
