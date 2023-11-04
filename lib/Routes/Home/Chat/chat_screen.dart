import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Providers/auth.dart';
import 'package:spacemoon/Providers/room.dart';
import 'package:spacemoon/Providers/router.dart';
import 'package:moonspace/widgets/anim_btn.dart';
import 'package:spacemoon/Providers/tweets.dart';
import 'package:spacemoon/Routes/Home/Chat/Info/chat_info.dart';
import 'package:spacemoon/Routes/Home/home.dart';

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
    final room = ref.watch(roomStreamProvider).value;
    final me = ref.watch(currentUserProvider).value;
    final meInRoom = ref.watch(currentRoomUserProvider).value;

    useEffect(() {
      ref.read(currentRoomProvider.notifier).updateRoom(id: chatId);

      return null;
    }, [room]);

    // dino(room);

    Query<Tweet?>? query = room?.tweetCol?.orderBy(
      Const.created.name,
      descending: true,
    );

    if (query == null || room == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
                Text('Me : ${me?.uid}'),
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
        body: Column(
          children: [],
        ),
      ),
    );
  }
}

// FilledButton(
//   onPressed: () {
//     ref.read(tweetsProvider.notifier).sendTweet(
//           tweet: Tweet(
//             user: 's',
//             mediaType: MediaType.IMAGE,
//             room: 'roo',
//           ),
//         );
//   },
//   child: const Text('Send Tweet'),
// ),
// FilledButton(
//   onPressed: () {
//     ref.read(tweetsProvider.notifier).deleteTweet(
//           tweet: Tweet(
//             room: 'HRLGHohzAAGcQSAgbJSa',
//             uid: 'Aqy0Xd73n36EFyvR3APU',
//           ),
//         );
//   },
//   child: const Text('Delete Tweet'),
// ),
