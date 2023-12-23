import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moonspace/helper/stream/functions.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:moonspace/widgets/animated/animated_buttons.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Helpers/proto.dart';
import 'package:spacemoon/Providers/room.dart';
import 'package:spacemoon/Providers/roomuser.dart';
import 'package:spacemoon/Providers/router.dart';
import 'package:spacemoon/Providers/user_data.dart';
import 'package:spacemoon/Routes/Home/Chat/Info/chat_info.dart';
import 'package:spacemoon/Routes/Home/home.dart';
import 'package:spacemoon/Routes/Home/search.dart';
import 'package:spacemoon/Routes/Special/error_page.dart';
import 'package:spacemoon/Widget/Chat/gallery.dart';
import 'package:spacemoon/Widget/Chat/send_box.dart';
import 'package:spacemoon/Widget/Chat/tweet_box.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:spacemoon/main.dart';

class ChatRoute extends GoRouteData {
  final String chatId;

  const ChatRoute({required this.chatId});

  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return MaterialPage(
      child: ChatPage(
        chatId: chatId,
      ),
    );
  }
}

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key, required this.chatId});

  final String chatId;

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  //
  final ItemScrollController itemScrollController = ItemScrollController();
  final ScrollOffsetController scrollOffsetController = ScrollOffsetController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  final ScrollOffsetListener scrollOffsetListener = ScrollOffsetListener.create();

  late final StreamController<(int? index, bool show)> dateStream =
      createDebounceFunc(1000, ((int? index, bool show) value) async {
    if (value.$2) {
      dateStream.add((value.$1, false));
    }
  });

  @override
  void initState() {
    super.initState();

    ref.read(currentRoomProvider.notifier).updateRoom(id: widget.chatId);

    itemPositionsListener.itemPositions.addListener(() {
      dateStream.add((itemPositionsListener.itemPositions.value.lastOrNull?.index, true));
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final roomPro = ref.watch(roomStreamProvider);
    // final room = roomPro.value;
    final room = ref.watch(
      roomStreamProvider.select(
        (room) => room.value == null
            ? null
            : Room(
                uid: room.value?.uid,
                displayName: room.value?.displayName,
                nick: room.value?.nick,
                photoURL: room.value?.photoURL,
              ),
      ),
    );

    final user = ref.watch(currentUserDataProvider).value;

    // final meInRoomPro = ref.watch(currentRoomUserProvider);
    // final meInRoom = meInRoomPro.value;
    final meInRoom = ref.watch(
      currentRoomUserProvider.select(
        (roomuser) => roomuser.value == null
            ? null
            : RoomUser(
                uid: roomuser.value?.uid,
                room: roomuser.value?.room,
                user: roomuser.value?.user,
                role: roomuser.value?.role),
      ),
    );

    // if (roomPro.isLoading) {
    //   return const Scaffold(
    //     backgroundColor: Colors.red,
    //   );
    // }
    // if (meInRoomPro.isLoading) {
    //   return const Scaffold(
    //     backgroundColor: Colors.blue,
    //   );
    // }

    if (room == null) {
      return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              ref.read(currentRoomProvider.notifier).exitRoom(meInRoom);
              context.pop();
            },
          ),
          title: Text(widget.chatId),
        ),
      );
    }

    Query<Tweet?>? query = room.tweetCol?.orderBy(
      Const.created.name,
      descending: true,
    );

    if (query == null) {
      return const Error404Page();
    }

    if (meInRoom == null || meInRoom.role == Role.REQUEST /* && room.open != Visible.OPEN*/) {
      return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              ref.read(currentRoomProvider.notifier).exitRoom(meInRoom);
              context.pop();
            },
          ),
        ),
        body: ChatInfoPage(
          chatId: room.uid,
          showAppbar: false,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            ref.read(currentRoomProvider.notifier).exitRoom(meInRoom);
            context.pop();
          },
        ),
        titleSpacing: 0,
        title: ListTile(
          titleAlignment: ListTileTitleAlignment.center,
          contentPadding: EdgeInsets.zero,
          onTap: () {
            ChatInfoRoute(chatId: widget.chatId).go(context);
          },
          title: Text(
            room.displayName.replaceAll(user?.displayName ?? '***', '').trim(),
            maxLines: 1,
          ),
          subtitle: Text(room.nick, maxLines: 1),
          leading: CircleAvatar(
            radius: 24,
            child: FutureSpaceBuilder(
              path: room.photoURL,
              radius: 100,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () async {
                  final url = SpaceMoon.domain + GoRouterState.of(context).uri.path;
                  await Clipboard.setData(
                    ClipboardData(text: url),
                  );
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied to Clipboard')),
                    );
                  }
                },
                icon: const Icon(Icons.copy_rounded),
              ),
              if (meInRoom.isUserOrAdmin)
                IconButton(
                  onPressed: () {
                    context.bSlidePush(
                      SearchPage(
                        room: room,
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_circle_outline),
                ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: FirestoreQueryBuilder(
                query: query,
                builder: (context, allTweetSnap, child) {
                  // if (allTweetSnap.isFetching) {
                  //   return const SizedBox.shrink();
                  // }

                  if (allTweetSnap.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'error ${allTweetSnap.error}',
                          style: context.tm,
                        ),
                      ),
                    );
                  }

                  return Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      ScrollablePositionedList.separated(
                        // minCacheExtent: 600,
                        itemScrollController: itemScrollController,
                        scrollOffsetController: scrollOffsetController,
                        itemPositionsListener: itemPositionsListener,
                        scrollOffsetListener: scrollOffsetListener,
                        reverse: true,
                        itemCount: allTweetSnap.docs.length,
                        separatorBuilder: (context, index) {
                          final doc = allTweetSnap.docs[index];
                          final tweet = doc.data()!;

                          if (index > 0 && index < allTweetSnap.docs.length) {
                            Tweet lastTweet = allTweetSnap.docs[index + 1].data()!;

                            final lDate = lastTweet.created.date;
                            final cDate = tweet.created.date;

                            if (lDate.month != cDate.month || lDate.day != cDate.day || lDate.year != cDate.year) {
                              return Chip(
                                padding: EdgeInsets.zero,
                                label: Text(tweet.created.dateString),
                              );
                            }
                          }
                          return const SizedBox.shrink();
                        },
                        itemBuilder: (context, index) {
                          if (allTweetSnap.hasMore && index + 1 == allTweetSnap.docs.length) {
                            allTweetSnap.fetchMore();
                          }
                          final doc = allTweetSnap.docs[index];
                          final tweet = doc.data()!;
                          tweet.room = widget.chatId;
                          tweet.path = doc.reference.path;

                          return TweetBox(
                            key: ValueKey(tweet.hashCode),
                            roomuser: meInRoom,
                            tweet: tweet,
                          );
                        },
                      ),
                      if (allTweetSnap.docs.isNotEmpty)
                        StreamBuilder(
                          stream: dateStream.stream,
                          builder: (context, dateSnapshot) {
                            final value = dateSnapshot.data;
                            final index = value?.$1;
                            if (index == null || allTweetSnap.docs.length <= index) {
                              return const SizedBox();
                            }
                            final show = value!.$2;
                            final date = allTweetSnap.docs[index].data()!.created.dateString;

                            return TweenAnimationBuilder(
                              tween: Tween<double>(begin: show ? 0 : 1, end: show ? 1 : 0),
                              curve: Curves.linear,
                              duration: const Duration(seconds: 1),
                              builder: (context, value, child) {
                                return Opacity(
                                  opacity: clampDouble(value * 5, 0, 1),
                                  child: child,
                                );
                              },
                              child: Chip(
                                padding: EdgeInsets.zero,
                                label: Text(date),
                              ),
                            );
                          },
                        ),
                    ],
                  );
                },
              ),
            ),
            if (meInRoom.isInvite)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: MaterialBanner(
                  elevation: 2,
                  content: const Text('Invited to room'),
                  actions: [
                    AsyncLock(
                      builder: (loading, status, lock, open, setStatus) {
                        return OutlinedButton(
                          onPressed: () async {
                            lock();
                            await ref.read(currentRoomProvider.notifier).deleteRoomUser(meInRoom);
                            ref.read(currentRoomProvider.notifier).exitRoom(null);
                            if (context.mounted) {
                              HomeRoute().go(context);
                            }
                            open();
                          },
                          child: const Text('Decline'),
                        );
                      },
                    ),
                    AsyncLock(
                      builder: (loading, status, lock, open, setStatus) {
                        return FilledButton(
                          onPressed: () async {
                            lock();
                            await ref.read(currentRoomProvider.notifier).upgradeAccessToRoom(meInRoom);
                            ref.invalidate(currentRoomUserProvider);
                            open();
                          },
                          child: const Text('Accept'),
                        );
                      },
                    ),
                  ],
                ),
              ),
            if (meInRoom.isUserOrAdmin) SendBox(roomUser: meInRoom),
          ],
        ),
      ),
    );
  }
}
