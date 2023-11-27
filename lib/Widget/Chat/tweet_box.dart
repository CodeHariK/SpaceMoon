import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:moonspace/helper/extensions/regex.dart';
import 'package:any_link_preview/any_link_preview.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Providers/room.dart';
import 'package:spacemoon/Providers/router.dart';
import 'package:spacemoon/Providers/tweets.dart';
import 'package:spacemoon/Static/theme.dart';
import 'package:spacemoon/Widget/AppFlowy/app_flowy_box.dart';
import 'package:spacemoon/Widget/Chat/gallery.dart';
import 'package:spacemoon/Widget/Chat/qr_box.dart';
import 'package:spacemoon/Widget/Common/video_player.dart';

class TweetBox extends ConsumerWidget {
  const TweetBox({
    super.key,
    required this.tweet,
    this.isHero = false,
  });

  final Tweet tweet;
  final bool isHero;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomuser = ref.watch(currentRoomUserProvider).value;

    final box = Material(
      color: Colors.transparent,
      child: Container(
        decoration: isHero
            ? null
            : BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                    spreadRadius: 1,
                    color: AppTheme.darkness
                        ? const Color.fromARGB(255, 67, 67, 67)
                        : const Color.fromARGB(77, 50, 158, 158),
                  ),
                ],
                color: AppTheme.darkness ? const Color.fromARGB(221, 50, 50, 50) : Colors.white,
                // border: Border.all(
                //   color: AppTheme.darkness ? AppTheme.seedColor.withAlpha(200) : AppTheme.seedColor.withAlpha(100),
                // ),
                // color: AppTheme.darkness ? AppTheme.seedColor.withAlpha(80) : Color.fromARGB(66, 238, 238, 238),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  bottomLeft: Radius.circular(((roomuser?.user == tweet.user) ? 20 : 0)),
                  bottomRight: Radius.circular((roomuser?.user == tweet.user) ? 0 : 20),
                  topRight: const Radius.circular(20),
                ),
              ),
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // crossAxisAlignment: roomuser?.user == tweet.user ? CrossAxisAlignment.end : CrossAxisAlignment.start,
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
                SizedBox(
                  height: 300,
                  width: 300,
                  child: QrBox(
                    codeQrtext: tweet.text,
                  ),
                ),

              if (tweet.mediaType == MediaType.GALLERY && tweet.gallery.isNotEmpty) GalleryBox(tweet: tweet),

              if (tweet.mediaType == MediaType.POST) AppFlowyBox(tweet: tweet),

              if (isWebsite(tweet.text))
                SizedBox(
                  width: 300,
                  child: AnyLinkPreview(
                    link: tweet.text,
                    displayDirection: UIDirection.uiDirectionVertical,
                    showMultimedia: true,
                    bodyMaxLines: 5,
                    bodyTextOverflow: TextOverflow.ellipsis,
                  ),
                ),

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
              if (tweet.mediaType == MediaType.TEXT && !isHero)
                Text(
                  tweet.text,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  // minLines: 1,
                  maxLines: 5,
                ),
            ],
          ),
        ),
      ),
    );

    final child = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(),
              Text(DateFormat.jm().format(tweet.created.toDateTime()), style: context.ls),
            ],
          ),
          (tweet.mediaType == MediaType.VIDEO || tweet.mediaType == MediaType.POST)
              ? box
              : LimitedBox(
                  maxWidth: AppTheme.w * .7,
                  child: Hero(
                    tag: tweet.path,
                    child: box,
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
            onLongPress: () {},
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
              ref.read(tweetsProvider.notifier).deleteTweet(tweet: tweet);
              context.pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
