import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:moonspace/form/async_text_field.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:moonspace/helper/validator/checkers.dart';
import 'package:moonspace/widgets/animated/animated_buttons.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Helpers/gorouter_ext.dart';
import 'package:spacemoon/Providers/room.dart';
import 'package:spacemoon/Providers/roomuser.dart';
import 'package:spacemoon/Providers/user_data.dart';
import 'package:spacemoon/Routes/Home/Chat/chat_screen.dart';
import 'package:spacemoon/Routes/Home/home.dart';
import 'package:spacemoon/Routes/Home/profile.dart';
import 'package:spacemoon/Static/assets.dart';

class SearchRoute extends GoRouteData {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return fadePage(context, state, const SearchPage());
  }
}

class SearchPage extends ConsumerWidget {
  const SearchPage({
    super.key,
    this.room,
  });

  final Room? room;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchRooms = ref.watch(searchRoomByNickProvider).value ?? [];
    final searchUsers = ref.watch(searchUserByNickProvider).value ?? [];
    final me = ref.watch(currentUserDataProvider).value;

    return Scaffold(
      appBar: room != null ? AppBar(title: const Text('Invite Members')) : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AsyncTextFormField(
                  autofocus: true,
                  decoration: (AsyncText value, controller) => const InputDecoration(
                    hintText: 'abc...',
                    labelText: 'Find by nickname',
                  ),
                  milliseconds: 600,
                  textInputAction: TextInputAction.done,
                  asyncValidator: (v) async {
                    if (v.isEmpty) return null;
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
                  showClear: true,
                  clearFunc: () {
                    ref.read(searchTextProvider.notifier).change('');
                  },
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
                          return UserTile(
                            me: me,
                            room: room,
                            searchUser: searchUser,
                          );
                        }),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserTile extends ConsumerWidget {
  const UserTile({
    super.key,
    required this.me,
    required this.room,
    required this.searchUser,
  });

  final User? me;
  final Room? room;
  final User? searchUser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchRoomUser =
        (room == null || me == null) ? null : ref.watch(getRoomUserProvider(roomId: room!.uid, userId: me!.uid)).value;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: () {
        if (context.mounted && searchUser?.uid != null) {
          context.rSlidePush(ProfilePage(
            searchuser: searchUser,
            showAppbar: true,
          ));
        }
      },
      title: Text(searchUser?.displayName ?? 'Name'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('User'),
          const SizedBox(width: 10),
          if (searchUser?.uid != me?.uid && (searchRoomUser != null || room == null))
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
                          room: Room(displayName: '${me!.displayName} ${searchUser!.displayName}'),
                          users: [
                            me!.uid,
                            searchUser!.uid,
                          ],
                        );
                        if (room != null && context.mounted) {
                          ChatRoute(chatId: room.uid).go(context);
                        }
                      }
                    }
                    open();
                  },
                  icon: !loading ? const Icon(Icons.add_circle_outline_outlined) : const CircularProgress(size: 20),
                );
              },
            ),
        ],
      ),
    );
  }
}
