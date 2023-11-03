import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moonspace/Helper/debug_functions.dart';
import 'package:moonspace/Helper/extensions.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Providers/auth.dart';
import 'package:spacemoon/Providers/room.dart';
import 'package:spacemoon/Providers/router.dart';
import 'package:moonspace/widgets/anim_btn.dart';

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

    lava('Build Chat Page');

    useEffect(() {
      ref.read(currentRoomProvider.notifier).updateRoom(id: chatId);

      lava('useEffect');

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
            child: ListView(
              children: [
                Text('Me : ${me?.uid}'),
                Text('Me in room : $meInRoom'),
                Text(room.toString()),
                if (meInRoom == null && room.open == Visible.MODERATED)
                  LoadingBtn(
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
          title: Text('Chat$chatId'),
        ),
        body: Column(
          children: [
            LimitedBox(
              maxHeight: 200,
              child: Consumer(
                builder: (context, ref, child) {
                  final allUsers = ref.watch(getAllMyUsersProvider);
                  return allUsers.when(
                    data: (data) {
                      lava(data.length);
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          final roomUser = data[index]!;
                          return ListTile(
                            title: Text(roomUser.user),
                            subtitle: Text(roomUser.role.name),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (roomUser.isRequest)
                                  IconButton.filledTonal(
                                    onPressed: () {
                                      ref.read(currentRoomProvider.notifier).acceptAccessToRoom(roomUser);
                                    },
                                    icon: const Icon(Icons.check),
                                  ),
                                if (roomUser.isAdminOrMod && roomUser != meInRoom)
                                  IconButton(
                                    onPressed: () {
                                      ref.read(currentRoomProvider.notifier).removeUser(roomUser);
                                    },
                                    icon: const Icon(Icons.close),
                                  )
                              ],
                            ),
                          );
                        },
                        itemCount: data.length,
                      );
                    },
                    error: (error, stackTrace) => Text(error.toString()),
                    loading: () => const CircularProgressIndicator(),
                  );
                },
              ),
            ),
            Text(room.toString()),
            Text(meInRoom.toString()),
            FilledButton(
              onPressed: () {
                ref.read(currentRoomProvider.notifier).removeUser(meInRoom!);
              },
              child: Text('Leave Room', style: context.hs),
            ),
          ],
        ),
      ),
    );
  }
}
