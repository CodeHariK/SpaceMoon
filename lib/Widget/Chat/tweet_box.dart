import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moonspace/Helper/extensions.dart';
import 'package:moonspace/darkknight/extensions/regex.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Providers/room.dart';
import 'package:spacemoon/Providers/router.dart';
import 'package:spacemoon/Static/theme.dart';
import 'package:spacemoon/Widget/Chat/qr_box.dart';
import 'package:spacemoon/Widget/Common/video_player.dart';

class TweetBox extends HookConsumerWidget {
  const TweetBox({
    super.key,
    required this.tweet,
    this.isHero = false,
  });

  final Tweet tweet;
  final bool isHero;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final ValueNotifier<PreviewData?> linkPreviewData = useState(null);

    final roomuser = ref.watch(currentRoomUserProvider).value;

    final box = Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.darkness ? AppTheme.seedColor.withAlpha(120) : AppTheme.seedColor.withAlpha(20),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              // SuperLink(tweet.text),

              //
              if (tweet.mediaType == MediaType.VIDEO)
                VideoPlayerBox(
                  tweet: tweet
                    ..text = 'Sintel'
                    ..link = 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
                  // 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
                ),

              if (tweet.mediaType == MediaType.IMAGE)
                ClipRRect(
                  borderRadius: 25.br,
                  child: SizedBox(
                    height: 300,
                    width: 300,
                    child: Image.network(
                      tweet.link,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

              if (tweet.mediaType == MediaType.QR)
                QrBox(
                  codeQrtext: tweet.text,
                ),

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

              // if (tweet.mediaType != MediaType.QR)
              if (isHero)
                TextFormField(
                  initialValue: tweet.text,
                  minLines: 1,
                  maxLines: 10,
                  decoration: const InputDecoration(
                    hintText: 'Type...',
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              if (!isHero)
                Text(
                  tweet.text,
                  // minLines: 1,
                  // maxLines: 5,
                ),
            ],
          ),
        ),
      ),
    );

    final child = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.palette_outlined),
                      Text('${tweet.created.toDateTime().toLocal().hour}'),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: (tweet.mediaType == MediaType.VIDEO)
                ? box
                : Row(
                    children: [
                      const Spacer(),
                      Hero(
                        tag: tweet.path,
                        child: box,
                      ),
                    ],
                  ),
          ),
        ]..sort(
            (_, __) => roomuser?.user == tweet.user ? -1 : 1,
          ),
      ),
    );

    return isHero
        ? (tweet.mediaType == MediaType.VIDEO)
            ? box
            : Hero(
                tag: tweet.path,
                child: box,
              )
        : GestureDetector(
            onTap: (tweet.mediaType == MediaType.VIDEO)
                ? null
                : () {
                    TweetRoute(
                      chatId: tweet.room,
                      tweetPath: tweet.path,
                      $extra: tweet,
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
  final Tweet $extra;

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
        tweet: $extra,
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
            tweet: $extra,
          );
        },
      ),
    );
  }
}

class TweetDialog extends ConsumerWidget {
  const TweetDialog({
    super.key,
    this.dialog = true,
    required this.chatId,
    required this.tweet,
  });

  final String chatId;
  final bool dialog;
  final Tweet tweet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => GoRouter.maybeOf(context)?.pop('Hello'),
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(4),
        content: TweetBox(tweet: tweet, isHero: true),
        actions: [
          OutlinedButton(
            onPressed: () {
              // ref.read(tweetsProvider.notifier).deleteTweet(tweet: tweet);
              context.pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
