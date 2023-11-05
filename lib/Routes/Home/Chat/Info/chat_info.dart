import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Providers/room.dart';
import 'package:spacemoon/Providers/router.dart';
import 'package:spacemoon/Routes/Special/error_page.dart';

class ChatInfoRoute extends GoRouteData {
  final String chatId;

  const ChatInfoRoute(this.chatId);

  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ChatInfoPage(
      chatId: chatId,
    );
  }
}

class ChatInfoPage extends HookConsumerWidget {
  const ChatInfoPage({super.key, required this.chatId});

  final String chatId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final room = ref.watch(roomStreamProvider).value;
    final meInRoom = ref.watch(currentRoomUserProvider).value;

    useEffect(() {
      ref.read(currentRoomProvider.notifier).updateRoom(id: chatId);

      return null;
    }, [room]);

    if (room == null) {
      return const Error404Page();
    }

    if ((meInRoom == null || meInRoom.role == Role.REQUEST) && room.open != Visible.OPEN) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            children: [
              Text('Me in room : $meInRoom'),
              Text(room.toString()),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat ${room.totalCount} $chatId'),
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
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        final roomUser = data[index]!;
                        return ListTile(
                          title: Text(roomUser.user),
                          subtitle: Text(roomUser.role.name),
                          leading: Icon(roomUser == meInRoom ? Icons.star_border : Icons.circle),
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
                              if (!roomUser.isAdminOrMod && roomUser != meInRoom && meInRoom!.isAdminOrMod)
                                IconButton(
                                  onPressed: () {
                                    ref.read(currentRoomProvider.notifier).deleteRoomUser(roomUser);
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
              ref.read(currentRoomProvider.notifier).deleteRoomUser(meInRoom!);
            },
            child: const Text('Leave Room'),
          ),
        ],
      ),
    );
  }
}
