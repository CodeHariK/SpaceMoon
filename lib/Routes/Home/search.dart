import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:moonspace/form/async_text_field.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:moonspace/helper/validator/checkers.dart';
import 'package:moonspace/widgets/animated/animated_buttons.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Providers/room.dart';
import 'package:spacemoon/Providers/user_data.dart';
import 'package:spacemoon/Routes/Home/Chat/chat_screen.dart';
import 'package:spacemoon/Routes/Home/home.dart';
import 'package:spacemoon/Routes/Home/profile.dart';
import 'package:spacemoon/Static/assets.dart';

class SearchRoute extends GoRouteData {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return const CupertinoPage(
      child: SearchPage(),
    );
  }
}

class SearchPage extends HookConsumerWidget {
  const SearchPage({
    super.key,
    this.room,
  });

  final Room? room;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomCon = useTextEditingController();
    final searchRooms = ref.watch(searchRoomByNickProvider).value ?? [];
    final searchUsers = ref.watch(searchUserByNickProvider).value ?? [];
    final me = ref.watch(currentUserDataProvider).value;

    return Scaffold(
      appBar: room != null ? AppBar(title: const Text('Invite Members')) : null,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AsyncTextFormField(
                controller: roomCon,
                autofocus: true,
                decoration: (AsyncText value, roomCon) => const InputDecoration(
                  hintText: 'abc...',
                  labelText: 'Find Rooms or Users by nickname',
                ),
                milliseconds: 600,
                textInputAction: TextInputAction.done,
                asyncValidator: (v) async {
                  if (v.checkMin(8) != null) {
                    return v.checkMin(8);
                  }
                  if (v.checkAlphanumeric() != null) {
                    return v.checkAlphanumeric();
                  }

                  ref.read(searchTextProvider.notifier).change(v);
                  await 200.mil.delay();

                  return null;
                },
                showSubmitSuffix: false,
              ),
            ),
            if (searchRooms.isNotEmpty || searchUsers.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 24, 0, 8),
                child: Text(
                  'Found ${searchRooms.isNotEmpty ? searchRooms.length : 0} room,'
                  ' ${searchUsers.isNotEmpty ? searchUsers.length : 0} user',
                  style: context.tl,
                ),
              ),
            if (searchRooms.isEmpty && searchUsers.isEmpty)
              Expanded(
                child: Center(
                  child: Lottie.asset(
                    Asset.lDot,
                    reverse: false,
                    repeat: true,
                  ),
                ),
              ),
            if (searchRooms.isNotEmpty || searchUsers.isNotEmpty)
              Expanded(
                child: ListView(
                  children: [
                    if (searchRooms.isNotEmpty)
                      ...searchRooms.map((searchRoom) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          onTap: () {
                            if (context.mounted && searchRoom?.uid != null) {
                              ChatRoute(chatId: searchRoom!.uid).push(context);
                            }
                          },
                          title: Text(searchRoom?.displayName ?? 'Name'),
                          trailing: const Text('Room'),
                        );
                      }),
                    if (searchUsers.isNotEmpty)
                      ...searchUsers.map((searchUser) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          onTap: () {
                            if (context.mounted) {
                              ProfileRoute($extra: ProfileObj(user: searchUser)).go(context);
                            }
                          },
                          title: Text(searchUser?.displayName ?? 'Name'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('User'),
                              const SizedBox(width: 10),
                              if (searchUser?.uid != me?.uid)
                                AsyncLock(
                                  builder: (loading, status, lock, open, setStatus) {
                                    return IconButton.filledTonal(
                                      onPressed: () async {
                                        lock();
                                        if (room != null) {
                                          await ref.read(currentRoomProvider.notifier).upgradeAccessToRoom(
                                                RoomUser(
                                                  user: searchUser?.uid,
                                                  room: room?.uid,
                                                ),
                                              );
                                          if (context.mounted) {
                                            context.pop();
                                          }
                                        } else {
                                          if (me != null && searchUser != null) {
                                            final room = await ref.read(currentRoomProvider.notifier).createRoom(
                                              room: Room(displayName: '${me.displayName} ${searchUser.displayName}'),
                                              users: [
                                                me.uid,
                                                searchUser.uid,
                                              ],
                                            );
                                            if (room != null && context.mounted) {
                                              ChatRoute(chatId: room.uid).go(context);
                                            }
                                          }
                                        }
                                        open();
                                      },
                                      icon: !loading
                                          ? const Icon(Icons.add_circle_outline_outlined)
                                          : const CircularProgress(size: 20),
                                    );
                                  },
                                ),
                            ],
                          ),
                        );
                      }),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
