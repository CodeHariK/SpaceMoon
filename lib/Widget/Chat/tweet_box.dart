// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Helpers/proto.dart';
import 'package:spacemoon/Providers/roomuser.dart';
import 'package:spacemoon/Providers/tweets.dart';
import 'package:spacemoon/Providers/user_data.dart';
import 'package:spacemoon/Routes/Home/profile.dart';
import 'package:spacemoon/Static/theme.dart';
import 'package:spacemoon/Widget/AppFlowy/app_flowy_box.dart';
import 'package:spacemoon/Widget/Chat/gallery.dart';
import 'package:spacemoon/Widget/Chat/qr_box.dart';

import 'package:moonspace/form/mario.dart';
import 'package:moonspace/helper/extensions/regex.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:moonspace/helper/validator/validator.dart';

// ignore: depend_on_referenced_packages
import 'package:flutter_chat_types/flutter_chat_types.dart' show PreviewData;
import 'package:flutter_link_previewer/flutter_link_previewer.dart';

class TweetBox extends ConsumerWidget {
  const TweetBox({
    super.key,
    required this.tweet,
    required this.roomuser,
    this.isHero = false,
  });

  final Tweet tweet;
  final RoomUser roomuser;
  final bool isHero;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tweetuser = ref.watch(getUserByIdProvider(tweet.user)).value;
    final tweetroomuser = ref.watch(GetRoomUserProvider(roomId: tweet.room, userId: tweet.user)).value;

    final box = Material(
      color: Colors.transparent,
      child: Container(
        decoration: isHero
            ? null
            : BoxDecoration(
                color: AppTheme.darkness
                    ? const Color.fromARGB(221, 50, 50, 50)
                    : const Color.fromARGB(223, 246, 246, 246),
                // border: Border.all(
                //   color: AppTheme.darkness ? AppTheme.seedColor.withAlpha(200) : AppTheme.seedColor.withAlpha(100),
                // ),
                // color: AppTheme.darkness ? AppTheme.seedColor.withAlpha(80) : Color.fromARGB(66, 238, 238, 238),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  bottomLeft: Radius.circular(((roomuser.user == tweet.user) ? 20 : 0)),
                  bottomRight: Radius.circular((roomuser.user == tweet.user) ? 0 : 20),
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
                  height: (250, 500).c,
                  width: (250, 500).c,
                  child: QrBox(
                    codeQrtext: tweet.text,
                  ),
                ),

              if (tweet.mediaType == MediaType.GALLERY && tweet.gallery.isNotEmpty) GalleryBox(tweet: tweet),

              if (tweet.mediaType == MediaType.POST) AppFlowyBox(tweet: tweet),

              if (isWebsite(tweet.text))
                SizedBox(
                  width: (250, 500).c,
                  child: LinkPreviewer(url: tweet.text),
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

              if ((tweet.mediaType == MediaType.TEXT || tweet.mediaType == MediaType.QR) &&
                  !isURL(tweet.text) /*&& !isHero*/)
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SelectableLinkify(
                    onOpen: (link) async {
                      if (!await safeLaunchUrl(link.url)) {
                        throw Exception('Could not launch ${link.url}');
                      }
                    },
                    contextMenuBuilder: (context, editableTextState) {
                      return AdaptiveTextSelectionToolbar.buttonItems(
                        anchors: editableTextState.contextMenuAnchors,
                        buttonItems: <ContextMenuButtonItem>[
                          ContextMenuButtonItem(
                            onPressed: () {
                              editableTextState.copySelection(SelectionChangedCause.toolbar);
                            },
                            type: ContextMenuButtonType.copy,
                          ),
                          ContextMenuButtonItem(
                            onPressed: () {
                              editableTextState.selectAll(SelectionChangedCause.toolbar);
                            },
                            type: ContextMenuButtonType.selectAll,
                          ),
                        ],
                      );
                    },
                    text:
                        tweet.mediaType == MediaType.QR ? tweet.text.split('||').lastOrNull ?? tweet.text : tweet.text,
                    style: context.bm,
                    linkStyle: context.bm.c(Colors.blue),
                  ),
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
          InkWell(
            onTap: () {
              context.cPush(ProfilePage(searchuser: tweetuser));
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (tweetuser != null)
                  CircleAvatar(
                    child: FutureSpaceBuilder(
                      path: tweetuser.photoURL,
                      thumbnail: true,
                      radius: 200,
                    ),
                  ),
                const SizedBox(height: 5),
                Text(tweet.created.timeString, style: context.ls),
              ],
            ),
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
            (_, __) => roomuser.user == tweet.user ? -1 : 1,
          ),
      ),
    );

    return isHero
        ? (tweet.mediaType == MediaType.POST || isWebsite(tweet.text))
            ? box
            : Hero(
                tag: tweet.path,
                child: box,
              )
        : GestureDetector(
            onLongPress: !((tweetroomuser != null && roomuser.role.value > tweetroomuser.role.value) ||
                    roomuser.user == tweet.user)
                ? null
                : () {
                    marioAlertDialog(
                      context: context,
                      title: 'Delete Tweet',
                      actions: (context) => [
                        MAction(
                          text: 'cancel',
                          fn: () => Navigator.pop(context),
                        ),
                        MAction(
                          text: 'Yes',
                          fn: () {
                            Navigator.pop(context);
                            ref.read(tweetsProvider.notifier).deleteTweet(tweet: tweet);
                          },
                        ),
                      ],
                    );
                  },
            // onTap: () {
            //   TweetRoute(
            //     chatId: tweet.room,
            //     tweetId: tweet.uid,
            //     $extra: tweet,
            //   ).navPush(context);
            // },
            child: child,
          );
  }
}

class LinkPreviewer extends StatefulWidget {
  const LinkPreviewer({super.key, required this.url});

  final String url;

  @override
  State<LinkPreviewer> createState() => _LinkPreviewerState();
}

class _LinkPreviewerState extends State<LinkPreviewer> {
  PreviewData? data;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        safeLaunchUrl(widget.url);
      },
      child: AnimatedScale(
        scale: data != null ? 1 : .95,
        duration: const Duration(milliseconds: 300),
        child: LinkPreview(
          enableAnimation: true,
          onPreviewDataFetched: (d) {
            data = d;
            if (context.mounted) {
              setState(() {});
            }
          },
          textStyle: context.bl,
          metadataTextStyle: context.bl,
          previewData: data,
          text: widget.url,
          textWidget: Container(
            height: (250, 500).c + 16,
            width: (250, 500).c + 16,
            alignment: Alignment.bottomCenter,
            child: Text(
              widget.url,
              style: context.bl.under.c(AppTheme.op),
            ),
          ),
          width: MediaQuery.of(context).size.width,
          previewBuilder: (p0, data) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  data.title ?? '',
                  style: context.tm.bold,
                ),
                Text(data.description ?? ''),
                Align(
                  alignment: Alignment.center,
                  child: CachedNetworkImage(
                    imageUrl: data.image?.url ?? '',
                    fit: BoxFit.cover,
                    errorListener: (value) {},
                    errorWidget: (context, url, error) => const SizedBox(),
                  ),
                ),
                Text(
                  data.link ?? '',
                  style: context.bl.under.c(AppTheme.op),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// class DialogPage extends Page<String> {
//   const DialogPage({required this.child, super.key});
//   final Widget child;
//   @override
//   Route<String> createRoute(BuildContext context) {
//     return DialogRoute<String>(
//       context: context,
//       settings: this,
//       useSafeArea: false,
//       builder: (BuildContext context) => child,
//     );
//   }
// }

// class TweetRoute extends GoRouteData {
//   final String chatId;
//   final String tweetId;
//   final Tweet $extra;

//   const TweetRoute({
//     required this.chatId,
//     required this.tweetId,
//     required this.$extra,
//   });

//   static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

//   @override
//   Page<String> buildPage(BuildContext context, GoRouterState state) {
//     return DialogPage(
//       key: state.pageKey,
//       child: TweetDialog(
//         chatId: chatId,
//         tweetId: tweetId,
//         tweet: $extra,
//       ),
//     );
//   }

//   void navPush(BuildContext context) {
//     Navigator.of(context).push(
//       PageRouteBuilder(
//         opaque: false,
//         barrierDismissible: true,
//         barrierColor: AppTheme.darkness ? const Color.fromARGB(50, 255, 255, 255) : const Color.fromARGB(50, 0, 0, 0),
//         transitionsBuilder: (context, animation, secondaryAnimation, child) {
//           return FadeTransition(
//             opacity: animation,
//             child: child,
//           );
//         },
//         pageBuilder: (BuildContext context, _, __) {
//           return TweetDialog(
//             chatId: chatId,
//             tweetId: tweetId,
//             tweet: $extra,
//           );
//         },
//       ),
//     );
//   }
// }

// class TweetDialog extends ConsumerWidget {
//   const TweetDialog({
//     super.key,
//     required this.chatId,
//     required this.tweetId,
//     required this.tweet,
//   });

//   final String chatId;
//   final String tweetId;
//   final Tweet tweet;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return GestureDetector(
//       onTap: () => GoRouter.maybeOf(context)?.pop('Hello'),
//       child: AlertDialog(
//         // title: Text('$chatId : $tweetId'),
//         contentPadding: const EdgeInsets.all(4),
//         content: TweetBox(
//           tweet: tweet,
//           isHero: true,
//         ),
//         actions: [
//           AsyncLock(
//             builder: (loading, status, lock, open, setStatus) {
//               return OutlinedButton(
//                 onPressed: () async {
//                   lock();
//                   await ref.read(tweetsProvider.notifier).deleteTweet(tweet: tweet);
//                   open();
//                   if (context.mounted) {
//                     context.pop();
//                   }
//                 },
//                 child: const Text('Delete'),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
