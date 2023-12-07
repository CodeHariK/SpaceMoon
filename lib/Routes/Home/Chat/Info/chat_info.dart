import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moonspace/form/async_text_field.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:moonspace/helper/validator/checkers.dart';
import 'package:moonspace/helper/validator/validator.dart';
import 'package:moonspace/widgets/animated/animated_buttons.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Helpers/proto.dart';
import 'package:spacemoon/Providers/room.dart';
import 'package:spacemoon/Providers/roomuser.dart';
import 'package:spacemoon/Providers/router.dart';
import 'package:spacemoon/Providers/user_data.dart';
import 'package:spacemoon/Routes/Home/Chat/chat_screen.dart';
import 'package:spacemoon/Routes/Home/home.dart';
import 'package:spacemoon/Static/theme.dart';
import 'package:spacemoon/Widget/Chat/gallery.dart';
import 'package:spacemoon/Widget/Common/fire_image.dart';
import 'package:spacemoon/Widget/Common/shimmer_boxes.dart';

class ChatInfoRoute extends GoRouteData {
  final String chatId;

  const ChatInfoRoute({required this.chatId});

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
    final meUser = ref.watch(currentUserDataProvider).value;
    final meInRoom = ref.watch(currentRoomUserProvider).value;
    final allRoomUsersPro = ref.watch(getAllRoomUsersProvider);
    final allRoomUsers = allRoomUsersPro.value ?? [];

    useEffect(() {
      ref.read(currentRoomProvider.notifier).updateRoom(id: chatId);

      return null;
    }, [room]);

    if (room == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Info'),
        ),
      );
    }

    // if (allUsersPro.isLoading) {
    //   return const Scaffold();
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          room.displayName.replaceAll(meUser?.displayName ?? '***', '').trim(),
        ),
        actions: [
          if (meInRoom?.isUserOrAdmin == true) InviteButton(room: room),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Align(
                  child: Container(
                    height: 240,
                    width: 240,
                    padding: const EdgeInsets.all(8),
                    child: InkWell(
                      splashFactory: InkSplash.splashFactory,
                      onTap: meInRoom?.role != Role.ADMIN
                          ? null
                          : () async {
                              final imageMetadata = await selectImageMedia();

                              if (imageMetadata == null) return;

                              await uploadFire(
                                meta: imageMetadata,
                                imageName: 'profile',
                                docPath: 'rooms/${room.uid}',
                                storagePath: 'profile/rooms/${room.uid}',
                                singlepath: Const.photoURL.name,
                              );
                            },
                      child: room.photoURL.isEmpty == true
                          ? const Icon(
                              CupertinoIcons.person_crop_circle_badge_plus,
                              size: 120,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(250),
                              child: CustomCacheImage(
                                imageUrl: spaceThumbImage(room.photoURL),
                              ),
                            ),
                    ),
                  ),
                ),
              ),
              SliverList.list(
                children: [
                  AsyncTextFormField(
                    key: ValueKey(room.displayName),
                    initialValue: room.displayName,
                    enabled: meInRoom?.isAdmin == true,
                    style: context.hm,
                    asyncValidator: (value) async {
                      return value.checkMin(8);
                    },
                    maxLines: 1,
                    showPrefix: false,
                    textInputAction: TextInputAction.done,
                    onSubmit: (con) async {
                      await ref.read(currentRoomProvider.notifier).updateRoomInfo(
                            Room(
                              uid: room.uid,
                              displayName: con.text,
                            ),
                          );
                    },
                    decoration: (AsyncText value, nickCon) => AppTheme.uInputDecoration.copyWith(
                      hintText: 'Name',
                    ),
                  ),
                  AsyncTextFormField(
                    key: ValueKey(room.nick),
                    initialValue: room.nick,
                    maxLines: 1,
                    enabled: meInRoom?.isAdmin == true,
                    style: context.hs,
                    asyncValidator: (value) async {
                      if (value.checkMin(8) != null) {
                        return value.checkMin(8);
                      }
                      if (value.checkAlphanumeric() != null) {
                        return value.checkAlphanumeric();
                      }
                      if (room.nick == value) {
                        return null;
                      }

                      final r = await countRoomByNick(value);

                      if (r != 0) {
                        return 'Not available';
                      }
                      return null;
                    },
                    showPrefix: false,
                    textInputAction: TextInputAction.done,
                    onSubmit: (con) async {
                      await ref.read(currentRoomProvider.notifier).updateRoomInfo(
                            Room(
                              uid: room.uid,
                              nick: con.text,
                            ),
                          );
                    },
                    decoration: (AsyncText value, nickCon) => AppTheme.uInputDecoration.copyWith(
                      hintText: '  abc...',
                      prefixIcon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Nickname : #', style: context.tl),
                        ],
                      ),
                    ),
                  ),
                  AsyncTextFormField(
                    key: ValueKey(room.description),
                    initialValue: room.description,
                    enabled: meInRoom?.isAdmin == true,
                    style: context.ts,
                    maxLines: null,
                    asyncValidator: (value) async {
                      return value.checkMin(8);
                    },
                    showPrefix: false,
                    textInputAction: TextInputAction.done,
                    onSubmit: (con) async {
                      await ref.read(currentRoomProvider.notifier).updateRoomInfo(
                            Room(
                              uid: room.uid,
                              description: con.text,
                            ),
                          );
                    },
                    decoration: (AsyncText value, nickCon) => AppTheme.uInputDecoration.copyWith(
                      hintText: 'Description',
                    ),
                  ),
                  IgnorePointer(
                    ignoring: (meInRoom?.isAdmin != true),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: AsyncLock(
                        builder: (loading, status, lock, open, setStatus) {
                          return DropdownButtonFormField(
                            key: ValueKey(room.open),
                            value: room.open,
                            items: Visible.values
                                .where((element) => element != Visible.INVALIDVISIBLE)
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.name),
                                  ),
                                )
                                .toList(),
                            borderRadius: 20.br,
                            decoration: const InputDecoration(
                              labelText: 'Visiblity',
                              constraints: BoxConstraints(maxWidth: 200),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                            onChanged: (value) async {
                              if (value != null) {
                                lock();
                                await ref.read(currentRoomProvider.notifier).updateRoomInfo(
                                      Room(
                                        uid: room.uid,
                                        open: value,
                                      ),
                                    );
                                open();
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Created on : ${room.created.dateString}',
                      style: context.tm,
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Last message on : ${room.updated.dateString}  @  ${room.updated.timeString}',
                      style: context.tm,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (meInRoom != null && meInRoom.isAdmin)
                        Align(
                          child: AsyncLock(
                            builder: (loading, status, lock, open, setStatus) {
                              return OutlinedButton(
                                onPressed: () async {
                                  lock();
                                  await ref.read(currentRoomProvider.notifier).deleteRoom(meInRoom);
                                  if (context.mounted) {
                                    HomeRoute().go(context);
                                  }
                                  open();
                                },
                                child: const Text('Delete Room'),
                              );
                            },
                          ),
                        ),
                      if (meInRoom != null)
                        Align(
                          child: AsyncLock(
                            builder: (loading, status, lock, open, setStatus) {
                              return OutlinedButton(
                                onPressed: () async {
                                  lock();
                                  await ref.read(currentRoomProvider.notifier).deleteRoomUser(meInRoom);
                                  ref.read(currentRoomProvider.notifier).exitRoom(null);
                                  ref.invalidate(currentRoomUserProvider);
                                  if (context.mounted) {
                                    HomeRoute().go(context);
                                  }
                                  open();
                                },
                                child: const Text('Leave Room'),
                              );
                            },
                          ),
                        ),
                      if (meInRoom == null && room.open.value >= Visible.MODERATED.value)
                        AsyncLock(
                          builder: (loading, status, lock, open, setStatus) {
                            return FilledButton.icon(
                              onPressed: () async {
                                lock();
                                await ref.read(currentRoomProvider.notifier).upgradeAccessToRoom(
                                      RoomUser(
                                        user: meUser?.uid,
                                        room: room.uid,
                                      ),
                                    );
                                open();
                              },
                              icon: const Icon(Icons.mail),
                              label: const Text('Send Request'),
                            );
                          },
                        ),
                      if (meInRoom?.role == Role.REQUEST) const Text('Request Sent'),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
              if (meInRoom != null && meInRoom.isAdminOrMod)
                SliverList.list(
                  children: [
                    const Divider(),
                    Text('Members', textAlign: TextAlign.center, style: context.tl),
                  ],
                ),
              if (meInRoom != null)
                SliverList.builder(
                  itemBuilder: (context, index) {
                    return Consumer(
                      builder: (context, ref, child) {
                        final roomUser = allRoomUsers[index]!;

                        final user = ref.watch(getUserByIdProvider(roomUser.user)).value;

                        return ListTile(
                          title: Text(user?.displayName ?? roomUser.user),
                          subtitle: Text(roomUser.role.name),
                          leading: (user == null)
                              ? Icon(roomUser == meInRoom ? Icons.star_border : Icons.circle)
                              : CircleAvatar(
                                  child: (!isURL(user.photoURL))
                                      ? null
                                      : CustomCacheImage(
                                          imageUrl: spaceThumbImage(user.photoURL),
                                          radius: 32,
                                        ),
                                ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (roomUser.role.value < meInRoom.role.value &&
                                  roomUser != meInRoom &&
                                  !roomUser.isInvite &&
                                  meInRoom.isAdminOrMod)
                                AsyncLock(
                                  builder: (loading, status, lock, open, setStatus) {
                                    return IconButton.filledTonal(
                                      onPressed: roomUser.isAdmin
                                          ? null
                                          : () async {
                                              lock();
                                              await ref
                                                  .read(currentRoomProvider.notifier)
                                                  .upgradeAccessToRoom(roomUser);
                                              open();
                                            },
                                      icon: !loading
                                          ? Icon(roomUser.isRequest
                                              ? Icons.check
                                              : (roomUser.isAdmin ? Icons.star : Icons.star_border))
                                          : const CircularProgress(size: 20),
                                    );
                                  },
                                ),
                              if (roomUser.role.value < meInRoom.role.value &&
                                  roomUser != meInRoom &&
                                  meInRoom.isAdminOrMod)
                                AsyncLock(
                                  builder: (loading, status, lock, open, setStatus) {
                                    return IconButton.filledTonal(
                                      onPressed: () async {
                                        lock();
                                        await ref.read(currentRoomProvider.notifier).deleteRoomUser(roomUser);
                                        open();
                                        ref.read(currentRoomProvider.notifier).exitRoom(null);
                                        ref.invalidate(currentRoomUserProvider);
                                        if (context.mounted) {
                                          HomeRoute().go(context);
                                        }
                                      },
                                      icon: !loading ? const Icon(Icons.close) : const CircularProgress(size: 20),
                                    );
                                  },
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  itemCount: allRoomUsers.length,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
