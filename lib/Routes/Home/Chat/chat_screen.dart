import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Providers/room.dart';
import 'package:spacemoon/Providers/router.dart';
import 'package:moonspace/widgets/anim_btn.dart';
import 'package:spacemoon/Routes/Home/Chat/Info/chat_info.dart';
import 'package:spacemoon/Routes/Home/home.dart';
import 'package:spacemoon/Routes/Special/error_page.dart';
import 'package:spacemoon/Widget/Chat/send_box.dart';
import 'package:spacemoon/Widget/Chat/tweet_box.dart';

class ChatRoute extends GoRouteData {
  final String chatId;

  const ChatRoute(this.chatId);

  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ChatPage(
      chatId: chatId,
    );
  }
}

class ChatPage extends HookConsumerWidget {
  const ChatPage({super.key, required this.chatId});

  final String chatId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomPro = ref.watch(roomStreamProvider);
    final room = roomPro.value;

    final meInRoom = ref.watch(currentRoomUserProvider).value;

    useEffect(() {
      ref.read(currentRoomProvider.notifier).updateRoom(id: chatId);

      return null;
    }, [room]);

    if (roomPro.isLoading) {
      return const Scaffold();
    }

    Query<Tweet?>? query = room?.tweetCol?.orderBy(
      Const.created.name,
      descending: true,
    );

    if (query == null || room == null) {
      return const Error404Page();
    }

    if ((meInRoom == null || meInRoom.role == Role.REQUEST) && room.open != Visible.OPEN) {
      return WillPopScope(
        onWillPop: () async {
          ref.read(currentRoomProvider.notifier).exitRoom();
          return true;
        },
        child: Scaffold(
          appBar: AppBar(),
          body: Center(
            child: Column(
              children: [
                Text('Me in room : $meInRoom'),
                Text(room.toString()),
                if (meInRoom?.role == Role.REQUEST)
                  FilledButton(
                    onPressed: () {
                      ref.read(currentRoomProvider.notifier).deleteRoomUser(meInRoom!);
                    },
                    child: const Text('Leave Room'),
                  ),
                if (meInRoom == null && room.open == Visible.MODERATED)
                  AsyncButton(
                    icon: Icons.mail,
                    asyncFn: () async {
                      await ref.read(currentRoomProvider.notifier).requestAccessToRoom();
                      return true;
                    },
                    name: 'Send Request',
                  ),
                if (meInRoom?.role == Role.REQUEST) const Text('Request Sent'),
              ],
            ),
          ),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        ref.read(currentRoomProvider.notifier).exitRoom();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: ListTile(
            onTap: () {
              ChatInfoRoute(chatId).go(context);
            },
            title: Text('Chat$chatId'),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: FirestoreQueryBuilder(
                    query: query,
                    builder: (context, snapshot, child) {
                      return ListView(
                        cacheExtent: 1000,
                        reverse: true,
                        children: snapshot.docs.map(
                          (doc) {
                            final tweet = doc.data()!;
                            tweet.room = chatId;
                            tweet.path = doc.reference.path;
                            return TweetBox(
                              tweet: tweet,
                            );
                          },
                        ).toList(),
                      );
                    },
                  ),
                ),
                if (meInRoom != null) SendBox(roomUser: meInRoom),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
