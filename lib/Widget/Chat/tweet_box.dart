import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moonspace/helper/extensions/regex.dart';
import 'package:moonspace/helper/validator/validator.dart';
import 'package:any_link_preview/any_link_preview.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:moonspace/widgets/animated/animated_buttons.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Helpers/proto.dart';
import 'package:spacemoon/Providers/router.dart';
import 'package:spacemoon/Providers/tweets.dart';
import 'package:spacemoon/Providers/user_data.dart';
import 'package:spacemoon/Static/theme.dart';
import 'package:spacemoon/Widget/AppFlowy/app_flowy_box.dart';
import 'package:spacemoon/Widget/Chat/gallery.dart';
import 'package:spacemoon/Widget/Chat/qr_box.dart';
import 'package:spacemoon/Widget/Common/shimmer_boxes.dart';

class TweetBox extends ConsumerWidget {
  const TweetBox({
    super.key,
    required this.tweet,
    this.isHero = false,
    required this.room,
  });

  final Tweet tweet;
  final Room room;
  final bool isHero;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserDataProvider).value;
    final tweetuser = ref.watch(getUserByIdProvider(tweet.user)).value;

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
                        : const Color.fromARGB(77, 162, 162, 162),
                  ),
                ],
                color: AppTheme.darkness ? const Color.fromARGB(221, 50, 50, 50) : Colors.white,
                // border: Border.all(
                //   color: AppTheme.darkness ? AppTheme.seedColor.withAlpha(200) : AppTheme.seedColor.withAlpha(100),
                // ),
                // color: AppTheme.darkness ? AppTheme.seedColor.withAlpha(80) : Color.fromARGB(66, 238, 238, 238),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  bottomLeft: Radius.circular(((user?.uid == tweet.user) ? 20 : 0)),
                  bottomRight: Radius.circular((user?.uid == tweet.user) ? 0 : 20),
                  topRight: const Radius.circular(20),
                ),
              ),
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
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

              if (isURL(tweet.text))
                SizedBox(
                  width: 300,
                  child: Text.rich(
                    TextSpan(
                      text: tweet.text,
                      style: const TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          safeLaunchUrl(tweet.text);
                        },
                    ),
                  ),
                ),

              // if (isHero)
              //   TextFormField(
              //     initialValue: tweet.text,
              //     minLines: 1,
              //     maxLines: 10,
              //     decoration: const InputDecoration(
              //       hintText: 'Type...',
              //       border: InputBorder.none,
              //       enabledBorder: InputBorder.none,
              //       focusedBorder: InputBorder.none,
              //     ),
              //   ),
              if (tweet.mediaType == MediaType.TEXT && !isURL(tweet.text) /*&& !isHero*/)
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
              if (tweetuser != null)
                CircleAvatar(
                  child: (!isURL(tweetuser.photoURL))
                      ? null
                      : CustomCacheImage(
                          imageUrl: spaceThumbImage(tweetuser.photoURL),
                          radius: 32,
                        ),
                ),
              const SizedBox(height: 5),
              Text(tweet.created.timeString, style: context.ls),
            ],
          ),
          (tweet.mediaType == MediaType.POST)
              ? box
              : LimitedBox(
                  maxWidth: AppTheme.w * .7,
                  child: Hero(
                    tag: tweet.path,
                    child: box,
                  ),
                ),
        ]..sort(
            (_, __) => user?.uid == tweet.user ? -1 : 1,
          ),
      ),
    );

    return isHero
        ? (tweet.mediaType == MediaType.POST)
            ? box
            : Hero(
                tag: tweet.path,
                child: box,
              )
        : GestureDetector(
            onLongPress: () {},
            onTap: () {
              TweetRoute(
                chatId: tweet.room,
                tweetId: tweet.uid,
                $extra: TweetRouteObj(
                  tweet: tweet,
                  room: room,
                ),
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

class TweetRouteObj {
  final Tweet tweet;
  final Room room;

  TweetRouteObj({
    required this.tweet,
    required this.room,
  });
}

class TweetRoute extends GoRouteData {
  final String chatId;
  final String tweetId;
  final TweetRouteObj $extra;

  const TweetRoute({
    required this.chatId,
    required this.tweetId,
    required this.$extra,
  });

  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  @override
  Page<String> buildPage(BuildContext context, GoRouterState state) {
    return DialogPage(
      key: state.pageKey,
      child: TweetDialog(
        chatId: chatId,
        tweetId: tweetId,
        tweet: $extra.tweet,
        room: $extra.room,
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
            tweetId: tweetId,
            tweet: $extra.tweet,
            room: $extra.room,
          );
        },
      ),
    );
  }
}

class TweetDialog extends ConsumerWidget {
  const TweetDialog({
    super.key,
    required this.chatId,
    required this.tweetId,
    required this.tweet,
    required this.room,
  });

  final String chatId;
  final String tweetId;
  final Tweet tweet;
  final Room room;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => GoRouter.maybeOf(context)?.pop('Hello'),
      child: AlertDialog(
        // title: Text('$chatId : $tweetId'),
        contentPadding: const EdgeInsets.all(4),
        content: TweetBox(
          tweet: tweet,
          isHero: true,
          room: room,
        ),
        actions: [
          AsyncLock(
            builder: (loading, status, lock, open, setStatus) {
              return OutlinedButton(
                onPressed: () async {
                  lock();
                  await ref.read(tweetsProvider.notifier).deleteTweet(tweet: tweet);
                  open();
                  if (context.mounted) {
                    context.pop();
                  }
                },
                child: const Text('Delete'),
              );
            },
          ),
        ],
      ),
    );
  }
}
